import 'package:bloodfit/features/your_daily_calories_intake/data/repository/your_daily_calories_intake_screen_repository.dart';
import 'package:bloodfit/helper/logger_util.dart';
import 'package:get/get.dart';

import '../model/get_calorie_requirements_model.dart';

class YourDailyCaloriesIntakeScreenController extends GetxController {
  ///---------->>> Section : Importing the repository
  final YourDailyCaloriesIntakeScreenRepository
  _yourDailyCaloriesIntakeScreenRepository;
  final Rxn<GetCalorieRequirementsModel> model =
      Rxn<GetCalorieRequirementsModel>();
  YourDailyCaloriesIntakeScreenController(
    this._yourDailyCaloriesIntakeScreenRepository,
  );

  RxBool isLoading = false.obs;
  RxBool isSuccess = false.obs;
  RxString errorMessage = ''.obs;
  void clearErrorMessage() {
    errorMessage.value = '';
  }


  RxString dailyCaloriesText = ''.obs;

  



  // Retries up to [maxRetries] times with a 2-second gap to handle the backend
  // race window where calorie requirements haven't been computed yet right after
  // health details are submitted.
  Future<void> getYourDailyCaloriesIntakeApi({int maxRetries = 3}) async {
    isLoading.value = true;
    clearErrorMessage();

    for (int attempt = 1; attempt <= maxRetries; attempt++) {
      try {
        LoggerUtils.debug("=== API CALL ATTEMPT $attempt/$maxRetries ===");

        final response = await _yourDailyCaloriesIntakeScreenRepository
            .yourDailyCaloriesIntakeRepository();

        LoggerUtils.debug("Status Code: ${response.statusCode}");
        LoggerUtils.debug("Is Success: ${response.isSuccess}");

        if (response.statusCode == 200 && response.isSuccess) {
          final data = GetCalorieRequirementsModel.fromJson(
            response.jsonResponse!,
          );
          final totalCalorie = data.data?.calorieRequirement?.totalCalorie;

          if (totalCalorie != null) {
            model.value = data;
            dailyCaloriesText.value = totalCalorie.toString();
            isSuccess.value = true;
            LoggerUtils.debug("✅ Success: totalCalorie = $totalCalorie");
            break;
          }

          // 200 but calorieRequirement not ready yet — backend race condition
          LoggerUtils.debug("⚠️ calorieRequirement null on attempt $attempt — backend not ready yet");
        } else {
          LoggerUtils.debug("❌ Non-200 on attempt $attempt: ${response.statusCode} | ${response.errorMessage}");
          errorMessage.value = response.errorMessage ?? "Unknown error";
        }
      } catch (e) {
        LoggerUtils.error("❌ Exception on attempt $attempt: $e");
        errorMessage.value = e.toString();
      }

      if (attempt < maxRetries) {
        LoggerUtils.debug("⏳ Retrying in 2s...");
        await Future.delayed(const Duration(seconds: 2));
      }
    }

    if (!isSuccess.value) {
      isSuccess.value = false;
      LoggerUtils.error("❌ All $maxRetries attempts failed");
    }

    isLoading.value = false;
  }

  // String get dailyConsumableCalories =>
  //     model.value?.data?.calorieRequirement?.totalCalorie.toString() ??
  //     'Failed to Get Daily Total \nConsumable Calories!';
}
