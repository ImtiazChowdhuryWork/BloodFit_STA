import 'package:bloodfit/controllers/information_gather_screen_controller.dart';
import 'package:get/get.dart';
import 'dart:async';

import '../constants/app_constant_text.dart';
import '../helper/di.dart';
import '../helper/logger_util.dart';

class IgSelectYourCountryScreenController extends GetxController {
  final RxString countryName = ''.obs;
  final RxString countryFlag = ''.obs;

  Timer? _debounceTimer; // For debouncing save operations

  @override
  void onInit() {
    super.onInit();
    // Load saved country when controller initializes
    loadSavedCountry();
  }

  /// Load saved country from storage
  void loadSavedCountry() {
    try {
      final savedCountryName = appData.read(kKeyUserCountryName);
      if (savedCountryName != null && savedCountryName is String) {
        countryName.value = savedCountryName;
        // Note: We only save the country name, not the flag
        // The flag would need to be re-fetched if needed
        LoggerUtils.debug("Loaded saved country: $savedCountryName");
      }
    } catch (e) {
      LoggerUtils.error("Error loading country: $e");
    }
  }

  /// Save country to storage
  void saveCountry() {
    try {
      if (countryName.value.isNotEmpty) {
        appData.write(kKeyUserCountryName, countryName.value);

        ///----------->>> Update the controller
        Get.find<InformationGatherMealPlanController>().triggerButtonUpdate();
        LoggerUtils.debug("Saved country: ${countryName.value}");
      }
    } catch (e) {
      LoggerUtils.error("Error saving country: $e");
    }
  }

  /// Remove country from storage
  void removeCountryFromStorage() {
    try {
      appData.remove(kKeyUserCountryName);
      LoggerUtils.debug("Removed country from storage");
    } catch (e) {
      LoggerUtils.error("Error removing country: $e");
    }
  }

  ///---->>> Set Country Name and Flag Value
  void setCountryNameAndFlag({required String name, required String flag}) {
    countryName.value = name;
    countryFlag.value = flag;

    // Debounce saving - save after a short delay
    _debounceTimer?.cancel();
    _debounceTimer = Timer(const Duration(milliseconds: 300), () {
      saveCountry();
    });
  }

  ///------->>> Remove Country Name And Flag Value
  void removeCountryNameAndFlag() {
    countryName.value = '';
    countryFlag.value = '';

    // Also remove from storage
    removeCountryFromStorage();
  }

  @override
  void onClose() {
    _debounceTimer?.cancel(); // Cancel timer
    super.onClose();
  }
}
