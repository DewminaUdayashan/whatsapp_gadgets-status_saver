import 'package:flutter/material.dart';
import 'package:readmore/readmore.dart';
import 'package:whatsapp_gadgets/constants/constants.dart';
import 'package:whatsapp_gadgets/controllers/messages_controller.dart';
import 'package:whatsapp_gadgets/models/message_model.dart';
import 'package:get/get.dart';

class GroupMessageView extends StatefulWidget {
  final GroupModel group;

  const GroupMessageView({Key? key, required this.group}) : super(key: key);

  @override
  _GroupMessageViewState createState() => _GroupMessageViewState();
}

class _GroupMessageViewState extends State<GroupMessageView> {
  MessageController controller = Get.find<MessageController>();
  List<GroupMessageModel> messages = List.empty(growable: true);

  @override
  void initState() {
    super.initState();
    messages.addAll(controller.groupMessages
        .where((msg) => msg.groupId == widget.group.id)
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
          widget.group.name,
        ),
      ),
      body: ListView.builder(
        itemCount: messages.length,
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
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        messages[index].sender,
                        style: context.theme.textTheme.headline5!.copyWith(
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(height: 5),
                      ReadMoreText(
                        messages[index].message,
                        style: context.theme.textTheme.headline5,
                      ),
                    ],
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
