import 'package:bloodfit/features/home/data/repository/update_meal_status_repository.dart';
import 'package:bloodfit/features/meal_plan_feature_options/presentation/data/controller/meal_plan_feature_options_controller.dart';
import 'package:bloodfit/features/meal_plan_feature_options/presentation/data/repository/meal_plan_feature_repository.dart';
import 'package:bloodfit/networks/network_caller.dart';
import 'package:get/get.dart';

import '../features/home/data/controller/home_screen_controller.dart';
import '../features/home/data/repository/daily_calories_api_repository.dart';
import '../features/home/data/repository/get_todays_meal_repository.dart';
import '../features/weight_history/data/controller/weight_history_screen_controller.dart';
import '../features/weight_history/data/repository/update_current_weight_repository.dart';
import 'features/home/data/repository/swap_meal_repository.dart';

class NavigationBinding extends Bindings {
  @override
  void dependencies() {
    // ✅ Core dependencies
    if (!Get.isRegistered<NetworkCaller>()) {
      Get.put(NetworkCaller(), permanent: true);
    }

    // ✅ Repositories
    Get.lazyPut(() => DailyCaloriesApiRepository(Get.find()));
    Get.lazyPut(() => GetTodaysMealRepository(Get.find()));
    Get.lazyPut(() => UpdateCurrentWeightRepository(Get.find()));
    Get.lazyPut(() => MealConsumptionRepository(Get.find()));
    Get.lazyPut(() => SwapMealRepository(Get.find()));
    Get.lazyPut(() => MealPlanFeatureRepository(Get.find()));

    // ✅ Controllers
    Get.lazyPut(
      () => HomeScreenController(
        Get.find<DailyCaloriesApiRepository>(),
        Get.find<GetTodaysMealRepository>(),
        Get.find<MealConsumptionRepository>(),
        Get.find<SwapMealRepository>(),
      ),
      fenix: true,
    );

    Get.lazyPut(
      () => MealPlanFeatureOptionsController(
        Get.find<MealPlanFeatureRepository>(),
      ), fenix: true,
    );

    Get.lazyPut(
      () => WeightHistoryScreenController(
        Get.find<UpdateCurrentWeightRepository>(),
      ),
      fenix: true,
    );
  }
}
