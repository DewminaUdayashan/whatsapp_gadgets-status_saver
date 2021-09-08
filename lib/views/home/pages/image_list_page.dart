import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:get/get.dart';
import 'package:liquid_pull_to_refresh/liquid_pull_to_refresh.dart';
import 'package:whatsapp_gadgets/constants/constants.dart';
import 'package:whatsapp_gadgets/controllers/image_controller.dart';
import 'package:whatsapp_gadgets/views/dialogs/empty_screen.dart';

import 'image_view.dart';

class ImageListPage extends GetWidget<ImageController> {
  const ImageListPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Column(
          children: [
            Expanded(
                child: GetBuilder<ImageController>(
              init: ImageController(),
              builder: (controller) => Container(
                margin: const EdgeInsets.all(8.0),
                child: LiquidPullToRefresh(
                  key: controller.refreshIndicatorKey,
                  color: lightGreen,
                  height: Get.height / 3,
                  showChildOpacityTransition: false,
                  borderWidth: 5,
                  onRefresh: () async {
                    return controller.handleRefresh();
                  },
                  child: Obx(
                    () => controller.isLoading
                        ? const Center(
                            child: CircularProgressIndicator(),
                          )
                        : controller.getImages.isEmpty
                            ? const EmptyScreen()
                            : StaggeredGridView.countBuilder(
                                itemCount: controller.getImages.length,
                                crossAxisCount: 4,
                                itemBuilder: (context, index) {
                                  final Uint8List bytes =
                                      controller.getImages[index];
                                  return Obx(
                                    () => controller.getImages.isEmpty
                                        ? const Center(
                                            child: CircularProgressIndicator(),
                                          )
                                        : Material(
                                            elevation: 8.0,
                                            borderRadius:
                                                const BorderRadius.all(
                                                    Radius.circular(8)),
                                            child: GestureDetector(
                                              onTap: () {
                                                // Navigator.push(context, new MaterialPageRoute(builder: (context) => new PhotoViewScreen(index, imageList)));
                                                // if (controller.onTapPhoto(index)) Navigator.push(context, CupertinoPageRoute(builder: (context) => Photo(index)));
                                                if (controller.selectedImageList
                                                    .isNotEmpty) {
                                                  controller.selectImage(index);
                                                } else {
                                                  Navigator.push(
                                                    context,
                                                    CupertinoPageRoute(
                                                      builder:
                                                          (context) => //TODO :
                                                              ImageView(index),
                                                    ),
                                                  );
                                                  controller.selectImage(index);
                                                }
                                              },
                                              onLongPress: () {
                                                controller.selectImage(index);
                                              },
                                              child: Stack(
                                                children: [
                                                  ClipRRect(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            8),
                                                    child: Image.memory(
                                                      bytes,
                                                      fit: BoxFit.cover,
                                                    ),
                                                  ),
                                                  if (controller
                                                      .selectedImageList
                                                      .contains(index))
                                                    Positioned(
                                                      top: 0,
                                                      right: 0,
                                                      bottom: 0,
                                                      left: 0,
                                                      child: Container(
                                                        color: Colors.black
                                                            .withOpacity(0.4),
                                                        child: const Center(
                                                          child: Icon(
                                                            Icons.check_box,
                                                            color: Colors.white,
                                                          ),
                                                        ),
                                                      ),
                                                    )
                                                ],
                                              ),
                                            ),
                                          ),
                                  );
                                },
                                staggeredTileBuilder: (int index) =>
                                    const StaggeredTile.fit(2),
                                mainAxisSpacing: 8.0,
                                crossAxisSpacing: 8.0,
                              ),
                  ),
                ),
              ),
            )),
            SizedBox(
              height: Get.height / 10,
            ),
          ],
        ),
      ],
    );
  }
}
