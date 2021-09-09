import 'package:get/get.dart';
import 'package:whatsapp_gadgets/constants/controllers_instatnceses.dart';
import 'package:whatsapp_gadgets/views/dialogs/no_any_paths_found_dialog.dart';
import 'package:whatsapp_gadgets/views/dialogs/unlock_type_dialog.dart';
import 'package:whatsapp_gadgets/views/dialogs/ask_notification_permission_dialog.dart';
import 'package:whatsapp_gadgets/views/dialogs/change_wa_type_dialog.dart';
import 'package:whatsapp_gadgets/views/dialogs/direct_message_dialog.dart';
import 'package:whatsapp_gadgets/views/dialogs/permission_asking_dialog.dart';
import 'package:whatsapp_gadgets/views/dialogs/settings_dialog.dart';
import 'package:whatsapp_gadgets/views/dialogs/welcome_dialog.dart';

class DialogHelper {
  static void permissionDialogApi30({Function? overrideDefaultFunction}) {
    Get.dialog(
        PermissionAskingDialog(
          overrideDefaultFunction: overrideDefaultFunction,
        ),
        name: "PERMISSIONDETAILAPI30");
  }

  static void changeWaTypeDialog() {
    Get.dialog(const ChangeWATypeDialog());
  }

  static void directMessageDialog() {
    Get.dialog(DirectMessageDialog());
  }

  static void settingsDialog() {
    Get.dialog(const SettingsDialog());
  }

  static void welcomeDialog() {
    if (controller.shouldShowWelcomeDialog) {
      Get.dialog(const WelcomeDialog(),
          barrierDismissible: false, name: "WELCOMEDIALOG");
    }
  }

  static void askNotificationPermission() {
    Get.dialog(
      const AskNotificationPermissionDialog(),
    );
  }

  static void showUnlockTypeDialog() async {
    await Future.delayed(const Duration(seconds: 2));
    Get.dialog(
      const UnlockTypeDialog(),
      barrierDismissible: false,
      name: "Type_Unlock_Dialog",
    );
  }

  static void showUnlockUndeletedMessageDialog() async {
    Get.dialog(
        const UnlockTypeDialog(
          forUnlockMessages: true,
        ),
        barrierDismissible: false,
        name: "Type_Unlock_Dialog");
  }

  static void noAnyPathsFoundDialog() {
    Get.dialog(const NoAnyPathsFoundDialog());
  }
}
