import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:whatsapp_gadgets/constants/constants.dart';
import 'package:whatsapp_gadgets/constants/controllers_instance.dart';
import 'package:whatsapp_gadgets/constants/texts.dart';
import 'package:whatsapp_gadgets/constants/whatsapp_types.dart';
import 'package:whatsapp_gadgets/controllers/ad_controller.dart';
import 'package:whatsapp_gadgets/controllers/app_controller.dart';
import 'package:whatsapp_gadgets/controllers/image_controller.dart';
import 'package:whatsapp_gadgets/controllers/video_controller.dart';
import 'package:whatsapp_gadgets/helpers/dialog_helper.dart';
import 'package:whatsapp_gadgets/helpers/permission/api30_permission_handler.dart';
import 'package:whatsapp_gadgets/helpers/snack_helper.dart';
import 'package:whatsapp_gadgets/helpers/utils.dart';
import 'package:whatsapp_gadgets/views/home/home.dart';

class ChangeWATypeDialog extends GetWidget<AdController> {
  const ChangeWATypeDialog({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: context.theme.scaffoldBackgroundColor,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16),
              child: Text(
                changeType2,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.headline4!.copyWith(
                      fontSize: 20,
                    ),
              ),
            ),
            Divider(color: Theme.of(context).accentColor),
            const SizedBox(height: 10),
            SingleChildScrollView(
              child: Obx(
                () => Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    ...controller.availableWhatsAppTypes
                        .toSet()
                        .toList()
                        .map((type) {
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 8),
                        child: ListTile(
                          tileColor: Colors.grey,
                          selected: controller.selectedWhatsAppType == type,
                          selectedTileColor: Colors.greenAccent,
                          onTap: () async {
                            if (type == WhatsAppType.saved) {
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
                              if (Get.isDialogOpen!) {
                                Get.back();
                              }
                              if (Home
                                  .getScaffoldKey.currentState!.isDrawerOpen) {
                                Get.back();
                              }
                            } else {
                              final List<String> paths =
                                  await Utils.getPathForWaType(type);
                              if (await controller.isNewVersion()) {
                                final val = await Api30PermissionHandler
                                    .checkPermission(
                                  url: paths.first.replaceAll('%20', ' '),
                                  blockNavigate: true,
                                );
                                if (val) {
                                  if (Get.isDialogOpen!) {
                                    Get.back();
                                  }
                                  if (Home.getScaffoldKey.currentState!
                                      .isDrawerOpen) {
                                    Get.back();
                                  }
                                  controller.selectWhatsAppType = type;
                                  Get.find<ImageController>()
                                      .loadImages(api30Path: paths.first);
                                  Get.find<VideoController>()
                                      .loadVideos(api30Path: paths.first);
                                } else {
                                  DialogHelper.permissionDialogApi30(
                                      overrideDefaultFunction: () async {
                                    if (await Api30PermissionHandler
                                        .askPermission(
                                      url: paths.first,
                                    )) {
                                      if (Get.isDialogOpen!) {
                                        Get.back();
                                      }
                                      if (Home.getScaffoldKey.currentState!
                                          .isDrawerOpen) {
                                        Get.back();
                                      }
                                      controller.selectWhatsAppType = type;
                                      Get.find<ImageController>()
                                          .loadImages(api30Path: paths.first);
                                      Get.find<VideoController>()
                                          .loadVideos(api30Path: paths.first);
                                    } else {
                                      SnackHelper.permissionGrantSnack();
                                    }
                                  });
                                }
                              } else {
                                controller.selectWhatsAppType = type;
                                if (Get.isDialogOpen!) {
                                  Get.back();
                                }
                                if (Home.getScaffoldKey.currentState!
                                    .isDrawerOpen) {
                                  Get.back();
                                }
                                Get.find<ImageController>().loadImages(
                                  path1: paths.first,
                                  path2: paths.last,
                                );
                                Get.find<VideoController>().loadVideos(
                                  path1: paths.first,
                                  path2: paths.last,
                                );
                              }
                            }
                          },
                          title: Center(
                            child: Text(
                              type == WhatsAppType.saved
                                  ? viewSaved
                                  : Utils.getNameForWaType(
                                      type,
                                      forList: true,
                                    ),
                              style: Theme.of(context)
                                  .textTheme
                                  .headline4!
                                  .copyWith(
                                    fontSize: 20,
                                    fontWeight: FontWeight.w400,
                                    color:
                                        controller.selectedWhatsAppType == type
                                            ? Colors.green[900]
                                            : Colors.white,
                                  ),
                            ),
                          ),
                          subtitle: controller.selectedWhatsAppType == type
                              ? const Center(
                                  child: Text(
                                  'Active',
                                  style: TextStyle(
                                    color: Colors.green,
                                  ),
                                ))
                              : const SizedBox.shrink(),
                        ),
                      );
                    }).toList(),
                    if (controller.availableWhatsAppTypes.length < 4) ...[
                      Text(
                        noMoreTypes,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Theme.of(context).accentColor,
                        ),
                      )
                    ],
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
