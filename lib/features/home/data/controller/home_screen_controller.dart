import 'package:bloodfit/constants/app_enums.dart';
import 'package:bloodfit/features/home/data/repository/get_todays_meal_repository.dart';
import 'package:bloodfit/gen/colors.gen.dart';
import 'package:bloodfit/helper/logger_util.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../controllers/enums_controller.dart';
import '../../../your_daily_calories_intake/data/model/get_calorie_requirements_model.dart';

import '../model/get_todays_meal_model.dart';
import '../repository/daily_calories_api_repository.dart';

class HomeScreenController extends GetxController {
  ///--------->>> Section : Importing the Repositories
  DailyCaloriesApiRepository _dailyCaloriesApiRepository;
  GetTodaysMealRepository _getTodaysMealRepository;

  ///----------->>> Section : Importing the Model
  Rxn<GetCalorieRequirementsModel> model = Rxn<GetCalorieRequirementsModel>();

  HomeScreenController(this._dailyCaloriesApiRepository,this._getTodaysMealRepository);

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

///----------------->>> Is Your Daily Calories Api Section Ends Here





  ///-------->>> Section : Todays Selected Meals Api Starts Here
  final EnumsController enumsController = Get.find<EnumsController>();
  RxBool isTodaysSelectedMealsLoading = false.obs;
  RxBool selectedMealPlanAvailable = false.obs;
  RxString todaysSelectedMealsErrorMessage = ''.obs;
  void clearTodaysSelectedErrorMessage(){
    todaysSelectedMealsErrorMessage.value = '';
  }

  void setSelectedMealPlanAvailableStatusToTrue(){
    selectedMealPlanAvailable.value = true;
  }

  Rxn<GetTodaysMealModel> todaysMealModel = Rxn<GetTodaysMealModel>();

  Future<void> getTodaysSelectedMealsApi()async{
    isTodaysSelectedMealsLoading.value = true;
    clearTodaysSelectedErrorMessage();
    final response = await _getTodaysMealRepository.getTodaysMealRepository();

    LoggerUtils.debug("API --->>> Todays Selected Meals Api <<<----- Response ----->>> ${response.jsonResponse}");

    LoggerUtils.debug("😇😇....Get Todays Meas Api Started!");
    try{

      

      if(response.statusCode == 200 && response.isSuccess){
        setSelectedMealPlanAvailableStatusToTrue();
        LoggerUtils.debug("Meals Plan Status : ${enumsController.setMealPlanAvailable()}");
        LoggerUtils.debug("🤓🤓....Todays Selected Meals Fetched From Server Successfully!");
        todaysMealModel.value = GetTodaysMealModel.fromJson(response.jsonResponse!);


        var data = todaysMealModel.value?.data;

        itemBreakFast.value = data?.breakfast ;
        itemLunch.value = data?.lunch;
        itemDinner.value = data?.dinner;
      }else{
        todaysSelectedMealsErrorMessage.value = response.errorMessage.toString();
        LoggerUtils.error("Something Went Wrong While Fetching the ---->>> Todays Selected Meals <<<-----API!");
        LoggerUtils.error("Status Code : ${response.statusCode}");
        
        LoggerUtils.error("Status Code : $todaysSelectedMealsErrorMessage");
      }

    }catch(error){
      todaysSelectedMealsErrorMessage.value = response.errorMessage.toString();
      LoggerUtils.error("Error Catched On ---->>> Todays Selected Meals Api <<<-----: ");
      LoggerUtils.debug("Error Found! Status Code : ${response.statusCode}");
      LoggerUtils.debug("Catched Error : $todaysSelectedMealsErrorMessage");
      
    }finally{
      isTodaysSelectedMealsLoading.value = false;
    }
  }


  Rxn<MealsDataModel> itemBreakFast = Rxn<MealsDataModel>();
  Rxn<MealsDataModel> itemLunch = Rxn<MealsDataModel>();
  Rxn<MealsDataModel> itemDinner = Rxn<MealsDataModel>();


  
  
  ///-------->>> Section : Todays Selected Meals Api Ends Here
  





  @override
  void onInit() {
    getDailyCaloriesApi();
    getTodaysSelectedMealsApi();
    super.onInit();
  }
}
