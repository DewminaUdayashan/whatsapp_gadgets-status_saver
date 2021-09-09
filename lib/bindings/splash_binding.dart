import 'package:get/get.dart';
import 'package:whatsapp_gadgets/controllers/image_controller.dart';
import 'package:whatsapp_gadgets/controllers/video_controller.dart';

class SplashBinding implements Bindings {
  @override
  void dependencies() {
    Get.put(ImageController(), permanent: true);
    Get.put(VideoController(), permanent: true);
  }
}
