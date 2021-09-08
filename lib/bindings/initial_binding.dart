import 'package:get/get.dart';
import 'package:whatsapp_gadgets/controllers/ad_controller.dart';
import 'package:whatsapp_gadgets/controllers/app_controller.dart';

class InitialBinding implements Bindings {
  @override
  void dependencies() {
    Get.put(AdController(),permanent: true);
    Get.put(AppController(), permanent: true);
  }
}
