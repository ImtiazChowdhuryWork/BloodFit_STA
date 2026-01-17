import 'package:flutter/material.dart';
import 'package:get/get.dart';

class IgFoodAllergiesScreenController extends GetxController {
  var addDislikeFoodController = TextEditingController().obs;
  var isAddDislikeTextFieldNotEmpty = false.obs;

  ///-------->>> Food List
  RxList<String> dislikedFoodList = [
    'Gluten',
    'Dairy',
    'Eggs',
    'Peanuts',
    'Soy',
    'Seafood',
  ].obs;

  ///------------>>> Add DisLiked Food Items to List
  void addDisLikeFoodToList() {
    final food = addDislikeFoodController.value.text.trim();

    if (food.isNotEmpty && !dislikedFoodList.contains(food)) {
      dislikedFoodList.add(food);
      addDislikeFoodController.value.clear();
    }
  }

  ///--------------->>> Remove Food Items from the Disliked Food List
  void removeFoodAllergy({required String food}) {
    dislikedFoodList.remove(food);
  }

  @override
  void onInit() {
    super.onInit();

    ///------------>>> Listen to text changes in the controller
    addDislikeFoodController.value.addListener(() {
      isAddDislikeTextFieldNotEmpty.value =
          addDislikeFoodController.value.text.isNotEmpty;
    });
  }

  @override
  void onClose() {
    // Dispose the controller to prevent memory leaks
    addDislikeFoodController.value.dispose();
    super.onClose();
  }
}
