import 'package:bloodfit/features/home/data/controller/home_screen_controller.dart';
import 'package:bloodfit/features/weight_history/data/controller/weight_history_screen_controller.dart';
import 'package:bloodfit/features/weight_history/data/repository/update_current_weight_repository.dart';
import 'package:get/get.dart';

import '../data/repository/daily_calories_api_repository.dart';

class HomeScreenBindings extends Bindings {
  @override
  void dependencies() {
    ///------->>> Section : Daily Consumable Calories
    Get.lazyPut(() => DailyCaloriesApiRepository(Get.find()));
    Get.lazyPut(() => HomeScreenController(Get.find()), fenix: true);

    ///-------->>>> Section : Current Weight Update
    Get.lazyPut(() => UpdateCurrentWeightRepository(Get.find()));
    Get.lazyPut(() => WeightHistoryScreenController(Get.find()));
  }
}
