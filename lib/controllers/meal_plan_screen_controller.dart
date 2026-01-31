import 'package:get/get.dart';

class MealPlanScreenController extends GetxController {
  ///User WorkOut Goal
  final selectedWorkOutGoal = RxnString();
  void setUserWorkOutGoal(String? value) {
    selectedWorkOutGoal.value = value;
  }

  ///User Desired Weight
  final selectedDesiredWeight = RxnString();
  void setUserDesiredWeight(String? value) {
    selectedDesiredWeight.value = value;
  }

  ///Section : ----------///Select your desired diet type///-----------------
  final selectedDietType = RxnString();
  void setSelectedDietType(String? value) {
    selectedDietType.value = value;
  }

  ///Section : ----------///Select MealPlan Days///-----------------
  final selectedMealplanDays = <String>{}.obs; // Holds multiple selected days

  void toggleMealplanDaySelection(String day) {
    if (selectedMealplanDays.contains(day)) {
      selectedMealplanDays.remove(day);
    } else {
      selectedMealplanDays.add(day);
    }
  }

  bool isMealplanDaySelected(String day) => selectedMealplanDays.contains(day);

  ///Section : ----------///Select Cheat Day///-----------------
  final selectedCheatDay = <String>{}.obs; // Holds multiple selected days

  void toggleCheatDaySelection(String day) {
    if (selectedCheatDay.contains(day)) {
      selectedCheatDay.remove(day);
    } else {
      selectedCheatDay.add(day);
    }
  }

  bool isCheatDaySelected(String day) => selectedCheatDay.contains(day);

  ///Section : ----------///Select Food Allergies///-----------------
  final allergicFoodSearchQuery = ''.obs;
  final selectedAllergicFoods = <String>[].obs;

  /// Toggle selection of an allergic food
  void toggleAllergicFoodSelection(String item) {
    if (selectedAllergicFoods.contains(item)) {
      selectedAllergicFoods.remove(item);
    } else {
      selectedAllergicFoods.add(item);
    }
  }

  /// Remove an allergic food from selected list
  void removeAllergicFood(String item) => selectedAllergicFoods.remove(item);

  ///Section : ----------///Select Dislike Foods///-----------------
  final dislikeFoodSearchQuery = ''.obs;
  final selectedDislikedFoods = <String>[].obs;

  /// Toggle selection of an allergic food
  void toggleDislikedFoodSelection(String item) {
    if (selectedDislikedFoods.contains(item)) {
      selectedDislikedFoods.remove(item);
    } else {
      selectedDislikedFoods.add(item);
    }
  }

  /// Remove an allergic food from selected list
  void removeDislikedFood(String item) => selectedDislikedFoods.remove(item);
}
