import 'package:bloodfit/features/meal_details/data/controller/meal_details_screen_controller.dart';
import 'package:bloodfit/features/meal_details/data/repository/generate_meal_image_repository.dart';
import 'package:get/get.dart';

import '../data/repository/has_meal_image_api_repository.dart';
import '../data/repository/meal_details_repository.dart';


class MealDetailsBinding extends Bindings{
  @override
  void dependencies() {
    Get.lazyPut(()=> MealDetailsRepository(Get.find()));
    Get.lazyPut(()=> GenerateMealImageRepository(Get.find()));
    Get.lazyPut(()=> HasMealImageApiRepository(Get.find()));
    Get.lazyPut(()=> MealDetailsScreenController(Get.find(), Get.find(), Get.find()));
  }
}