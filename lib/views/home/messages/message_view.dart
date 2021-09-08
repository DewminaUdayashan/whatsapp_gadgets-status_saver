import 'package:flutter/material.dart';
import 'package:readmore/readmore.dart';
import 'package:whatsapp_gadgets/constants/constants.dart';
import 'package:whatsapp_gadgets/controllers/messages_controller.dart';
import 'package:whatsapp_gadgets/models/message_model.dart';
import 'package:get/get.dart';

class MessageView extends StatefulWidget {
  final SenderModel sender;

  const MessageView({Key? key, required this.sender}) : super(key: key);

  @override
  _MessageViewState createState() => _MessageViewState();
}

class _MessageViewState extends State<MessageView> {
  MessageController controller = Get.find<MessageController>();
  List<MessageModel> messages = List.empty(growable: true);

  @override
  void initState() {
    super.initState();
    messages.addAll(controller.messages
        .where((msg) => msg.senderId == widget.sender.id)
        .toList());
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.isDarkMode ? Colors.grey[800] : Colors.white70,
      appBar: AppBar(
        backgroundColor: tealGreen,
        title: Text(
          widget.sender.sender,
        ),
      ),
      body: ListView.builder(
        itemCount: messages.length,
        shrinkWrap: true,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.all(9.0),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Container(
                decoration: BoxDecoration(
                  color: context.isDarkMode ? Colors.grey[900] : Colors.white,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(9.0),
                  child: ReadMoreText(
                    messages[index].message,
                    style: context.theme.textTheme.headline5,
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
