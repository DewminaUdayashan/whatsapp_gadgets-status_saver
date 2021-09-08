import 'package:flutter/material.dart';
import 'package:listen_whatsapp/listen_whatsapp.dart';
import 'package:whatsapp_gadgets/constants/texts.dart';
import 'package:get/get.dart';

class AskNotificationPermissionDialog extends StatelessWidget {
  const AskNotificationPermissionDialog({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Dialog(
      insetPadding: const EdgeInsets.all(20),
      backgroundColor: context.theme.scaffoldBackgroundColor,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 25),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              notificationPermission,
              style: context.theme.textTheme.headline5!.copyWith(
                fontSize: 25,
              ),
            ),
            const SizedBox(height: 16),
            Divider(color: context.theme.accentColor),
            Text(
              notificationPermission2,
              textAlign: TextAlign.center,
              style: context.theme.textTheme.headline5!.copyWith(
                fontSize: 20,
              ),
            ),
            const SizedBox(height: 16),
            TextButton(
              onPressed: () {
                if (Get.isDialogOpen!) {
                  Get.back();
                }
                ListenWhatsapp.startService();
              },
              style: TextButton.styleFrom(
                backgroundColor: Colors.green,
              ),
              child: const Text(
                'Continue',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
