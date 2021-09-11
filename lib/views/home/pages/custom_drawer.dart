import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:listen_whatsapp/listen_whatsapp.dart';
import 'package:share_plus/share_plus.dart';
import 'package:whatsapp_gadgets/constants/constants.dart';
import 'package:whatsapp_gadgets/constants/texts.dart';
import 'package:whatsapp_gadgets/controllers/ad_controller.dart';
import 'package:whatsapp_gadgets/helpers/dialog_helper.dart';
import 'package:whatsapp_gadgets/views/home/pages/widgets/contact_us_button.dart';

class CustomDrawer extends StatelessWidget {
  const CustomDrawer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
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
                Image.asset(
                  'android/app/src/main/res/mipmap-xxxhdpi/ic_launcher_foreground.png',
                  width: Get.width / 3,
                  height: Get.width / 3,
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
                  onTap: () => DialogHelper.changeWaTypeDialog(),
                ),
                // DrawerButton(
                //   title: viewSaved,
                //   color: Colors.green,
                //   onTap: () {
                //     Get.find<AppController>().selectWhatsAppType =
                //         WhatsAppType.saved;
                //     Get.find<ImageController>().loadImages(
                //       fromDirectory: true,
                //       path1: savedDirectory,
                //     );
                //     Get.find<VideoController>().loadVideos(
                //       fromDirectory: true,
                //       path1: savedDirectory,
                //     );
                //     if (Home.getScaffoldKey.currentState!.isDrawerOpen) {
                //       Get.back();
                //     }
                //   },
                // ),
                const SizedBox(
                  height: 16,
                ),
                const Divider(
                  color: Colors.grey,
                ),
                DrawerButton(
                  title: sendDirectMessage,
                  color: Colors.blueGrey,
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
                      if (Get.find<AdController>().isPremiumUnlocked.value) {
                        Get.toNamed("/messages");
                      } else {
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
                      const Expanded(child: ContactUsButton()),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Row(
                    children: [
                      Expanded(
                        child: IconButton(
                          onPressed: () {
                            Share.share(
                              'Hey.! I found a super cool status saver. Check it out. 🤩\nhttps://play.google.com/store/apps/details?id=dewz.whatsapp.status.status_saver',
                            );
                          },
                          icon: Row(
                            children: [
                              Icon(
                                Icons.share,
                                color: context.theme.iconTheme.color,
                              ),
                              const SizedBox(width: 5),
                              Text(
                                "Share",
                                style:
                                    context.theme.textTheme.headline6!.copyWith(
                                  fontWeight: FontWeight.normal,
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Row(
                    children: [
                      Expanded(
                        child: IconButton(
                          onPressed: () {
                            DialogHelper.whyAdsDialog();
                          },
                          icon: Row(
                            children: [
                              Text(
                                "why ads?",
                                style:
                                    context.theme.textTheme.headline6!.copyWith(
                                  fontWeight: FontWeight.normal,
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
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
