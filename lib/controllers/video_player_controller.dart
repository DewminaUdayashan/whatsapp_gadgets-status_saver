import 'package:better_player/better_player.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:get/get.dart';
import 'package:whatsapp_gadgets/controllers/video_controller.dart';

class VideoPlayerController extends GetxController {
  final videoListController = Get.find<VideoController>();

  List<BetterPlayerDataSource> createDataSet() {
    final List<BetterPlayerDataSource> dataSourceList =
        List<BetterPlayerDataSource>.empty(growable: true);
    try {
      for (final bytes in videoListController.getVideos) {
        dataSourceList.add(
          BetterPlayerDataSource(
            BetterPlayerDataSourceType.memory,
            '',
            bytes: bytes,
          ),
        );
      }
    } catch (e, stack) {
      FirebaseCrashlytics.instance.log(e.toString());
      FirebaseCrashlytics.instance.recordError(e, stack);
    }

    //
    return dataSourceList;
  }
}
