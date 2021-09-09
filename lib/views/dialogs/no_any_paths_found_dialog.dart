import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

class NoAnyPathsFoundDialog extends StatelessWidget {
  const NoAnyPathsFoundDialog({Key? key}) : super(key: key);

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
              'Attention..!',
              style: context.theme.textTheme.headline5!.copyWith(
                fontSize: 25,
              ),
            ),
            const Divider(),
            Text(
              'We cannot found any statuses. Please watch some statuses & restart the app before load the app for the '
              'first time.Also Make sure you have installed WhatsApp on your mobile.\n☺',
              textAlign: TextAlign.center,
              style: context.theme.textTheme.headline5!.copyWith(
                fontSize: 20,
              ),
            ),
            const Divider(),
            TextButton(
              onPressed: () {
                SystemNavigator.pop(animated: true);
              },
              style: TextButton.styleFrom(
                backgroundColor: Colors.green,
              ),
              child: const Text(
                'Sure',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
