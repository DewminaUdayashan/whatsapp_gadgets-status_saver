import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:whatsapp_gadgets/controllers/ad_controller.dart';

class ExitDialog extends StatelessWidget {
  const ExitDialog({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Dialog(

      backgroundColor: context.theme.scaffoldBackgroundColor,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              "Exit?",
              style: context.textTheme.headline5!.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const Divider(),
            Get.find<AdController>().typeChangeDialogNativeAd(),
            const Divider(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                TextButton(
                  onPressed: () {
                    SystemNavigator.pop();
                  },
                  style: TextButton.styleFrom(backgroundColor: Colors.grey),
                  child: const Text(
                    'Yes',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
                TextButton(
                  onPressed: () {
                    Get.back();
                  },
                  style: TextButton.styleFrom(backgroundColor: Colors.green),
                  child: const Text(
                    'No',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),

    );
  }
}
