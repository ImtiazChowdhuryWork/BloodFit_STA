import 'package:bloodfit/features/information_gather_meal_plan/data/controller/information_gather_meal_screen_controller.dart';
import 'package:bloodfit/features/information_gather_meal_plan/data/repository/information_gather_meal_repository.dart';
import 'package:get/get.dart';

class InformationGatherMealBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => InformationGatherMealPlanRepository(Get.find()));
    Get.lazyPut(() => InformationGatherMealScreenController(Get.find()));
  }
}
