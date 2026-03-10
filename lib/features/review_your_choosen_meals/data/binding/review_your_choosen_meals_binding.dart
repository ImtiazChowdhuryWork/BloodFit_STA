import 'package:get/get.dart';

import '../controller/review_your_choosen_meals_screen_controller.dart';

class ReviewYourChoosenMealsBinding extends Bindings {
  @override
  void dependencies() {
    /// Controller - depends on CreateMealPlanRepository
    /// (Repository is already registered in GenerateMealPlanBindings)
    Get.lazyPut<ReviewYourChoosenMealsScreenController>(
      () => ReviewYourChoosenMealsScreenController(Get.find()),
    );
  }
}