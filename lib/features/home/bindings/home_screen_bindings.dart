import 'package:bloodfit/features/home/data/controller/home_screen_controller.dart';
import 'package:get/get.dart';

import '../data/repository/daily_calories_api_repository.dart';

class HomeScreenBindings extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => DailyCaloriesApiRepository(Get.find()));
    Get.lazyPut(() => HomeScreenController(Get.find()), fenix: true);
  }
}
