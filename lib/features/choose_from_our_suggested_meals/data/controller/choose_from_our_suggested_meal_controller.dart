import 'package:bloodfit/features/choose_from_our_suggested_meals/data/model/recent_chosen_meals_model.dart';
import 'package:bloodfit/features/choose_from_our_suggested_meals/data/repository/ai_suggested_meals_repository.dart';
import 'package:bloodfit/helper/logger_util.dart';
import 'package:get/get.dart';

import '../model/ai_suggested_meals_model.dart';
import '../repository/previously_selected_meals_repository.dart';

class ChooseFromOurSuggestedMealController extends GetxController {
  ///------->>> Section : Importing the Preselected Repository
  final PreviouslySelectedMealsRepository _previouslySelectedMealsRepository;

  ///-------<>>>> Section : Importing the AI Suggested Meals Repository
  final AiSuggestedMealsRepository _aiSuggestedMealsRepository;

  ChooseFromOurSuggestedMealController(this._previouslySelectedMealsRepository,this._aiSuggestedMealsRepository);

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
    selectedTabName.value = 'dinner'; // Fixed typo
    return selectedTabName.value;
  } else {
    LoggerUtils.error(
      "Given Input is unexpected, Because the index $index has exceeded the tab total index"
    );
    return ''; // Return empty string for invalid index
  }
}

  RxBool isPreviouslySelectedMealsLoading = false.obs;
  RxString errorMessage = ''.obs;
  void clearErrorMessage() {
    errorMessage.value = '';
  }

  Future<void> getPreviouslySelectedMeals() async {
  clearErrorMessage();
  isPreviouslySelectedMealsLoading.value = true;

  try {
    final responses =
        await _previouslySelectedMealsRepository.previouslySelectedMealsRepository(
      mealType: selectedTabName.value,
    );

    if (responses.statusCode == 200 && responses.isSuccess) {
      final model =
          RecentChosenMealsModel.fromJson(responses.jsonResponse!);

      final List<Datum> meals = model.data ?? [];

      if (selectedTabName.value == 'breakfast') {
        breakfastRecentChosenMeals.assignAll(meals);
      } else if (selectedTabName.value == 'lunch') {
        lunchRecentChosenMeals.assignAll(meals);
      } else if (selectedTabName.value == 'dinner') {
        dinnerRecentChosenMeals.assignAll(meals);
      }
    } else {
      errorMessage.value = responses.errorMessage.toString();
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

RxBool isAiSuggestedMealsLoading = false.obs;
RxString aiSuggestedMealsErrorMessage = ''.obs;
Rxn<AiSuggestedMealsData> aiSuggestedMealsData = Rxn<AiSuggestedMealsData>();

void clearAiSuggestedErrorMessage() {
  aiSuggestedMealsErrorMessage.value = '';
}

Future<void> getAiSuggestedMealsApi() async {
  isAiSuggestedMealsLoading.value = true;
  clearAiSuggestedErrorMessage();

  try {
    final response = await _aiSuggestedMealsRepository.aiSuggestedMealsRepository();

    if (response.statusCode == 200 && response.isSuccess) {
      /// ✅ SUCCESS CASE
      final model = AiSuggestedMealsModel.fromJson(response.jsonResponse!);

      if (model.data != null) {
        aiSuggestedMealsData.value = model.data;

        /// Optionally, you can prefill breakfast/lunch/dinner lists
        breakfastRecentChosenMeals.assignAll(_extractMeals(model.data!.breakfastOptions));
        lunchRecentChosenMeals.assignAll(_extractMeals(model.data!.lunchOptions));
        dinnerRecentChosenMeals.assignAll(_extractMeals(model.data!.dinnerOptions));
      }
    } else {
      aiSuggestedMealsErrorMessage.value = response.errorMessage.toString();
      LoggerUtils.error("Failed to Get AI Suggested Meals : Error Code :: ${response.statusCode}");
      LoggerUtils.error("Error Message : ${aiSuggestedMealsErrorMessage.value}");
    }
  } catch (error) {
    aiSuggestedMealsErrorMessage.value = error.toString();
    LoggerUtils.error("Error Caught While Getting the AI Suggested Meals!");
    LoggerUtils.error("Caught Error : ${aiSuggestedMealsErrorMessage.value}");
  } finally {
    isAiSuggestedMealsLoading.value = false;
  }
}

/// Helper method to flatten Options into a list of HealthyComforting
List<Datum> _extractMeals(Options? options) {
  if (options == null) return [];

  final meals = <Datum>[];

  // Protein Packed
  if (options.proteinPacked != null && options.proteinPacked!.isNotEmpty) {
    for (var meal in options.proteinPacked!) {
      meals.add(Datum.fromHealthyComforting(meal));
    }
  }

  // Light Fresh
  if (options.lightFresh != null && options.lightFresh!.isNotEmpty) {
    for (var meal in options.lightFresh!) {
      meals.add(Datum.fromHealthyComforting(meal));
    }
  }

  // Healthy & Comforting
  if (options.healthyComforting != null && options.healthyComforting!.isNotEmpty) {
    for (var meal in options.healthyComforting!) {
      meals.add(Datum.fromHealthyComforting(meal));
    }
  }

  return meals;
}






///--------->>> Section : AI SUGGESTED Meals Api Method Ends Here




  
  
}
