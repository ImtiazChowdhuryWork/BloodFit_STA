import 'package:get/get.dart';

import '../data/controller/subscription_plans_screen_controller.dart';
import '../data/repository/subscription_screen_repository.dart';

class SubscriptionPlansBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => SubscriptionScreenRepository(Get.find()));
    Get.lazyPut(() => SubscriptionPlansScreenController(Get.find()));
  }
}
