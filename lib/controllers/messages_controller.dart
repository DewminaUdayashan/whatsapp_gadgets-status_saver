import 'package:get/get.dart';
import 'package:listen_whatsapp/listen_whatsapp.dart';
import 'package:whatsapp_gadgets/models/message_model.dart';

class MessageController extends GetxController {
  RxList<SenderModel> senders = List<SenderModel>.empty(growable: true).obs;
  RxList<MessageModel> messages = List<MessageModel>.empty(growable: true).obs;
  RxList<GroupModel> groups = List<GroupModel>.empty(growable: true).obs;
  RxList<GroupMessageModel> groupMessages =
      List<GroupMessageModel>.empty(growable: true).obs;

  Future<bool> isPermissionGranted() async {
    return ListenWhatsapp.checkIsServiceEnabled();
  }

  Future<void> _loadSenders() async {
    senders.clear();
    ListenWhatsapp.startService();
    final List<Map<String, dynamic>> list = await ListenWhatsapp.getSenders();
    for (final map in list) {
      print(map);
      senders.add(SenderModel.fromJson(map));
    }
    senders.sort((a, b) => a.date.compareTo(b.date));
    senders = senders.reversed.toList().obs;
  }

  Future<void> _loadMessages() async {
    messages.clear();
    final List<Map<String, dynamic>> list = await ListenWhatsapp.getMessages();
    for (final map in list) {
      messages.add(MessageModel.fromJson(map));
    }
  }

  Future<void> _loadGroups() async {
    groups.clear();
    final List<Map<String, dynamic>> list = await ListenWhatsapp.getGroups();
    for (final map in list) {
      groups.add(GroupModel.fromJson(map));
    }
    groups.sort((a, b) => a.date.compareTo(b.date));
    groups = groups.reversed.toList().obs;
  }

  Future<void> _loadGroupMessages() async {
    groupMessages.clear();
    final List<Map<String, dynamic>> list =
        await ListenWhatsapp.getGroupMessages();
    for (final map in list) {
      groupMessages.add(GroupMessageModel.fromJson(map));
    }
  }

  void warmUpMessages() {
    _loadSenders();
    _loadMessages();
    _loadGroups();
    _loadGroupMessages();
  }

  @override
  Future<void> onInit() async {
    super.onInit();
    warmUpMessages();
  }
}
