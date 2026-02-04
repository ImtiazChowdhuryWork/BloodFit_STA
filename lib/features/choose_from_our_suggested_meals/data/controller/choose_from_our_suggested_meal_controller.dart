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

  // RxnList<

  RxBool isPreviouslySelectedMealsLoading = false.obs;
  RxString errorMessage = ''.obs;
  void clearErrorMessage() {
    errorMessage.value = '';
  }

  Future<void> getPreviouslySelectedMeals() async {
    clearErrorMessage();
    isPreviouslySelectedMealsLoading.value = true;

    final responses = await _previouslySelectedMealsRepository
        .previouslySelectedMealsRepository();

    try {
      if (responses.statusCode == 200 && responses.isSuccess) {
      } else {
        errorMessage.value = responses.errorMessage.toString();
        LoggerUtils.error(
          "Error Found while Fetching the Previously Selected Items!",
        );
        LoggerUtils.error("Status Code : ${responses.statusCode}");
        LoggerUtils.error("Error Message : ${errorMessage.value}");
      }
    } catch (error) {
      errorMessage.value = error.toString();
      LoggerUtils.error("Catched Error : ${errorMessage.value}");
    } finally {
      isPreviouslySelectedMealsLoading.value = false;
    }
  }

  ///--------->>> Section : Previously Selected Meals Api Method End
}
