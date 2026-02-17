import 'package:bloodfit/features/choose_from_our_suggested_meals/data/controller/choose_from_our_suggested_meal_controller.dart';
import 'package:bloodfit/features/choose_from_our_suggested_meals/data/repository/ai_suggested_meals_repository.dart';
import 'package:get/get.dart';

import '../data/repository/previously_selected_meals_repository.dart';

class GenerateMealPlanBindings extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => PreviouslySelectedMealsRepository(Get.find()));
    Get.lazyPut(() => AiSuggestedMealsRepository(Get.find()));
    Get.lazyPut(() => ChooseFromOurSuggestedMealController(Get.find(), Get.find()));
  }
}
