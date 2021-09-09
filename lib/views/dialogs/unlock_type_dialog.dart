import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:whatsapp_gadgets/constants/texts.dart';
import 'package:whatsapp_gadgets/controllers/ad_controller.dart';

class UnlockTypeDialog extends GetWidget<AdController> {
  final bool forUnlockMessages;

  const UnlockTypeDialog({Key? key, this.forUnlockMessages = false})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return Future.value(false);
      },
      child: Dialog(
        insetPadding: const EdgeInsets.all(10),
        backgroundColor: context.theme.scaffoldBackgroundColor,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                unlockW4BTitle,
                textAlign: TextAlign.center,
                style: context.theme.textTheme.headline6,
              ),
              const Divider(),
              Get.find<AdController>().typeChangeDialogNativeAd(),
              const Divider(),
              Text(
                unlockW4BDetail,
                textAlign: TextAlign.center,
                style: context.theme.textTheme.headline6!.copyWith(
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const Divider(),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Obx(
                    () => TextButton(
                      onPressed: () {
                        if (!forUnlockMessages) {
                          controller.addAccessibleWaType();
                        } else {
                          controller.unlockUndeleteMessages();
                        }
                      },
                      style: TextButton.styleFrom(
                        backgroundColor: Colors.green,
                      ),
                      child: controller.isTypeChangeDialogLoading.value
                          ? const Center(
                              child: CircularProgressIndicator(
                                color: Colors.white,
                              ),
                            )
                          : const Text(
                              "Unlock",
                              style: TextStyle(
                                color: Colors.white,
                              ),
                            ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Text(
                    '- OR -',
                    style: context.theme.textTheme.headline5!.copyWith(
                      fontSize: 12,
                    ),
                  ),
                  const SizedBox(width: 16),
                  TextButton(
                    onPressed: () {},
                    style: TextButton.styleFrom(
                      backgroundColor: Colors.yellow[900],
                    ),
                    child: const Text(
                      "Premium",
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
