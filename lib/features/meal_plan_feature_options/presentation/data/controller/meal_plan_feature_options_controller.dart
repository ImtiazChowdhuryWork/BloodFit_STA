
import 'package:get/get.dart';

import '../../../../../helper/logger_util.dart';
import '../model/get_meals_by_model.dart';
import '../repository/meal_plan_feature_repository.dart';

class MealPlanFeatureOptionsController extends GetxController {
  final MealPlanFeatureRepository _repository;

  MealPlanFeatureOptionsController(this._repository);

  /// State
  RxBool isLoading = false.obs;
  RxString selectedDateDataError = ''.obs;
  RxString selectedDate = ''.obs;

  /// Data
  Rxn<GetMealsByDateModel> mealsByDateModel = Rxn<GetMealsByDateModel>();
  RxList<Datum> mealsByDateList = <Datum>[].obs;

  void setSelectedDate({required String date}) {
    selectedDate.value = date;
  }

  void clearError() {
    selectedDateDataError.value = '';
  }

  Future<void> postGetMealsBySelectedDate() async {
    try {
      isLoading.value = true;
      clearError();
      mealsByDateList.clear();

      LoggerUtils.debug("===== POST GET MEALS BY SELECTED DATE =====");
      LoggerUtils.debug("Selected Date Value: '${selectedDate.value}'");
      LoggerUtils.debug("Selected Date Length: ${selectedDate.value.length}");
      LoggerUtils.debug("Selected Date Bytes: ${selectedDate.value.codeUnits}");

      final response = await _repository.mealPlanFeatureRepository(
        selectedDate: selectedDate.value,
      );

      if (response.statusCode == 200 && response.isSuccess) {
        /// 🔑 THIS WAS MISSING
        mealsByDateModel.value =
            GetMealsByDateModel.fromJson(response.jsonResponse!);

        mealsByDateList.assignAll(
          mealsByDateModel.value?.data ?? [],
        );

        LoggerUtils.debug(
          "Meals loaded for date: ${selectedDate.value}",
        );
        LoggerUtils.debug("Number of meals loaded: ${mealsByDateList.length}");
        LoggerUtils.debug("Full Response JSON: ${response.jsonResponse}");
        LoggerUtils.debug("Data from model: ${mealsByDateModel.value?.data}");

        LoggerUtils.debug("╔═══════════════════════════════════════════════════════════");
        LoggerUtils.debug("🍽️ [MEAL_PLAN] Meals returned by API for date: ${selectedDate.value}");
        for (int i = 0; i < mealsByDateList.length; i++) {
          final meal = mealsByDateList[i];
          LoggerUtils.debug("  [$i] mealName: ${meal.mealName}");
          LoggerUtils.debug("  [$i] mealType: ${meal.mealType}");
          LoggerUtils.debug("  [$i] kcal    : ${meal.kcal}");
          LoggerUtils.debug("  [$i] caloryCount: ${meal.caloryCount?.map((c) => '${c.label}:${c.kcal}').join(', ')}");
        }
        LoggerUtils.debug("╚═══════════════════════════════════════════════════════════");
      } else {
        selectedDateDataError.value = response.errorMessage ?? 'Unknown error';
        LoggerUtils.error("Failed to get response for Selected Date! : $selectedDate");
        LoggerUtils.error("Response Status Code : ${response.statusCode}");
        LoggerUtils.error("Response Error Message : ${selectedDateDataError.toString()}");
      }
    } catch (error) {
      selectedDateDataError.value = error.toString();
      LoggerUtils.error("Error Catched While Getting Data for Selected Date");
      LoggerUtils.error("Catched Error : ${selectedDateDataError.value}");
    } finally {
      isLoading.value = false;
      LoggerUtils.debug("===== API CALL COMPLETED =====");
    }
  }
}