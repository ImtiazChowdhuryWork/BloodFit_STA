import 'package:bloodfit/features/meal_details/data/controller/meal_details_screen_controller.dart';
import 'package:get/get.dart';

import '../data/repository/meal_details_repository.dart';


class MealDetailsBinding extends Bindings{
  @override
  void dependencies() {
    Get.lazyPut(()=> MealDetailsRepository(Get.find()));
    Get.lazyPut(()=> MealDetailsScreenController(Get.find()));
  }
}