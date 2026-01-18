import 'package:bloodfit/controllers/information_gather_screen_controller.dart';
import 'package:get/get.dart';
import 'dart:async';

import '../constants/app_constant_text.dart';
import '../constants/app_list.dart';
import '../helper/di.dart';
import '../helper/logger_util.dart';

class SelectDietController extends GetxController {
  /// Holds the selected index (-1 means none selected yet)
  final RxInt selectedIndex = (-1).obs;

  Timer? _debounceTimer; // For debouncing save operations

  @override
  void onInit() {
    super.onInit();
    // Load saved diet when controller initializes
    loadSavedDiet();
  }

  /// Load saved diet from storage
  void loadSavedDiet() {
    try {
      final savedDietName = appData.read(kKeyUserDietType);
      if (savedDietName != null && savedDietName is String) {
        // Find the index of the saved diet in the list
        for (int i = 0; i < AppList.pickYourDietList.length; i++) {
          if (AppList.pickYourDietList[i].dietName == savedDietName) {
            selectedIndex.value = i;
            LoggerUtils.debug("Loaded saved diet: $savedDietName at index $i");
            break;
          }
        }
      }
    } catch (e) {
      LoggerUtils.error("Error loading diet: $e");
    }
  }

  /// Save diet to storage
  void saveDiet(int index) {
    try {
      if (index >= 0 && index < AppList.pickYourDietList.length) {
        final dietName = AppList.pickYourDietList[index].dietName.toLowerCase();
        appData.write(kKeyUserDietType, dietName);

        ///----------->>> Update the controller
        Get.find<InformationGatherMealPlanController>().triggerButtonUpdate();
        LoggerUtils.debug("Saved diet: $dietName");
      }
    } catch (e) {
      LoggerUtils.error("Error saving diet: $e");
    }
  }

  /// Remove diet from storage
  void removeDietFromStorage() {
    try {
      appData.remove(kKeyUserDietType);
      LoggerUtils.debug("Removed diet from storage");
    } catch (e) {
      LoggerUtils.error("Error removing diet: $e");
    }
  }

  /// Update selected diet index with auto-save
  void selectDiet(int index) {
    if (selectedIndex.value == index) {
      // If tapping the already selected item, deselect it
      selectedIndex.value = -1;
      removeDietFromStorage();
    } else {
      // Select new item
      selectedIndex.value = index;

      // Debounce saving - save after a short delay
      _debounceTimer?.cancel();
      _debounceTimer = Timer(const Duration(milliseconds: 300), () {
        saveDiet(index);
      });
    }
  }

  /// Get the selected diet name (optional helper method)
  String? getSelectedDietName() {
    if (selectedIndex.value >= 0 &&
        selectedIndex.value < AppList.pickYourDietList.length) {
      return AppList.pickYourDietList[selectedIndex.value].dietName;
    }
    return null;
  }

  @override
  void onClose() {
    _debounceTimer?.cancel(); // Cancel timer
    super.onClose();
  }
}
