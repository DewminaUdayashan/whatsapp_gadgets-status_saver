import 'dart:math';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:whatsapp_gadgets/controllers/messages_controller.dart';
import 'package:whatsapp_gadgets/views/home/messages/widgets/avatar.dart';
import 'package:whatsapp_gadgets/views/home/messages/widgets/empty_widget.dart';

import 'message_view.dart';

class ContactMessagesTab extends GetWidget<MessageController> {
  const ContactMessagesTab({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 10),
        Expanded(
          child: Obx(
            () => controller.senders.isEmpty
                ? const EmptyWidget()
                : ListView.separated(
                    itemCount: controller.senders.length,
                    separatorBuilder: (context, index) => const Divider(),
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.only(top: 10),
                        child: ListTile(
                          onTap: () {
                            Get.to(
                              MessageView(
                                sender: controller.senders[index],
                              ),
                            );
                          },
                          leading: const Avatar(icon: Icons.person),
                          title: Text(
                            controller.senders[index].sender,
                            style: context.theme.textTheme.headline5!.copyWith(
                              fontSize: 26,
                            ),
                          ),
                          trailing: Text(
                            '4.15 PM',
                            style: context.theme.textTheme.headline6!.copyWith(
                              fontSize: 15,
                            ),
                          ),
                        ),
                      );
                    },
                  ),
          ),
        )
      ],
    );
  }
}
