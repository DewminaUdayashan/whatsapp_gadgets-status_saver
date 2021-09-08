import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:whatsapp_gadgets/constants/constants.dart' as constants;
import 'package:whatsapp_gadgets/constants/whatsapp_types.dart';
import 'package:whatsapp_gadgets/controllers/app_controller.dart';
import 'package:whatsapp_gadgets/controllers/image_controller.dart';
import 'package:whatsapp_gadgets/helpers/utils.dart';

class ImageView extends StatefulWidget {
  const ImageView(this.currentIndex);

  final int currentIndex;

  @override
  _ImageViewState createState() => _ImageViewState();
}

class _ImageViewState extends State<ImageView> {
  ImageController controller = Get.find<ImageController>();
  final List<WhatsAppType> waTypes = List<WhatsAppType>.empty(growable: true);
  final ValueNotifier<bool> isDialOpen = ValueNotifier(false);

  @override
  void initState() {
    super.initState();
    waTypes.addAll(Get.find<AppController>().availableWhatsAppTypes);
    if (waTypes.contains(WhatsAppType.normal) &&
        waTypes.contains(WhatsAppType.dual)) {
      waTypes.remove(WhatsAppType.dual);
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        controller.selectedImageList.clear();
        return true;
      },
      child: WillPopScope(
        onWillPop: () async {
          if (isDialOpen.value) {
            isDialOpen.value = false;
            return false;
          }
          controller.selectedImageList.clear();
          return true;
        },
        child: Scaffold(
          backgroundColor: context.theme.accentColor,
          body: Stack(
            children: [
              PhotoViewGallery.builder(
                itemCount: controller.getImages.length,
                builder: (context, index) {
                  return PhotoViewGalleryPageOptions(
                    imageProvider: MemoryImage(controller.getImages[index]),
                    initialScale: PhotoViewComputedScale.contained,
                    minScale: PhotoViewComputedScale.contained,
                  );
                },
                loadingBuilder: (context, event) => Center(
                  child: SizedBox(
                    width: 20.0,
                    height: 20.0,
                    child: CircularProgressIndicator(
                      value: event == null
                          ? 0
                          : event.cumulativeBytesLoaded /
                              event.expectedTotalBytes!,
                    ),
                  ),
                ),
                backgroundDecoration: BoxDecoration(
                  color: context.theme.scaffoldBackgroundColor,
                ),
                pageController:
                    PageController(initialPage: widget.currentIndex),
                onPageChanged: (index) {
                  controller.setSelectedSingleImage(index);
                },
              ),
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: Material(
                  child: Container(
                    color: const Color.fromRGBO(7, 94, 84, 1),
                    // color: Colors.grey[900],
                    height: Get.height * 0.1,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        IconButton(
                          color: Colors.black,
                          icon: const Icon(
                            Icons.save,
                            color: constants.lightGrey,
                          ),
                          tooltip: 'Save Image',
                          onPressed: () {
                            controller.saveImage();
                          },
                        ),
                        IconButton(
                          icon: const Icon(
                            Icons.share,
                            color: constants.lightGrey,
                          ),
                          tooltip: 'Share Image',
                          onPressed: () {
                            controller.shareImage();
                          },
                        ),
                        if (Get.find<AppController>()
                                .availableWhatsAppTypes
                                .length ==
                            1) ...[
                          IconButton(
                            color: constants.lightGreen,
                            icon: const FaIcon(
                              FontAwesomeIcons.whatsapp,
                            ),
                            onPressed: () => controller.shareImage(
                              package: 'com.whatsapp',
                            ),
                          ),
                        ] else ...[
                          SpeedDial(
                            icon: FontAwesomeIcons.whatsapp,
                            iconTheme: const IconThemeData(
                              color: Colors.greenAccent,
                            ),
                            elevation: 0,
                            activeIcon: Icons.close,
                            backgroundColor: Colors.transparent,
                            activeBackgroundColor:
                                Colors.black12.withOpacity(.3),
                            overlayColor: Colors.black.withOpacity(.2),
                            openCloseDial: isDialOpen,
                            spaceBetweenChildren: 14,
                            children: [
                              for (var type in waTypes)
                                SpeedDialChild(
                                  backgroundColor:
                                      Utils.getColorForWaType(type),
                                  onTap: () {
                                    controller.shareImage(
                                      package:
                                          Utils.getPackageNameForWaType(type),
                                    );
                                  },
                                  label: Utils.getNameForWaType(type),
                                  labelBackgroundColor:
                                      context.theme.canvasColor,
                                  labelStyle: context.theme.textTheme.headline6!
                                      .copyWith(
                                    fontSize: 10,
                                    fontWeight: FontWeight.normal,
                                    fontStyle: FontStyle.italic,
                                  ),
                                  child:
                                      const FaIcon(FontAwesomeIcons.whatsapp),
                                ),
                            ],
                          ),
                        ]
                      ],
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}



