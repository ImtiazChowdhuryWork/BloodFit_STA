import 'package:bloodfit/controllers/information_gather_screen_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dart:async';

import '../constants/app_constant_text.dart';
import '../helper/di.dart';
import '../helper/logger_util.dart';

class IgFoodAllergiesScreenController extends GetxController {
  var allergiesFoodController = TextEditingController().obs;
  var isAllegiesTextFieldNotEmpty = false.obs;

  ///-------->>> Food List
  RxList<String> alleriesFoodList = <String>[].obs;

  Timer? _debounceTimer; // For debouncing save operations

  @override
  void onInit() {
    super.onInit();

    ///------------>>> Listen to text changes in the controller
    allergiesFoodController.value.addListener(() {
      isAllegiesTextFieldNotEmpty.value =
          allergiesFoodController.value.text.isNotEmpty;
    });

    // Load saved food allergies when controller initializes
    loadSavedFoodAllergies();
  }

  /// Load saved food allergies from storage
  void loadSavedFoodAllergies() {
    try {
      final savedAllergies = appData.read(kKeyUserFoodAlergisList);
      if (savedAllergies != null && savedAllergies is List<dynamic>) {
        // Convert List<dynamic> to List<String>
        final List<String> loadedAllergies = savedAllergies
            .whereType<String>()
            .where((item) => item.isNotEmpty)
            .toList();

        if (loadedAllergies.isNotEmpty) {
          alleriesFoodList.assignAll(loadedAllergies);
          LoggerUtils.debug("Loaded saved food allergies: $loadedAllergies");
        }
      }
    } catch (e) {
      LoggerUtils.error("Error loading food allergies: $e");
    }
  }

  /// Save food allergies to storage
  void saveFoodAllergies() {
    try {
      if (alleriesFoodList.isNotEmpty) {
        appData.write(kKeyUserFoodAlergisList, alleriesFoodList.toList());

        ///----------->>> Update the controller
        Get.find<InformationGatherMealPlanController>().update();
        LoggerUtils.debug("Saved food allergies: ${alleriesFoodList.toList()}");
      } else {
        // If list is empty, remove from storage
        appData.remove(kKeyUserFoodAlergisList);
        LoggerUtils.debug("Removed food allergies (list empty)");
      }
    } catch (e) {
      LoggerUtils.error("Error saving food allergies: $e");
    }
  }

  /// Remove food allergies from storage
  void removeFoodAllergiesFromStorage() {
    try {
      appData.remove(kKeyUserFoodAlergisList);
      LoggerUtils.debug("Removed food allergies from storage");
    } catch (e) {
      LoggerUtils.error("Error removing food allergies: $e");
    }
  }

  ///------------>>> Add Allergies Food Items to List
  void addAllergiesFoodToList() {
    final food = allergiesFoodController.value.text.trim();

    if (food.isNotEmpty && !alleriesFoodList.contains(food)) {
      alleriesFoodList.add(food);
      allergiesFoodController.value.clear();

      // Save to storage after adding
      _saveWithDebounce();
    }
  }

  ///--------------->>> Remove Food Items from the Allergies Food List
  void removeFoodAllergy({required String food}) {
    alleriesFoodList.remove(food);

    // Save to storage after removing
    _saveWithDebounce();
  }

  /// Clear all food allergies
  void clearAllFoodAllergies() {
    alleriesFoodList.clear();
    removeFoodAllergiesFromStorage();
  }

  /// Debounced saving to prevent multiple rapid saves
  void _saveWithDebounce() {
    _debounceTimer?.cancel();
    _debounceTimer = Timer(const Duration(milliseconds: 500), () {
      saveFoodAllergies();
    });
  }

  @override
  void onClose() {
    _debounceTimer?.cancel(); // Cancel timer
    allergiesFoodController.value.dispose();
    super.onClose();
  }
}
