import 'dart:math';

import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:whatsapp_gadgets/constants/constants.dart';
import 'package:whatsapp_gadgets/constants/texts.dart';

class SnackHelper {
  static void contactError() {
    Get.rawSnackbar(
      backgroundColor: Colors.amber,
      icon: const Icon(
        Icons.error_outline_outlined,
        color: Colors.black,
      ),
      titleText: const Text(
        'Something Went Wrong with making connection..',
        style: TextStyle(fontWeight: FontWeight.w700),
      ),
      messageText: const Text(
          "Please be kind enough to mail us 'dewappsacc@gmail.com'. We'll contact you soon. Thank you.!"),
      duration: const Duration(seconds: 6),
      mainButton: TextButton(
        onPressed: () {
          FirebaseCrashlytics.instance
              .log("User send log ====> " + e.toString());
        },
        child: const Text(reportBug),
      ),
      snackPosition: SnackPosition.TOP,
    );
  }

  static void cantSendMessage({String? err}) {
    Get.rawSnackbar(
      backgroundColor: Colors.amber,
      icon: const Icon(
        Icons.error_outline_outlined,
        color: Colors.black,
      ),
      titleText: const Text(
        'Something Went Wrong',
        style: TextStyle(fontWeight: FontWeight.w700),
      ),
      messageText: const Text("Can't Send Message. Please Check Your Info."),
      duration: const Duration(seconds: 4),
      mainButton: TextButton(
        onPressed: () {
          FirebaseCrashlytics.instance
              .log("User send log ====> " + e.toString());
        },
        child: const Text(reportBug),
      ),
      snackPosition: SnackPosition.TOP,
    );
  }

  static void savedSnack() {
    Get.rawSnackbar(
      backgroundColor: tealGreen,
      icon: const Icon(
        Icons.check_circle,
        color: Colors.black,
      ),
      titleText: const Text(
        'Success',
        style: TextStyle(fontWeight: FontWeight.w700),
      ),
      messageText: const Text('Status Saved to Your Gallery'),
      duration: const Duration(seconds: 4),
      snackPosition: SnackPosition.TOP,
    );
  }

  static void permissionGrantSnack() {
    Get.rawSnackbar(
      backgroundColor: Colors.amber,
      icon: const Icon(
        Icons.error_outline_outlined,
        color: Colors.black,
      ),
      titleText: const Text(
        'Something Went Wrong',
        style: TextStyle(fontWeight: FontWeight.w700),
      ),
      messageText: const Text('Please Follow Instructions'),
      duration: const Duration(seconds: 2),
    );
  }

  static void permissionDenied() {
    Get.rawSnackbar(
      backgroundColor: Colors.amber,
      icon: const Icon(
        Icons.error_outline_outlined,
        color: Colors.black,
      ),
      titleText: const Text(
        'Something Went Wrong',
        style: TextStyle(fontWeight: FontWeight.w700),
      ),
      messageText: const Text('Please Follow Instructions'),
      duration: const Duration(seconds: 2),
    );
  }

  static void permissionDeniedForever() {
    Get.rawSnackbar(
      backgroundColor: Colors.amber,
      icon: const Icon(
        Icons.error_outline_outlined,
        color: Colors.black,
      ),
      titleText: const Text(
        'Permission Permanently Denied',
        style: TextStyle(fontWeight: FontWeight.w700),
      ),
      messageText: const Text('Please Open App Settings & Grant Permission'),
      mainButton: TextButton(
        onPressed: () {
          openAppSettings();
        },
        style: TextButton.styleFrom(
          backgroundColor: Colors.green,
        ),
        child: const Text(
          'Grant',
          style: TextStyle(
            color: Colors.white70,
          ),
        ),
      ),
      duration: const Duration(seconds: 2),
    );
  }
}
