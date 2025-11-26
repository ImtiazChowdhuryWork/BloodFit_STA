import 'package:get/get.dart';

import '../../../controllers/view_profile_subscription_type_free_screen_controller.dart';

class ViewProfileSubTypeFreeBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ViewProfileSubscriptionTypeFreeScreenController>(
      () => ViewProfileSubscriptionTypeFreeScreenController(),
    );
  }
}
