import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:whatsapp_gadgets/constants/constants.dart';
import 'package:whatsapp_gadgets/constants/texts.dart';
import 'package:whatsapp_gadgets/controllers/ad_controller.dart';
import 'package:whatsapp_gadgets/controllers/messages_controller.dart';
import 'package:whatsapp_gadgets/views/home/messages/contact_messages_tab.dart';
import 'package:whatsapp_gadgets/views/home/messages/group_messages_tab.dart';

class MessagesScreen extends GetWidget<MessageController> {
  const MessagesScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: DefaultTabController(
        length: 2,
        child: Scaffold(
          backgroundColor: context.theme.scaffoldBackgroundColor,
          appBar: AppBar(
            backgroundColor: tealGreen.withOpacity(.9),
            actions: [
              IconButton(
                  onPressed: () {
                    controller.warmUpMessages();
                  },
                  tooltip: "Reload Messages",
                  icon: const Icon(Icons.refresh_outlined))
            ],
            title: Text(
              messages2,
              style: context.theme.textTheme.headline5!.copyWith(
                fontSize: 27,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
            titleSpacing: 0,
            bottom: TabBar(
              indicatorWeight: 4,
              indicatorColor: context.theme.accentColor,
              tabs: const [
                Tab(
                  icon: Icon(Icons.message_outlined),
                ),
                Tab(icon: Icon(Icons.group_outlined)),
              ],
            ),
          ),
          body: Stack(
            children: [
              const Padding(
                padding: EdgeInsets.only(bottom: 53),
                child: TabBarView(
                  children: [
                    ContactMessagesTab(),
                    GroupMessagesTab(),
                  ],
                ),
              ),
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                height: 53,
                child: Get.find<AdController>().mainTopNativeBannerAd(context),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
