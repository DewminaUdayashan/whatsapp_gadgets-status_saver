import 'package:get/get.dart';
import 'package:whatsapp_gadgets/controllers/messages_controller.dart';

class MessagesBinding implements Bindings {
  @override
  void dependencies() {
    Get.put(MessageController());
  }
}
