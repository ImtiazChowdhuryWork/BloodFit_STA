import 'package:bloodfit/controllers/information_gather_screen_controller.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'dart:async';

import '../constants/app_constant_text.dart';
import '../helper/di.dart';
import '../helper/logger_util.dart';

class IgFoodDislikesScreenController extends GetxController {
  ///------------->>> Controllers
  final dislikeFoodController = TextEditingController().obs;
  RxBool isDisLikeFoodControllerNotEmpty = false.obs;

  ///---------->>> DisLike Food List
  RxList<String> dislikedFoodList = <String>[].obs;

  Timer? _debounceTimer; // For debouncing save operations

  @override
  void onInit() {
    super.onInit();

    ///------------>>> Listen to text changes in the controller
    dislikeFoodController.value.addListener(() {
      isDisLikeFoodControllerNotEmpty.value =
          dislikeFoodController.value.text.isNotEmpty;
    });

    // Load saved food dislikes when controller initializes
    loadSavedFoodDislikes();
  }

  /// Load saved food dislikes from storage
  void loadSavedFoodDislikes() {
    try {
      final savedDislikes = appData.read(kKeyUserDislLikeFoodList);
      if (savedDislikes != null && savedDislikes is List<dynamic>) {
        // Convert List<dynamic> to List<String>
        final List<String> loadedDislikes = savedDislikes
            .whereType<String>()
            .where((item) => item.isNotEmpty)
            .toList();

        if (loadedDislikes.isNotEmpty) {
          dislikedFoodList.assignAll(loadedDislikes);
          LoggerUtils.debug("Loaded saved food dislikes: $loadedDislikes");
        }
      }
    } catch (e) {
      LoggerUtils.error("Error loading food dislikes: $e");
    }
  }

  /// Save food dislikes to storage
  void saveFoodDislikes() {
    try {
      if (dislikedFoodList.isNotEmpty) {
        appData.write(kKeyUserDislLikeFoodList, dislikedFoodList.toList());

        ///----------->>> Update the controller
        Get.find<InformationGatherMealPlanController>().update();
        LoggerUtils.debug("Saved food dislikes: ${dislikedFoodList.toList()}");
      } else {
        // If list is empty, remove from storage
        appData.remove(kKeyUserDislLikeFoodList);
        LoggerUtils.debug("Removed food dislikes (list empty)");
      }
    } catch (e) {
      LoggerUtils.error("Error saving food dislikes: $e");
    }
  }

  /// Remove food dislikes from storage
  void removeFoodDislikesFromStorage() {
    try {
      appData.remove(kKeyUserDislLikeFoodList);
      LoggerUtils.debug("Removed food dislikes from storage");
    } catch (e) {
      LoggerUtils.error("Error removing food dislikes: $e");
    }
  }

  ///------------>>> Add DisLiked Food Items to List
  void addDisLikeFoodToList() {
    final food = dislikeFoodController.value.text.trim();

    if (food.isNotEmpty && !dislikedFoodList.contains(food)) {
      dislikedFoodList.add(food);
      dislikeFoodController.value.clear();

      // Save to storage after adding
      _saveWithDebounce();
    }
  }

  ///--------------->>> Remove Food Items from the Disliked Food List
  void removeDislikeFoodFromList({required String food}) {
    dislikedFoodList.remove(food);

    // Save to storage after removing
    _saveWithDebounce();
  }

  /// Clear all food dislikes
  void clearAllFoodDislikes() {
    dislikedFoodList.clear();
    removeFoodDislikesFromStorage();
  }

  /// Debounced saving to prevent multiple rapid saves
  void _saveWithDebounce() {
    _debounceTimer?.cancel();
    _debounceTimer = Timer(const Duration(milliseconds: 500), () {
      saveFoodDislikes();
    });
  }

  @override
  void onClose() {
    _debounceTimer?.cancel(); // Cancel timer
    dislikeFoodController.value.dispose();
    super.onClose();
  }
}
