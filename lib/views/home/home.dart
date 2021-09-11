import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:whatsapp_gadgets/constants/constants.dart';
import 'package:whatsapp_gadgets/constants/whatsapp_types.dart';
import 'package:whatsapp_gadgets/controllers/ad_controller.dart';
import 'package:whatsapp_gadgets/controllers/app_controller.dart';
import 'package:whatsapp_gadgets/controllers/image_controller.dart';
import 'package:whatsapp_gadgets/controllers/page_view_controller.dart';
import 'package:whatsapp_gadgets/controllers/video_controller.dart';
import 'package:whatsapp_gadgets/helpers/dialog_helper.dart';
import 'package:whatsapp_gadgets/helpers/utils.dart';
import 'package:whatsapp_gadgets/views/home/pages/custom_drawer.dart';
import 'package:whatsapp_gadgets/views/home/pages/image_list_page.dart';
import 'package:whatsapp_gadgets/views/home/pages/video_list_page.dart';

const homePages = <Widget>[
  ImageListPage(),
  VideoListPage(),
];

class Home extends GetWidget<PageViewController> {
  Home({Key? key}) : super(key: key);

  final ImageController pc = Get.find<ImageController>();
  final VideoController vc = Get.find<VideoController>();
  static final GlobalKey<ScaffoldState> _scaffoldKey =
      GlobalKey<ScaffoldState>();

  static GlobalKey<ScaffoldState> get getScaffoldKey => _scaffoldKey;

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance!.addPostFrameCallback((timeStamp) {
      Get.find<AppController>().welcome();
      Get.find<AppController>().wVal = 1;
    });
    return WillPopScope(
      onWillPop: () async {
        if (_scaffoldKey.currentState!.isDrawerOpen) {
          Navigator.pop(context);
        }
        if (pc.selectedImageList.isNotEmpty) {
          pc.selectedImageList.clear();
        } else if (vc.selectedVideoList.isNotEmpty) {
          vc.selectedVideoList.clear();
        } else {
          DialogHelper.exitDialog();
        }
        return Future.value(false);
      },
      child: SafeArea(
        child: Scaffold(
            key: _scaffoldKey,
            backgroundColor: context.theme.scaffoldBackgroundColor,
            drawer: const CustomDrawer(),
            body: Builder(
              builder: (context) => Stack(
                children: [
                  Stack(
                    children: [
                      Column(
                        children: [
                          const SizedBox(
                            height: 50,
                          ),
                          Expanded(
                            child: PageView(
                              controller: controller.controller,
                              onPageChanged: (value) {
                                pc.selectedImageList.clear();
                                vc.selectedVideoList.clear();
                                controller.setCurrentPage = value;
                              },
                              children: homePages.toList(),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                          height: 52,
                          child: Get.find<AdController>()
                              .mainTopNativeBannerAd(context)),
                    ],
                  ),
                  Positioned(
                    bottom: 0,
                    child: Container(
                      height: Get.height / 10,
                      width: Get.width,
                      decoration: const BoxDecoration(
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(10),
                          topRight: Radius.circular(10),
                        ),
                        color: tealGreen,
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          vertical: 5,
                          horizontal: 20,
                        ),
                        child: Obx(
                          () => Row(
                            children: [
                              Expanded(
                                child: pc.selectedImageList.isNotEmpty ||
                                        vc.selectedVideoList.isNotEmpty
                                    ? IconButton(
                                        icon: const Icon(
                                          Icons.select_all,
                                          size: 20,
                                          color: Colors.white,
                                        ),
                                        onPressed: () {
                                          controller.currentPage == 0
                                              ? pc.selectAllImages()
                                              : vc.selectAllVideos();
                                        })
                                    : IconButton(
                                        icon: const Icon(
                                          Icons.menu_open_outlined,
                                          color: Colors.white,
                                          size: 20,
                                        ),
                                        onPressed: () =>
                                            Scaffold.of(context).openDrawer(),
                                      ),
                              ),
                              Expanded(
                                flex: 9,
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children: [
                                    IconButton(
                                        icon: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Icon(
                                              Icons.image,
                                              color: controller.currentPage == 0
                                                  ? lightGreen
                                                  : Colors.white,
                                            ),
                                            Obx(
                                              () => controller.currentPage == 0
                                                  ? Text(
                                                      pc.imageCount.toString(),
                                                      style: const TextStyle(
                                                        color: Colors.white,
                                                        fontSize: 7,
                                                      ),
                                                    )
                                                  : Container(
                                                      height: 0,
                                                    ),
                                            ),
                                          ],
                                        ),
                                        onPressed: () {
                                          pc.selectedImageList.clear();
                                          vc.selectedVideoList.clear();
                                          controller.animateToPage(0);
                                        }),
                                    IconButton(
                                        icon: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Icon(
                                              Icons.video_collection,
                                              color: controller.currentPage == 1
                                                  ? lightGreen
                                                  : Colors.white,
                                            ),
                                            Obx(
                                              () => controller.currentPage == 1
                                                  ? Text(
                                                      '${vc.getVideos.length}',
                                                      style: const TextStyle(
                                                        color: Colors.white,
                                                        fontSize: 7,
                                                      ),
                                                    )
                                                  : Container(
                                                      height: 0,
                                                    ),
                                            ),
                                          ],
                                        ),
                                        onPressed: () {
                                          pc.selectedImageList.clear();
                                          vc.selectedVideoList.clear();
                                          controller.animateToPage(1);
                                        }),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  Obx(
                    () => Positioned(
                      bottom: 35,
                      left: Get.width / 2.4,
                      right: Get.width / 2.4,
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        height: pc.selectedImageList.isNotEmpty ||
                                vc.selectedVideoList.isNotEmpty
                            ? 55
                            : 0,
                        width: pc.selectedImageList.isNotEmpty ? 55 : 0,
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.lightBlue,
                        ),
                        child: pc.selectedImageList.isNotEmpty ||
                                vc.selectedVideoList.isNotEmpty
                            ? FloatingActionButton(
                                backgroundColor: lightBlue,
                                onPressed: () {
                                  vc.selectedVideoList.isNotEmpty
                                      ? vc.saveVideo()
                                      : pc.saveImage();
                                },
                                child: const Icon(Icons.save),
                              )
                            : const SizedBox.shrink(),
                      ),
                    ),
                  ),
                  Obx(
                    () => AnimatedPositioned(
                      duration: const Duration(milliseconds: 300),
                      bottom: pc.selectedImageList.isNotEmpty ||
                              vc.selectedVideoList.isNotEmpty
                          ? 70
                          : -100,
                      right: 5,
                      child: pc.selectedImageList.isNotEmpty ||
                              vc.selectedVideoList.isNotEmpty
                          ? AnimatedContainer(
                              duration: const Duration(milliseconds: 300),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: pc.selectedImageList.isNotEmpty ||
                                        vc.selectedVideoList.isNotEmpty
                                    ? Colors.white
                                    : Colors.transparent,
                              ),
                              child: Row(
                                children: [
                                  TextButton(
                                    onPressed: () {
                                      vc.selectedVideoList.isNotEmpty
                                          ? vc.shareVideo()
                                          : pc.shareImage();
                                    },
                                    child: const Icon(Icons.share),
                                  ),
                                  TextButton(
                                    onPressed: () {
                                      vc.selectedVideoList.isNotEmpty
                                          ? vc.shareVideo(
                                              package: Utils
                                                  .getPackageNameForWaType(Get
                                                          .find<AppController>()
                                                      .availableWhatsAppTypes
                                                      .first),
                                            )
                                          : pc.shareImage(
                                              package: Utils
                                                  .getPackageNameForWaType(Get
                                                          .find<AppController>()
                                                      .availableWhatsAppTypes
                                                      .first),
                                            );
                                    },
                                    child: const FaIcon(
                                      FontAwesomeIcons.whatsapp,
                                    ),
                                  ),
                                ],
                              ),
                            )
                          : const SizedBox.shrink(),
                    ),
                  ),
                  Obx(
                    () => Get.find<AppController>().selectedWhatsAppType ==
                            WhatsAppType.saved
                        ? AnimatedPositioned(
                            duration: const Duration(milliseconds: 300),
                            bottom: pc.selectedImageList.isNotEmpty ||
                                    vc.selectedVideoList.isNotEmpty
                                ? 70
                                : -100,
                            left: 5,
                            child: pc.selectedImageList.isNotEmpty ||
                                    vc.selectedVideoList.isNotEmpty
                                ? AnimatedContainer(
                                    duration: const Duration(milliseconds: 300),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      color: pc.selectedImageList.isNotEmpty ||
                                              vc.selectedVideoList.isNotEmpty
                                          ? Colors.white
                                          : Colors.transparent,
                                    ),
                                    child: TextButton(
                                      onPressed: () {
                                        vc.selectedVideoList.isNotEmpty
                                            ? vc.deleteVideos()
                                            : pc.deleteImages();
                                      },
                                      child: const Icon(
                                        Icons.delete_forever_rounded,
                                        color: Colors.red,
                                      ),
                                    ),
                                  )
                                : const SizedBox.shrink(),
                          )
                        : const SizedBox.shrink(),
                  ),
                ],
              ),
            )),
      ),
    );
  }

  Color getColor(Set<MaterialState> states) {
    const Set<MaterialState> interactiveStates = <MaterialState>{
      MaterialState.pressed,
      MaterialState.hovered,
      MaterialState.focused,
    };
    if (states.any(interactiveStates.contains)) {
      return Colors.white.withOpacity(0.3);
    }
    return Colors.white.withOpacity(0.3);
  }
}
