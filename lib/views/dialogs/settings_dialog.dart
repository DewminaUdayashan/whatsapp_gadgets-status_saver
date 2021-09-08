import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:whatsapp_gadgets/constants/controllers_instatnceses.dart';
import 'package:whatsapp_gadgets/helpers/storage_helper.dart';

class SettingsDialog extends StatelessWidget {
  const SettingsDialog({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: context.theme.scaffoldBackgroundColor,
      insetPadding: const EdgeInsets.all(8),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Obx(
            () => SwitchListTile(
              title: Text(
                'Dark Mode',
                style: context.theme.textTheme.headline6,
              ),
              value: controller.isDarkMode,
              onChanged: (val) {
                if (val) {
                  Get.changeThemeMode(ThemeMode.dark);
                  controller.darkMode = val;
                  StorageHelper.markAsDarkModeEnable(val: val);
                } else {
                  Get.changeThemeMode(ThemeMode.light);
                  controller.darkMode = val;
                  StorageHelper.markAsDarkModeEnable();
                }
              },
            ),
          ),
          Obx(
            () => SwitchListTile(
              title: Text(
                'Reminder Notification',
                style: context.theme.textTheme.headline6,
              ),
              value: controller.isNotificationEnabled,
              onChanged: (val) {
                controller.setNotificationState = val;
                StorageHelper.setNotificationState(val: val);
                if (!val) {
                  controller.notificationController.cancel();
                } else {
                  if (!controller.isNotificationEnabled) {
                    controller.notificationController.showDailyNotification();
                  }
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
