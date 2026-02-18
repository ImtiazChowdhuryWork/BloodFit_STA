import 'package:bloodfit/features/home/data/repository/update_meal_status_repository.dart';
import 'package:get/get.dart';

import '../../choose_from_our_suggested_meals/bindings/generate_meal_plan_bindings.dart';
import '../../weight_history/data/controller/weight_history_screen_controller.dart';
import '../../weight_history/data/repository/update_current_weight_repository.dart';
import '../data/controller/home_screen_controller.dart';
import '../data/repository/daily_calories_api_repository.dart';
import '../data/repository/get_todays_meal_repository.dart';
import '../data/repository/swap_meal_repository.dart';

class HomeScreenBindings extends Bindings {
  @override
  void dependencies() {

    /// Core / Network (must already exist)
    /// Get.put(NetworkCaller()); ← assuming already registered globally

    /// -------->>> Repositories
    Get.lazyPut(() => DailyCaloriesApiRepository(Get.find()));
    Get.lazyPut(() => GetTodaysMealRepository(Get.find()));

    /// -------->>> Controllers
    Get.lazyPut(
      () => HomeScreenController(
        Get.find<DailyCaloriesApiRepository>(),
        Get.find<GetTodaysMealRepository>(),
        Get.find<MealConsumptionRepository>(),
        Get.find<SwapMealRepository>(),
      ),
      fenix: true,
    );

    /// -------->>> Current Weight
    Get.lazyPut(() => UpdateCurrentWeightRepository(Get.find()));
    Get.lazyPut(() => WeightHistoryScreenController(Get.find()));

    /// -------->>> Meal Plan Feature
    GenerateMealPlanBindings().dependencies();
  }
}
