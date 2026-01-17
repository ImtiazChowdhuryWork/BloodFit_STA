import 'package:flutter/material.dart';
import 'package:get/get.dart';

class IgFoodAllergiesScreenController extends GetxController {
  var allergiesFoodController = TextEditingController().obs;
  var isAllegiesTextFieldNotEmpty = false.obs;

  ///-------->>> Food List
  RxList<String> alleriesFoodList = <String>[].obs;

  ///------------>>> Add Allergies Food Items to List
  void addAllergiesFoodToList() {
    final food = allergiesFoodController.value.text.trim();

    if (food.isNotEmpty && !alleriesFoodList.contains(food)) {
      alleriesFoodList.add(food);
      allergiesFoodController.value.clear();
    }
  }

  ///--------------->>> Remove Food Items from the Allergies Food List
  void removeFoodAllergy({required String food}) {
    alleriesFoodList.remove(food);
  }

  @override
  void onInit() {
    super.onInit();

    ///------------>>> Listen to text changes in the controller
    allergiesFoodController.value.addListener(() {
      isAllegiesTextFieldNotEmpty.value =
          allergiesFoodController.value.text.isNotEmpty;
    });
  }

  @override
  void onClose() {
    // Dispose the controller to prevent memory leaks
    allergiesFoodController.value.dispose();
    super.onClose();
  }
}
