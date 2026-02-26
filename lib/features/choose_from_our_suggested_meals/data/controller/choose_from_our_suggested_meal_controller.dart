import 'dart:convert';

import 'package:bloodfit/features/choose_from_our_suggested_meals/data/model/ai_suggested_meals_model.dart';
import 'package:bloodfit/features/choose_from_our_suggested_meals/data/model/recent_chosen_meals_model.dart';
import 'package:bloodfit/features/choose_from_our_suggested_meals/data/repository/ai_suggested_meals_repository.dart';
import 'package:bloodfit/helper/logger_util.dart';
import 'package:get/get.dart';

import '../repository/previously_selected_meals_repository.dart';

class ChooseFromOurSuggestedMealController extends GetxController {
  ///------->>> Section : Importing the Preselected Repository
  final PreviouslySelectedMealsRepository _previouslySelectedMealsRepository;

  ///-------<>>>> Section : Importing the AI Suggested Meals Repository
  final AiSuggestedMealsRepository _aiSuggestedMealsRepository;

  ChooseFromOurSuggestedMealController(
    this._previouslySelectedMealsRepository,
    this._aiSuggestedMealsRepository,
  );

  @override
  void onInit() {
    super.onInit();
    LoggerUtils.debug("🚀🚀🚀 ChooseFromOurSuggestedMealController initialized - Application scoped");
    LoggerUtils.debug("📋 Setting up reactive listeners for selection changes...");

   
    LoggerUtils.debug("✅ Reactive listeners successfully registered");
  }

  @override
  void onClose() {
    LoggerUtils.debug("👋👋👋 ChooseFromOurSuggestedMealController closed");
    super.onClose();
  }



  ///---------->>> Section : Boiler Code Start
  // // Each tab/item has a checkbox
  RxList<RxBool> isCheckBoxSelectedList = List.generate(
    10,
    (_) => false.obs,
  ).obs;

  void setIsCheckBoxSelectedValue(int index, bool value) {
    isCheckBoxSelectedList[index].value = value;
  }

  ///---------->>> Section : Boiler Code End

  ///--------->>> Section : Previously Selected Meals Api Method Start Here

  ///--------->>> Section : Recently Selected Items List
  RxList<Datum> breakfastRecentChosenMeals = <Datum>[].obs;
  RxList<Datum> lunchRecentChosenMeals = <Datum>[].obs;
  RxList<Datum> dinnerRecentChosenMeals = <Datum>[].obs;

  ///-------->>> Section : Tab Name
  RxString selectedTabName = ''.obs;
  String setSelectedTabName({required int index}) {
    if (index == 0) {
      selectedTabName.value = 'breakfast';
      LoggerUtils.debug("📑 Tab changed to: BREAKFAST");
      return selectedTabName.value;
    } else if (index == 1) {
      selectedTabName.value = 'lunch';
      LoggerUtils.debug("📑 Tab changed to: LUNCH");
      return selectedTabName.value;
    } else if (index == 2) {
      selectedTabName.value = 'dinner';
      LoggerUtils.debug("📑 Tab changed to: DINNER");
      return selectedTabName.value;
    } else {
      LoggerUtils.error(
        "❌ Given Input is unexpected, Because the index $index has exceeded the tab total index",
      );
      return '';
    }
  }

  RxBool isPreviouslySelectedMealsLoading = false.obs;
  RxString errorMessage = ''.obs;
  void clearErrorMessage() {
    errorMessage.value = '';
  }

  /// Cached meal types for previously selected meals to avoid redundant API calls
  RxBool isBreakfastRecentMealsLoaded = false.obs;
  RxBool isLunchRecentMealsLoaded = false.obs;
  RxBool isDinnerRecentMealsLoaded = false.obs;

  Future<void> getPreviouslySelectedMeals() async {
    final mealType = selectedTabName.value;

    LoggerUtils.debug("🔍 getPreviouslySelectedMeals called for: $mealType");

    /// Skip if already loaded for this meal type
    if (mealType == 'breakfast' && isBreakfastRecentMealsLoaded.value) {
      LoggerUtils.debug("⏭️ Skipping - Breakfast recent meals already loaded");
      return;
    }
    if (mealType == 'lunch' && isLunchRecentMealsLoaded.value) {
      LoggerUtils.debug("⏭️ Skipping - Lunch recent meals already loaded");
      return;
    }
    if (mealType == 'dinner' && isDinnerRecentMealsLoaded.value) {
      LoggerUtils.debug("⏭️ Skipping - Dinner recent meals already loaded");
      return;
    }

    LoggerUtils.debug("📡 Fetching previously selected meals from API...");
    clearErrorMessage();
    isPreviouslySelectedMealsLoading.value = true;

    try {
      final responses = await _previouslySelectedMealsRepository
          .previouslySelectedMealsRepository(mealType: mealType);

      if (responses.statusCode == 200 && responses.isSuccess) {
        LoggerUtils.debug(
          "🥳🥳🥳 Recently Selected Meals fetched successfully for $mealType!",
        );
        final model = RecentChosenMealsModel.fromJson(responses.jsonResponse!);

        LoggerUtils.debug(
          const JsonEncoder.withIndent('  ').convert(responses.jsonResponse),
        );

        final List<Datum> meals = model.data ?? [];
        LoggerUtils.debug("📦 Received ${meals.length} meals for $mealType");

        if (mealType == 'breakfast') {
          breakfastRecentChosenMeals.assignAll(meals);
          isBreakfastRecentMealsLoaded.value = true;
          LoggerUtils.debug("✅ Breakfast recent meals loaded and cached");
        } else if (mealType == 'lunch') {
          lunchRecentChosenMeals.assignAll(meals);
          isLunchRecentMealsLoaded.value = true;
          LoggerUtils.debug("✅ Lunch recent meals loaded and cached");
        } else if (mealType == 'dinner') {
          dinnerRecentChosenMeals.assignAll(meals);
          isDinnerRecentMealsLoaded.value = true;
          LoggerUtils.debug("✅ Dinner recent meals loaded and cached");
        }
      } else {
        LoggerUtils.error("❌ API Error for $mealType");
        LoggerUtils.error("🔴 Status Code : ${responses.statusCode}");
        LoggerUtils.error("🔴 Error Message : ${responses.errorMessage}");
        
        errorMessage.value = responses.errorMessage.toString();
        if (mealType == 'breakfast') {
          breakfastRecentChosenMeals.clear();
        } else if (mealType == 'lunch') {
          lunchRecentChosenMeals.clear();
        } else if (mealType == 'dinner') {
          dinnerRecentChosenMeals.clear();
        } else {
          LoggerUtils.error('❌ Unexpected tab state: $mealType');
        }
      }
    } catch (error) {
      errorMessage.value = error.toString();
      LoggerUtils.error("💥 Caught Error in getPreviouslySelectedMeals: $error");
    } finally {
      isPreviouslySelectedMealsLoading.value = false;
      LoggerUtils.debug("🏁 Previously selected meals loading completed");
    }
  }

  ///--------->>> Section : Previously Selected Meals Api Method Ends Here

  ///--------->>> Section : AI SUGGESTED Meals Api Method Start Here
  ///
  ///-------<>>>>> Section : Get The Selected Set
  RxString selectedDate = ''.obs;
  void setSelectedDate({required String date}){
    selectedDate.value = date;
  }

  /// Global loading state for UI
  RxBool isAiSuggestedMealsLoading = false.obs;
  RxString aiSuggestedMealsErrorMessage = ''.obs;

  /// Per-meal-type loading flags to prevent duplicate API calls
  RxBool isBreakfastAiMealsLoaded = false.obs;
  RxBool isLunchAiMealsLoaded = false.obs;
  RxBool isDinnerAiMealsLoaded = false.obs;

  void clearAiSuggestedErrorMessage() {
    aiSuggestedMealsErrorMessage.value = '';
  }

  ///-------------->>> Section : PERSISTENT CACHE - All meals cached once
  RxList<String> tesList = <String>[].obs;
  /// Breakfast Cache
  

  /// Lunch Cache
  

  /// Dinner Cache
  

  ///-------------->>> Section : Per Tabs 3 Meal Types - These now read from cache
  

  ///--------->>> Section : AI SUGGESTED Meals Api Method Ends Here


}
