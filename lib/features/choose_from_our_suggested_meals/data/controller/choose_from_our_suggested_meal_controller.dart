import 'dart:convert';

import 'package:bloodfit/features/choose_from_our_suggested_meals/data/model/ai_suggested_meals_model.dart';
import 'package:bloodfit/features/choose_from_our_suggested_meals/data/model/recent_chosen_meals_model.dart';
import 'package:bloodfit/features/choose_from_our_suggested_meals/data/repository/ai_suggested_meals_repository.dart';
import 'package:bloodfit/helper/logger_util.dart';
import 'package:flutter/material.dart';
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
    LoggerUtils.debug("ChooseFromOurSuggestedMealController initialized - Application scoped");
  }

  @override
  void onClose() {
    LoggerUtils.debug("ChooseFromOurSuggestedMealController closed");
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
      return selectedTabName.value;
    } else if (index == 1) {
      selectedTabName.value = 'lunch';
      return selectedTabName.value;
    } else if (index == 2) {
      selectedTabName.value = 'dinner';
      return selectedTabName.value;
    } else {
      LoggerUtils.error(
        "Given Input is unexpected, Because the index $index has exceeded the tab total index",
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
    
    /// Skip if already loaded for this meal type
    if (mealType == 'breakfast' && isBreakfastRecentMealsLoaded.value) return;
    if (mealType == 'lunch' && isLunchRecentMealsLoaded.value) return;
    if (mealType == 'dinner' && isDinnerRecentMealsLoaded.value) return;

    clearErrorMessage();
    isPreviouslySelectedMealsLoading.value = true;

    try {
      final responses = await _previouslySelectedMealsRepository
          .previouslySelectedMealsRepository(mealType: mealType);

      if (responses.statusCode == 200 && responses.isSuccess) {
        LoggerUtils.debug(
          "🥳🥳🥳Recently Selected Meals are fatched successfully for $mealType!",
        );
        final model = RecentChosenMealsModel.fromJson(responses.jsonResponse!);

        LoggerUtils.debug(
          const JsonEncoder.withIndent('  ').convert(responses.jsonResponse),
        );

        final List<Datum> meals = model.data ?? [];

        if (mealType == 'breakfast') {
          breakfastRecentChosenMeals.assignAll(meals);
          isBreakfastRecentMealsLoaded.value = true;
        } else if (mealType == 'lunch') {
          lunchRecentChosenMeals.assignAll(meals);
          isLunchRecentMealsLoaded.value = true;
        } else if (mealType == 'dinner') {
          dinnerRecentChosenMeals.assignAll(meals);
          isDinnerRecentMealsLoaded.value = true;
        }
      } else {
        errorMessage.value = responses.errorMessage.toString();
        if (mealType == 'breakfast') {
          breakfastRecentChosenMeals.clear();
        } else if (mealType == 'lunch') {
          lunchRecentChosenMeals.clear();
        } else if (mealType == 'dinner') {
          dinnerRecentChosenMeals.clear();
        } else {
          LoggerUtils.error('Unexpected tab state: $mealType');
        }
        LoggerUtils.error("API Error");
        LoggerUtils.error("Status Code : ${responses.statusCode}");
        LoggerUtils.error("Error Message : ${errorMessage.value}");
      }
    } catch (error) {
      errorMessage.value = error.toString();
      LoggerUtils.error("Caught Error : $error");
    } finally {
      isPreviouslySelectedMealsLoading.value = false;
    }
  }

  ///--------->>> Section : Previously Selected Meals Api Method Ends Here

  ///--------->>> Section : AI SUGGESTED Meals Api Method Start Here

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
  /// Breakfast Cache
  final RxList<HealthyComforting> cachedBreakfastProteinPacked = <HealthyComforting>[].obs;
  final RxList<HealthyComforting> cachedBreakfastLightAndFresh = <HealthyComforting>[].obs;
  final RxList<HealthyComforting> cachedBreakfastHeartyComforting = <HealthyComforting>[].obs;

  /// Lunch Cache
  final RxList<HealthyComforting> cachedLunchProteinPacked = <HealthyComforting>[].obs;
  final RxList<HealthyComforting> cachedLunchLightAndFresh = <HealthyComforting>[].obs;
  final RxList<HealthyComforting> cachedLunchHeartyComforting = <HealthyComforting>[].obs;

  /// Dinner Cache
  final RxList<HealthyComforting> cachedDinnerProteinPacked = <HealthyComforting>[].obs;
  final RxList<HealthyComforting> cachedDinnerLightAndFresh = <HealthyComforting>[].obs;
  final RxList<HealthyComforting> cachedDinnerHeartyComforting = <HealthyComforting>[].obs;

  ///-------------->>> Section : Per Tabs 3 Meal Types - These now read from cache
  RxList<HealthyComforting> proteinPackedItemsList = <HealthyComforting>[].obs;
  RxList<HealthyComforting> lightAndFreshItemsList = <HealthyComforting>[].obs;
  RxList<HealthyComforting> heartyAndConfortingItemsList = <HealthyComforting>[].obs;

  /// Fetch AI suggested meals ONCE and cache them
  Future<void> fetchAndCacheAiSuggestedMeals() async {
    /// Don't fetch if all meals are already cached
    if (isBreakfastAiMealsLoaded.value && 
        isLunchAiMealsLoaded.value && 
        isDinnerAiMealsLoaded.value) {
      LoggerUtils.debug("All AI meals already cached - skipping API call");
      return;
    }

    /// Don't fetch if already loading
    if (isAiSuggestedMealsLoading.value) {
      LoggerUtils.debug("AI meals already loading - skipping duplicate call");
      return;
    }

    LoggerUtils.debug("Fetching AI suggested meals from API...");
    isAiSuggestedMealsLoading.value = true;
    clearAiSuggestedErrorMessage();

    try {
      final response = await _aiSuggestedMealsRepository
          .aiSuggestedMealsRepository();

      if (response.statusCode == 200 && response.isSuccess) {
        LoggerUtils.debug("🥳🥳🥳AI Suggested Meals fetched successfully!");
        final model = AiSuggestedMealsModel.fromJson(response.jsonResponse!);

        ///-----------<>>>>> SECTION : Cache Breakfast Data
        cachedBreakfastProteinPacked.assignAll(
          model.data?.breakfastOptions?.proteinPacked ?? []);
        cachedBreakfastLightAndFresh.assignAll(
          model.data?.breakfastOptions?.lightFresh ?? []);
        cachedBreakfastHeartyComforting.assignAll(
          model.data?.breakfastOptions?.healthyComforting ?? []);
        isBreakfastAiMealsLoaded.value = true;

        ///-----------<>>>>> SECTION : Cache Lunch Data
        cachedLunchProteinPacked.assignAll(
          model.data?.lunchOptions?.proteinPacked ?? []);
        cachedLunchLightAndFresh.assignAll(
          model.data?.lunchOptions?.lightFresh ?? []);
        cachedLunchHeartyComforting.assignAll(
          model.data?.lunchOptions?.healthyComforting ?? []);
        isLunchAiMealsLoaded.value = true;

        ///-----------<>>>>> SECTION : Cache Dinner Data
        cachedDinnerProteinPacked.assignAll(
          model.data?.dinnerOptions?.proteinPacked ?? []);
        cachedDinnerLightAndFresh.assignAll(
          model.data?.dinnerOptions?.lightFresh ?? []);
        cachedDinnerHeartyComforting.assignAll(
          model.data?.dinnerOptions?.healthyComforting ?? []);
        isDinnerAiMealsLoaded.value = true;

        LoggerUtils.debug("All meal types cached successfully");
      } else {
        aiSuggestedMealsErrorMessage.value = response.errorMessage.toString();
        LoggerUtils.error(
          "Failed to Get AI Suggested Meals : Error Code :: ${response.statusCode}",
        );
        LoggerUtils.error(
          "AI Suggested Meals Error Message : ${aiSuggestedMealsErrorMessage.value}",
        );
      }
    } catch (error) {
      aiSuggestedMealsErrorMessage.value = error.toString();
      LoggerUtils.error("Error Caught While Getting AI Suggested Meals!");
      LoggerUtils.error("Caught Error : ${aiSuggestedMealsErrorMessage.value}");
    } finally {
      isAiSuggestedMealsLoading.value = false;
    }
  }

  /// Load meals for the current tab from cache (no API call)
  void loadMealsForCurrentTabFromCache() {
    final mealType = selectedTabName.value;
    LoggerUtils.debug("Loading $mealType meals from cache");

    if (mealType == 'breakfast') {
      proteinPackedItemsList.assignAll(cachedBreakfastProteinPacked);
      lightAndFreshItemsList.assignAll(cachedBreakfastLightAndFresh);
      heartyAndConfortingItemsList.assignAll(cachedBreakfastHeartyComforting);
    } else if (mealType == 'lunch') {
      proteinPackedItemsList.assignAll(cachedLunchProteinPacked);
      lightAndFreshItemsList.assignAll(cachedLunchLightAndFresh);
      heartyAndConfortingItemsList.assignAll(cachedLunchHeartyComforting);
    } else if (mealType == 'dinner') {
      proteinPackedItemsList.assignAll(cachedDinnerProteinPacked);
      lightAndFreshItemsList.assignAll(cachedDinnerLightAndFresh);
      heartyAndConfortingItemsList.assignAll(cachedDinnerHeartyComforting);
    }
  }

  /// Combined method: Fetch if not cached, then load from cache
  Future<void> getAiSuggestedMealsApi() async {
    await fetchAndCacheAiSuggestedMeals();
    loadMealsForCurrentTabFromCache();
  }

  /// Reset all cached data (for explicit user reset or app exit)
  void resetAllCachedData() {
    cachedBreakfastProteinPacked.clear();
    cachedBreakfastLightAndFresh.clear();
    cachedBreakfastHeartyComforting.clear();
    cachedLunchProteinPacked.clear();
    cachedLunchLightAndFresh.clear();
    cachedLunchHeartyComforting.clear();
    cachedDinnerProteinPacked.clear();
    cachedDinnerLightAndFresh.clear();
    cachedDinnerHeartyComforting.clear();

    isBreakfastAiMealsLoaded.value = false;
    isLunchAiMealsLoaded.value = false;
    isDinnerAiMealsLoaded.value = false;

    proteinPackedItemsList.clear();
    lightAndFreshItemsList.clear();
    heartyAndConfortingItemsList.clear();

    LoggerUtils.debug("All cached AI meal data reset");
  }

  ///--------->>> Section : AI SUGGESTED Meals Api Method Ends Here

  ///--------->>> Section : Meal Selection State Management

  /// Selected meal items per tab (null = no selection)
  Rx<HealthyComforting?> selectedBreakfastMeal = Rx<HealthyComforting?>(null);
  Rx<HealthyComforting?> selectedLunchMeal = Rx<HealthyComforting?>(null);
  Rx<HealthyComforting?> selectedDinnerMeal = Rx<HealthyComforting?>(null);

  /// Callback for when meal selection changes
  VoidCallback? onMealSelectionChanged;

  /// Set the meal selection callback
  void setMealSelectionCallback(VoidCallback callback) {
    onMealSelectionChanged = callback;
  }

  /// Select a meal for a specific tab (enforces single selection per tab)
  void selectMeal({
    required String mealType,
    required HealthyComforting meal,
  }) {
    if (mealType == 'breakfast') {
      selectedBreakfastMeal.value = meal;
    } else if (mealType == 'lunch') {
      selectedLunchMeal.value = meal;
    } else if (mealType == 'dinner') {
      selectedDinnerMeal.value = meal;
    }

    /// Notify the UI to show the tracker
    onMealSelectionChanged?.call();
  }

  /// Deselect a meal for a specific tab
  void deselectMeal({
    required String mealType,
  }) {
    if (mealType == 'breakfast') {
      selectedBreakfastMeal.value = null;
    } else if (mealType == 'lunch') {
      selectedLunchMeal.value = null;
    } else if (mealType == 'dinner') {
      selectedDinnerMeal.value = null;
    }

    /// Notify the UI to show the tracker
    onMealSelectionChanged?.call();
  }

  /// Toggle meal selection (select if not selected, deselect if already selected)
  void toggleMealSelection({
    required String mealType,
    required HealthyComforting meal,
  }) {
    if (mealType == 'breakfast') {
      if (selectedBreakfastMeal.value?.mealName == meal.mealName) {
        deselectMeal(mealType: mealType);
      } else {
        selectMeal(mealType: mealType, meal: meal);
      }
    } else if (mealType == 'lunch') {
      if (selectedLunchMeal.value?.mealName == meal.mealName) {
        deselectMeal(mealType: mealType);
      } else {
        selectMeal(mealType: mealType, meal: meal);
      }
    } else if (mealType == 'dinner') {
      if (selectedDinnerMeal.value?.mealName == meal.mealName) {
        deselectMeal(mealType: mealType);
      } else {
        selectMeal(mealType: mealType, meal: meal);
      }
    }
  }

  /// Check if a specific meal is selected
  bool isMealSelected({
    required String mealType,
    required HealthyComforting meal,
  }) {
    if (mealType == 'breakfast') {
      return selectedBreakfastMeal.value?.mealName == meal.mealName;
    } else if (mealType == 'lunch') {
      return selectedLunchMeal.value?.mealName == meal.mealName;
    } else if (mealType == 'dinner') {
      return selectedDinnerMeal.value?.mealName == meal.mealName;
    }
    return false;
  }

  /// Check if all three meals are selected (for enabling Build Meal Plan button)
  bool get isMealPlanComplete {
    return selectedBreakfastMeal.value != null &&
        selectedLunchMeal.value != null &&
        selectedDinnerMeal.value != null;
  }

  /// Get the list of all selected meals
  List<HealthyComforting> getSelectedMeals() {
    final meals = <HealthyComforting>[];
    if (selectedBreakfastMeal.value != null) {
      meals.add(selectedBreakfastMeal.value!);
    }
    if (selectedLunchMeal.value != null) {
      meals.add(selectedLunchMeal.value!);
    }
    if (selectedDinnerMeal.value != null) {
      meals.add(selectedDinnerMeal.value!);
    }
    return meals;
  }

  /// Reset all selections (for explicit user reset)
  void resetAllSelections() {
    selectedBreakfastMeal.value = null;
    selectedLunchMeal.value = null;
    selectedDinnerMeal.value = null;
    LoggerUtils.debug("All meal selections reset");
  }

  ///--------->>> Section : Meal Selection State Management Ends Here
}
