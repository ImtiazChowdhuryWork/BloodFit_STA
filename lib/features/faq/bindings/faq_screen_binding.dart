import 'package:get/get.dart';

import '../data/controller/faq_screen_controller.dart';
import '../data/reqository/faq_repository.dart';

class FaqScreenBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => FaqRepository(Get.find()));
    Get.lazyPut(() => FaqScreenController(Get.find()));
  }
}
