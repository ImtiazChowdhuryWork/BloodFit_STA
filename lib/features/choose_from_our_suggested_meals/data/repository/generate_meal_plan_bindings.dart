import 'package:bloodfit/features/choose_from_our_suggested_meals/data/controller/choose_from_our_suggested_meal_controller.dart';
import 'package:get/get.dart';

import '../model/generate_meal_plan_model.dart';

class GenerateMealPlanBindings extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => GenerateMealPlanModel());
    Get.lazyPut(() => ChooseFromOurSuggestedMealController());
  }
}
