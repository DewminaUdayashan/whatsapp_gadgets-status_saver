import 'package:flutter/material.dart';
import 'package:get/get.dart';

class WhyAds extends StatelessWidget {
  const WhyAds({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Dialog(
      insetPadding: const EdgeInsets.all(20),
      backgroundColor: context.theme.scaffoldBackgroundColor,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Why Ads?',
              style: context.textTheme.headline5!.copyWith(
                fontWeight: FontWeight.w900,
                fontSize: 25,
              ),
            ),
            const Divider(),
            Text(
              "I know ads are disturbing to you. But it is the only way I can earn & maintain this service for you.🥺\n"
              "I always trying to "
              "reduce the amount of ads that showing to you & give all features completely free & user friendly. From future updates there will be ways to"
              " remove ads & use this app as you like. And there will be more features on future updates.🥳 Please let me know your thoughts,"
              " suggestions & complains.\n\n❤",
              textAlign: TextAlign.center,
              style: context.textTheme.headline5!.copyWith(
                letterSpacing: 1.5,
              ),
            ),
            const Divider(),
            TextButton(
              onPressed: () => Get.back(),
              style: TextButton.styleFrom(
                backgroundColor: Colors.green,
              ),
              child: const Text(
                'Back',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
