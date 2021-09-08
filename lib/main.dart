import 'dart:async';
import 'package:facebook_audience_network/facebook_audience_network.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:whatsapp_gadgets/bindings/home_binding.dart';
import 'package:whatsapp_gadgets/bindings/initial_binding.dart';
import 'package:whatsapp_gadgets/bindings/messages_binding.dart';
import 'package:whatsapp_gadgets/bindings/splash_binding.dart';
import 'package:whatsapp_gadgets/constants/texts.dart';
import 'package:whatsapp_gadgets/constants/themes.dart';
import 'package:whatsapp_gadgets/helpers/dialog_helper.dart';
import 'package:whatsapp_gadgets/helpers/permission/old_permission_handler.dart';
import 'package:whatsapp_gadgets/helpers/storage_helper.dart';
import 'package:whatsapp_gadgets/views/home/home.dart';
import 'package:whatsapp_gadgets/views/home/messages/messages.dart';
import 'package:whatsapp_gadgets/views/permission/permission_asker_screen.dart';
import 'package:whatsapp_gadgets/views/splash/splash_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runZonedGuarded<Future<void>>(() async {
    FirebaseCrashlytics.instance.setCrashlyticsCollectionEnabled(true);
    FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterError;
    await GetStorage.init();
    FacebookAudienceNetwork.init(
      testingId: "93844ac8-5f8f-4abd-9588-b3bb99a9cae9",
    );
    runApp(MyApp());
  }, (error, stack) => FirebaseCrashlytics.instance.recordError(error, stack));
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'WhatsApp Gadgets',
      theme: Themes.theme,
      darkTheme: Themes.darkTheme,
      themeMode: StorageHelper.getThemeMode(),
      getPages: [
        GetPage(
          name: "/home",
          page: () => Home(),
          binding: HomeBinding(),
          transition: Transition.downToUp,
        ),
        GetPage(
          name: "/api_30_permission",
          page: () => PermissionAskerScreen(
            title: letsSetup,
            subTitle: privacyDetailsApi30,
            onTap: () {
              DialogHelper.permissionDialogApi30();
            },
          ),
        ),
        GetPage(
          name: "/permission",
          page: () => PermissionAskerScreen(
            title: letsSetup,
            subTitle: privacyDetails,
            onTap: () {
              OldPermissionHandler.askPermission();
            },
          ),
        ),
        GetPage(
          name: "/splash",
          page: () => const SplashScreen(
            shouldWarmUp: false,
          ),
          binding: SplashBinding(),
          transition: Transition.noTransition,
        ),
        GetPage(
          name: "/messages",
          page: () => const MessagesScreen(),
          binding: MessagesBinding(),
          transition: Transition.noTransition,
        ),
      ],
      initialBinding: InitialBinding(),
      // home: const SplashScreen(),
      home: const SplashScreen(),
    );
  }
}
