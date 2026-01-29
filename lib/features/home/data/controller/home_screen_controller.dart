import 'package:bloodfit/constants/app_enums.dart';
import 'package:bloodfit/gen/colors.gen.dart';
import 'package:bloodfit/helper/logger_util.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../your_daily_calories_intake/data/model/your_daily_calories_intak_model.dart';
import '../repository/daily_calories_api_repository.dart';

class HomeScreenController extends GetxController {
  ///--------->>> Section : Importing the Repositories
  DailyCaloriesApiRepository _dailyCaloriesApiRepository;

  ///----------->>> Section : Importing the Model
  Rxn<YourDailyCaloriesIntakeModel> model = Rxn<YourDailyCaloriesIntakeModel>();

  HomeScreenController(this._dailyCaloriesApiRepository);

  ///Section : ----------------////Selectable Meal Calendar for Meal Plan///----------------------
  RxInt mealCalanderSelectableDays = 3.obs;
  List<WeekDayEnum> weekDayList = WeekDayEnum.values;
  RxList<WeekDayEnum> selectedDaysList = <WeekDayEnum>[].obs; // Keep as RxList

  void toggleDaySelection(WeekDayEnum day) {
    if (selectedDaysList.contains(day)) {
      selectedDaysList.remove(day);
    } else {
      if (selectedDaysList.length < mealCalanderSelectableDays.value) {
        selectedDaysList.add(day);
      } else {
        Get.snackbar(
          'Limit Reached',
          'You can only select ${mealCalanderSelectableDays.value} days',
          backgroundColor: AppColors.cb20000.withOpacity(
            0.2,
          ), // translucent “glass” white
          colorText: Colors.white, // readable on translucent bg
          snackPosition: SnackPosition.TOP,
          borderRadius: 16,
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          borderWidth: 1,
          borderColor: Colors.white.withOpacity(0.3),
          boxShadows: [
            BoxShadow(
              color: Colors.white.withOpacity(0.1),
              blurRadius: 12,
              offset: const Offset(0, 6),
            ),
          ],
          icon: const Icon(Icons.info_outline, color: AppColors.cb20000),
        );
      }
    }
    // The RxList will automatically notify its observers
  }

  bool isDaySelected(WeekDayEnum day) {
    return selectedDaysList.contains(day);
  }

  ///Section : ---------------------///Update Your Current Weight drop down///-------------------
  var selectedWeightUnit = 'Kg'.obs;
  TextEditingController weightController = TextEditingController();

  ///Feat : -> Set Value of Weight UnitType
  void setSelectedWeightUnit({required String unit}) {
    selectedWeightUnit.value = unit;
  }

  ///Feat : -> Close the weight controller
  @override
  void onClose() {
    weightController.dispose();
    super.onClose();
  }

  ///Feat : -> Show and Hide Submit Button
  RxBool isWeightAvailable = false.obs;

  @override
  void onInit() {
    super.onInit();
    // Initialize based on current text field value
    isWeightAvailable.value = weightController.text.trim().isNotEmpty;
  }

  void updateWeightAvailability() {
    isWeightAvailable.value = weightController.text.trim().isNotEmpty;
  }

  void setIsWeightAvailableValue({required bool newValue}) {
    isWeightAvailable.value = newValue;
  }

  ///----------------->>> Is Your Daily Calories Api Section
  RxBool isDailyCaloriesLoading = false.obs;
  RxString errorMessage = ''.obs;
  void clearErrorMessage() async {
    errorMessage.value = '';
  }

  Future<void> getDailyCaloriesApi() async {
    isDailyCaloriesLoading.value = true;
    clearErrorMessage();

    try {
      final response = await _dailyCaloriesApiRepository
          .dailyCaloriesApiRepository();

      if (response.statusCode == 200 && response.isSuccess) {
        LoggerUtils.debug("Daily Calories Data Fetched Successfully!");
        var data = YourDailyCaloriesIntakeModel.fromJson(
          response.jsonResponse!,
        );

        model.value = data;
      } else {
        errorMessage.value = response.errorMessage.toString();
        LoggerUtils.error("Something Went Wrong!");
        LoggerUtils.error("Error Found : ${errorMessage.value}");
      }
    } catch (e) {
      errorMessage.value = e.toString();
      LoggerUtils.error("Error Found : ${errorMessage.value}");
    } finally {
      isDailyCaloriesLoading.value = false;
    }
  }

  String get totalCalories =>
      model.value?.data?.totalDailyCalories.toString() ?? '';
  int get consumedCarbs =>
      model.value?.data?.totalDailyMacronutrients?.carbohydrates ?? 0;
  int get consumedProtein =>
      model.value?.data?.totalDailyMacronutrients?.protein ?? 0;
  int get consumedFat => model.value?.data?.totalDailyMacronutrients?.fat ?? 0;
}
