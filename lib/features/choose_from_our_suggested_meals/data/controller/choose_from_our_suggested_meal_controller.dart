import 'dart:async';
import 'dart:convert';
import 'package:bloodfit/constants/app_constant_text.dart';
import 'package:bloodfit/features/choose_from_our_suggested_meals/data/model/recent_chosen_meals_model.dart';
import 'package:bloodfit/helper/di.dart';
import 'package:bloodfit/helper/logger_util.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../../../networks/socket_services.dart';
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
      
      // Save jobId to local storage with today's date
      await _saveJobIdToLocal(jobId);

      // Initialize socket in background (don't wait)
      _socketServices.init().then((_) {
        setJobId(id: jobId);
        LoggerUtils.debug("🎧 Socket listener setup in background for jobId: $jobId");
      });
      
      // Poll immediately for meals (don't wait for socket)
      LoggerUtils.debug("📡 Polling API immediately for new jobId: $jobId");
      await getAiSuggestedMealsViaPolling();

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

/// Process the AI meals response received via socket
void _processAiMealsResponse(dynamic response) {
  LoggerUtils.debug("🔄 [PROCESS] _processAiMealsResponse() CALLED");
  LoggerUtils.debug("🔄 [PROCESS] Current loading state before processing: ${isAiSuggestedMealsLoading.value}");
  
  try {
    LoggerUtils.debug("🔄 [PROCESS] Processing AI meals response...");

    // Parse the response data
    final mealsData = AiSuggestedMealsModel.fromJson(response);

    // Store the full response
    aiGeneratedMealsData.value = mealsData;

    ///------->>> Process BREAKFAST meals
    breakfastProteinPackedMeals.assignAll(
      mealsData.result?.breakfastOptions?.proteinPacked ?? []
    );
    breakfastLightAndFreshMeals.assignAll(
      mealsData.result?.breakfastOptions?.lightFresh ?? []
    );
    breakfastHealthyAndComfortingMeals.assignAll(
      mealsData.result?.breakfastOptions?.healthyComforting ?? []
    );

    ///-------->>> Process LUNCH meals
    lunchProteinPackedMeals.assignAll(
      mealsData.result?.lunchOptions?.proteinPacked ?? []
    );
    lunchLightAndFreshMeals.assignAll(
      mealsData.result?.lunchOptions?.lightFresh ?? []
    );
    lunchHealthyAndComfortingMeals.assignAll(
      mealsData.result?.lunchOptions?.healthyComforting ?? []
    );

    ///-------->>> Process DINNER meals
    dinnerProteinPackedMeals.assignAll(
      mealsData.result?.dinnerOptions?.proteinPacked ?? []
    );
    dinnerLightAndFreshMeals.assignAll(
      mealsData.result?.dinnerOptions?.lightFresh ?? []
    );
    dinnerHealthyAndComfortingMeals.assignAll(
      mealsData.result?.dinnerOptions?.healthyComforting ?? []
    );

    // Also populate flat lists for backward compatibility
    _populateFlatLists();

    // Log the counts for verification
    _logMealCounts();

    // Update loading flags based on current tab
    _updateMealTypeLoadedFlag();

    LoggerUtils.debug("✅ [PROCESS] Meals populated successfully");
    LoggerUtils.debug("✅ [PROCESS] Loading state after processing: ${isAiSuggestedMealsLoading.value}");

  } catch (e) {
    LoggerUtils.error("❌ [PROCESS] Error processing AI meals response: $e");
    aiGeneretedMealsDataErrorMessage.value = "Failed to process meals data";
  } finally {
    // Reset loading states
    LoggerUtils.debug("🔓 [PROCESS] Finally block - resetting loading states");
    isAiSuggestedMealsLoading.value = false;
    isAiGeneratedMealsValueLoading.value = false;
    LoggerUtils.debug("🔓 [PROCESS] Loading states reset to FALSE");
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
  LoggerUtils.debug("📡 [POLLING] getAiSuggestedMealsViaPolling() CALLED");
  LoggerUtils.debug("📡 [POLLING] Current jobId: ${jobID.value}");
  LoggerUtils.debug("📡 [POLLING] Current loading state: ${isAiSuggestedMealsLoading.value}");
  
  try {
    isAiGeneratedMealsValueLoading.value = true;
    clearAiGeneretedMealsDataErrorMessage();

    LoggerUtils.debug("📡 [POLLING] Calling API...");

    final response = await _aiSuggestedMealsRepository
        .aiSuggestedMealsRepository(jobId: jobID.value);

    LoggerUtils.debug("📡 [POLLING] API response received: statusCode=${response.statusCode}");

    if (response.statusCode == 200 && response.isSuccess) {
      LoggerUtils.debug("✅ [POLLING] AI Meals fetched via polling successfully");
      _processAiMealsResponse(response.jsonResponse!);
      
      // Reset loading states on success
      isAiSuggestedMealsLoading.value = false;
      isAiGeneratedMealsValueLoading.value = false;
      LoggerUtils.debug("✅ [POLLING] Loading states RESET to FALSE");
    } else {
      aiGeneretedMealsDataErrorMessage.value = response.errorMessage.toString();
      LoggerUtils.error("❌ [POLLING] Failed to Get AI Generated Meals Data via polling!");
      LoggerUtils.error("❌ [POLLING] Status Code : ${response.statusCode}");
      LoggerUtils.error("❌ [POLLING] Error Message : ${aiGeneretedMealsDataErrorMessage.value}");

      isAiSuggestedMealsLoading.value = false;
      isAiGeneratedMealsValueLoading.value = false;
    }
  } catch (error) {
    aiGeneretedMealsDataErrorMessage.value = error.toString();
    LoggerUtils.error("💥 [POLLING] Caught Error While Getting the AI Generated Meals Data via polling");
    LoggerUtils.error("💥 [POLLING] Caught Error : ${aiGeneretedMealsDataErrorMessage.value}");

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
    
    LoggerUtils.debug("💾 Saving jobId to local storage: $jobId for date: $today");
  } catch (error) {
    LoggerUtils.error("❌ Error saving jobId to local storage: $error");
  }
}

/// Load jobId from local storage (only valid if from today)
Future<String?> _loadJobIdFromLocal() async {
  try {
    final storedData = appData.read(kKeyJobIdForAiGeneretedMeals);
    
    if (storedData == null) {
      LoggerUtils.debug("📭 No stored jobId found in local storage");
      return null;
    }
    
    if (storedData is Map<String, dynamic>) {
      final storedDate = storedData['date'] as String?;
      final storedJobId = storedData['jobId'] as String?;
      final today = _getCurrentDate();
      
      if (storedDate == today) {
        LoggerUtils.debug("📦 Found valid jobId from today: $storedJobId (stored on: $storedDate)");
        return storedJobId;
      } else {
        LoggerUtils.debug("🗑️ Stored jobId is from $storedDate, not today ($today). Clearing...");
        await _clearStoredJobId();
        return null;
      }
    }
    
    LoggerUtils.debug("📭 Invalid stored data format");
    return null;
  } catch (error) {
    LoggerUtils.error("❌ Error loading jobId from local storage: $error");
    return null;
  }
}

/// Clear stored jobId from local storage
Future<void> _clearStoredJobId() async {
  try {
    await appData.write(kKeyJobIdForAiGeneretedMeals, null);
    LoggerUtils.debug("🧹 Cleared stored jobId from local storage");
  } catch (error) {
    LoggerUtils.error("❌ Error clearing stored jobId: $error");
  }
}

/// Initialize AI meals - check for existing jobId or fetch new one
Future<void> initializeAiMeals() async {
  LoggerUtils.debug("🎯 [CONTROLLER] initializeAiMeals() CALLED");
  LoggerUtils.debug("🎯 [CONTROLLER] Current loading state: ${isAiSuggestedMealsLoading.value}");
  
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
    
    if (hasMealsInMemory) {
      LoggerUtils.debug("✅ [CONTROLLER] Meals already in memory, skipping initialization");
      isAiSuggestedMealsLoading.value = false;
      return;
    }
    
    // No meals in memory, proceed with initialization
    LoggerUtils.debug("🔄 [CONTROLLER] Initializing AI meals (no meals in memory)...");

    // Check for existing jobId from today
    final existingJobId = await _loadJobIdFromLocal();
    LoggerUtils.debug("🎯 [CONTROLLER] existingJobId=$existingJobId");

    if (existingJobId != null && existingJobId.isNotEmpty) {
      // Valid jobId exists from today - POLL IMMEDIATELY (socket is too slow)
      LoggerUtils.debug("🔄 [CONTROLLER] Using existing jobId from local storage: $existingJobId");
      LoggerUtils.debug("📡 [CONTROLLER] Polling API immediately for jobId: $existingJobId");
      
      // Poll immediately - don't wait for socket
      await getAiSuggestedMealsViaPolling();
      
      // Setup socket listener in background for real-time updates (if any)
      _socketServices.init().then((_) {
        setJobId(id: existingJobId);
        LoggerUtils.debug("🎧 [CONTROLLER] Socket listener setup in background for jobId: $existingJobId");
      });
    } else {
      // No valid jobId, fetch new one
      LoggerUtils.debug("🆕 [CONTROLLER] No valid jobId found in local storage, fetching new one...");
      await getAiSuggestedMealsJobIdApi();
    }
  } catch (error) {
    LoggerUtils.error("❌ [CONTROLLER] Failed to initialize AI meals: $error");
    aiSuggestedMealsErrorMessage.value = "Failed to initialize: $error";
    isAiSuggestedMealsLoading.value = false;
  }
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



