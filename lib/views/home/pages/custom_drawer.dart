import 'dart:io';

import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:listen_whatsapp/listen_whatsapp.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:whatsapp_gadgets/constants/constants.dart';
import 'package:whatsapp_gadgets/constants/texts.dart';
import 'package:whatsapp_gadgets/constants/whatsapp_types.dart';
import 'package:whatsapp_gadgets/controllers/ad_controller.dart';
import 'package:whatsapp_gadgets/controllers/app_controller.dart';
import 'package:whatsapp_gadgets/controllers/image_controller.dart';
import 'package:whatsapp_gadgets/controllers/notification_controller.dart';
import 'package:whatsapp_gadgets/controllers/video_controller.dart';
import 'package:whatsapp_gadgets/helpers/dialog_helper.dart';
import 'package:whatsapp_gadgets/helpers/snack_helper.dart';
import 'package:whatsapp_gadgets/views/home/home.dart';

class CustomDrawer extends StatelessWidget {
  const CustomDrawer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (Scaffold.of(context).isDrawerOpen) {}
        print('open');

        return true;
      },
      child: Drawer(
        child: Container(
          color: Theme.of(context).scaffoldBackgroundColor,
          child: Scrollbar(
            interactive: true,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  const SizedBox(
                    height: kToolbarHeight / 1.7,
                  ),
                  const FaIcon(
                    FontAwesomeIcons.whatsappSquare,
                    color: lightGreen,
                    size: 70,
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  Text(
                    name,
                    style: context.theme.textTheme.headline6,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  const Divider(
                    color: Colors.grey,
                  ),
                  DrawerButton(
                      title: changeType,
                      onTap: () => DialogHelper.changeWaTypeDialog()),
                  DrawerButton(
                    title: viewSaved,
                    color: Colors.green,
                    onTap: () {
                      Get.find<AppController>().selectWhatsAppType =
                          WhatsAppType.saved;
                      Get.find<ImageController>().loadImages(
                        fromDirectory: true,
                        path1: savedDirectory,
                      );
                      Get.find<VideoController>().loadVideos(
                        fromDirectory: true,
                        path1: savedDirectory,
                      );
                      if (Home.getScaffoldKey.currentState!.isDrawerOpen) {
                        Get.back();
                      }
                    },
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  const Divider(
                    color: Colors.grey,
                  ),
                  DrawerButton(
                    title: sendDirectMessage,
                    color: tealGreen,
                    onTap: () {
                      DialogHelper.directMessageDialog();
                    },
                  ),
                  DrawerButton(
                    title: messages,
                    color: lightBlue,
                    onTap: () async {
                      final permission =
                          await ListenWhatsapp.checkIsServiceEnabled();
                      if (permission) {
                        print('ready to start');
                        if (Get.find<AdController>()
                            .isUndeletedMessagesUnlocked
                            .value) {
                          print('navigating =========================>');
                          Get.toNamed("/messages");
                        } else {
                          print('Unlock =========================>');
                          DialogHelper.showUnlockUndeletedMessageDialog();
                        }
                      } else {
                        DialogHelper.askNotificationPermission();
                      }
                    },
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  const Divider(
                    color: Colors.grey,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Row(
                      children: [
                        IconButton(
                          onPressed: () {
                            DialogHelper.settingsDialog();
                          },
                          icon: Icon(
                            Icons.settings,
                            color: context.theme.iconTheme.color,
                          ),
                        ),
                        Expanded(
                          child: IconButton(
                            onPressed: () async {
                              try {
                                const number = '+94787693462';
                                const message = "";
                                const url =
                                    "https://wa.me/$number?text=$message";
                                if (await canLaunch(url)) {
                                  await launch(url);
                                } else {
                                  SnackHelper.contactError();
                                }
                              } catch (e, stack) {
                                SnackHelper.contactError();
                                FirebaseCrashlytics.instance.log(e.toString());
                                FirebaseCrashlytics.instance
                                    .recordError(e, stack);
                              }
                            },
                            icon: Row(
                              children: [
                                Icon(
                                  FontAwesomeIcons.whatsapp,
                                  color: context.theme.iconTheme.color,
                                ),
                                const SizedBox(width: 5),
                                Text(
                                  "Contact Us",
                                  style: context.theme.textTheme.headline6!
                                      .copyWith(
                                    fontWeight: FontWeight.normal,
                                    fontSize: 10,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class DrawerButton extends StatelessWidget {
  final String title;
  final Function onTap;
  final Color color;

  const DrawerButton({
    Key? key,
    required this.title,
    required this.onTap,
    this.color = lightGreen,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: Padding(
        padding: const EdgeInsets.only(top: 16, right: 16, left: 16),
        child: InkWell(
          splashColor: tealGreen,
          highlightColor: Colors.transparent,
          onTap: () => onTap(),
          borderRadius: BorderRadius.circular(16),
          child: Ink(
            width: Get.width,
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Padding(
              padding: const EdgeInsets.all(17.0),
              child: Text(
                title,
                style: Theme.of(context).textTheme.headline6!.copyWith(
                      fontWeight: FontWeight.w400,
                      fontSize: 18,
                      color: Colors.white,
                    ),
                textAlign: TextAlign.center,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
