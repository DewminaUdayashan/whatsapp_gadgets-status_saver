import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:whatsapp_gadgets/controllers/messages_controller.dart';
import 'package:whatsapp_gadgets/views/home/messages/widgets/empty_widget.dart';
import 'package:whatsapp_gadgets/views/home/messages/group_message_view.dart';

import 'message_view.dart';
import 'widgets/avatar.dart';

class GroupMessagesTab extends GetWidget<MessageController> {
  const GroupMessagesTab({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 10),
        Expanded(
          child: Obx(
            () => controller.groups.isEmpty
                ? const EmptyWidget()
                : ListView.separated(
                    itemCount: controller.groups.length,
                    separatorBuilder: (context, index) => const Divider(),
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.only(top: 10),
                        child: ListTile(
                          onTap: () {
                            Get.to(
                              GroupMessageView(
                                group: controller.groups[index],
                              ),
                            );
                          },
                          leading: const Avatar(
                            icon: Icons.people_rounded,
                          ),
                          title: Text(
                            controller.groups[index].name,
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
