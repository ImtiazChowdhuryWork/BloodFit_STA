import 'package:bloodfit/features/your_daily_calories_intake/data/repository/your_daily_calories_intake_screen_repository.dart';
import 'package:bloodfit/helper/logger_util.dart';
import 'package:get/get.dart';

import '../model/your_daily_calories_intak_model.dart';

class YourDailyCaloriesIntakeScreenController extends GetxController {
  ///---------->>> Section : Importing the repository
  final YourDailyCaloriesIntakeScreenRepository
  _yourDailyCaloriesIntakeScreenRepository;
  final Rxn<YourDailyCaloriesIntakeModel> model =
      Rxn<YourDailyCaloriesIntakeModel>();
  YourDailyCaloriesIntakeScreenController(
    this._yourDailyCaloriesIntakeScreenRepository,
  );

  RxBool isLoading = false.obs;
  RxBool isSuccess = false.obs;
  RxString errorMessage = ''.obs;
  void clearErrorMessage() {
    errorMessage.value = '';
  }

  Future<void> getYourDailyCaloriesIntakeApi() async {
    try {
      isLoading.value = true;
      clearErrorMessage();

      final response = await _yourDailyCaloriesIntakeScreenRepository
          .yourDailyCaloriesIntakeRepository();

      if (response.statusCode == 200 && response.isSuccess) {
        isSuccess.value = true;
        final data = YourDailyCaloriesIntakeModel.fromJson(
          response.jsonResponse!,
        );
        model.value = data;
        LoggerUtils.debug("Success : Daily Calories Consumable Data Found!");
      } else {
        errorMessage.value = response.errorMessage.toString();
        LoggerUtils.error("Something Went Wrong!");
      }
    } catch (e) {
      isSuccess.value = true;
      errorMessage.value = e.toString();
      LoggerUtils.error("Status Code : ");
      LoggerUtils.error("Error Found💩💩💩💩💩 : ${errorMessage.value}");
    } finally {
      isLoading.value = false;
    }
  }

  String get dailyConsumableCalories =>
      model.value?.data?.totalDailyCalories.toString() ??
      'Failed to Get Daily Total \nConsumable Calories!';
}
