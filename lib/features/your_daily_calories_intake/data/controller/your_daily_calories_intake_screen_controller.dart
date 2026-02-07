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

  



  Future<void> getYourDailyCaloriesIntakeApi() async {
  try {
    isLoading.value = true;
    clearErrorMessage();
    LoggerUtils.debug("=== API CALL STARTED ===");
    LoggerUtils.debug("Initial state - isSuccess: ${isSuccess.value}");

    final response = await _yourDailyCaloriesIntakeScreenRepository
        .yourDailyCaloriesIntakeRepository();

    LoggerUtils.debug("=== API RESPONSE RECEIVED ===");
    LoggerUtils.debug("Status Code: ${response.statusCode}");
    LoggerUtils.debug("Is Success: ${response.isSuccess}");
    
    LoggerUtils.debug("Error Message: ${response.errorMessage}");
    
    // Log the actual JSON response
    LoggerUtils.debug("JSON Response: ${response.jsonResponse}");

    if (response.statusCode == 200 && response.isSuccess) {
      isSuccess.value = true;
      LoggerUtils.debug("Setting isSuccess to TRUE");
      
      try {
        final data = GetCalorieRequirementsModel.fromJson(
          response.jsonResponse!,
        );
        model.value = data;
        dailyCaloriesText.value = model.value?.data?.calorieRequirement?.totalCalorie.toString() ?? 'Failed to Get Daily Total Consumable Calories!';
        
        // Debug the parsed data
        LoggerUtils.debug("=== PARSED DATA ===");
        LoggerUtils.debug("Model is null: ${model.value == null}");
        LoggerUtils.debug("Model data is null: ${model.value?.data == null}");
        LoggerUtils.debug("CalorieRequirement is null: ${model.value?.data?.calorieRequirement == null}");
        LoggerUtils.debug("TotalCalorie: ${model.value?.data?.calorieRequirement?.totalCalorie}");
        
        // Test the getter
        LoggerUtils.debug("dailyConsumableCalories getter returns: $dailyCaloriesText");
        
        LoggerUtils.debug("Success : Daily Calories Consumable Data Found!");
      } catch (parseError) {
        LoggerUtils.error("Error parsing JSON: $parseError");
        isSuccess.value = false;
        errorMessage.value = "Data parsing error: $parseError";
      }
    } else {
      isSuccess.value = false;
      errorMessage.value = response.errorMessage?.toString() ?? "Unknown error";
      LoggerUtils.debug("API Failed - Setting isSuccess to FALSE");
      LoggerUtils.debug("Error: $errorMessage");
    }
  } catch (e) {
    isSuccess.value = false;  // Make sure this is FALSE!
    errorMessage.value = e.toString();
    LoggerUtils.debug("=== EXCEPTION CAUGHT ===");
    LoggerUtils.debug("Setting isSuccess to FALSE due to exception");
    LoggerUtils.error("Error: $e");
  } finally {
    isLoading.value = false;
    LoggerUtils.debug("=== API CALL FINISHED ===");
    LoggerUtils.debug("Final state - isSuccess: ${isSuccess.value}, isLoading: ${isLoading.value}");
    LoggerUtils.debug("Error message: ${errorMessage.value}");
  }
}

  // String get dailyConsumableCalories =>
  //     model.value?.data?.calorieRequirement?.totalCalorie.toString() ??
  //     'Failed to Get Daily Total \nConsumable Calories!';
}
