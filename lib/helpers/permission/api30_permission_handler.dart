import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:get/get.dart';
import 'package:whatsapp_gadgets/constants/constants.dart';
import 'package:whatsapp_gadgets/constants/controllers_instatnceses.dart';
import 'package:whatsapp_gadgets/helpers/utils.dart';
import 'package:storage_access_framework/storage_access_framework.dart';

class Api30PermissionHandler {
  static Future<bool> checkPermission(
      {required String url, bool blockNavigate = false}) async {
    late bool val;
    try {
      val = await StorageAccessFramework.isPermissionAvailableForUri(uri: url);
      if (val) {
        controller.setExistingUser = true;
      } else {
        if (!blockNavigate) {
          Get.offNamed("/api_30_permission");
        }
      }
    } catch (e, stack) {
      FirebaseCrashlytics.instance.log(e.toString());
      FirebaseCrashlytics.instance.recordError(e, stack);
    }

    return val;
  }

  static Future<bool> askPermission({required String url}) async {
    print("PATH ======> 2" + url);

    final Uri? data;
    try {
      data = await StorageAccessFramework.openDocumentTree(initialUri: url);
      if (data == null) {
        return false;
      } else if (Utils.decodeUrl(data.path) == url) {
        return true;
      } else {
        return false;
      }
    } catch (e, stack) {
      FirebaseCrashlytics.instance.log(e.toString());
      FirebaseCrashlytics.instance.recordError(e, stack);
      return false;
    }
  }
}
