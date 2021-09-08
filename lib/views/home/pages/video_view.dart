import 'dart:io';
import 'dart:typed_data';

import 'package:better_player/better_player.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:whatsapp_gadgets/constants/constants.dart';
import 'package:whatsapp_gadgets/constants/whatsapp_types.dart';
import 'package:whatsapp_gadgets/controllers/app_controller.dart';
import 'package:whatsapp_gadgets/controllers/video_controller.dart';
import 'package:whatsapp_gadgets/controllers/video_player_controller.dart';
import 'package:whatsapp_gadgets/helpers/utils.dart';

class VideoView extends StatefulWidget {
  final int index;

  const VideoView({Key? key, required this.index}) : super(key: key);

  @override
  _VideoViewState createState() => _VideoViewState();
}

class _VideoViewState extends State<VideoView> {
  final VideoPlayerController controller = Get.put(VideoPlayerController());
  final VideoController _videoController = Get.find<VideoController>();
  late BetterPlayerPlaylistController betterPlayerController;
  final List<WhatsAppType> waTypes = List<WhatsAppType>.empty(growable: true);
  ValueNotifier<bool> isDialOpen = ValueNotifier(false);

  @override
  void initState() {
    super.initState();
    waTypes.addAll(Get.find<AppController>().availableWhatsAppTypes);
    if (waTypes.contains(WhatsAppType.normal) &&
        waTypes.contains(WhatsAppType.dual)) {
      waTypes.remove(WhatsAppType.dual);
    }

    betterPlayerController = BetterPlayerPlaylistController(
      controller.createDataSet(),
      betterPlayerConfiguration: BetterPlayerConfiguration(
        aspectRatio: .5,
        fit: BoxFit.scaleDown,
        autoPlay: true,
        controlsConfiguration: BetterPlayerControlsConfiguration(
          backgroundColor: darkGrey,
          enableSubtitles: false,
          enableAudioTracks: false,
          enableQualities: false,
          enableFullscreen: false,
        ),
      ),
      betterPlayerPlaylistConfiguration: BetterPlayerPlaylistConfiguration(
        initialStartIndex: widget.index,
        nextVideoDelay: const Duration(seconds: 1),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    betterPlayerController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (isDialOpen.value) {
          isDialOpen.value = false;
          return false;
        }
        _videoController.selectedVideoList.clear();
        return true;
      },
      child: Scaffold(
        floatingActionButton: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            SpeedDial(
              icon: Icons.add,
              activeIcon: Icons.close,
              backgroundColor: context.theme.accentColor,
              activeBackgroundColor: context.theme.accentColor,
              overlayColor: Colors.black.withOpacity(.2),
              openCloseDial: isDialOpen,
              spaceBetweenChildren: 14,
              onOpen: () {
                try {
                  betterPlayerController.betterPlayerController!.pause();
                } catch (e) {
                  print(e);
                }
              },
              onClose: () {
                try {
                  betterPlayerController.betterPlayerController!.play();
                } catch (e) {
                  print(e);
                }
              },
              children: [
                SpeedDialChild(
                  backgroundColor: lightGreen,
                  onTap: () {
                    _videoController.saveVideo(
                      index: betterPlayerController.currentDataSourceIndex,
                    );
                  },
                  label: 'Save',
                  labelBackgroundColor: context.theme.canvasColor,
                  labelStyle: context.theme.textTheme.headline6!.copyWith(
                    fontSize: 10,
                    fontWeight: FontWeight.normal,
                    fontStyle: FontStyle.italic,
                  ),
                  child: const Icon(Icons.save_outlined),
                ),
                SpeedDialChild(
                  backgroundColor: lightBlue,
                  onTap: () {
                    _videoController.shareVideo(
                      selectedIndex:
                          betterPlayerController.currentDataSourceIndex,
                    );
                  },
                  label: 'Share',
                  labelBackgroundColor: context.theme.canvasColor,
                  labelStyle: context.theme.textTheme.headline6!.copyWith(
                    fontSize: 10,
                    fontWeight: FontWeight.normal,
                    fontStyle: FontStyle.italic,
                  ),
                  child: const Icon(Icons.share_outlined),
                ),
                for (var type in waTypes)
                  SpeedDialChild(
                    backgroundColor: Utils.getColorForWaType(type),
                    onTap: () {
                      _videoController.shareVideo(
                        package: Utils.getPackageNameForWaType(type),
                        selectedIndex:
                            betterPlayerController.currentDataSourceIndex,
                      );
                    },
                    label: Utils.getNameForWaType(type),
                    labelBackgroundColor: context.theme.canvasColor,
                    labelStyle: context.theme.textTheme.headline6!.copyWith(
                      fontSize: 10,
                      fontWeight: FontWeight.normal,
                      fontStyle: FontStyle.italic,
                    ),
                    child: const FaIcon(FontAwesomeIcons.whatsapp),
                  ),
              ],
            ),
            const SizedBox(height: kToolbarHeight + 16),
          ],
        ),
        body: Center(
          child: BetterPlayer(
            controller: betterPlayerController.betterPlayerController!,
          ),
        ),
      ),
    );
  }
}
