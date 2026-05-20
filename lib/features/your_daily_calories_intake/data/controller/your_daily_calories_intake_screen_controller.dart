import 'package:bloodfit/features/your_daily_calories_intake/data/repository/your_daily_calories_intake_screen_repository.dart';
import 'package:bloodfit/helper/logger_util.dart';
import 'package:get/get.dart';

import '../model/get_calorie_requirements_model.dart';

class YourDailyCaloriesIntakeScreenController extends GetxController {
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
  RxString dailyCaloriesText = ''.obs;

  // Shown in the loading circle while polling
  RxString loadingMessage = 'Calculating...'.obs;

  void clearErrorMessage() => errorMessage.value = '';

  // Polls every [pollInterval] seconds for up to [timeoutSeconds] seconds.
  // The user sees a "Calculating..." state the whole time — the Retry button
  // only appears if the backend never returns data within the timeout window.
  Future<void> getYourDailyCaloriesIntakeApi({
    int timeoutSeconds = 300,
    int pollIntervalSeconds = 3,
  }) async {
    isLoading.value = true;
    isSuccess.value = false;
    clearErrorMessage();

    final int maxAttempts = (timeoutSeconds / pollIntervalSeconds).ceil();

    for (int attempt = 1; attempt <= maxAttempts; attempt++) {
      try {
        LoggerUtils.debug("⏱ Polling attempt $attempt/$maxAttempts");

        final response = await _yourDailyCaloriesIntakeScreenRepository
            .yourDailyCaloriesIntakeRepository();

        if (response.statusCode == 200 && response.isSuccess) {
          final data = GetCalorieRequirementsModel.fromJson(
            response.jsonResponse!,
          );
          final totalCalorie = data.data?.calorieRequirement?.totalCalorie;

          if (totalCalorie != null) {
            model.value = data;
            dailyCaloriesText.value = totalCalorie.toString();
            isSuccess.value = true;
            LoggerUtils.debug("✅ Calorie data ready: $totalCalorie kcal");
            break;
          }

          LoggerUtils.debug("⏳ Backend still computing — will retry in ${pollIntervalSeconds}s");
        } else {
          LoggerUtils.debug("❌ Non-200: ${response.statusCode} | ${response.errorMessage}");
          errorMessage.value = response.errorMessage ?? "Unknown error";
        }
      } catch (e) {
        LoggerUtils.error("❌ Exception on attempt $attempt: $e");
        errorMessage.value = e.toString();
      }

      if (attempt < maxAttempts) {
        await Future.delayed(Duration(seconds: pollIntervalSeconds));
      }
    }

    if (!isSuccess.value) {
      LoggerUtils.error("❌ Calorie data unavailable after ${timeoutSeconds}s");
    }

    isLoading.value = false;
  }
}
