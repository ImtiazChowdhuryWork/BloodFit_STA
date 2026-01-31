import 'package:get/get.dart';

import '../../../controllers/meal_plan_screen_controller.dart';

class ProfileMealPlanBindings extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => MealPlanScreenController());
  }
}
