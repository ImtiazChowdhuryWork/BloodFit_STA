import 'dart:async';

import 'package:bloodfit/constants/app_enums.dart';
import 'package:bloodfit/features/home/data/model/swap_meal_options_model.dart';
import 'package:bloodfit/features/home/data/repository/get_todays_meal_repository.dart';
import 'package:bloodfit/features/home/data/repository/swap_meal_options_repository.dart';
import 'package:bloodfit/features/home/data/repository/swap_meal_repository.dart';
import 'package:bloodfit/features/home/data/repository/update_meal_status_repository.dart';
import 'package:bloodfit/gen/colors.gen.dart';
import 'package:bloodfit/helper/logger_util.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../controllers/app_snackbar_controller.dart';
import '../../../../controllers/enums_controller.dart';
import '../../../your_daily_calories_intake/data/model/get_calorie_requirements_model.dart';

import '../model/get_todays_meal_model.dart' hide Icon;
import '../repository/daily_calories_api_repository.dart';
import '../../../meal_plan_feature_options/presentation/data/controller/meal_plan_feature_options_controller.dart';

class HomeScreenController extends GetxController {
  ///--------->>> Section : Importing the Repositories
  DailyCaloriesApiRepository _dailyCaloriesApiRepository;
  GetTodaysMealRepository _getTodaysMealRepository;
  MealConsumptionRepository _mealConsumptionRepository;
  SwapMealRepository _swapMealRepository;
  SwapMealOptionsRepository _swapMealOptionsRepository;

  ///----------->>> Section : Importing the Model
  Rxn<GetCalorieRequirementsModel> model = Rxn<GetCalorieRequirementsModel>();

  HomeScreenController(
    this._dailyCaloriesApiRepository,
    this._getTodaysMealRepository,
    this._mealConsumptionRepository,
    this._swapMealRepository,
    this._swapMealOptionsRepository,
  );

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

  ///----------------->>> Is Your Daily Calories Api Section Start Here
  RxBool isDailyCaloriesLoading = false.obs;
  RxBool isSuccess = false.obs;
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
        var data = GetCalorieRequirementsModel.fromJson(response.jsonResponse!);

        model.value = data;
        isSuccess.value = true;
      } else {
        errorMessage.value = response.errorMessage.toString();
        LoggerUtils.error("Something Went Wrong!");
        LoggerUtils.error("Error Found : ${errorMessage.value}");
      }
    } catch (e) {
      errorMessage.value = e.toString();
      isSuccess.value = false;
      LoggerUtils.error("Error Found : ${errorMessage.value}");
    } finally {
      isDailyCaloriesLoading.value = false;
    }
  }

  String get totalCalories =>
      model.value?.data?.calorieRequirement?.totalCalorie.toString() ?? '0';
  int get consumedCarbs => model.value?.data?.calorieRequirement?.carbs ?? 0;
  int get consumedProtein =>
      model.value?.data?.calorieRequirement?.protein ?? 0;
  int get consumedFat => model.value?.data?.calorieRequirement?.fat ?? 0;
  int get completationPercentage =>
      model.value?.data?.completionPercentage ?? 0;

  ///----------------->>> Is Your Daily Calories Api Section Ends Here

  ///-------->>> Section : Todays Selected Meals Api Starts Here
  final EnumsController enumsController = Get.find<EnumsController>();
  RxBool isTodaysSelectedMealsLoading = false.obs;
  RxBool selectedMealPlanAvailable = false.obs;
  RxString todaysSelectedMealsErrorMessage = ''.obs;
  void clearTodaysSelectedErrorMessage() {
    todaysSelectedMealsErrorMessage.value = '';
  }

  void setSelectedMealPlanAvailableStatus({required bool status}) {
    selectedMealPlanAvailable.value = status;
  }

  Rxn<GetTodaysMealModel> todaysMealModel = Rxn<GetTodaysMealModel>();

  Future<void> getTodaysSelectedMealsApi() async {
    isTodaysSelectedMealsLoading.value = true;
    clearTodaysSelectedErrorMessage();
    setSelectedMealPlanAvailableStatus(status: false);

    LoggerUtils.debug("😇😇....Get Todays Meas Api Started!");
    try {
      final response = await _getTodaysMealRepository.getTodaysMealRepository();
      LoggerUtils.debug(
        "API --->>> Todays Selected Meals Api <<<----- Response ----->>> ${response.jsonResponse}",
      );

      LoggerUtils.debug("Status Code : ${response.statusCode}");
      LoggerUtils.debug("👁👁👁 IS Success Value : ${response.isSuccess}");

      if (response.statusCode == 200 && response.isSuccess) {
  todaysMealModel.value =
      GetTodaysMealModel.fromJson(response.jsonResponse!);

  final data = todaysMealModel.value?.data ?? [];

  todaysSelectedMealsList.assignAll(data);

  // Reset first
  itemBreakFast.value = null;
  itemLunch.value = null;
  itemDinner.value = null;

  for (final meal in todaysSelectedMealsList) {
    switch (meal.mealType) {
      case 'breakfast':
        itemBreakFast.value = meal;
        break;
      case 'lunch':
        itemLunch.value = meal;
        break;
      case 'dinner':
        itemDinner.value = meal;
        break;
    }
  }

  final bool isMealNamesFound =
      (itemBreakFast.value?.mealName?.isNotEmpty ?? false) &&
      (itemLunch.value?.mealName?.isNotEmpty ?? false) &&
      (itemDinner.value?.mealName?.isNotEmpty ?? false);

  setSelectedMealPlanAvailableStatus(status: isMealNamesFound);

  LoggerUtils.debug(
    "Meals Available: $isMealNamesFound | "
    "Breakfast: ${itemBreakFast.value?.mealName}, "
    "Lunch: ${itemLunch.value?.mealName}, "
    "Dinner: ${itemDinner.value?.mealName}",
  );
} else {
        todaysSelectedMealsErrorMessage.value = response.errorMessage
            .toString();
        LoggerUtils.error(
          "Something Went Wrong While Fetching the ---->>> Todays Selected Meals <<<-----API!",
        );
        LoggerUtils.error("Status Code : ${response.statusCode}");

        LoggerUtils.error("Status Code : $todaysSelectedMealsErrorMessage");
      }
    } catch (error) {
      todaysSelectedMealsErrorMessage.value = error.toString();
      LoggerUtils.error(
        "Error Catched On ---->>> Todays Selected Meals Api <<<-----: ",
      );
      // LoggerUtils.debug("Error Found! Status Code : ${error}");
      LoggerUtils.debug("Catched Error : $todaysSelectedMealsErrorMessage");
    } finally {
      isTodaysSelectedMealsLoading.value = false;
    }
  }

  // Rxn<Datum> itemBreakFast = Rxn<Datum>();
  // Rxn<TodaysMealDataModel> itemLunch = Rxn<TodaysMealDataModel>();
  // Rxn<TodaysMealDataModel> itemDinner = Rxn<TodaysMealDataModel>();

// ---------- Individual Meals State ----------
Rxn<Datum> itemBreakFast = Rxn<Datum>();
Rxn<Datum> itemLunch = Rxn<Datum>();
Rxn<Datum> itemDinner = Rxn<Datum>();
  RxList<Datum> todaysSelectedMealsList = <Datum>[].obs;

  ///----->>> BreakFast Getters
  String? get breakfastName =>
      itemBreakFast.value?.mealName ?? 'Meal name not found!';
  int? get breakfastTotalKcal => itemBreakFast.value?.kcal ?? 0;
  String? get breakFastImage => itemBreakFast.value?.image ?? '';
  String? get breakFastMealEatenStatus => itemBreakFast.value?.status ?? '';
  String? get breakfastMealID =>
      itemBreakFast.value?.id ?? 'Breakfast Meal ID Not Found!';

  ///----->>> Lunch Getters
  String? get lunchName => itemLunch.value?.mealName ?? 'Meal name not found!';
  int? get lunchTotalKcal => itemLunch.value?.kcal ?? 0;
  String? get lunchImage => itemLunch.value?.image ?? '';
  String? get lunchMealEatenStatus => itemLunch.value?.status ?? '';
  String? get lunchMealID => itemLunch.value?.id ?? 'Lunch Meal ID Not Found!';

  ///----->>> Diner Getters
  String? get dinerName => itemDinner.value?.mealName ?? 'Meal name not found!';
  int? get dinerKcal => itemDinner.value?.kcal ?? 0;
  String? get dinerImage => itemDinner.value?.image ?? '';
  String? get dinerMealEatenStatus => itemDinner.value?.status ?? '';
  String? get dinerMealID => itemDinner.value?.id ?? 'Diner Meal ID Not Found!';

  ///-------->>> Section : Todays Selected Meals Api Ends Here

  ///-------->>> Section : Todyas Meals Eaten Api Starts Here

  ///------>>> Loader
  RxBool isTodaysMealEatenValueLoading = false.obs;

  ///------>>> Section : Error Message
  RxString isTodaysMealEatenHasError = ''.obs;
  void clearTodaysMealEatenError() {
    isTodaysMealEatenHasError.value = '';
  }

  ///------>>> Section : Meals Eaten Status
  RxBool isTodaysMealEaten = false.obs;
  void setTodaysMealEatenStatus({required bool status}) {
    isTodaysMealEaten.value = status;
  }

  ///--------->>> Section : Meal ID
  RxString selectedMealID = ''.obs;

  Future<void> patchUpdateMealConsumptionApi({required String mealID}) async {
    isTodaysMealEatenValueLoading.value = true;
    clearTodaysMealEatenError();
    setTodaysMealEatenStatus(status: false);

    try {
      LoggerUtils.debug("Meal ID Received : $mealID");

      final response = await _mealConsumptionRepository
          .updateMealConsumptionRepository(mealID: mealID);

      if (response.statusCode == 200 && response.isSuccess) {
        setTodaysMealEatenStatus(status: true);
        LoggerUtils.debug(
          "Meals Eaten Status Updated Successfully for Meal ID : $mealID",
        );

        // Refresh the meals data and daily calories to reflect the updated status
        await getTodaysSelectedMealsApi();
        await getDailyCaloriesApi();
      } else {
        isTodaysMealEatenHasError.value = response.errorMessage.toString();
        LoggerUtils.error(
          "Something Went Wrong. While UPdating the meal status!",
        );
        LoggerUtils.error("Error Message : ${isTodaysMealEatenHasError.value}");
      }
    } catch (error) {
      isTodaysMealEatenHasError.value = error.toString();
      LoggerUtils.error("Error Catced : While Updating Meals Eaten Status!");
      LoggerUtils.error("Error : $error");
    } finally {
      isTodaysMealEatenValueLoading.value = false;
    }
  }

  ///-------->>> Section : Todyas Meals Eaten Api Ends Here

  ///--------->>> Section : Swap Meal Api Starts Here
  ///
  ///This api method is not implemented yet

  RxBool isSwapMealValueLoading = false.obs;
  RxString swapMealErrorMessage = ''.obs;
  void clearSwapMealError() {
    swapMealErrorMessage.value = '';
  }

  Future<void> pathchSwapMealApi({required String mealID, required String description, required List<String> ingredientList, required String imageUrl, required List<Map<String, dynamic>> caloriesCount}) async {
    try {
      isSwapMealValueLoading.value = true;
      clearSwapMealError();

      LoggerUtils.debug("===== PATCH SWAP MEAL API → REQUEST =====");
      LoggerUtils.debug("Endpoint mealID  : $mealID");
      LoggerUtils.debug("description      : $description");
      LoggerUtils.debug("ingredientList   : $ingredientList");
      LoggerUtils.debug("imageUrl         : $imageUrl");
      LoggerUtils.debug("caloriesCount    : $caloriesCount");
      LoggerUtils.debug("=========================================");

      final response = await _swapMealRepository.swapMealRepository(
        mealID: mealID,
        description: description,
        ingredientList: ingredientList,
        imageUrl: imageUrl,
        caloriesCount: caloriesCount,
      );

      LoggerUtils.debug("===== PATCH SWAP MEAL API → RESPONSE =====");
      LoggerUtils.debug("Status Code  : ${response.statusCode}");
      LoggerUtils.debug("Is Success   : ${response.isSuccess}");
      LoggerUtils.debug("Error Msg    : ${response.errorMessage}");
      LoggerUtils.debug("JSON Body    : ${response.jsonResponse}");
      LoggerUtils.debug("==========================================");

      if (response.statusCode == 200 && response.isSuccess) {
        LoggerUtils.debug("🤪🤪🤪🤪Meals Swaped Successfully!");
        // Navigate back first so the overlay context is available for the snackbar
        Get.back();
        AppSnackBarController.show(
          message: 'Meal swapped successfully!',
          type: AppSnackBarType.success,
          position: AppSnackBarPosition.top,
          duration: const Duration(seconds: 4),
        );
        // Refresh home screen data
        await getTodaysSelectedMealsApi();
        await getDailyCaloriesApi();
        // Refresh meal plan options screen if it's currently active
        if (Get.isRegistered<MealPlanFeatureOptionsController>()) {
          await Get.find<MealPlanFeatureOptionsController>().postGetMealsBySelectedDate();
          final refreshedMeals = Get.find<MealPlanFeatureOptionsController>().mealsByDateList;
          LoggerUtils.debug("===== REFRESHED MEAL PLAN OPTIONS LIST =====");
          LoggerUtils.debug("Total meals after swap : ${refreshedMeals.length}");
          refreshedMeals.asMap().forEach((index, meal) {
            LoggerUtils.debug("  [$index] mealName=${meal.mealName}, mealType=${meal.mealType}, kcal=${meal.kcal}, status=${meal.status}");
          });
          LoggerUtils.debug("============================================");
        }
      } else {
        swapMealErrorMessage.value = response.errorMessage ?? 'Failed to swap meal';
        LoggerUtils.error("☠️ Swap Meal Failed: ${swapMealErrorMessage.value}");
      }
    } catch (error) {
      swapMealErrorMessage.value = error.toString();
      LoggerUtils.error(
        "☠️☠️☠️☠️☠️Error Catched While Swaping Meals From Home Screen!",
      );
      LoggerUtils.error(
        "☠️☠️☠️☠️☠️Swap Meal Catched Error : ${swapMealErrorMessage.value}",
      );
    } finally {
      isSwapMealValueLoading.value = false;
    }
  }

  ///--------->>> Section : Swap Meal Api Ends Here
  ///
  ///
  ///--------->>> Section : Swap Meal Options Api Starts Here
  
  Rxn<SwapMealOptionsModel> swapMealOptionsModel = Rxn<SwapMealOptionsModel>();
  
  RxBool isSwapMealOptionsLoading = false.obs;
  RxString swapMealOptionsErrorMessage = ''.obs;
  void clearSwapMealOptionsErrorMessage(){
    swapMealOptionsErrorMessage.value = '';
  }

  RxString categoryName = ''.obs;
  void setCategoryName({required String value}){
    categoryName.value = value;
  }

  RxString subCategoryName = ''.obs;
  void setSubCategoryName({required String value}){
    subCategoryName.value = value;
  }

  RxInt currentCallores = 0.obs;
  void setCurrentCalories({required int value}){
    currentCallores.value = value;
  }


  // ─── Swap Meal Options Progress Simulation ───────────────────────────────

  RxInt swapMealOptionsLoadingProgress = 0.obs;
  RxString swapMealOptionsLoadingMessage = ''.obs;
  Timer? _swapProgressTimer;
  bool _isSwapProgressRunning = false;

  static const List<String> _swapLoadingMessages = [
    'Finding meal alternatives...',
    'Matching your calorie target...',
    'Comparing nutritional values...',
    'Selecting the best options...',
    'Almost done...',
  ];

  void _startSwapProgressSimulation() {
    if (_isSwapProgressRunning) return;
    _isSwapProgressRunning = true;
    _swapProgressTimer?.cancel();
    swapMealOptionsLoadingProgress.value = 0;
    swapMealOptionsLoadingMessage.value = _swapLoadingMessages[0];

    _swapProgressTimer = Timer.periodic(const Duration(milliseconds: 575), (_) {
      if (swapMealOptionsLoadingProgress.value < 95) {
        swapMealOptionsLoadingProgress.value += 1;
        _updateSwapProgressMessage();
      }
    });
  }

  Future<void> _completeSwapProgress() async {
    if (!_isSwapProgressRunning) return;
    _isSwapProgressRunning = false;
    _swapProgressTimer?.cancel();
    _swapProgressTimer = null;
    swapMealOptionsLoadingMessage.value = 'Meal options ready!';

    // Animate smoothly from current position to 100%
    while (swapMealOptionsLoadingProgress.value < 100) {
      await Future.delayed(const Duration(milliseconds: 30));
      swapMealOptionsLoadingProgress.value += 1;
    }

    // Hold at 100% briefly so the user sees it
    await Future.delayed(const Duration(milliseconds: 400));
    swapMealOptionsLoadingProgress.value = 0;
  }

  void _updateSwapProgressMessage() {
    final p = swapMealOptionsLoadingProgress.value;
    if (p < 20) {
      swapMealOptionsLoadingMessage.value = _swapLoadingMessages[0];
    } else if (p < 40) {
      swapMealOptionsLoadingMessage.value = _swapLoadingMessages[1];
    } else if (p < 60) {
      swapMealOptionsLoadingMessage.value = _swapLoadingMessages[2];
    } else if (p < 80) {
      swapMealOptionsLoadingMessage.value = _swapLoadingMessages[3];
    } else {
      swapMealOptionsLoadingMessage.value = _swapLoadingMessages[4];
    }
  }

  // ─────────────────────────────────────────────────────────────────────────────

  Future<void> getSwapMealOptionsApi()async{
    try{
      isSwapMealOptionsLoading.value = true;
      clearSwapMealOptionsErrorMessage();
      _startSwapProgressSimulation();

      final response = await _swapMealOptionsRepository.swapMealOptionsRepository(category: categoryName.value, subCategory: subCategoryName.value, currentCallories: currentCallores.value);

      if(response.statusCode == 200 && response.isSuccess){
        LoggerUtils.debug("😇😇😇😇😇Swap Meal Options Retrieved Successfully!");

        swapMealOptionsModel.value = SwapMealOptionsModel.fromJson(response.jsonResponse!);

        final alternatives = swapMealOptionsModel.value?.data?.alternatives ?? [];
        LoggerUtils.debug("===== SWAP MEAL OPTIONS LIST =====");
        LoggerUtils.debug("Original Category    : ${swapMealOptionsModel.value?.data?.originalCategory}");
        LoggerUtils.debug("Original SubCategory : ${swapMealOptionsModel.value?.data?.originalSubCategory}");
        LoggerUtils.debug("Target Calories      : ${swapMealOptionsModel.value?.data?.targetCalories}");
        LoggerUtils.debug("Total alternatives   : ${alternatives.length}");
        alternatives.asMap().forEach((index, item) {
          LoggerUtils.debug("--- Alternative [$index] ---");
          LoggerUtils.debug("  mealName    : ${item.mealName}");
          LoggerUtils.debug("  description : ${item.description}");
          LoggerUtils.debug("  totalCal    : ${item.totalCalories}");
          LoggerUtils.debug("  category    : ${item.category} / ${item.subCategory}");
          LoggerUtils.debug("  image       : ${item.image}");
          LoggerUtils.debug("  ingredients : ${item.ingredients?.map((i) => i.name).toList()}");
          LoggerUtils.debug("  macros      : carbs=${item.macronutrients?.carbohydrates}, protein=${item.macronutrients?.protein}, fat=${item.macronutrients?.fat}");
        });
        LoggerUtils.debug("==================================");
      }else{
        LoggerUtils.error("😩😩😩😩😩Failed get Swap Meal Options!");
        LoggerUtils.error("😩😩😩😩😩Error Code :: ${response.statusCode} :: Error Message --> ${response.errorMessage.toString()}");
        swapMealOptionsErrorMessage.value = 'Unable to load meal options. Please try again.';
      }
      await _completeSwapProgress();

    }catch(error){

      LoggerUtils.error("😓😓😓😓😓😓Something Went Wrong while fetching the api!");
      LoggerUtils.error("😓😓😓😓😓😓Error Message : ${error.toString()}");
      swapMealOptionsErrorMessage.value = 'Unable to load meal options. Please try again.';
      await _completeSwapProgress();

    }finally{
      isSwapMealOptionsLoading.value = false;
    }
  }

  @override
  void onClose() {
    _swapProgressTimer?.cancel();
    super.onClose();
  }


  ///--------->>> Section : Swap Meal Options Api Ends Here

  @override
  void onInit() {
    getDailyCaloriesApi();
    getTodaysSelectedMealsApi();
    ///----------<>>>>> Section : Swap Meal Api Methods  needs to be added Here
    ///pathchSwapMealApi()
    super.onInit();
  }
}



