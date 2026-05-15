import 'package:get/get.dart';

import '../data/controller/meal_scanner_screen_controller.dart';
import '../data/repository/meal_scanner_repository.dart';

class MealScannerBindings extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => MealScannerRepository(Get.find()));
    Get.lazyPut(() => MealScannerScreenController());
  }
}
