import 'package:facebook_audience_network/ad/ad_interstitial.dart';
import 'package:facebook_audience_network/ad/ad_native.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:whatsapp_gadgets/constants/constants.dart';
import 'package:whatsapp_gadgets/constants/whatsapp_types.dart';
import 'package:whatsapp_gadgets/controllers/app_controller.dart';
import 'package:whatsapp_gadgets/helpers/snack_helper.dart';
import 'package:whatsapp_gadgets/helpers/storage_helper.dart';
import 'package:whatsapp_gadgets/models/accessible_wa_type_model.dart';

class AdController extends GetxController {
  RxList<AccessibleWATypeModel> accessibleWATypes = <AccessibleWATypeModel>[
    AccessibleWATypeModel(whatsAppType: WhatsAppType.normal.toString()),
    AccessibleWATypeModel(whatsAppType: WhatsAppType.dual.toString()),
    AccessibleWATypeModel(whatsAppType: WhatsAppType.saved.toString()),
  ].obs;
  final RxBool isInterstitialLoaded = false.obs;
  final RxBool isInterstitialVideoWatched = false.obs;
  final RxBool isTypeChangeDialogLoading = false.obs;
  final RxBool isUndeletedMessagesUnlocked = false.obs;
  late Map<String, dynamic> undeletedMessageState;

  Future<void> unlockUndeleteMessages() async {
    isTypeChangeDialogLoading.value = true;
    isUndeletedMessagesUnlocked.value = true;
    StorageHelper.saveMessageFeatureUnlockedStatus(true);
    await Future.delayed(const Duration(seconds: 3));
    isTypeChangeDialogLoading.value = false;
    if (Get.isDialogOpen!) {
      Get.back();
    }
  }

  Future<void> addAccessibleWaType() async {
    isTypeChangeDialogLoading.value = true;
    accessibleWATypes.add(
      AccessibleWATypeModel(
        whatsAppType: Get.find<AppController>().selectedWhatsAppType.toString(),
        updatedAt: DateTime.now().toString(),
      ),
    );
    await Future.delayed(const Duration(seconds: 3));
    isTypeChangeDialogLoading.value = false;
    if (Get.isDialogOpen!) {
      Get.back();
    }
    StorageHelper.saveUnlockedTypes(accessibleWATypes);
    SnackHelper.unlockedByAd();
  }

  FacebookNativeAd typeChangeDialogNativeAd() => FacebookNativeAd(
        placementId: "1868610943311642_1868983939941009",
        adType: NativeAdType.NATIVE_AD,
        width: double.infinity,
        height: Get.height / 2,
        backgroundColor: Colors.blue,
        titleColor: Colors.white,
        descriptionColor: Colors.white,
        buttonColor: Colors.deepPurple,
        buttonTitleColor: Colors.white,
        buttonBorderColor: Colors.white,
        keepAlive: true,
        //set true if you do not want adview to refresh on widget rebuild
        keepExpandedWhileLoading: false,
        // set false if you want to collapse the native ad view when the ad is loading
        expandAnimationDuraion: 300,
        //in milliseconds. Expands the adview with animation when ad is loaded
        listener: (result, value) {
          print("Native Ad: $result --> $value");
        },
      );

  FacebookNativeAd mainTopNativeBannerAd(BuildContext context) =>
      FacebookNativeAd(
        placementId: "1868610943311642_1868611856644884",
        adType: NativeAdType.NATIVE_BANNER_AD,
        bannerAdSize: NativeBannerAdSize.HEIGHT_50,
        width: double.infinity,
        backgroundColor: context.theme.scaffoldBackgroundColor,
        titleColor: context.theme.accentColor,
        descriptionColor: context.theme.accentColor,
        buttonColor: Colors.green,
        buttonTitleColor: Colors.white,
        buttonBorderColor: Colors.white,
        listener: (result, value) {
          print("Native Ad: $result --> $value");
        },
      );

  void _loadUnlockedFeatures() {
    // WhatsApp Types
    for (final type in StorageHelper.getUnlockedTypes()) {
      accessibleWATypes.addIf(!accessibleWATypes.contains(type), type);
    }
    StorageHelper.saveUnlockedTypes(accessibleWATypes);
    //
    //Messages
    undeletedMessageState = StorageHelper.isMessageFeatureUnlocked();
    print("PREMIUM FEATURE PRINTIN ===> " + undeletedMessageState.toString());
    isUndeletedMessagesUnlocked.value = undeletedMessageState["status"] as bool;
  }

  // Remove Subscriptions after week
  void _validateUnlockedFeatures() {
    Future.delayed(const Duration(seconds: 15), () {
      final List<AccessibleWATypeModel> _tmp = List.from(accessibleWATypes);
      for (AccessibleWATypeModel waTypeModel in _tmp) {
        String? updatedAt = waTypeModel.updatedAt;
        if (updatedAt != null && !updatedAt.contains("null")) {
          DateTime updatedAtDate = DateTime.parse(waTypeModel.updatedAt!)
              .add(durationOneWeek); //TODO: ADD DAYS
          if (updatedAtDate
              .toUtc()
              .toLocal()
              .isBefore(DateTime.now().toUtc().toLocal())) {
            accessibleWATypes.remove(waTypeModel);
          }
        }
        StorageHelper.saveUnlockedTypes(accessibleWATypes);
      }

      String undeletedMsgUpdatedAt = undeletedMessageState["updatedAt"];
      if (!undeletedMsgUpdatedAt.contains("null")) {
        DateTime undeletedMsgUpdatedAtDate =
            DateTime.parse(undeletedMsgUpdatedAt).add(durationOneWeek);
        if (undeletedMsgUpdatedAtDate
            .toUtc()
            .toLocal()
            .isBefore(DateTime.now().toUtc().toLocal())) {
          print('PREMIUM FEATURE OUTDATED');
          isUndeletedMessagesUnlocked.value = false;
          StorageHelper.saveMessageFeatureUnlockedStatus(false);
        } else {
          isUndeletedMessagesUnlocked.value = true;
        }
      }
    });
  }

  @override
  void onInit() {
    super.onInit();
    _loadUnlockedFeatures();
    _validateUnlockedFeatures();
  }
}
