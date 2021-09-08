import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:whatsapp_gadgets/constants/controllers_instatnceses.dart';
import 'package:whatsapp_gadgets/constants/whatsapp_types.dart';
import 'package:whatsapp_gadgets/controllers/app_controller.dart';

class EmptyScreen extends GetWidget<AppController> {
  const EmptyScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Obx(
        () => Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              controller.selectedWhatsAppType == WhatsAppType.saved
                  ? "😱\n\n You don't have saved statuses yet"
                  : "😱\n\nThere isn't any new statuses available\n",
              style: context.theme.textTheme.headline6!.copyWith(
                color: context.theme.accentColor,
              ),
              textAlign: TextAlign.center,
            ),
            Text(
              controller.selectedWhatsAppType == WhatsAppType.saved
                  ? "Please comeback after saving statuses"
                  : "Please comeback after watching some status from your WhatsApp "
                      "& reload.\n\n😇",
              textAlign: TextAlign.center,
              style: context.theme.textTheme.headline6,
            ),
            const SizedBox(height: 16),
            TextButton(
              onPressed: () {
                controller.handleRefresh();
              },
              style: TextButton.styleFrom(
                backgroundColor: Colors.green,
              ),
              child: const Text(
                'Reload',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
