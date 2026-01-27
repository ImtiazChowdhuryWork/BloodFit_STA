import 'package:bloodfit/features/your_daily_calories_intake/data/controller/your_daily_calories_intake_screen_controller.dart';
import 'package:bloodfit/features/your_daily_calories_intake/data/repository/your_daily_calories_intake_screen_repository.dart';
import 'package:get/get.dart';

class YourDailyCaloriesIntakeBindings extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => YourDailyCaloriesIntakeScreenRepository(Get.find()));
    Get.lazyPut(() => YourDailyCaloriesIntakeScreenController(Get.find()));
  }
}
