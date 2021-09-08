import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:whatsapp_gadgets/controllers/app_controller.dart';

const Duration splashDuration = Duration(milliseconds: 2500);
final Color darkGrey = Colors.grey[900]!;
const Color lightGreen = Color.fromRGBO(37, 211, 102, 1);
const Color lightGrey = Color.fromRGBO(236, 229, 221, 1);
const Color tealGreen = Color.fromRGBO(7, 94, 84, 1);
const Color lightBlue = Color.fromRGBO(52, 183, 241, 1);

const String whatsAppApi30 =
    'primary:Android/Media/com.whatsapp/WhatsApp/Media/.Statuses';
const String whatsApp4BApi30 =
    'primary:Android/Media/com.whatsapp.w4b/WhatsApp%20Business/Media/.Statuses';
const String whatsAppGBApi30Path1 =
    'primary:Android/Media/com.gbwhatsapp/GBWhatsApp/Media/.Statuses';
const String whatsAppGBApi30Path2 = 'primary:GBWhatsApp/Media/.Statuses';
const String whatsAppDualApi30 =
    'primary:DualApp/Android/Media/com.whatsapp/WhatsApp/Media/.Statuses';

const String whatsApp =
    '/storage/emulated/0/Android/media/com.whatsapp/WhatsApp/Media/.Statuses';
const String whatsApp2 = '/storage/emulated/0/WhatsApp/Media/.Statuses';

const String whatsApp4B =
    '/storage/emulated/0/Android/Media/com.whatsapp.w4b/WhatsApp Business/Media/.Statuses';
const String whatsApp4B2 =
    '/storage/emulated/0/WhatsApp Business/Media/.Statuses';

const String whatsAppGB =
    '/storage/emulated/0/Android/Media/com.gbwhatsapp/GBWhatsApp/Media/.Statuses';
const String whatsAppGB2 = '/storage/emulated/0/GBWhatsApp/Media/.Statuses';

const String whatsAppDual =
    '/storage/emulated/0/DualApp/Android/Media/com.whatsapp/WhatsApp/Media/.Statuses';
const String whatsAppDual2 =
    '/storage/emulated/0/DualApp/WhatsApp/Media/.Statuses';

const String savedDirectory = '/storage/emulated/0/DCIM/DewzStatus';

const String tempThumbName = '.ss_tmp_thumbs';
const String tempShareName = '.ss_tmp_share';
const String tempWaShare = 'ss_tmp_share';

const welcomedStorageKey = 'USER_WELCOMED_STORAGE_KEY_!242B1634';
const darkModeStorageKey = 'DARK_MODE_ENABLED_STORAGE_KEY_324!@&';
const notificationEnabledKey = "NOTIFICATION_ENABLED_KEY_@#@132453";
const bugLogKey = "APP_BUG_LOG_KEY_!@#11314";

const avatarColors = <Color>[
  Colors.lightBlueAccent,
  Colors.amber,
  Colors.greenAccent,
  Colors.yellowAccent,
  Colors.lightGreenAccent,
  Colors.redAccent,
  Colors.tealAccent,
  Colors.cyanAccent,
  Colors.amberAccent,
];
