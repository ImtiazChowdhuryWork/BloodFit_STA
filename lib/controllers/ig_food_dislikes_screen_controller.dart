import 'package:flutter/widgets.dart';
import 'package:get/get.dart';

class IgFoodDislikesScreenController extends GetxController {
  ///------------->>> Controllers
  final dislikeFoodController = TextEditingController().obs;
  RxBool isDisLikeFoodControllerNotEmpty = false.obs;

  ///---------->>> DisLike Food List
  RxList<String> dislikedFoodList = <String>[].obs;

  ///------------>>> Add DisLiked Food Items to List
  void addDisLikeFoodToList() {
    final food = dislikeFoodController.value.text.trim();

    if (food.isNotEmpty && !dislikedFoodList.contains(food)) {
      dislikedFoodList.add(food);
      dislikeFoodController.value.clear();
    }
  }

  ///--------------->>> Remove Food Items from the Disliked Food List
  void removeDislikeFoodFromList({required String food}) {
    dislikedFoodList.remove(food);
  }

  @override
  void onInit() {
    super.onInit();

    ///------------>>> Listen to text changes in the controller
    dislikeFoodController.value.addListener(() {
      isDisLikeFoodControllerNotEmpty.value =
          dislikeFoodController.value.text.isNotEmpty;
    });
  }

  @override
  void onClose() {
    // Dispose the controller to prevent memory leaks
    dislikeFoodController.value.dispose();
    super.onClose();
  }
}
