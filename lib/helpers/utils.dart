import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';
import 'package:whatsapp_gadgets/constants/constants.dart';
import 'package:whatsapp_gadgets/constants/controllers_instatnceses.dart';
import 'package:whatsapp_gadgets/constants/whatsapp_types.dart';
import 'package:whatsapp_gadgets/controllers/app_controller.dart';
import 'package:storage_access_framework/storage_access_framework.dart';
import 'platform_handle_helper.dart';

class Utils {
  //

  static Future<List<WhatsAppType>> checkInstalledWhatsApps(
      int buildVersion, {bool returnOnly= false}) async {
    final List<WhatsAppType> list = <WhatsAppType>[];
    try {
      bool wa = await PlatformHandleHelper.ifAppInstalled('com.whatsapp');
      bool wa4b = await PlatformHandleHelper.ifAppInstalled('com.whatsapp.4b');
      bool waGb = await PlatformHandleHelper.ifAppInstalled('com.gbwhatsapp');
      late final bool waDual;
      if (buildVersion > 28) {
        wa = await StorageAccessFramework.isDirectoryExists(
            directoryPath:
                'storage/emulated/0/Android/Media/com.whatsapp/WhatsApp/Media/.Statuses');
        waDual = await StorageAccessFramework.isDirectoryExists(
            directoryPath:
                'storage/emulated/0/DualApp/Android/Media/com.whatsapp/WhatsApp/Media/.Statuses');
        wa4b = await StorageAccessFramework.isDirectoryExists(
            directoryPath:
                'storage/emulated/0/Android/Media/com.whatsapp.w4b/WhatsApp Business/Media/.Statuses');
        waGb = await isWaGBAvailable() > 0 && await isWaGBAvailable() < 3;
      } else {
        wa = await StorageAccessFramework.isDirectoryExists(
            directoryPath: 'storage/emulated/0/WhatsApp/Media/.Statuses');
        wa4b = await StorageAccessFramework.isDirectoryExists(
            directoryPath:
                'storage/emulated/0/WhatsApp Business/Media/.Statuses');
        waGb = await isWaGBAvailable() > 0 && await isWaGBAvailable() < 3;
        waDual = await StorageAccessFramework.isDirectoryExists(
            directoryPath:
                'storage/emulated/0/DualApp/WhatsApp/Media/.Statuses');
      }

      if(!returnOnly){
        if (wa) {
          controller.addWhatsAppType(WhatsAppType.normal);
          list.add(WhatsAppType.normal);
        }
        if (waDual) {
          controller.addWhatsAppType(WhatsAppType.dual);
          list.add(WhatsAppType.dual);
        }
        if (wa4b) {
          controller.addWhatsAppType(WhatsAppType.w4b);
          list.add(WhatsAppType.w4b);
        }
        if (waGb) {
          controller.addWhatsAppType(WhatsAppType.gb);
          list.add(WhatsAppType.gb);
        }
      }
    } catch (e, stack) {
      FirebaseCrashlytics.instance.log(e.toString());
      FirebaseCrashlytics.instance.recordError(e, stack);
    }
    return list;
  }

  static Future<int> isWaGBAvailable() async {
    try {
      if (await StorageAccessFramework.isDirectoryExists(
          directoryPath:
              'storage/emulated/0/Android/Media/com.gbwhatsapp/GBWhatsApp/Media/.Statuses')) {
        return 1;
      } else if (await StorageAccessFramework.isDirectoryExists(
          directoryPath: 'storage/emulated/0/GBWhatsApp/Media/.Statuses')) {
        return 2;
      }
    } catch (e, stack) {
      FirebaseCrashlytics.instance.log(e.toString());
      FirebaseCrashlytics.instance.recordError(e, stack);
    }

    return 0;
  }

  static Future<List<String>> getPathForWaType(WhatsAppType type) async {
    final int? _buildVersion = await StorageAccessFramework.platformVersion;
    if (_buildVersion != null) {
      if (_buildVersion > 28) {
        if (type == WhatsAppType.normal) {
          return [whatsAppApi30];
        }
        if (type == WhatsAppType.dual) {
          return [whatsAppDualApi30];
        }
        if (type == WhatsAppType.w4b) {
          return [whatsApp4BApi30];
        }
        if (type == WhatsAppType.gb) {
          if (await isWaGBAvailable() == 1) {
            return [whatsAppGBApi30Path1];
          } else {
            return [whatsAppGBApi30Path2];
          }
        }
      } else {
        if (type == WhatsAppType.normal) {
          return [whatsApp, whatsApp2];
        }
        if (type == WhatsAppType.dual) {
          return [whatsAppDual, whatsAppDual2];
        }
        if (type == WhatsAppType.w4b) {
          return [whatsApp4B, whatsApp4B2];
        }
        if (type == WhatsAppType.gb) {
          return [whatsAppGB, whatsAppGB2];
        }
      }
    }
    return [];
  }

  //"content://com.android.externalstorage.documents/tree/primary%3AAndroid%2FMedia%2Fcom.whatsapp%2FWhatsApp%2FMedia%2F.Statuses"
//'primary:Android/Media/com.whatsapp/WhatsApp/Media/.Statuses';

  static String? decodeUrl(String? url) {
    if (url == null) {
      return null;
    } else {
      String decoded = '';
      print('DECODED 1 $url');
      decoded +=
          url.replaceAll('content://com.android.externalstorage.documents', '');
      decoded = decoded.replaceAll('/tree/', '');
      // decoded += decoded.replaceAll('%3A', ':').replaceAll('%2F', '/');
      // decoded = decoded.replaceAll('/tree/', '');
      decoded = decoded.substring(0, decoded.length - 1);
      print('DECODED URI =>> $decoded');
      return decoded;
    }
  }

  static String getPackageNameForWaType(WhatsAppType type) {
    if (type == WhatsAppType.gb) {
      return 'com.gbwhatsapp';
    }
    if (type == WhatsAppType.w4b) {
      return 'com.whatsapp.w4b';
    }
    return 'com.whatsapp';
  }

  static String getNameForWaType(WhatsAppType type, {bool forList = false}) {
    if (type == WhatsAppType.gb) {
      return 'GB';
    }
    if (type == WhatsAppType.w4b) {
      return 'Business';
    }
    if (forList) {
      if (type == WhatsAppType.dual) {
        return 'Dual';
      } else {
        return 'WhatsApp';
      }
    } else {
      return 'WhatsApp / Dual';
    }
  }

  static Color getColorForWaType(WhatsAppType type) {
    if (type == WhatsAppType.gb) {
      return Colors.green[300]!;
    }
    if (type == WhatsAppType.w4b) {
      return Colors.lightGreenAccent;
    }

    return Colors.greenAccent;
  }
}
