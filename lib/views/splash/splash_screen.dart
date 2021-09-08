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
    print('loading home');
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
    // WidgetsBinding.instance!.addPostFrameCallback((_){
    //   Future.delayed(splashDuration,(){
    //     Get.offNamed("/home");
    //   });
    // });
    return Scaffold(
      body: Center(
        child: Icon(
          Icons.whatshot,
          color: Theme.of(context).accentColor,
        ),
      ),
    );
  }
}
