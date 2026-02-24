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
    LoggerUtils.debug("🚀🚀🚀 ChooseFromOurSuggestedMealController initialized - Application scoped");
    LoggerUtils.debug("📋 Setting up reactive listeners for selection changes...");

    /// Set up reactive listeners for selection changes
    ever(selectedBreakfastMeal, (_) {
      LoggerUtils.debug("🔔 Reactive listener triggered: Breakfast selection changed");
      onMealSelectionChanged?.call();
    });
    ever(selectedLunchMeal, (_) {
      LoggerUtils.debug("🔔 Reactive listener triggered: Lunch selection changed");
      onMealSelectionChanged?.call();
    });
    ever(selectedDinnerMeal, (_) {
      LoggerUtils.debug("🔔 Reactive listener triggered: Dinner selection changed");
      onMealSelectionChanged?.call();
    });

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
  RxString cachedBreakfastImage = ''.obs;

  /// Lunch Cache
  final RxList<HealthyComforting> cachedLunchProteinPacked = <HealthyComforting>[].obs;
  final RxList<HealthyComforting> cachedLunchLightAndFresh = <HealthyComforting>[].obs;
  final RxList<HealthyComforting> cachedLunchHeartyComforting = <HealthyComforting>[].obs;
  RxString cachedLunchImage = ''.obs;

  /// Dinner Cache
  final RxList<HealthyComforting> cachedDinnerProteinPacked = <HealthyComforting>[].obs;
  final RxList<HealthyComforting> cachedDinnerLightAndFresh = <HealthyComforting>[].obs;
  final RxList<HealthyComforting> cachedDinnerHeartyComforting = <HealthyComforting>[].obs;
  RxString cachedDinnerImage = ''.obs;

  ///-------------->>> Section : Per Tabs 3 Meal Types - These now read from cache
  RxList<HealthyComforting> proteinPackedItemsList = <HealthyComforting>[].obs;
  RxList<HealthyComforting> lightAndFreshItemsList = <HealthyComforting>[].obs;
  RxList<HealthyComforting> heartyAndConfortingItemsList = <HealthyComforting>[].obs;
  RxString currentTabImageUrl = ''.obs;

  /// Fetch AI suggested meals ONCE and cache them
  Future<void> fetchAndCacheAiSuggestedMeals() async {
    LoggerUtils.debug("🔍 fetchAndCacheAiSuggestedMeals called");
    LoggerUtils.debug(
      "📊 Cache status - Breakfast: ${isBreakfastAiMealsLoaded.value}, Lunch: ${isLunchAiMealsLoaded.value}, Dinner: ${isDinnerAiMealsLoaded.value}"
    );

    /// Don't fetch if all meals are already cached
    if (isBreakfastAiMealsLoaded.value &&
        isLunchAiMealsLoaded.value &&
        isDinnerAiMealsLoaded.value) {
      LoggerUtils.debug("✅ All AI meals already cached - skipping API call");
      return;
    }

    /// Don't fetch if already loading
    if (isAiSuggestedMealsLoading.value) {
      LoggerUtils.debug("⏳ AI meals already loading - skipping duplicate call");
      return;
    }

    LoggerUtils.debug("📡 Fetching AI suggested meals from API...");
    isAiSuggestedMealsLoading.value = true;
    clearAiSuggestedErrorMessage();

    try {
      final response = await _aiSuggestedMealsRepository
          .aiSuggestedMealsRepository();

      if (response.statusCode == 200 && response.isSuccess) {
        LoggerUtils.debug("🥳🥳🥳 AI Suggested Meals fetched successfully!");
        final model = AiSuggestedMealsModel.fromJson(response.jsonResponse!);

        ///-----------<>>>>> SECTION : Cache Breakfast Data
        final breakfastProtein = model.data?.breakfastOptions?.proteinPacked ?? [];
        final breakfastLight = model.data?.breakfastOptions?.lightFresh ?? [];
        final breakfastHearty = model.data?.breakfastOptions?.healthyComforting ?? [];
        
        cachedBreakfastProteinPacked.assignAll(breakfastProtein);
        cachedBreakfastLightAndFresh.assignAll(breakfastLight);
        cachedBreakfastHeartyComforting.assignAll(breakfastHearty);
        cachedBreakfastImage.value = model.data?.breakfastImage ?? '';
        isBreakfastAiMealsLoaded.value = true;
        LoggerUtils.debug("✅ Breakfast cached: ${breakfastProtein.length + breakfastLight.length + breakfastHearty.length} meals, Image: ${cachedBreakfastImage.value}");

        ///-----------<>>>>> SECTION : Cache Lunch Data
        final lunchProtein = model.data?.lunchOptions?.proteinPacked ?? [];
        final lunchLight = model.data?.lunchOptions?.lightFresh ?? [];
        final lunchHearty = model.data?.lunchOptions?.healthyComforting ?? [];
        
        cachedLunchProteinPacked.assignAll(lunchProtein);
        cachedLunchLightAndFresh.assignAll(lunchLight);
        cachedLunchHeartyComforting.assignAll(lunchHearty);
        cachedLunchImage.value = model.data?.lunchImage ?? '';
        isLunchAiMealsLoaded.value = true;
        LoggerUtils.debug("✅ Lunch cached: ${lunchProtein.length + lunchLight.length + lunchHearty.length} meals, Image: ${cachedLunchImage.value}");

        ///-----------<>>>>> SECTION : Cache Dinner Data
        final dinnerProtein = model.data?.dinnerOptions?.proteinPacked ?? [];
        final dinnerLight = model.data?.dinnerOptions?.lightFresh ?? [];
        final dinnerHearty = model.data?.dinnerOptions?.healthyComforting ?? [];
        
        cachedDinnerProteinPacked.assignAll(dinnerProtein);
        cachedDinnerLightAndFresh.assignAll(dinnerLight);
        cachedDinnerHeartyComforting.assignAll(dinnerHearty);
        cachedDinnerImage.value = model.data?.dinnerImage ?? '';
        isDinnerAiMealsLoaded.value = true;
        LoggerUtils.debug("✅ Dinner cached: ${dinnerProtein.length + dinnerLight.length + dinnerHearty.length} meals, Image: ${cachedDinnerImage.value}");

        LoggerUtils.debug("🎉 All meal types cached successfully");
      } else {
        LoggerUtils.error("❌ Failed to Get AI Suggested Meals");
        LoggerUtils.error("🔴 Error Code :: ${response.statusCode}");
        LoggerUtils.error("🔴 Error Message : ${response.errorMessage}");
        
        if(response.statusCode == 524){
          aiSuggestedMealsErrorMessage.value = "Connection timed out. Please check your internet connection and try again.";
        }else{
          aiSuggestedMealsErrorMessage.value = response.errorMessage.toString();
        }
      }
    } catch (error) {
      LoggerUtils.error("💥 Error Caught While Getting AI Suggested Meals!");
      LoggerUtils.error("🔴 Caught Error : $error");
      aiSuggestedMealsErrorMessage.value = error.toString();
    } finally {
      isAiSuggestedMealsLoading.value = false;
      LoggerUtils.debug("🏁 AI meals loading completed");
    }
  }

  /// Load meals for the current tab from cache (no API call)
  void loadMealsForCurrentTabFromCache() {
    final mealType = selectedTabName.value;
    LoggerUtils.debug("📥 loadMealsForCurrentTabFromCache called for: $mealType");

    if (mealType == 'breakfast') {
      proteinPackedItemsList.assignAll(cachedBreakfastProteinPacked);
      lightAndFreshItemsList.assignAll(cachedBreakfastLightAndFresh);
      heartyAndConfortingItemsList.assignAll(cachedBreakfastHeartyComforting);
      currentTabImageUrl.value = cachedBreakfastImage.value;
      LoggerUtils.debug(
        "📦 Breakfast loaded from cache: ${cachedBreakfastProteinPacked.length + cachedBreakfastLightAndFresh.length + cachedBreakfastHeartyComforting.length} meals, Image: ${currentTabImageUrl.value}"
      );
    } else if (mealType == 'lunch') {
      proteinPackedItemsList.assignAll(cachedLunchProteinPacked);
      lightAndFreshItemsList.assignAll(cachedLunchLightAndFresh);
      heartyAndConfortingItemsList.assignAll(cachedLunchHeartyComforting);
      currentTabImageUrl.value = cachedLunchImage.value;
      LoggerUtils.debug(
        "📦 Lunch loaded from cache: ${cachedLunchProteinPacked.length + cachedLunchLightAndFresh.length + cachedLunchHeartyComforting.length} meals, Image: ${currentTabImageUrl.value}"
      );
    } else if (mealType == 'dinner') {
      proteinPackedItemsList.assignAll(cachedDinnerProteinPacked);
      lightAndFreshItemsList.assignAll(cachedDinnerLightAndFresh);
      heartyAndConfortingItemsList.assignAll(cachedDinnerHeartyComforting);
      currentTabImageUrl.value = cachedDinnerImage.value;
      LoggerUtils.debug(
        "📦 Dinner loaded from cache: ${cachedDinnerProteinPacked.length + cachedDinnerLightAndFresh.length + cachedDinnerHeartyComforting.length} meals, Image: ${currentTabImageUrl.value}"
      );
    } else {
      LoggerUtils.error("❌ Unknown meal type: $mealType");
    }
  }

  /// Combined method: Fetch if not cached, then load from cache
  Future<void> getAiSuggestedMealsApi() async {
    LoggerUtils.debug("🔄 getAiSuggestedMealsApi called");
    await fetchAndCacheAiSuggestedMeals();
    loadMealsForCurrentTabFromCache();
    LoggerUtils.debug("✅ getAiSuggestedMealsApi completed");
  }

  /// Reset all cached data (for explicit user reset or app exit)
  void resetAllCachedData() {
    LoggerUtils.debug("🗑️ resetAllCachedData called");
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

    LoggerUtils.debug("✅ All cached AI meal data reset");
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
    LoggerUtils.debug("📞 setMealSelectionCallback registered");
    onMealSelectionChanged = callback;
  }

  /// Select a meal for a specific tab (enforces single selection per tab)
  void selectMeal({
    required String mealType,
    required HealthyComforting meal,
  }) {
    LoggerUtils.debug("➕ selectMeal called - Type: $mealType, Meal: ${meal.mealName}");
    
    if (mealType == 'breakfast') {
      selectedBreakfastMeal.value = meal;
      LoggerUtils.debug("✅ Breakfast selected: ${meal.mealName}");
    } else if (mealType == 'lunch') {
      selectedLunchMeal.value = meal;
      LoggerUtils.debug("✅ Lunch selected: ${meal.mealName}");
    } else if (mealType == 'dinner') {
      selectedDinnerMeal.value = meal;
      LoggerUtils.debug("✅ Dinner selected: ${meal.mealName}");
    }
    
    LoggerUtils.debug("🔔 Reactive listener (ever) will automatically trigger the callback");
  }

  /// Deselect a meal for a specific tab
  void deselectMeal({
    required String mealType,
  }) {
    LoggerUtils.debug("➖ deselectMeal called for: $mealType");
    
    if (mealType == 'breakfast') {
      selectedBreakfastMeal.value = null;
      LoggerUtils.debug("✅ Breakfast deselected");
    } else if (mealType == 'lunch') {
      selectedLunchMeal.value = null;
      LoggerUtils.debug("✅ Lunch deselected");
    } else if (mealType == 'dinner') {
      selectedDinnerMeal.value = null;
      LoggerUtils.debug("✅ Dinner deselected");
    }
    
    LoggerUtils.debug("🔔 Reactive listener (ever) will automatically trigger the callback");
  }

  /// Toggle meal selection (select if not selected, deselect if already selected)
  void toggleMealSelection({
    required String mealType,
    required HealthyComforting meal,
  }) {
    LoggerUtils.debug("🔄 toggleMealSelection called - Type: $mealType, Meal: ${meal.mealName}");
    
    if (mealType == 'breakfast') {
      final currentSelection = selectedBreakfastMeal.value?.mealName;
      LoggerUtils.debug("📊 Current breakfast selection: $currentSelection");
      
      if (currentSelection == meal.mealName) {
        LoggerUtils.debug("🔴 Same meal - will deselect");
        deselectMeal(mealType: mealType);
      } else {
        LoggerUtils.debug("🟢 Different meal - will select");
        selectMeal(mealType: mealType, meal: meal);
      }
    } else if (mealType == 'lunch') {
      final currentSelection = selectedLunchMeal.value?.mealName;
      LoggerUtils.debug("📊 Current lunch selection: $currentSelection");
      
      if (currentSelection == meal.mealName) {
        LoggerUtils.debug("🔴 Same meal - will deselect");
        deselectMeal(mealType: mealType);
      } else {
        LoggerUtils.debug("🟢 Different meal - will select");
        selectMeal(mealType: mealType, meal: meal);
      }
    } else if (mealType == 'dinner') {
      final currentSelection = selectedDinnerMeal.value?.mealName;
      LoggerUtils.debug("📊 Current dinner selection: $currentSelection");
      
      if (currentSelection == meal.mealName) {
        LoggerUtils.debug("🔴 Same meal - will deselect");
        deselectMeal(mealType: mealType);
      } else {
        LoggerUtils.debug("🟢 Different meal - will select");
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
      final isSelected = selectedBreakfastMeal.value?.mealName == meal.mealName;
      LoggerUtils.debug("🔍 isMealSelected - Breakfast: ${meal.mealName} = $isSelected");
      return isSelected;
    } else if (mealType == 'lunch') {
      final isSelected = selectedLunchMeal.value?.mealName == meal.mealName;
      LoggerUtils.debug("🔍 isMealSelected - Lunch: ${meal.mealName} = $isSelected");
      return isSelected;
    } else if (mealType == 'dinner') {
      final isSelected = selectedDinnerMeal.value?.mealName == meal.mealName;
      LoggerUtils.debug("🔍 isMealSelected - Dinner: ${meal.mealName} = $isSelected");
      return isSelected;
    }
    LoggerUtils.error("❌ Unknown meal type in isMealSelected: $mealType");
    return false;
  }

  /// Check if all three meals are selected (for enabling Build Meal Plan button)
  bool get isMealPlanComplete {
    final isComplete = selectedBreakfastMeal.value != null &&
        selectedLunchMeal.value != null &&
        selectedDinnerMeal.value != null;
    LoggerUtils.debug(
      "📊 isMealPlanComplete: $isComplete (B: ${selectedBreakfastMeal.value != null}, L: ${selectedLunchMeal.value != null}, D: ${selectedDinnerMeal.value != null})"
    );
    return isComplete;
  }

  /// Get the list of all selected meals
  List<HealthyComforting> getSelectedMeals() {
    final meals = <HealthyComforting>[];
    if (selectedBreakfastMeal.value != null) {
      meals.add(selectedBreakfastMeal.value!);
      LoggerUtils.debug("📦 Added breakfast: ${selectedBreakfastMeal.value!.mealName}");
    }
    if (selectedLunchMeal.value != null) {
      meals.add(selectedLunchMeal.value!);
      LoggerUtils.debug("📦 Added lunch: ${selectedLunchMeal.value!.mealName}");
    }
    if (selectedDinnerMeal.value != null) {
      meals.add(selectedDinnerMeal.value!);
      LoggerUtils.debug("📦 Added dinner: ${selectedDinnerMeal.value!.mealName}");
    }
    LoggerUtils.debug("🎁 Total selected meals: ${meals.length}");
    return meals;
  }

  /// Reset all selections (for explicit user reset)
  void resetAllSelections() {
    LoggerUtils.debug("🗑️ resetAllSelections called");
    selectedBreakfastMeal.value = null;
    selectedLunchMeal.value = null;
    selectedDinnerMeal.value = null;
    LoggerUtils.debug("✅ All meal selections reset");
  }

  ///--------->>> Section : Meal Selection State Management Ends Here
}
