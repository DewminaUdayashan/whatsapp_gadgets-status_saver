import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:whatsapp_gadgets/constants/controllers_instance.dart';
import 'package:whatsapp_gadgets/helpers/snack_helper.dart';

class OldPermissionHandler {
  static Future<void> checkPermission() async {
    if (await Permission.storage.status == PermissionStatus.granted) {
      controller.setExistingUser = true;
    } else {
      Get.offNamed("/permission");
    }
  }

  static Future<void> askPermission() async {
    if (await Permission.storage.request() == PermissionStatus.granted) {
      controller.setExistingUser = true;
    } else if (await Permission.storage.request() == PermissionStatus.denied) {
      SnackHelper.permissionDenied();
    } else if (await Permission.storage.request() ==
            PermissionStatus.permanentlyDenied ||
        await Permission.storage.request() == PermissionStatus.restricted) {
      SnackHelper.permissionDeniedForever();
    }
  }
}
