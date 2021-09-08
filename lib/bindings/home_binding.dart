import 'package:get/get.dart';
import 'package:whatsapp_gadgets/controllers/notification_controller.dart';
import 'package:whatsapp_gadgets/controllers/page_view_controller.dart';

class HomeBinding implements Bindings {
  @override
  void dependencies() {
    Get.put(PageViewController(), permanent: true);
  }
}
