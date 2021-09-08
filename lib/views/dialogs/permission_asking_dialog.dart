import 'dart:typed_data';

import 'package:better_player/better_player.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:whatsapp_gadgets/controllers/app_controller.dart';

class PermissionAskingDialog extends StatefulWidget {
  final Function? overrideDefaultFunction;

  const PermissionAskingDialog({Key? key, this.overrideDefaultFunction})
      : super(key: key);

  @override
  _PermissionAskingDialogState createState() => _PermissionAskingDialogState();
}

class _PermissionAskingDialogState extends State<PermissionAskingDialog> {
  BetterPlayerController? _betterPlayerController;

  @override
  void initState() {
    super.initState();
    init();
  }

  Future<void> init() async {
    final ByteData bytes = await rootBundle.load("assets/intro.3gp");
    final buffer = bytes.buffer;
    final BetterPlayerDataSource betterPlayerDataSource =
        BetterPlayerDataSource(
      BetterPlayerDataSourceType.memory,
      "",
      bytes: Uint8List.fromList(
        buffer.asInt8List(bytes.offsetInBytes, bytes.lengthInBytes),
      ),
    );
    _betterPlayerController = BetterPlayerController(
        const BetterPlayerConfiguration(
          autoPlay: true,
          looping: true,
          aspectRatio: 9 / 16,
          fit: BoxFit.fitHeight,
          controlsConfiguration: BetterPlayerControlsConfiguration(
            showControls: false,
          ),
        ),
        betterPlayerDataSource: betterPlayerDataSource);
    setState(() {});
  }

  @override
  void dispose() {
    super.dispose();
    _betterPlayerController!.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      insetPadding: const EdgeInsets.all(8),
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  "Please Select 'USE THIS FOLDER' on Next Screen to Continue",
                  textAlign: TextAlign.center,
                  style: context.theme.textTheme.headline6!.copyWith(
                    fontSize: 17,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              SizedBox(
                height: Get.height / 2,
                width: Get.width,
                child: Center(
                  child: _betterPlayerController == null
                      ? const CircularProgressIndicator()
                      : BetterPlayer(
                          controller: _betterPlayerController!,
                        ),
                ),
              ),
              const SizedBox(height: kToolbarHeight / 2),
              TextButton(
                onPressed: () async {
                  if (widget.overrideDefaultFunction == null) {
                    Get.find<AppController>().handleApi30Permission();
                  } else {
                    widget.overrideDefaultFunction!();
                  }
                },
                style: TextButton.styleFrom(
                  backgroundColor: Colors.green,
                ),
                child: const Text(
                  'Next',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 17,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
