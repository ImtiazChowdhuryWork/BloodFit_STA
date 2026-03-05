import 'dart:async';
import 'dart:convert';
import 'package:bloodfit/constants/app_constant_text.dart';
import 'package:bloodfit/features/choose_from_our_suggested_meals/data/model/recent_chosen_meals_model.dart';
import 'package:bloodfit/gen/colors.gen.dart';
import 'package:bloodfit/helper/di.dart';
import 'package:bloodfit/helper/logger_util.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../../../endpoints.dart';
import '../../../../networks/socket_services.dart';
import '../../../../routes/routes.dart';
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

  ///--------->>> Section : Meal Selection Tracking (One meal per tab)
  /// Track selected meal ID for each tab (only one meal can be selected per tab)
  RxString selectedBreakfastMealId = ''.obs;
  RxString selectedLunchMealId = ''.obs;
  RxString selectedDinnerMealId = ''.obs;
  
  /// Track selected meal data for display in tracker
  RxString selectedBreakfastMealName = ''.obs;
  RxString selectedLunchMealName = ''.obs;
  RxString selectedDinnerMealName = ''.obs;
  
  /// Get selected meal ID based on current tab
  String getSelectedMealIdForTab(String tabName) {
    if (tabName == 'breakfast') {
      return selectedBreakfastMealId.value;
    } else if (tabName == 'lunch') {
      return selectedLunchMealId.value;
    } else if (tabName == 'dinner') {
      return selectedDinnerMealId.value;
    }
    return '';
  }
  
  /// Set selected meal for a specific tab (automatically deselects previous selection)
  void setSelectedMeal({
    required String tabName,
    required String mealId,
    required String mealName,
  }) {
    LoggerUtils.debug("╔═══════════════════════════════════════════════════════════");
    LoggerUtils.debug("🎯 [SELECTION] setSelectedMeal CALLED");
    LoggerUtils.debug("🎯 [SELECTION] tabName: $tabName");
    LoggerUtils.debug("🎯 [SELECTION] mealId: $mealId");
    LoggerUtils.debug("🎯 [SELECTION] mealName: $mealName");
    LoggerUtils.debug("╚═══════════════════════════════════════════════════════════");
    
    String actionText = '';
    
    if (tabName == 'breakfast') {
      // If clicking the same meal, deselect it
      if (selectedBreakfastMealId.value == mealId) {
        LoggerUtils.debug("🎯 [SELECTION] Deselecting breakfast meal");
        selectedBreakfastMealId.value = '';
        selectedBreakfastMealName.value = '';
        actionText = 'Breakfast meal deselected';
      } else {
        LoggerUtils.debug("🎯 [SELECTION] Selecting new breakfast meal");
        selectedBreakfastMealId.value = mealId;
        selectedBreakfastMealName.value = mealName;
        actionText = 'Breakfast: $mealName';
      }
    } else if (tabName == 'lunch') {
      // If clicking the same meal, deselect it
      if (selectedLunchMealId.value == mealId) {
        LoggerUtils.debug("🎯 [SELECTION] Deselecting lunch meal");
        selectedLunchMealId.value = '';
        selectedLunchMealName.value = '';
        actionText = 'Lunch meal deselected';
      } else {
        LoggerUtils.debug("🎯 [SELECTION] Selecting new lunch meal");
        selectedLunchMealId.value = mealId;
        selectedLunchMealName.value = mealName;
        actionText = 'Lunch: $mealName';
      }
    } else if (tabName == 'dinner') {
      // If clicking the same meal, deselect it
      if (selectedDinnerMealId.value == mealId) {
        LoggerUtils.debug("🎯 [SELECTION] Deselecting dinner meal");
        selectedDinnerMealId.value = '';
        selectedDinnerMealName.value = '';
        actionText = 'Dinner meal deselected';
      } else {
        LoggerUtils.debug("🎯 [SELECTION] Selecting new dinner meal");
        selectedDinnerMealId.value = mealId;
        selectedDinnerMealName.value = mealName;
        actionText = 'Dinner: $mealName';
      }
    }
    
    LoggerUtils.debug("🎯 [SELECTION] Current selections - Breakfast: ${selectedBreakfastMealId.value}, Lunch: ${selectedLunchMealId.value}, Dinner: ${selectedDinnerMealId.value}");
    
    // Show snackbar notification
    _showSelectionSnackbar(actionText);
  }
  
  /// Show snackbar notification for meal selection
  void _showSelectionSnackbar(String actionText) {
    final selectedCount = getSelectedMealsCount();
    final isComplete = isMealPlanComplete;

    LoggerUtils.debug("╔═══════════════════════════════════════════════════════════");
    LoggerUtils.debug("📢 [SNACKBAR] _showSelectionSnackbar CALLED");
    LoggerUtils.debug("📢 [SNACKBAR] actionText: $actionText");
    LoggerUtils.debug("📢 [SNACKBAR] selectedCount: $selectedCount");
    LoggerUtils.debug("📢 [SNACKBAR] isComplete: $isComplete");
    LoggerUtils.debug("╚═══════════════════════════════════════════════════════════");

    // Use Get.overlayContext to show snackbar
    final overlayContext = Get.overlayContext;
    if (overlayContext == null) {
      LoggerUtils.error("❌ [SNACKBAR] overlayContext is null - cannot show snackbar");
      return;
    }

    if (isComplete) {
      // Show success snackbar that stays until user interacts
      LoggerUtils.debug("📢 [SNACKBAR] Showing COMPLETE snackbar");
      ScaffoldMessenger.of(overlayContext).showSnackBar(
        SnackBar(
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                '🎉 Meal Plan Complete!',
                style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 4),
              Text(
                'All 3 meals selected. Ready to build!',
                style: TextStyle(color: Colors.white.withOpacity(0.9), fontSize: 14),
              ),
            ],
          ),
          backgroundColor: AppColors.cb20000,
          duration: const Duration(seconds: 5),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          margin: const EdgeInsets.all(16),
          action: SnackBarAction(
            label: 'Build Now',
            textColor: Colors.white,
            onPressed: () {
              ScaffoldMessenger.of(overlayContext).hideCurrentSnackBar();
              Get.toNamed(Routes.reviewYourChoosenMealScreen);
            },
          ),
          dismissDirection: DismissDirection.down,
        ),
      );
    } else {
      // Show progress snackbar that auto-dismisses
      LoggerUtils.debug("📢 [SNACKBAR] Showing PROGRESS snackbar ($selectedCount/3)");
      ScaffoldMessenger.of(overlayContext).showSnackBar(
        SnackBar(
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Meal Selected',
                style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 4),
              Text(
                '$actionText ($selectedCount/3 meals selected)',
                style: TextStyle(color: Colors.white.withOpacity(0.9), fontSize: 14),
              ),
            ],
          ),
          backgroundColor: AppColors.c262626,
          duration: const Duration(seconds: 2),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          margin: const EdgeInsets.all(16),
          dismissDirection: DismissDirection.down,
        ),
      );
    }
  }
  
  /// Check if a meal is currently selected in a specific tab
  bool isMealSelected({
    required String tabName,
    required String mealId,
  }) {
    if (tabName == 'breakfast') {
      return selectedBreakfastMealId.value == mealId;
    } else if (tabName == 'lunch') {
      return selectedLunchMealId.value == mealId;
    } else if (tabName == 'dinner') {
      return selectedDinnerMealId.value == mealId;
    }
    return false;
  }
  
  /// Get count of selected meals (0-3, one per tab)
  int getSelectedMealsCount() {
    int count = 0;
    if (selectedBreakfastMealId.value.isNotEmpty) count++;
    if (selectedLunchMealId.value.isNotEmpty) count++;
    if (selectedDinnerMealId.value.isNotEmpty) count++;
    return count;
  }
  
  /// Check if meal plan is complete (all 3 meals selected)
  bool get isMealPlanComplete => getSelectedMealsCount() == 3;
  
  /// Get all selected meals
  Map<String, String> getSelectedMeals() {
    return {
      'breakfast': selectedBreakfastMealName.value,
      'lunch': selectedLunchMealName.value,
      'dinner': selectedDinnerMealName.value,
    };
  }
  
  /// Clear all selections
  void clearAllSelections() {
    selectedBreakfastMealId.value = '';
    selectedBreakfastMealName.value = '';
    selectedLunchMealId.value = '';
    selectedLunchMealName.value = '';
    selectedDinnerMealId.value = '';
    selectedDinnerMealName.value = '';
    LoggerUtils.debug("🎯 [SELECTION] All selections cleared");
  }

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

  // ///--------->>> Section : AI SUGGESTED Meals Api Method Start Here
  // ///
  // ///-------<>>>>> Section : Get The Selected Set
  // RxString selectedDate = ''.obs;
  // void setSelectedDate({required String date}){
  //   selectedDate.value = date;
  // }

  // /// Global loading state for UI
  // RxBool isAiSuggestedMealsLoading = false.obs;
  // RxString aiSuggestedMealsErrorMessage = ''.obs;

  // /// Per-meal-type loading flags to prevent duplicate API calls
  // RxBool isBreakfastAiMealsLoaded = false.obs;
  // RxBool isLunchAiMealsLoaded = false.obs;
  // RxBool isDinnerAiMealsLoaded = false.obs;

  // void clearAiSuggestedErrorMessage() {
  //   aiSuggestedMealsErrorMessage.value = '';
  // }

  // ///-------------->>> Section : AI Genereted Meals Api Method Starts Here
  // ///-------------->>> Socket Is Used for getting the Response of the ai
  // ///-------------->>> For Getting the AI Meals We have to go through two API Methods
  // ///-------------->>> First Api Method Target is to get "JOB ID"
  // ///-------------->>> Second Api Method Target is to using that "JOB ID" -> GET the AI Geanareted Meals
  // RxList<String> tesList = <String>[].obs;
  
//   ///-------Step 1------->>>> Api Method : Get Job ID
//   Rxn<AiSuggestedMealsJobIdModel> jobIdModel = Rxn<AiSuggestedMealsJobIdModel>();
//   RxString jobID = ''.obs;

//   void setJobId({required String id}){
//     jobID.value = id;
//     LoggerUtils.debug("Received JOB ID : ${jobID.value}");
//   }

//   RxBool isJobIdValueLoading = false.obs;
//   RxString jobIdErrorMessage = ''.obs;
//   void clearJobIdErrorMessage(){
//     jobIdErrorMessage.value = '';
//   }


//   Future<void> getAiSuggestedMealsJobIdApi()async{
//     try{
//       isJobIdValueLoading.value = true;
//       clearAiSuggestedErrorMessage();

//       final response = await _aiSuggestedMealsJobIdRepository.aiSuggestedMealsJobIdRepository();

//       LoggerUtils.debug("Job ID Api Response ${response.jsonResponse}");

//       if(response.statusCode == 200 && response.isSuccess){

//         final aiSuggestedMealsData = AiSuggestedMealsJobIdModel.fromJson(response.jsonResponse!);

//         LoggerUtils.debug("Ai Suggested Meals Job ID Fetched Successfully");

//         setJobId(id: aiSuggestedMealsData.data?.jobId ?? '');



//       }else{
//         jobIdErrorMessage.value = response.errorMessage.toString();
//         LoggerUtils.error("Failed to get Job Id from Job ID Api");
//         LoggerUtils.error("Response Code : ${response.statusCode}");
//         LoggerUtils.error("Error Message : ${jobIdErrorMessage.value}");
//       }

//     }catch(error){
//       jobIdErrorMessage.value = error.toString();
//       LoggerUtils.error("Error Catched While getting the JobID Value!");
//       LoggerUtils.error("Catched Error : ${jobIdErrorMessage.value}");

//     }finally{
//       isJobIdValueLoading.value = false;
//     }
//   }



//   ///-------Step 2------->>>> Api Method : Get Ai Genarated Meals Data using the jobId
//   Rxn<AiSuggestedMealsModel> aiGeneratedMealsData = Rxn<AiSuggestedMealsModel>();

//   RxBool isAiGeneratedMealsValueLoading = false.obs;
  
//   RxString aiGeneretedMealsDataErrorMessage = ''.obs;
//   void clearAiGeneretedMealsDataErrorMessage(){
//     aiGeneretedMealsDataErrorMessage.value = '';
//   }

//   Future<void> getAiSuggestedMels()async{
//     try{
//       isAiGeneratedMealsValueLoading.value = true;
//       clearAiGeneretedMealsDataErrorMessage();


//       final response = await _aiSuggestedMealsRepository.aiSuggestedMealsRepository(jobId: jobID.value);

//       if(response.statusCode == 200 && response.isSuccess){

//       }else{
//         aiGeneretedMealsDataErrorMessage.value = response.errorMessage.toString();
//         LoggerUtils.error("Failed to Get AI Genereted Meals Data!");
//         LoggerUtils.error("Status Code : ${response.statusCode}");
//         LoggerUtils.error("Error Message : ${aiGeneretedMealsDataErrorMessage.value}");
//       }

//     }catch(error){

//       aiGeneretedMealsDataErrorMessage.value = error.toString();
//       LoggerUtils.error("Catched Error While Getting the Ai Genereted Meals Data");
//       LoggerUtils.error("Catched Error : ${aiGeneretedMealsDataErrorMessage.value}");


//     }finally{
//       isAiGeneratedMealsValueLoading.value = false;
//     }
//   }




  
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

/// Track if initial AI meals load has been attempted
RxBool hasLoadedAiMealsInitially = false.obs;

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

/// Socket service instance
final SocketServices _socketServices = SocketServices();

/// Timer for polling fallback (in case socket doesn't respond)
Timer? _responseTimer;

///-------Step 1------->>>> Api Method : Get Job ID
Rxn<AiSuggestedMealsJobIdModel> jobIdModel = Rxn<AiSuggestedMealsJobIdModel>();
RxString jobID = ''.obs;

void setJobId({required String id}){
  jobID.value = id;
  LoggerUtils.debug("✅ Received JOB ID : ${jobID.value}");
  
  // After getting jobId, start listening for socket responses
  _listenForAiMealsResponse();
}

RxBool isJobIdValueLoading = false.obs;
RxString jobIdErrorMessage = ''.obs;

void clearJobIdErrorMessage(){
  jobIdErrorMessage.value = '';
}

Future<void> getAiSuggestedMealsJobIdApi() async {
  try {
    isJobIdValueLoading.value = true;
    isAiSuggestedMealsLoading.value = true;
    clearAiSuggestedErrorMessage();
    clearJobIdErrorMessage();

    final response = await _aiSuggestedMealsJobIdRepository
        .aiSuggestedMealsJobIdRepository();

    LoggerUtils.debug("📡 Job ID Api Response: ${response.jsonResponse}");

    if (response.statusCode == 200 && response.isSuccess) {
      final aiSuggestedMealsData =
          AiSuggestedMealsJobIdModel.fromJson(response.jsonResponse!);

      LoggerUtils.debug("✅ AI Suggested Meals Job ID Fetched Successfully");

      final jobId = aiSuggestedMealsData.data?.jobId ?? '';
      LoggerUtils.debug("🆔 Extracted jobId: '$jobId'");

      // Save jobId to local storage with today's date
      await _saveJobIdToLocal(jobId);

      // Set jobId IMMEDIATELY (before polling) so polling has valid jobId
      LoggerUtils.debug("🔄 Setting jobID.value = '$jobId' BEFORE polling...");
      jobID.value = jobId;
      LoggerUtils.debug("✅ jobID.value is now: '${jobID.value}'");

      // Initialize socket in background (don't wait)
      LoggerUtils.debug("🎧 Initializing socket in background...");
      _socketServices.init().then((_) {
        LoggerUtils.debug("🎧 Socket initialized, setting up listener for jobId: $jobId");
        _listenForAiMealsResponse();
        LoggerUtils.debug("🎧 Socket listener setup complete for jobId: $jobId");
      }).catchError((error) {
        LoggerUtils.error("❌ Socket initialization failed: $error");
      });

      // Poll immediately for meals (NOW jobId is set)
      LoggerUtils.debug("📡 Calling getAiSuggestedMealsViaPolling() with jobId: $jobId");
      LoggerUtils.debug("📡 Current jobID.value before polling: '${jobID.value}'");
      
      // CRITICAL: Ensure polling happens even if socket fails
      try {
        await getAiSuggestedMealsViaPolling();
        LoggerUtils.debug("📡 getAiSuggestedMealsViaPolling() COMPLETED successfully");
      } catch (pollingError) {
        LoggerUtils.error("❌ getAiSuggestedMealsViaPolling() FAILED: $pollingError");
        LoggerUtils.error("❌ Error type: ${pollingError.runtimeType}");
      }
      
      LoggerUtils.debug("📡 ✅ Polling flow completed");

    } else {
      jobIdErrorMessage.value = response.errorMessage.toString();
      LoggerUtils.error("❌ Failed to get Job Id from Job ID Api");
      LoggerUtils.error("Response Code : ${response.statusCode}");
      LoggerUtils.error("Error Message : ${jobIdErrorMessage.value}");

      // Reset loading states on error
      isAiSuggestedMealsLoading.value = false;
    }
  } catch (error) {
    jobIdErrorMessage.value = error.toString();
    LoggerUtils.error("💥 Error Catched While getting the JobID Value!");
    LoggerUtils.error("Catched Error : ${jobIdErrorMessage.value}");

    isAiSuggestedMealsLoading.value = false;
  } finally {
    isJobIdValueLoading.value = false;
  }
}

///-------Step 2------->>>> Socket Listener Method : Listen for AI Generated Meals Data
Rxn<AiSuggestedMealsModel> aiGeneratedMealsData = Rxn<AiSuggestedMealsModel>();

///---------------->>> BREAKFAST Categories
RxList<HealthyComforting> breakfastProteinPackedMeals = <HealthyComforting>[].obs;
RxList<HealthyComforting> breakfastLightAndFreshMeals = <HealthyComforting>[].obs;
RxList<HealthyComforting> breakfastHealthyAndComfortingMeals = <HealthyComforting>[].obs;


///---------------->>> LUNCH Categories
RxList<HealthyComforting> lunchProteinPackedMeals = <HealthyComforting>[].obs;
RxList<HealthyComforting> lunchLightAndFreshMeals = <HealthyComforting>[].obs;
RxList<HealthyComforting> lunchHealthyAndComfortingMeals = <HealthyComforting>[].obs;

///---------------->>> DINNER Categories
RxList<HealthyComforting> dinnerProteinPackedMeals = <HealthyComforting>[].obs;
RxList<HealthyComforting> dinnerLightAndFreshMeals = <HealthyComforting>[].obs;
RxList<HealthyComforting> dinnerHealthyAndComfortingMeals = <HealthyComforting>[].obs;

/// Flat lists for backward compatibility or general use
RxList<dynamic> breakfastAiGeneratedMeals = <dynamic>[].obs;
RxList<dynamic> lunchAiGeneratedMeals = <dynamic>[].obs;
RxList<dynamic> dinnerAiGeneratedMeals = <dynamic>[].obs;

RxBool isAiGeneratedMealsValueLoading = false.obs;
RxString aiGeneretedMealsDataErrorMessage = ''.obs;

void clearAiGeneretedMealsDataErrorMessage() {
  aiGeneretedMealsDataErrorMessage.value = '';
}

/// Listen for socket response for AI meals
void _listenForAiMealsResponse() {
  if (jobID.value.isEmpty) {
    LoggerUtils.error("❌ Cannot listen for socket response: Job ID is empty");
    return;
  }

  LoggerUtils.debug("🎧 Setting up socket listener for jobId: ${jobID.value}");

  // Clear any existing timer
  _responseTimer?.cancel();

  // Set a timeout for socket response (3 minutes)
  _responseTimer = Timer(const Duration(minutes: 3), () {
    LoggerUtils.error("⏰ Socket response timeout for jobId: ${jobID.value}");
    LoggerUtils.debug("🔄 Falling back to polling API...");
    
    // Fallback to polling API when socket times out
    getAiSuggestedMealsViaPolling();
  });

  // Listen for the specific event using jobId
  _socketServices.socket?.on('ai-meals-response-${jobID.value}', (data) {
    LoggerUtils.debug("📥 Received socket response for jobId: ${jobID.value}");
    LoggerUtils.debug("📦 Socket Data: $data");
    
    // Cancel the timeout timer since we received the response
    _responseTimer?.cancel();
    
    _processAiMealsResponse(data);
  });

  // Listen for error events
  _socketServices.socket?.on('ai-meals-error-${jobID.value}', (error) {
    _responseTimer?.cancel();
    LoggerUtils.error("❌ Socket error response: $error");
    aiGeneretedMealsDataErrorMessage.value = error.toString();
    isAiSuggestedMealsLoading.value = false;
    isAiGeneratedMealsValueLoading.value = false;
  });

  // Optional: Listen for progress updates if your backend supports it
  _socketServices.socket?.on('ai-meals-progress-${jobID.value}', (progress) {
    LoggerUtils.debug("📊 AI Meals Generation Progress: $progress");
    // You can update UI with progress if needed
  });
}

/// Process the AI meals response received via socket or polling
void _processAiMealsResponse(dynamic response) {
  LoggerUtils.debug("╔═══════════════════════════════════════════════════════════");
  LoggerUtils.debug("🔄 [PROCESS] _processAiMealsResponse() CALLED");
  LoggerUtils.debug("🔄 [PROCESS] Response type: ${response.runtimeType}");
  LoggerUtils.debug("🔄 [PROCESS] Response data: $response");
  LoggerUtils.debug("╚═══════════════════════════════════════════════════════════");

  try {
    LoggerUtils.debug("🔄 [PROCESS] Starting AI meals processing...");

    // Parse the response data
    LoggerUtils.debug("🔄 [PROCESS] Parsing response to AiSuggestedMealsModel...");
    final mealsData = AiSuggestedMealsModel.fromJson(response);
    LoggerUtils.debug("✅ [PROCESS] Response parsed successfully");
    LoggerUtils.debug("🔄 [PROCESS] mealsData.result: ${mealsData.result}");
    LoggerUtils.debug("🔄 [PROCESS] mealsData.result?.breakfastOptions: ${mealsData.result?.breakfastOptions}");

    // Store the full response
    LoggerUtils.debug("🔄 [PROCESS] Storing aiGeneratedMealsData...");
    aiGeneratedMealsData.value = mealsData;
    LoggerUtils.debug("✅ [PROCESS] aiGeneratedMealsData stored");

    ///------->>> Process BREAKFAST meals
    LoggerUtils.debug("🔄 [PROCESS] Processing BREAKFAST meals...");
    breakfastProteinPackedMeals.assignAll(
      mealsData.result?.breakfastOptions?.proteinPacked ?? []
    );
    breakfastLightAndFreshMeals.assignAll(
      mealsData.result?.breakfastOptions?.lightFresh ?? []
    );
    breakfastHealthyAndComfortingMeals.assignAll(
      mealsData.result?.breakfastOptions?.healthyComforting ?? []
    );
    LoggerUtils.debug("✅ [PROCESS] BREAKFAST meals processed:");
    LoggerUtils.debug("   • Protein Packed: ${breakfastProteinPackedMeals.length}");
    LoggerUtils.debug("   • Light & Fresh: ${breakfastLightAndFreshMeals.length}");
    LoggerUtils.debug("   • Healthy & Comforting: ${breakfastHealthyAndComfortingMeals.length}");

    ///-------->>> Process LUNCH meals
    LoggerUtils.debug("🔄 [PROCESS] Processing LUNCH meals...");
    lunchProteinPackedMeals.assignAll(
      mealsData.result?.lunchOptions?.proteinPacked ?? []
    );
    lunchLightAndFreshMeals.assignAll(
      mealsData.result?.lunchOptions?.lightFresh ?? []
    );
    lunchHealthyAndComfortingMeals.assignAll(
      mealsData.result?.lunchOptions?.healthyComforting ?? []
    );
    LoggerUtils.debug("✅ [PROCESS] LUNCH meals processed:");
    LoggerUtils.debug("   • Protein Packed: ${lunchProteinPackedMeals.length}");
    LoggerUtils.debug("   • Light & Fresh: ${lunchLightAndFreshMeals.length}");
    LoggerUtils.debug("   • Healthy & Comforting: ${lunchHealthyAndComfortingMeals.length}");

    ///-------->>> Process DINNER meals
    LoggerUtils.debug("🔄 [PROCESS] Processing DINNER meals...");
    dinnerProteinPackedMeals.assignAll(
      mealsData.result?.dinnerOptions?.proteinPacked ?? []
    );
    dinnerLightAndFreshMeals.assignAll(
      mealsData.result?.dinnerOptions?.lightFresh ?? []
    );
    dinnerHealthyAndComfortingMeals.assignAll(
      mealsData.result?.dinnerOptions?.healthyComforting ?? []
    );
    LoggerUtils.debug("✅ [PROCESS] DINNER meals processed:");
    LoggerUtils.debug("   • Protein Packed: ${dinnerProteinPackedMeals.length}");
    LoggerUtils.debug("   • Light & Fresh: ${dinnerLightAndFreshMeals.length}");
    LoggerUtils.debug("   • Healthy & Comforting: ${dinnerHealthyAndComfortingMeals.length}");

    // Also populate flat lists for backward compatibility
    LoggerUtils.debug("🔄 [PROCESS] Populating flat lists...");
    _populateFlatLists();
    LoggerUtils.debug("✅ [PROCESS] Flat lists populated");

    // Log the counts for verification
    _logMealCounts();

    // Update loading flags based on current tab
    LoggerUtils.debug("🔄 [PROCESS] Updating meal type loaded flags...");
    _updateMealTypeLoadedFlag();
    LoggerUtils.debug("✅ [PROCESS] Meal type loaded flags updated");

    LoggerUtils.debug("✅ [PROCESS] Meals populated successfully");
    LoggerUtils.debug("✅ [PROCESS] Loading state after processing: ${isAiSuggestedMealsLoading.value}");
    LoggerUtils.debug("╔═══════════════════════════════════════════════════════════");
    LoggerUtils.debug("✅ [PROCESS] _processAiMealsResponse() COMPLETED SUCCESSFULLY");
    LoggerUtils.debug("╚═══════════════════════════════════════════════════════════");

  } catch (e) {
    LoggerUtils.error("╔═══════════════════════════════════════════════════════════");
    LoggerUtils.error("❌ [PROCESS] Error processing AI meals response: $e");
    LoggerUtils.error("❌ [PROCESS] Error type: ${e.runtimeType}");
    LoggerUtils.error("╚═══════════════════════════════════════════════════════════");
    aiGeneretedMealsDataErrorMessage.value = "Failed to process meals data";
  } finally {
    // Reset loading states
    LoggerUtils.debug("🔓 [PROCESS] Finally block - resetting loading states");
    LoggerUtils.debug("🔓 [PROCESS] Current isAiSuggestedMealsLoading: ${isAiSuggestedMealsLoading.value}");
    LoggerUtils.debug("🔓 [PROCESS] Current isAiGeneratedMealsValueLoading: ${isAiGeneratedMealsValueLoading.value}");
    isAiSuggestedMealsLoading.value = false;
    isAiGeneratedMealsValueLoading.value = false;
    LoggerUtils.debug("🔓 [PROCESS] Loading states reset to FALSE");
    LoggerUtils.debug("🔓 [PROCESS] New isAiSuggestedMealsLoading: ${isAiSuggestedMealsLoading.value}");
    LoggerUtils.debug("🔓 [PROCESS] New isAiGeneratedMealsValueLoading: ${isAiGeneratedMealsValueLoading.value}");
  }
}

///------->>> Section : Three Tabs Meals Images
String get breakFastMealImage => aiGeneratedMealsData.value?.result?.breakfastImage ?? '';
String get lunchMealImage => aiGeneratedMealsData.value?.result?.lunchImage ?? '';
String get dinnerMealImage => aiGeneratedMealsData.value?.result?.dinnerImage ?? '';

/// Populate flat lists for backward compatibility
void _populateFlatLists() {
  breakfastAiGeneratedMeals.clear();
  breakfastAiGeneratedMeals.addAll(breakfastProteinPackedMeals);
  breakfastAiGeneratedMeals.addAll(breakfastLightAndFreshMeals);
  breakfastAiGeneratedMeals.addAll(breakfastHealthyAndComfortingMeals);
  
  lunchAiGeneratedMeals.clear();
  lunchAiGeneratedMeals.addAll(lunchProteinPackedMeals);
  lunchAiGeneratedMeals.addAll(lunchLightAndFreshMeals);
  lunchAiGeneratedMeals.addAll(lunchHealthyAndComfortingMeals);
  
  dinnerAiGeneratedMeals.clear();
  dinnerAiGeneratedMeals.addAll(dinnerProteinPackedMeals);
  dinnerAiGeneratedMeals.addAll(dinnerLightAndFreshMeals);
  dinnerAiGeneratedMeals.addAll(dinnerHealthyAndComfortingMeals);
}

/// Log meal counts for debugging
void _logMealCounts() {
  LoggerUtils.debug("📊 AI Meals Summary:");
  LoggerUtils.debug("🍳 BREAKFAST:");
  LoggerUtils.debug("   • Protein Packed: ${breakfastProteinPackedMeals.length}");
  LoggerUtils.debug("   • Light & Fresh: ${breakfastLightAndFreshMeals.length}");
  LoggerUtils.debug("   • Healthy & Comforting: ${breakfastHealthyAndComfortingMeals.length}");
  
  LoggerUtils.debug("🍱 LUNCH:");
  LoggerUtils.debug("   • Protein Packed: ${lunchProteinPackedMeals.length}");
  LoggerUtils.debug("   • Light & Fresh: ${lunchLightAndFreshMeals.length}");
  LoggerUtils.debug("   • Healthy & Comforting: ${lunchHealthyAndComfortingMeals.length}");
  
  LoggerUtils.debug("🍽️ DINNER:");
  LoggerUtils.debug("   • Protein Packed: ${dinnerProteinPackedMeals.length}");
  LoggerUtils.debug("   • Light & Fresh: ${dinnerLightAndFreshMeals.length}");
  LoggerUtils.debug("   • Healthy & Comforting: ${dinnerHealthyAndComfortingMeals.length}");
}

/// Get meals for current tab based on category
List<dynamic> getMealsForCurrentTab({required String category}) {
  final currentTab = selectedTabName.value;
  
  switch (currentTab) {
    case 'breakfast':
      return _getBreakfastMealsByCategory(category);
    case 'lunch':
      return _getLunchMealsByCategory(category);
    case 'dinner':
      return _getDinnerMealsByCategory(category);
    default:
      return [];
  }
}

/// Get breakfast meals by category
List<dynamic> _getBreakfastMealsByCategory(String category) {
  switch (category.toLowerCase()) {
    case 'proteinpacked':
    case 'protein_packed':
      return breakfastProteinPackedMeals;
    case 'lightfresh':
    case 'light_fresh':
      return breakfastLightAndFreshMeals;
    case 'healthycomforting':
    case 'healthy_comforting':
      return breakfastHealthyAndComfortingMeals;
    default:
      return breakfastAiGeneratedMeals;
  }
}

/// Get lunch meals by category
List<dynamic> _getLunchMealsByCategory(String category) {
  switch (category.toLowerCase()) {
    case 'proteinpacked':
    case 'protein_packed':
      return lunchProteinPackedMeals;
    case 'lightfresh':
    case 'light_fresh':
      return lunchLightAndFreshMeals;
    case 'healthycomforting':
    case 'healthy_comforting':
      return lunchHealthyAndComfortingMeals;
    default:
      return lunchAiGeneratedMeals;
  }
}

/// Get dinner meals by category
List<dynamic> _getDinnerMealsByCategory(String category) {
  switch (category.toLowerCase()) {
    case 'proteinpacked':
    case 'protein_packed':
      return dinnerProteinPackedMeals;
    case 'lightfresh':
    case 'light_fresh':
      return dinnerLightAndFreshMeals;
    case 'healthycomforting':
    case 'healthy_comforting':
      return dinnerHealthyAndComfortingMeals;
    default:
      return dinnerAiGeneratedMeals;
  }
}

/// Check if a specific category has meals
bool hasMealsInCategory({required String category}) {
  return getMealsForCurrentTab(category: category).isNotEmpty;
}

/// Get total count of meals for current tab
int getTotalMealsCountForCurrentTab() {
  final currentTab = selectedTabName.value;
  
  switch (currentTab) {
    case 'breakfast':
      return breakfastProteinPackedMeals.length +
             breakfastLightAndFreshMeals.length +
             breakfastHealthyAndComfortingMeals.length;
    case 'lunch':
      return lunchProteinPackedMeals.length +
             lunchLightAndFreshMeals.length +
             lunchHealthyAndComfortingMeals.length;
    case 'dinner':
      return dinnerProteinPackedMeals.length +
             dinnerLightAndFreshMeals.length +
             dinnerHealthyAndComfortingMeals.length;
    default:
      return 0;
  }
}

/// Update the meal type loaded flag based on current tab
void _updateMealTypeLoadedFlag() {
  final currentTab = selectedTabName.value;
  
  if (currentTab == 'breakfast') {
    isBreakfastAiMealsLoaded.value = getTotalMealsCountForCurrentTab() > 0;
  } else if (currentTab == 'lunch') {
    isLunchAiMealsLoaded.value = getTotalMealsCountForCurrentTab() > 0;
  } else if (currentTab == 'dinner') {
    isDinnerAiMealsLoaded.value = getTotalMealsCountForCurrentTab() > 0;
  }
}

/// Alternative fallback method: Polling API (if socket fails)
Future<void> getAiSuggestedMealsViaPolling() async {
  LoggerUtils.debug("╔═══════════════════════════════════════════════════════════");
  LoggerUtils.debug("📡 [POLLING] getAiSuggestedMealsViaPolling() CALLED");
  LoggerUtils.debug("📡 [POLLING] Current jobId: '${jobID.value}'");
  LoggerUtils.debug("📡 [POLLING] Current loading state: ${isAiSuggestedMealsLoading.value}");
  LoggerUtils.debug("╚═══════════════════════════════════════════════════════════");

  try {
    isAiGeneratedMealsValueLoading.value = true;
    clearAiGeneretedMealsDataErrorMessage();

    LoggerUtils.debug("📡 [POLLING] Calling API...");
    LoggerUtils.debug("📡 [POLLING] Endpoint: ${Endpoints.aiSuggestedMealsData(jobID: jobID.value)}");

    final response = await _aiSuggestedMealsRepository
        .aiSuggestedMealsRepository(jobId: jobID.value);

    LoggerUtils.debug("📡 [POLLING] API response received: statusCode=${response.statusCode}");
    LoggerUtils.debug("📡 [POLLING] isSuccess: ${response.isSuccess}");
    LoggerUtils.debug("📡 [POLLING] errorMessage: ${response.errorMessage}");
    LoggerUtils.debug("📡 [POLLING] Response data length: ${response.jsonResponse.toString().length}");

    // CRITICAL: Check both conditions explicitly
    final isStatusOk = response.statusCode == 200;
    final isSuccessful = response.isSuccess == true;
    
    LoggerUtils.debug("📡 [POLLING] isStatusOk (200): $isStatusOk");
    LoggerUtils.debug("📡 [POLLING] isSuccessful: $isSuccessful");
    LoggerUtils.debug("📡 [POLLING] Both conditions met: ${isStatusOk && isSuccessful}");

    if (isStatusOk && isSuccessful) {
      LoggerUtils.debug("✅ [POLLING] AI Meals fetched via polling successfully");
      LoggerUtils.debug("🔄 [POLLING] Calling _processAiMealsResponse() with data...");
      
      try {
        _processAiMealsResponse(response.jsonResponse!);
        LoggerUtils.debug("✅ [POLLING] _processAiMealsResponse() COMPLETED");
      } catch (processError) {
        LoggerUtils.error("❌ [POLLING] _processAiMealsResponse() threw error: $processError");
        LoggerUtils.error("❌ [POLLING] Error type: ${processError.runtimeType}");
        // Continue to reset loading states even if processing fails
      }

      // Reset loading states on success
      LoggerUtils.debug("🔓 [POLLING] Resetting loading states to FALSE");
      isAiSuggestedMealsLoading.value = false;
      isAiGeneratedMealsValueLoading.value = false;
      LoggerUtils.debug("✅ [POLLING] Loading states RESET to FALSE");
      LoggerUtils.debug("╔═══════════════════════════════════════════════════════════");
      LoggerUtils.debug("✅ [POLLING] getAiSuggestedMealsViaPolling() COMPLETED SUCCESSFULLY");
      LoggerUtils.debug("╚═══════════════════════════════════════════════════════════");
    } else {
      LoggerUtils.error("╔═══════════════════════════════════════════════════════════");
      LoggerUtils.error("❌ [POLLING] Failed to Get AI Generated Meals Data via polling!");
      LoggerUtils.error("❌ [POLLING] Status Code : ${response.statusCode}");
      LoggerUtils.error("❌ [POLLING] isSuccess : ${response.isSuccess}");
      LoggerUtils.error("❌ [POLLING] Error Message : ${response.errorMessage}");
      LoggerUtils.error("╚═══════════════════════════════════════════════════════════");
      aiGeneretedMealsDataErrorMessage.value = response.errorMessage.toString();

      LoggerUtils.debug("🔓 [POLLING] Resetting loading states to FALSE (on error)");
      isAiSuggestedMealsLoading.value = false;
      isAiGeneratedMealsValueLoading.value = false;
    }
  } catch (error) {
    LoggerUtils.error("╔═══════════════════════════════════════════════════════════");
    LoggerUtils.error("💥 [POLLING] Caught Error While Getting AI Generated Meals Data");
    LoggerUtils.error("💥 [POLLING] Error type: ${error.runtimeType}");
    LoggerUtils.error("💥 [POLLING] Error: $error");
    LoggerUtils.error("╚═══════════════════════════════════════════════════════════");
    aiGeneretedMealsDataErrorMessage.value = error.toString();

    LoggerUtils.debug("🔓 [POLLING] Resetting loading states to FALSE (on exception)");
    isAiSuggestedMealsLoading.value = false;
    isAiGeneratedMealsValueLoading.value = false;
  }
}

// ///--------->>> Section : Local Storage Methods for JobId Caching

/// Get current date in YYYY-MM-DD format
String _getCurrentDate() {
  final now = DateTime.now();
  return DateFormat('yyyy-MM-dd').format(now);
}

/// Save jobId to local storage with today's date
Future<void> _saveJobIdToLocal(String jobId) async {
  try {
    final today = _getCurrentDate();
    final data = {
      'jobId': jobId,
      'date': today,
    };

    await appData.write(kKeyJobIdForAiGeneretedMeals, data);

    LoggerUtils.debug("╔═══════════════════════════════════════════════════════════");
    LoggerUtils.debug("💾 [STORAGE] Saving jobId to local storage");
    LoggerUtils.debug("💾 [STORAGE] jobId: $jobId");
    LoggerUtils.debug("💾 [STORAGE] date: $today");
    LoggerUtils.debug("╚═══════════════════════════════════════════════════════════");
  } catch (error) {
    LoggerUtils.error("╔═══════════════════════════════════════════════════════════");
    LoggerUtils.error("❌ [STORAGE] Error saving jobId to local storage: $error");
    LoggerUtils.error("╚═══════════════════════════════════════════════════════════");
  }
}

/// Load jobId from local storage (only valid if from today)
Future<String?> _loadJobIdFromLocal() async {
  LoggerUtils.debug("╔═══════════════════════════════════════════════════════════");
  LoggerUtils.debug("📥 [STORAGE] Loading jobId from local storage...");
  
  try {
    final storedData = appData.read(kKeyJobIdForAiGeneretedMeals);

    if (storedData == null) {
      LoggerUtils.debug("📥 [STORAGE] No stored jobId found in local storage");
      LoggerUtils.debug("╚═══════════════════════════════════════════════════════════");
      return null;
    }

    if (storedData is Map<String, dynamic>) {
      final storedDate = storedData['date'] as String?;
      final storedJobId = storedData['jobId'] as String?;
      final today = _getCurrentDate();

      LoggerUtils.debug("📥 [STORAGE] Found stored data:");
      LoggerUtils.debug("📥 [STORAGE]   • storedJobId: '$storedJobId'");
      LoggerUtils.debug("📥 [STORAGE]   • storedDate: '$storedDate'");
      LoggerUtils.debug("📥 [STORAGE]   • today: '$today'");

      if (storedDate == today) {
        LoggerUtils.debug("📥 [STORAGE] ✅ Date matches today! Using stored jobId");
        LoggerUtils.debug("╚═══════════════════════════════════════════════════════════");
        return storedJobId;
      } else {
        LoggerUtils.debug("📥 [STORAGE] ❌ Date mismatch! storedDate != today");
        LoggerUtils.debug("🗑️ [STORAGE] Clearing old stored jobId...");
        await _clearStoredJobId();
        LoggerUtils.debug("╚═══════════════════════════════════════════════════════════");
        return null;
      }
    }

    LoggerUtils.debug("📥 [STORAGE] ❌ Invalid stored data format");
    LoggerUtils.debug("╚═══════════════════════════════════════════════════════════");
    return null;
  } catch (error) {
    LoggerUtils.error("╔═══════════════════════════════════════════════════════════");
    LoggerUtils.error("❌ [STORAGE] Error loading jobId from local storage: $error");
    LoggerUtils.error("╚═══════════════════════════════════════════════════════════");
    return null;
  }
}

/// Clear stored jobId from local storage
Future<void> _clearStoredJobId() async {
  try {
    await appData.write(kKeyJobIdForAiGeneretedMeals, null);
    LoggerUtils.debug("🧹 [STORAGE] Cleared stored jobId from local storage");
  } catch (error) {
    LoggerUtils.error("❌ [STORAGE] Error clearing stored jobId: $error");
  }
}

/// Initialize AI meals - check for existing jobId or fetch new one
Future<void> initializeAiMeals() async {
  LoggerUtils.debug("╔═══════════════════════════════════════════════════════════");
  LoggerUtils.debug("🎯 [CONTROLLER] initializeAiMeals() CALLED");
  LoggerUtils.debug("🎯 [CONTROLLER] Current loading state: ${isAiSuggestedMealsLoading.value}");
  LoggerUtils.debug("🎯 [CONTROLLER] Current jobId: '${jobID.value}'");
  LoggerUtils.debug("╚═══════════════════════════════════════════════════════════");

  // Set loading IMMEDIATELY - before any checks
  isAiSuggestedMealsLoading.value = true;
  LoggerUtils.debug("🎯 [CONTROLLER] Loading state SET to TRUE");
  clearAiSuggestedErrorMessage();

  try {
    // Check if meals already exist in memory - if yes, no need to reload
    final hasMealsInMemory = breakfastProteinPackedMeals.isNotEmpty ||
                            lunchProteinPackedMeals.isNotEmpty ||
                            dinnerProteinPackedMeals.isNotEmpty;

    LoggerUtils.debug("🎯 [CONTROLLER] hasMealsInMemory=$hasMealsInMemory");
    LoggerUtils.debug("🎯 [CONTROLLER] Breakfast meals: ${breakfastProteinPackedMeals.length + breakfastLightAndFreshMeals.length + breakfastHealthyAndComfortingMeals.length}");
    LoggerUtils.debug("🎯 [CONTROLLER] Lunch meals: ${lunchProteinPackedMeals.length + lunchLightAndFreshMeals.length + lunchHealthyAndComfortingMeals.length}");
    LoggerUtils.debug("🎯 [CONTROLLER] Dinner meals: ${dinnerProteinPackedMeals.length + dinnerLightAndFreshMeals.length + dinnerHealthyAndComfortingMeals.length}");

    if (hasMealsInMemory) {
      LoggerUtils.debug("✅ [CONTROLLER] Meals already in memory, skipping initialization");
      LoggerUtils.debug("🎯 [CONTROLLER] Resetting loading state to FALSE");
      isAiSuggestedMealsLoading.value = false;
      return;
    }

    // No meals in memory, proceed with initialization
    LoggerUtils.debug("🔄 [CONTROLLER] Initializing AI meals (no meals in memory)...");
    LoggerUtils.debug("🔄 [CONTROLLER] Loading jobId from local storage...");

    // Check for existing jobId from today
    final existingJobId = await _loadJobIdFromLocal();
    LoggerUtils.debug("🎯 [CONTROLLER] existingJobId from local storage: '${existingJobId ?? 'NULL'}'");

    if (existingJobId != null && existingJobId.isNotEmpty) {
      // Valid jobId exists from today - Set jobId FIRST, then POLL
      LoggerUtils.debug("╔═══════════════════════════════════════════════════════════");
      LoggerUtils.debug("🔄 [CONTROLLER] ✅ Valid jobId found in local storage");
      LoggerUtils.debug("🔄 [CONTROLLER] Using existing jobId: $existingJobId");
      LoggerUtils.debug("╚═══════════════════════════════════════════════════════════");
      
      // Set jobId BEFORE polling (so API call has valid jobId)
      LoggerUtils.debug("🔄 [CONTROLLER] Setting jobID.value = $existingJobId");
      jobID.value = existingJobId;
      LoggerUtils.debug("🔄 [CONTROLLER] jobID.value is now: '${jobID.value}'");
      
      // Poll immediately for meals
      LoggerUtils.debug("📡 [CONTROLLER] Calling getAiSuggestedMealsViaPolling()...");
      await getAiSuggestedMealsViaPolling();
      LoggerUtils.debug("📡 [CONTROLLER] getAiSuggestedMealsViaPolling() COMPLETED");

      // Setup socket listener in background for real-time updates (if any)
      LoggerUtils.debug("🎧 [CONTROLLER] Setting up socket listener in background...");
      _socketServices.init().then((_) {
        LoggerUtils.debug("🎧 [CONTROLLER] Socket initialized successfully");
        LoggerUtils.debug("🎧 [CONTROLLER] Socket listener setup in background for jobId: $existingJobId");
      }).catchError((error) {
        LoggerUtils.error("❌ [CONTROLLER] Socket initialization failed: $error");
      });
    } else {
      // No valid jobId, fetch new one
      LoggerUtils.debug("╔═══════════════════════════════════════════════════════════");
      LoggerUtils.debug("🆕 [CONTROLLER] ❌ No valid jobId found in local storage");
      LoggerUtils.debug("🆕 [CONTROLLER] Fetching new jobId via API...");
      LoggerUtils.debug("╚═══════════════════════════════════════════════════════════");
      await getAiSuggestedMealsJobIdApi();
      LoggerUtils.debug("🆕 [CONTROLLER] getAiSuggestedMealsJobIdApi() COMPLETED");
    }
  } catch (error) {
    LoggerUtils.error("╔═══════════════════════════════════════════════════════════");
    LoggerUtils.error("❌ [CONTROLLER] Failed to initialize AI meals: $error");
    LoggerUtils.error("❌ [CONTROLLER] Error type: ${error.runtimeType}");
    LoggerUtils.error("╚═══════════════════════════════════════════════════════════");
    aiSuggestedMealsErrorMessage.value = "Failed to initialize: $error";
    isAiSuggestedMealsLoading.value = false;
    hasLoadedAiMealsInitially.value = true; // Mark as attempted even on error
  } finally {
    // Mark that initial load has been attempted
    hasLoadedAiMealsInitially.value = true;
    LoggerUtils.debug("✅ [CONTROLLER] Initial AI meals load attempt completed");
  }
  
  // Reset loading state at the end
  isAiSuggestedMealsLoading.value = false;
  LoggerUtils.debug("🎯 [CONTROLLER] Resetting loading state to FALSE");
}

/// Clean up socket listeners when controller is closed
@override
void onClose() {
  LoggerUtils.debug("👋👋👋 ChooseFromOurSuggestedMealController closed");

  // Cancel any active timer
  _responseTimer?.cancel();

  // Remove socket listeners to prevent memory leaks
  if (jobID.value.isNotEmpty) {
    _socketServices.socket?.off('ai-meals-response-${jobID.value}');
    _socketServices.socket?.off('ai-meals-error-${jobID.value}');
    _socketServices.socket?.off('ai-meals-progress-${jobID.value}');
  }

  // Optional: Disconnect socket if no other controllers are using it
  // _socketServices.disconnect();
  
  // DO NOT clear stored jobId from local storage - it should persist for the day

  super.onClose();
}

///--------->>> Section : AI SUGGESTED Meals Api Method Ends Here

  

  
 
}



