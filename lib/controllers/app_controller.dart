import 'dart:io';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';
import 'package:whatsapp_gadgets/constants/constants.dart';
import 'package:whatsapp_gadgets/constants/whatsapp_types.dart';
import 'package:whatsapp_gadgets/controllers/ad_controller.dart';
import 'package:whatsapp_gadgets/controllers/image_controller.dart';
import 'package:whatsapp_gadgets/controllers/notification_controller.dart';
import 'package:whatsapp_gadgets/controllers/video_controller.dart';
import 'package:whatsapp_gadgets/helpers/dialog_helper.dart';
import 'package:whatsapp_gadgets/helpers/permission/api30_permission_handler.dart';
import 'package:whatsapp_gadgets/helpers/permission/old_permission_handler.dart';
import 'package:whatsapp_gadgets/helpers/snack_helper.dart';
import 'package:whatsapp_gadgets/helpers/storage_helper.dart';
import 'package:whatsapp_gadgets/helpers/utils.dart';
import 'package:storage_access_framework/storage_access_framework.dart';
import 'package:whatsapp_gadgets/models/accessible_wa_type_model.dart';

class AppController extends GetxController {
  final notificationController = NotificationController();
  final RxBool _isExistingUser = false.obs;
  final List<WhatsAppType> _availableWhatsAppTypes =
      List<WhatsAppType>.empty(growable: true);
  final Rx<WhatsAppType> _selectedWhatsAppType = WhatsAppType.normal.obs;
  final RxBool _darkMode = false.obs;
  final RxBool _notificationEnable = true.obs;
  final RxBool _showWelcomeDialog = false.obs;

  bool get isNotificationEnabled => _notificationEnable.value;

  set setNotificationState(bool val) => _notificationEnable.value = val;

  bool get shouldShowWelcomeDialog => _showWelcomeDialog.value;

  set setWelcomed(bool val) => _showWelcomeDialog.value = val;

  bool get isDarkMode => _darkMode.value;

  set darkMode(bool val) => _darkMode.value = val;

  //Existing User
  bool get isExistingUser => _isExistingUser.value;

  set setExistingUser(bool isExisting) => _isExistingUser.value = isExisting;

  //*

  //Available WA Types
  List<WhatsAppType> get availableWhatsAppTypes => _availableWhatsAppTypes;

  void addWhatsAppType(WhatsAppType type) => _availableWhatsAppTypes.add(type);

  //*

  //Selected WA Type
  WhatsAppType get selectedWhatsAppType => _selectedWhatsAppType.value;

  set selectWhatsAppType(WhatsAppType type) =>
      _selectedWhatsAppType.value = type;

  //*

  Future<bool> isNewVersion() async {
    late int? v;
    try {
      v = await StorageAccessFramework.platformVersion;
    } catch (e, stack) {
      FirebaseCrashlytics.instance.log(e.toString());
      FirebaseCrashlytics.instance.recordError(e, stack);
    }
    if (v == null) {
      return false;
    } else {
      if (v > 28) {
        return true;
      } else {
        return false;
      }
    }
  }

  Future<void> clearCache() async {
    try {
      final dir = await getTemporaryDirectory();
      dir.listSync().forEach((element) {
        if (element.path.contains(tempThumbName) ||
            element.path.contains(tempShareName)) {
          element.deleteSync();
        }
      });
      final List<Directory>? dirs = await getExternalCacheDirectories();
      if (dirs!.isNotEmpty) {
        for (final value in dirs.first.listSync()) {
          if (value.path.contains(tempShareName)) {
            value.deleteSync();
          }
        }
      }
    } catch (e, stack) {
      FirebaseCrashlytics.instance.log(e.toString());
      FirebaseCrashlytics.instance.recordError(e, stack);
    }
  }

  final _paths = List<String>.empty(growable: true);

  Future<void> warmUp() async {
    clearCache();
    final int? _buildVersion = await StorageAccessFramework.platformVersion;
    if (_buildVersion != null) {
      await Utils.checkInstalledWhatsApps(_buildVersion);
      selectWhatsAppType = availableWhatsAppTypes.first;
      if (_buildVersion > 28) {
        print(
            "<--------------------- Running on Above Api 28 --------------------->");
        _paths.addAll(await Utils.getPathForWaType(selectedWhatsAppType));
        Api30PermissionHandler.checkPermission(url: _paths.first);
        ever(_isExistingUser, (bool data) {
          if (data) {
            Get.toNamed('/splash');
          }
        });
      } else {
        print(
            "<--------------------- Running on Below Api 28 --------------------->");
        OldPermissionHandler.checkPermission();
        ever(_isExistingUser, (bool data) {
          if (data) {
            Get.toNamed('/splash');
          }
        });
      }
    }
  }

  Future<void> handleApi30Permission() async {
    if (await Api30PermissionHandler.askPermission(url: _paths.first)) {
      setExistingUser = true;
    } else {
      SnackHelper.permissionGrantSnack();
      setExistingUser = false;
    }
  }

  Future<void> handleRefresh() async {
    if (selectedWhatsAppType != WhatsAppType.saved) {
      List<String> paths = await Utils.getPathForWaType(selectedWhatsAppType);
      if (await isNewVersion()) {
        Get.find<ImageController>().loadImages(api30Path: paths.first);
        Get.find<VideoController>().loadVideos(api30Path: paths.first);
      } else {
        Get.find<ImageController>().loadImages(
          path1: paths.first,
          path2: paths.last,
        );
        Get.find<VideoController>().loadVideos(
          path1: paths.first,
          path2: paths.last,
        );
      }
    }
  }

  int wVal = 0;

  void welcome() {
    if (shouldShowWelcomeDialog && wVal < 1) {
      DialogHelper.welcomeDialog();
    }
  }

  @override
  void onInit() {
    super.onInit();

    notificationController.initialize();
    if (StorageHelper.isWelcomed()) {
      setWelcomed = false;
      darkMode = StorageHelper.isDarkModeSaved();
      setNotificationState = StorageHelper.isNotificationEnabled();
    } else {
      setWelcomed = true;
      notificationController.showNotification();
      notificationController.showDailyNotification();
      StorageHelper.setNotificationState();
      setNotificationState = true;
      if (Get.isPlatformDarkMode) {
        darkMode = true;
        StorageHelper.markAsDarkModeEnable(val: true);
      } else {
        darkMode = false;
        StorageHelper.markAsDarkModeEnable();
      }
    }

    ever(_selectedWhatsAppType, (whatsappType) {
      print("WhatsApp Type Changed =======> $whatsappType");
      bool canAccess = false;
      for (AccessibleWATypeModel accessibleWATypeModel
          in Get.find<AdController>().accessibleWATypes) {
        if (accessibleWATypeModel.whatsAppType == whatsappType) {
          print("Type Already Unlocked");
          canAccess = true;
          return;
        }
        canAccess = false;
      }
      if (!canAccess) {
        DialogHelper.showUnlockTypeDialog();
      }
    });
  }
}
