import 'package:bloodfit/features/choose_from_our_suggested_meals/data/model/recent_chosen_meals_model.dart';
import 'package:bloodfit/helper/logger_util.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';

import '../repository/previously_selected_meals_repository.dart';

class ChooseFromOurSuggestedMealController extends GetxController {
  ///------->>> Section : Importing the Preselected Repository
  final PreviouslySelectedMealsRepository _previouslySelectedMealsRepository;

  ChooseFromOurSuggestedMealController(this._previouslySelectedMealsRepository);

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

  ///--------->>> Section : Previously Selected Meals Api Method Start
  

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


  
  
}
