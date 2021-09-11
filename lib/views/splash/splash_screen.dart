import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:whatsapp_gadgets/constants/constants.dart';
import 'package:whatsapp_gadgets/controllers/app_controller.dart';

class SplashScreen extends StatefulWidget {
  final bool shouldWarmUp;

  const SplashScreen({Key? key, this.shouldWarmUp = true}) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  Future<void> _getToHome() async {
    await Future.delayed(splashDuration);
    Get.offNamed('/home');
  }

  @override
  void initState() {
    super.initState();
    if (widget.shouldWarmUp) {
      Get.find<AppController>().warmUp();
    } else {
      _getToHome();
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Stack(
          fit: StackFit.expand,
          children: [
            Align(
              alignment: Alignment.center,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Image.asset(
                    'android/app/src/main/res/mipmap-xxxhdpi/ic_launcher_foreground.png',
                    width: Get.width / 2,
                    height: Get.width / 2,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Hello there.!',
                    textAlign: TextAlign.center,
                    style: context.textTheme.headline6!.copyWith(
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: LinearProgressIndicator(
                backgroundColor: context.theme.scaffoldBackgroundColor,
                color: lightGreen,
                minHeight: 7,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
