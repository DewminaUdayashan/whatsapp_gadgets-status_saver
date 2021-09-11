import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:octo_image/octo_image.dart';
import 'package:whatsapp_gadgets/constants/constants.dart';
import 'package:whatsapp_gadgets/controllers/video_controller.dart';
import 'package:whatsapp_gadgets/views/dialogs/empty_screen.dart';
import 'package:whatsapp_gadgets/views/home/pages/video_view.dart';

class VideoListPage extends GetWidget<VideoController> {
  const VideoListPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: controller.handleRefresh,
      backgroundColor: lightGreen,
      color: Colors.white,
      strokeWidth: 3,
      child: Column(
        children: [
          Expanded(
            child: Obx(
              () => controller.isLoading
                  ? const Center(
                      child: CircularProgressIndicator(),
                    )
                  : controller.getVideos.isEmpty
                      ? const EmptyScreen()
                      : Container(
                          margin: const EdgeInsets.all(8.0),
                          child: StaggeredGridView.countBuilder(
                            itemCount: controller.getVideos.length,
                            crossAxisCount: 4,
                            itemBuilder: (context, index) {
                              return Material(
                                elevation: 8.0,
                                borderRadius:
                                    const BorderRadius.all(Radius.circular(8)),
                                child: GestureDetector(
                                  onTap: () {
                                    // controller.onTap(index);
                                    if (controller
                                        .selectedVideoList.isNotEmpty) {
                                      controller.selectVideo(index);
                                    } else {
                                      // vc.navigateToPlayer(
                                      //         File.fromUri(
                                      //           Uri.parse(
                                      //               controller.videoList[index]), //:TODO
                                      //         ),
                                      //       ),
                                      //       controller.selectVideo(index),
                                      //     };
                                      Get.to(VideoView(
                                        index: index,
                                      ));
                                    }
                                  },
                                  onLongPress: () {
                                    controller.selectVideo(index);
                                  },
                                  child: Obx(
                                    () => Stack(
                                      children: [
                                        OctoImage(
                                          image: MemoryImage(
                                            controller.getThumbnails[index],
                                          ),
                                          fit: BoxFit.cover,
                                        ),
                                        if (controller.selectedVideoList
                                            .contains(index)) ...[
                                          Positioned(
                                            top: 0,
                                            right: 0,
                                            bottom: 0,
                                            left: 0,
                                            child: Container(
                                              color:
                                                  Colors.black.withOpacity(0.4),
                                              child: const Center(
                                                child: Icon(
                                                  Icons.check_box,
                                                  color: Colors.white,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ] else ...[
                                          const Positioned.fill(
                                            child: Center(
                                              child: FittedBox(
                                                child: Icon(
                                                  Icons
                                                      .play_circle_filled_rounded,
                                                  size: 50,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ]
                                      ],
                                    ),
                                  ),
                                ),
                                //  FutureBuilder(
                                //     future: controller.getImage(controller.videoList[index]),
                                //     builder: (context, snapshot) {
                                //       if (snapshot.connectionState == ConnectionState.done) {
                                //         if (snapshot.hasData) {
                                //           return GestureDetector(
                                //             onTap: () {
                                //               // controller.onTap(index);
                                //               controller.selectedVideoList.length > 0
                                //                   ? controller.selectVideo(index)
                                //                   : {
                                //                       vc.navigateToPlayer(
                                //                         File.fromUri(
                                //                           Uri.parse(
                                //                               controller.videoList[index]),
                                //                         ),
                                //                       ),
                                //                       controller.selectVideo(index),
                                //                     };
                                //             },
                                //             onLongPress: () {
                                //               print('loooooong');
                                //               controller.selectVideo(index);
                                //             },
                                //             child: Obx(() => Stack(
                                //                   children: [
                                //                     Image.file(
                                //                       File(snapshot.data),
                                //                       fit: BoxFit.cover,
                                //                     ),
                                //                     controller.selectedVideoList
                                //                             .contains(index)
                                //                         ? Positioned(
                                //                             top: 0,
                                //                             right: 0,
                                //                             bottom: 0,
                                //                             left: 0,
                                //                             child: Container(
                                //                               color: Colors.black
                                //                                   .withOpacity(0.4),
                                //                               child: Center(
                                //                                 child: Icon(
                                //                                   Icons.check_box,
                                //                                   color: Colors.white,
                                //                                 ),
                                //                               ),
                                //                             ),
                                //                           )
                                //                         : Container(),
                                //                   ],
                                //                 )),
                                //           );
                                //         } else {
                                //           return Center(
                                //             child: CircularProgressIndicator(),
                                //           );
                                //         }
                                //       } else {
                                //         return Container(
                                //             height: 280.0,
                                //             // child: Image.asset("assets/images/video_loader.gif"),
                                //             child: Icon(Icons.hourglass_empty));
                                //       }
                                //     }),
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
          SizedBox(
            height: Get.height / 10,
          ),
        ],
      ),
    );
  }
}
