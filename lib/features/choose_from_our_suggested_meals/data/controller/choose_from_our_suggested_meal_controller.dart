import 'dart:convert';
import 'package:bloodfit/features/choose_from_our_suggested_meals/data/model/recent_chosen_meals_model.dart';
import 'package:bloodfit/helper/logger_util.dart';
import 'package:get/get.dart';

import '../model/ai_suggested_meals_job_id_model.dart';
import '../model/ai_suggested_meals_model.dart';
import '../repository/ai_suggested_meals_job_id_repository.dart';
import '../repository/ai_suggested_meals_repository.dart';
import '../repository/previously_selected_meals_repository.dart';

class ChooseFromOurSuggestedMealController extends GetxController {
  ///------->>> Section : Importing the Preselected Repository
  final PreviouslySelectedMealsRepository _previouslySelectedMealsRepository;

  ///-------<>>>> Section : Importing the AI Suggested Meals Job ID Repository
  final AiSuggestedMealsJobIdRepository _aiSuggestedMealsJobIdRepository;

  ///-------<>>>> Section : Importing the AI Suggested Meals Repository
  final AiSuggestedMealsRepository _aiSuggestedMealsRepository;

  ChooseFromOurSuggestedMealController(
    this._previouslySelectedMealsRepository,
    this._aiSuggestedMealsJobIdRepository,
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

  ///-------------->>> Section : AI Genereted Meals Api Method Starts Here
  ///-------------->>> Socket Is Used for getting the Response of the ai
  ///-------------->>> For Getting the AI Meals We have to go through two API Methods
  ///-------------->>> First Api Method Target is to get "JOB ID"
  ///-------------->>> Second Api Method Target is to using that "JOB ID" -> GET the AI Geanareted Meals
  RxList<String> tesList = <String>[].obs;
  
  ///-------Step 1------->>>> Api Method : Get Job ID
  Rxn<AiSuggestedMealsJobIdModel> jobIdModel = Rxn<AiSuggestedMealsJobIdModel>();
  RxString jobID = ''.obs;

  void setJobId({required String id}){
    jobID.value = id;
    LoggerUtils.debug("Received JOB ID : ${jobID.value}");
  }

  RxBool isJobIdValueLoading = false.obs;
  RxString jobIdErrorMessage = ''.obs;
  void clearJobIdErrorMessage(){
    jobIdErrorMessage.value = '';
  }


  Future<void> getAiSuggestedMealsJobIdApi()async{
    try{
      isJobIdValueLoading.value = true;
      clearAiSuggestedErrorMessage();

      final response = await _aiSuggestedMealsJobIdRepository.aiSuggestedMealsJobIdRepository();

      LoggerUtils.debug("Job ID Api Response ${response.jsonResponse}");

      if(response.statusCode == 200 && response.isSuccess){

        final aiSuggestedMealsData = AiSuggestedMealsJobIdModel.fromJson(response.jsonResponse!);

        LoggerUtils.debug("Ai Suggested Meals Job ID Fetched Successfully");

        setJobId(id: aiSuggestedMealsData.data?.jobId ?? '');



      }else{
        jobIdErrorMessage.value = response.errorMessage.toString();
        LoggerUtils.error("Failed to get Job Id from Job ID Api");
        LoggerUtils.error("Response Code : ${response.statusCode}");
        LoggerUtils.error("Error Message : ${jobIdErrorMessage.value}");
      }

    }catch(error){
      jobIdErrorMessage.value = error.toString();
      LoggerUtils.error("Error Catched While getting the JobID Value!");
      LoggerUtils.error("Catched Error : ${jobIdErrorMessage.value}");

    }finally{
      isJobIdValueLoading.value = false;
    }
  }



  ///-------Step 2------->>>> Api Method : Get Ai Genarated Meals Data
  Rxn<AiSuggestedMealsModel> aiGeneratedMealsData = Rxn<AiSuggestedMealsModel>();

  RxBool isAiGeneratedMealsValueLoading = false.obs;
  
  RxString aiGeneretedMealsDataErrorMessage = ''.obs;
  void clearAiGeneretedMealsDataErrorMessage(){
    aiGeneretedMealsDataErrorMessage.value = '';
  }

  Future<void> getAiSuggestedMels()async{
    try{
      isAiGeneratedMealsValueLoading.value = true;
      clearAiGeneretedMealsDataErrorMessage();


      final response = await _aiSuggestedMealsRepository.aiSuggestedMealsRepository(jobId: jobID.value);

      if(response.statusCode == 200 && response.isSuccess){

      }else{
        aiGeneretedMealsDataErrorMessage.value = response.errorMessage.toString();
        LoggerUtils.error("Failed to Get AI Genereted Meals Data!");
        LoggerUtils.error("Status Code : ${response.statusCode}");
        LoggerUtils.error("Error Message : ${aiGeneretedMealsDataErrorMessage.value}");
      }

    }catch(error){

      aiGeneretedMealsDataErrorMessage.value = error.toString();
      LoggerUtils.error("Catched Error While Getting the Ai Genereted Meals Data");
      LoggerUtils.error("Catched Error : ${aiGeneretedMealsDataErrorMessage.value}");


    }finally{
      isAiGeneratedMealsValueLoading.value = false;
    }
  }




  


  

  
  

  ///--------->>> Section : AI SUGGESTED Meals Api Method Ends Here


}
