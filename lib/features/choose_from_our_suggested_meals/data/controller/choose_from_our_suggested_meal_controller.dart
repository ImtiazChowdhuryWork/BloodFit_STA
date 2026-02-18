import 'package:bloodfit/constants/app_constant_text.dart';
import 'package:bloodfit/features/choose_from_our_suggested_meals/data/model/ai_suggested_meals_model.dart';
import 'package:bloodfit/features/choose_from_our_suggested_meals/data/model/recent_chosen_meals_model.dart';
import 'package:bloodfit/features/choose_from_our_suggested_meals/data/repository/ai_suggested_meals_repository.dart';
import 'package:bloodfit/helper/di.dart';
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
        "Given Input is unexpected, Because the index $index has exceeded the tab total index",
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
      final responses = await _previouslySelectedMealsRepository
          .previouslySelectedMealsRepository(mealType: selectedTabName.value);

      if (responses.statusCode == 200 && responses.isSuccess) {
        LoggerUtils.debug("🥳🥳🥳Recently Selected Meals are fatched successfully!");
        final model = RecentChosenMealsModel.fromJson(responses.jsonResponse!);

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
        if (selectedTabName.value == 'breakfast') {
          breakfastRecentChosenMeals.clear();
        } else if (selectedTabName.value == 'lunch') {
          lunchRecentChosenMeals.clear();
        } else if (selectedTabName.value == 'dinner') {
          dinnerRecentChosenMeals.clear();
        } else {
          LoggerUtils.error('Unexpected tab state: ${selectedTabName.value}');
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

  RxBool isAiSuggestedMealsLoading = false.obs;

  RxString aiSuggestedMealsErrorMessage = ''.obs;
  void clearAiSuggestedErrorMessage() {
    aiSuggestedMealsErrorMessage.value = '';
  }


  ///-------------->>> Section : Per Tabs 3 Meal Types(Protein-Packed, Light & Fresh, Hearty & Comforting) List
  RxList<HealthyComforting> proteinPackedItemsList = <HealthyComforting>[].obs;
  RxList<HealthyComforting> lightAndFreshItemsList = <HealthyComforting>[].obs;
  RxList<HealthyComforting> heartyAndConfortingItemsList = <HealthyComforting>[].obs;

  Future<void> getAiSuggestedMealsApi() async {
    isAiSuggestedMealsLoading.value = true;
    clearAiSuggestedErrorMessage();
    try {
      final response = await _aiSuggestedMealsRepository
          .aiSuggestedMealsRepository();

      if (response.statusCode == 200 && response.isSuccess) {
        LoggerUtils.debug("🥳🥳🥳Ai Suggested Meals are fatched successfully!");
        final model = AiSuggestedMealsModel.fromJson(response.jsonResponse!);



        ///-----------<>>>>> SECTION : Data Extrection <>>>>>>>>>---------------///
        ///-----------<>>>> Section : Breakast Items
        final List<HealthyComforting> breakfastProteinPackedItems = model.data?.breakfastOptions?.proteinPacked ?? [];
        final List<HealthyComforting> breakfastLightAndFreshItems = model.data?.breakfastOptions?.lightFresh ?? [];
        final List<HealthyComforting> breakfastHeartyComforting = model.data?.breakfastOptions?.healthyComforting ?? [];

        ///-----------<>>>> Section : Lunch Items
        final List<HealthyComforting> lunchProteinPackedItems = model.data?.lunchOptions?.proteinPacked ?? [];
        final List<HealthyComforting> lunchLightAndFreshItems = model.data?.lunchOptions?.lightFresh ?? [];
        final List<HealthyComforting> lunchHeartyComforting = model.data?.lunchOptions?.healthyComforting ?? [];

        ///-----------<>>>> Section : Dinner Items
        final List<HealthyComforting> dinnerProteinPackedItems = model.data?.dinnerOptions?.proteinPacked ?? [];
        final List<HealthyComforting> dinnerLightAndFreshItems = model.data?.dinnerOptions?.lightFresh ?? [];
        final List<HealthyComforting> dinnerHeartyComforting = model.data?.dinnerOptions?.healthyComforting ?? [];



        if (selectedTabName.value == 'breakfast') {
          ///---------<>>>> Section : Assign Breakfast Extrected Data to List
          proteinPackedItemsList.assignAll(breakfastProteinPackedItems);
          lightAndFreshItemsList.assignAll(breakfastLightAndFreshItems);
          heartyAndConfortingItemsList.assignAll(breakfastHeartyComforting);
        } else if (selectedTabName.value == 'lunch') {
          ///---------<>>>> Section : Assign Lunch Extrected Data to List
          proteinPackedItemsList.assignAll(lunchProteinPackedItems);
          lightAndFreshItemsList.assignAll(lunchLightAndFreshItems);
          heartyAndConfortingItemsList.assignAll(lunchHeartyComforting);
        } else if (selectedTabName.value == 'dinner') {
          ///---------<>>>> Section : Assign Lunch Extrected Data to List
          proteinPackedItemsList.assignAll(dinnerProteinPackedItems);
          lightAndFreshItemsList.assignAll(dinnerLightAndFreshItems);
          heartyAndConfortingItemsList.assignAll(dinnerHeartyComforting);
        }
      } else {
        aiSuggestedMealsErrorMessage.value = response.errorMessage.toString();
        if (selectedTabName.value == 'breakfast') {
          proteinPackedItemsList.clear();
          lightAndFreshItemsList.clear();
          heartyAndConfortingItemsList.clear();
        } else if (selectedTabName.value == 'lunch') {
          proteinPackedItemsList.clear();
          lightAndFreshItemsList.clear();
          heartyAndConfortingItemsList.clear();
        } else if (selectedTabName.value == 'dinner') {
          proteinPackedItemsList.clear();
          lightAndFreshItemsList.clear();
          heartyAndConfortingItemsList.clear();
        } else {
          LoggerUtils.error('Unexpected tab state: ${selectedTabName.value}');
        }
        LoggerUtils.error(
          "Failed to Get AI Suggested Mealse : Error Code :: ${response.statusCode}",
        );
        LoggerUtils.error(
          "Error Message : ${aiSuggestedMealsErrorMessage.value}",
        );
      }
    } catch (error) {
      aiSuggestedMealsErrorMessage.value = error.toString();
      LoggerUtils.error("Error Catched While Getting the Ai Suggested Meals!");
      LoggerUtils.error(
        "Catched Error : ${aiSuggestedMealsErrorMessage.value}",
      );
    } finally {
      isAiSuggestedMealsLoading.value = false;
    }
  }

  ///--------->>> Section : AI SUGGESTED Meals Api Method Ends Here
}
