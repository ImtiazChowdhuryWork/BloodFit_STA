import 'package:get/get.dart';

import '../presentation/data/controller/meal_plan_feature_options_controller.dart';
import '../presentation/data/repository/meal_plan_feature_repository.dart';

class MealPlanFeatureOptionsBinding extends Bindings{
  @override
  void dependencies() {
    Get.lazyPut(()=> MealPlanFeatureRepository(Get.find()));
    Get.lazyPut(()=> MealPlanFeatureOptionsController(Get.find()));
  }
}