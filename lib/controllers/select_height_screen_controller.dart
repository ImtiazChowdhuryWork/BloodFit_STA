// import 'package:flutter/material.dart';
// import 'package:get/get.dart';

// class SelectHeightScreenController extends GetxController {
//   final ScrollController scrollController = ScrollController();
//   final RxDouble centerValue = 150.0.obs;
//   final RxString unit = "cm".obs;

//   double lastValidCenterValue = 150.0;
//   double? containerHeight;

//   // Ruler configuration
//   double itemHeight = 20.0;
//   double itemSpacing = 2.0;
//   double minValue = 0.0;
//   double maxValue = 250.0;
//   int totalItems = 0;
//   int bigDividerInterval = 5;
//   double smallDividerValue = 1.0;

//   bool _isInitialized = false;

//   // Method to set configuration without triggering rebuilds
//   void setRulerConfiguration({
//     double? minValue,
//     double? maxValue,
//     double? smallDividerValue,
//     int? bigDividerInterval,
//     double? containerHeight,
//   }) {
//     this.minValue = minValue ?? this.minValue;
//     this.maxValue = maxValue ?? this.maxValue;
//     this.smallDividerValue = smallDividerValue ?? this.smallDividerValue;
//     this.bigDividerInterval = bigDividerInterval ?? this.bigDividerInterval;
//     this.containerHeight = containerHeight;

//     double totalRange = this.maxValue - this.minValue;
//     totalItems = totalRange.toInt() + 1;

//     _isInitialized = true;
//   }

//   // Separate method to set initial value after build
//   void setInitialValue(double value) {
//     if (!_isInitialized) return;

//     // Use a small delay to avoid build phase conflicts
//     Future.delayed(Duration.zero, () {
//       centerValue.value = value;
//       lastValidCenterValue = value;
//     });
//   }

//   double getValueFromIndex(int index) {
//     return minValue + index;
//   }

//   int getIndexFromValue(double value) {
//     return (value - minValue).round();
//   }

//   bool isBigDivider(int itemIndex) {
//     return itemIndex % bigDividerInterval == 0;
//   }

//   String getFormattedFeetInches() {
//     if (unit.value == "cm") {
//       return "${centerValue.value.toInt()} cm";
//     } else {
//       double totalInches = centerValue.value / 2.54;
//       int feet = (totalInches / 12).floor();
//       int inches = (totalInches % 12).round();
//       return "${feet}ft ${inches}in";
//     }
//   }

//   // Method to get the display value based on current unit
//   String getDisplayValue() {
//     if (unit.value == "cm") {
//       return "${centerValue.value.toInt()}";
//     } else {
//       // For feet/inches, return the feet portion
//       double totalInches = centerValue.value / 2.54;
//       int feet = (totalInches / 12).floor();
//       return "${feet}";
//     }
//   }

//   // Method to get the secondary display value for inches when in ft mode
//   String getSecondaryDisplayValue() {
//     if (unit.value == "cm") {
//       return "cm";
//     } else {
//       double totalInches = centerValue.value / 2.54;
//       int inches = (totalInches % 12).round();
//       return "${inches}in";
//     }
//   }

//   void toggleUnit() {
//     if (unit.value == "cm") {
//       unit.value = "ft";
//     } else {
//       unit.value = "cm";
//     }
//     update();
//   }

//   double getCenteredValue(double scrollOffset) {
//     if (containerHeight == null || !_isInitialized) return lastValidCenterValue;

//     final double centerY = containerHeight! / 2;

//     // Calculate which item is exactly at the center
//     final double centerPosition = scrollOffset + centerY;
//     final int centeredIndex = (centerPosition / (itemHeight + itemSpacing))
//         .floor();

//     // Ensure index is within bounds and adjust for center padding
//     final int adjustedIndex =
//         centeredIndex - 1; // Subtract 1 for the center padding item
//     if (adjustedIndex >= 0 && adjustedIndex < totalItems) {
//       return getValueFromIndex(adjustedIndex);
//     }

//     return lastValidCenterValue;
//   }

//   void _updateCenterIndex() {
//     if (containerHeight == null || !_isInitialized) return;

//     final double scrollOffset = scrollController.offset;
//     final double calculatedValue = getCenteredValue(scrollOffset);

//     if (calculatedValue != centerValue.value) {
//       if (calculatedValue >= minValue && calculatedValue <= maxValue) {
//         centerValue.value = calculatedValue;
//         lastValidCenterValue = calculatedValue;
//       }
//     }
//   }

//   // Method to scroll to initial position after build
//   void scrollToInitialPosition(double initialValue) {
//     if (containerHeight == null || !_isInitialized) return;

//     WidgetsBinding.instance.addPostFrameCallback((_) {
//       final initialIndex = getIndexFromValue(initialValue);
//       // Calculate offset considering the center padding (exact center)
//       final double centerPadding = containerHeight! / 2;
//       final initialOffset =
//           initialIndex * (itemHeight + itemSpacing) -
//           (centerPadding - (itemHeight / 2));
//       scrollController.jumpTo(
//         initialOffset.clamp(0.0, scrollController.position.maxScrollExtent),
//       );
//     });
//   }

//   @override
//   void onInit() {
//     super.onInit();
//     scrollController.addListener(_updateCenterIndex);
//   }

//   @override
//   void onClose() {
//     scrollController.removeListener(_updateCenterIndex);
//     scrollController.dispose();
//     super.onClose();
//   }
// }

import 'package:bloodfit/controllers/information_gather_screen_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dart:async';

import '../constants/app_constant_text.dart';
import '../helper/di.dart';
import '../helper/logger_util.dart';

class SelectHeightScreenController extends GetxController {
  final ScrollController scrollController = ScrollController();
  final RxDouble centerValue = 150.0.obs;
  final RxString unit = "cm".obs;
  final RxBool hasUserInteracted = false.obs;

  double lastValidCenterValue = 150.0;
  double? containerHeight;

  // For debouncing save operations
  Timer? _debounceTimer;

  // Ruler configuration
  double itemHeight = 20.0;
  double itemSpacing = 2.0;
  double minValue = 0.0;
  double maxValue = 250.0;
  int totalItems = 0;
  int bigDividerInterval = 5;
  double smallDividerValue = 1.0;

  bool _isInitialized = false;

  @override
  void onInit() {
    super.onInit();
    scrollController.addListener(_onScroll);

    // Load saved height when controller initializes
    loadSavedHeight();
  }

  void _onScroll() {
    // Check if scroll controller is attached to any scroll views before accessing
    if (!scrollController.hasClients) return;

    _updateCenterIndex();

    // Debounce saving - save when scrolling stops
    _debounceTimer?.cancel();
    _debounceTimer = Timer(const Duration(milliseconds: 300), () {
      // Check again if controller is still valid when timer executes
      if (Get.isRegistered<SelectHeightScreenController>()) {
        saveHeightAndUnit();
      }
    });
  }

  /// Load saved height from storage
  // void loadSavedHeight() {
  //   try {
  //     final savedHeightWithUnit = appData.read(kKeyUserHeight);
  //     final savedHeightWithoutUnit = appData.read(kKeyUserHeightWithoutUnit);
  //     final savedUnit = appData.read('${kKeyUserHeight}_unit');

  //     if (savedHeightWithUnit != null || savedHeightWithoutUnit != null) {
  //       double heightToDisplay;
  //       double? heightWithUnit;
  //       double? heightWithoutUnit;

  //       // Try to parse both values
  //       if (savedHeightWithUnit != null) {
  //         heightWithUnit = double.tryParse(savedHeightWithUnit.toString());
  //       }

  //       if (savedHeightWithoutUnit != null) {
  //         heightWithoutUnit = double.tryParse(
  //           savedHeightWithoutUnit.toString(),
  //         );
  //       }

  //       // Priority: Use height with unit if available, else use height without unit
  //       if (heightWithUnit != null) {
  //         heightToDisplay = heightWithUnit;
  //       } else if (heightWithoutUnit != null) {
  //         heightToDisplay = heightWithoutUnit;
  //       } else {
  //         return; // No valid height found
  //       }

  //       // Check what unit was last selected for display
  //       if (savedUnit == 'ft') {
  //         unit.value = 'ft';
  //       } else {
  //         unit.value = 'cm';
  //       }

  //       // Ensure height is within range
  //       if (heightToDisplay >= minValue && heightToDisplay <= maxValue) {
  //         // Set the height for display
  //         centerValue.value = heightToDisplay;
  //         lastValidCenterValue = heightToDisplay;

  //         LoggerUtils.debug(
  //           "Loaded saved height: WithUnit=$heightWithUnit, WithoutUnit=$heightWithoutUnit ${savedUnit ?? 'cm'}",
  //         );
  //       }
  //       // Mark that user has interacted if we have saved data
  //       if (hasValidSavedData) {
  //         hasUserInteracted.value = true;
  //       }
  //     }
  //   } catch (e) {
  //     LoggerUtils.error("Error loading height: $e");
  //   }
  // }

  /// Load saved height from storage
  void loadSavedHeight() {
    try {
      final savedHeightWithUnit = appData.read(kKeyUserHeight);
      final savedHeightWithoutUnit = appData.read(kKeyUserHeightWithoutUnit);
      final savedUnit = appData.read('${kKeyUserHeight}_unit');

      bool hasValidSavedData = false; // Add this variable
      double heightToDisplay = 150.0; // Default for display only

      if (savedHeightWithUnit != null || savedHeightWithoutUnit != null) {
        double? heightWithUnit;
        double? heightWithoutUnit;

        // Try to parse both values
        if (savedHeightWithUnit != null) {
          heightWithUnit = double.tryParse(savedHeightWithUnit.toString());
        }

        if (savedHeightWithoutUnit != null) {
          heightWithoutUnit = double.tryParse(
            savedHeightWithoutUnit.toString(),
          );
        }

        // Priority: Use height with unit if available, else use height without unit
        if (heightWithUnit != null) {
          heightToDisplay = heightWithUnit;
          hasValidSavedData = true; // Set to true
        } else if (heightWithoutUnit != null) {
          heightToDisplay = heightWithoutUnit;
          hasValidSavedData = true; // Set to true
        }

        // Check what unit was last selected for display
        if (savedUnit == 'ft') {
          unit.value = 'ft';
        } else {
          unit.value = 'cm';
        }
      }

      // If we have valid saved data, use it
      if (hasValidSavedData) {
        // Ensure height is within range
        if (heightToDisplay >= minValue && heightToDisplay <= maxValue) {
          // Set the height for display
          centerValue.value = heightToDisplay;
          lastValidCenterValue = heightToDisplay;

          // Mark that user has interacted since we have saved data
          hasUserInteracted.value = true;

          LoggerUtils.debug(
            "Loaded saved height: $heightToDisplay ${unit.value} (User has interacted: ${hasUserInteracted.value})",
          );
        }
      } else {
        // No valid saved height - set default for display only
        // DO NOT set hasUserInteracted to true here
        // Set default display values
        centerValue.value = heightToDisplay;
        lastValidCenterValue = heightToDisplay;

        LoggerUtils.debug(
          "No saved height found. Set display default: $heightToDisplay ${unit.value} (User has NOT interacted)",
        );
      }
    } catch (e) {
      LoggerUtils.error("Error loading height: $e");

      // Fallback to default on error
      centerValue.value = 150.0;
      lastValidCenterValue = 150.0;
    }
  }

  /// Save height and unit to storage
  void saveHeightAndUnit() {
    try {
      hasUserInteracted.value = true;
      final double selectedValue = centerValue.value;
      final String selectedUnit = unit.value;

      double heightToSaveInCm;
      double heightToSaveWithUnit = selectedValue; // Exact value user sees

      if (selectedUnit == 'ft') {
        // Convert ft to cm (1 ft = 30.48 cm)
        // First convert to total inches, then to cm
        // centerValue is in cm, so we need to handle conversion properly
        // For ft display, we're showing feet, but storing in cm
        heightToSaveInCm =
            selectedValue; // Already in cm (converted from ft if needed)

        // For display with unit, we need to convert cm to feet/inches
        final totalInches = selectedValue / 2.54;
        final feet = (totalInches / 12).floor();
        final inches = (totalInches % 12).round();
        heightToSaveWithUnit = feet.toDouble(); // Store feet for display
      } else {
        // Already in cm, no conversion needed
        heightToSaveInCm = selectedValue;
        heightToSaveWithUnit = selectedValue;
      }

      // Save TWO values to local storage:

      // 1. WITH UNIT: The exact value user sees (e.g., 5 ft or 170 cm)
      appData.write(kKeyUserHeight, heightToSaveWithUnit);

      // 2. WITHOUT UNIT: Always in cm (converted if needed)
      appData.write(kKeyUserHeightWithoutUnit, heightToSaveInCm);

      // Also save the unit user selected (for UI display when loading)
      appData.write('${kKeyUserHeight}_unit', selectedUnit);

      ///----------->>> Update the controller
      Get.find<InformationGatherMealPlanController>().triggerButtonUpdate();

      LoggerUtils.debug(
        "Saved height - WithUnit: $heightToSaveWithUnit $selectedUnit, WithoutUnit: $heightToSaveInCm cm",
      );
    } catch (e) {
      LoggerUtils.error("Error saving height: $e");
    }
  }

  // Method to set configuration without triggering rebuilds
  void setRulerConfiguration({
    double? minValue,
    double? maxValue,
    double? smallDividerValue,
    int? bigDividerInterval,
    double? containerHeight,
  }) {
    this.minValue = minValue ?? this.minValue;
    this.maxValue = maxValue ?? this.maxValue;
    this.smallDividerValue = smallDividerValue ?? this.smallDividerValue;
    this.bigDividerInterval = bigDividerInterval ?? this.bigDividerInterval;
    this.containerHeight = containerHeight;

    double totalRange = this.maxValue - this.minValue;
    totalItems = totalRange.toInt() + 1;

    _isInitialized = true;
  }

  // Separate method to set initial value after build
  void setInitialValue(double value) {
    if (!_isInitialized) return;

    // Use a post-frame callback to avoid build phase conflicts
    WidgetsBinding.instance.addPostFrameCallback((_) {
      centerValue.value = value;
      lastValidCenterValue = value;
    });
  }

  double getValueFromIndex(int index) {
    return minValue + index;
  }

  int getIndexFromValue(double value) {
    return (value - minValue).round();
  }

  bool isBigDivider(int itemIndex) {
    return itemIndex % bigDividerInterval == 0;
  }

  String getFormattedFeetInches() {
    if (unit.value == "cm") {
      return "${centerValue.value.toInt()} cm";
    } else {
      double totalInches = centerValue.value / 2.54;
      int feet = (totalInches / 12).floor();
      int inches = (totalInches % 12).round();
      return "${feet}ft ${inches}in";
    }
  }

  // Method to get the display value based on current unit
  String getDisplayValue() {
    if (unit.value == "cm") {
      return "${centerValue.value.toInt()}";
    } else {
      // For feet/inches, return the feet portion
      double totalInches = centerValue.value / 2.54;
      int feet = (totalInches / 12).floor();
      return "${feet}";
    }
  }

  // Method to get the secondary display value for inches when in ft mode
  String getSecondaryDisplayValue() {
    if (unit.value == "cm") {
      return "cm";
    } else {
      double totalInches = centerValue.value / 2.54;
      int inches = (totalInches % 12).round();
      return "${inches}in";
    }
  }

  void toggleUnit() {
    if (unit.value == "cm") {
      unit.value = "ft";
    } else {
      unit.value = "cm";
    }

    // Save when unit changes
    saveHeightAndUnit();

    update();
  }

  double getCenteredValue(double scrollOffset) {
    if (containerHeight == null || !_isInitialized) return lastValidCenterValue;

    final double centerY = containerHeight! / 2;

    // Calculate which item is exactly at the center
    final double centerPosition = scrollOffset + centerY;
    final int centeredIndex = (centerPosition / (itemHeight + itemSpacing))
        .floor();

    // Ensure index is within bounds and adjust for center padding
    final int adjustedIndex =
        centeredIndex - 1; // Subtract 1 for the center padding item
    if (adjustedIndex >= 0 && adjustedIndex < totalItems) {
      return getValueFromIndex(adjustedIndex);
    }

    return lastValidCenterValue;
  }

  void _updateCenterIndex() {
    // Check if scroll controller is attached to any scroll views before accessing
    if (!scrollController.hasClients) return;
    if (containerHeight == null || !_isInitialized) return;

    final double scrollOffset = scrollController.offset;
    final double calculatedValue = getCenteredValue(scrollOffset);

    if (calculatedValue != centerValue.value) {
      if (calculatedValue >= minValue && calculatedValue <= maxValue) {
        centerValue.value = calculatedValue;
        lastValidCenterValue = calculatedValue;
      }
    }
  }

  // Method to scroll to initial position after build
  void scrollToInitialPosition(double initialValue) {
    if (containerHeight == null || !_isInitialized) return;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      // Check if scroll controller is still attached before accessing
      if (!scrollController.hasClients) return;

      final initialIndex = getIndexFromValue(initialValue);
      // Calculate offset considering the center padding (exact center)
      final double centerPadding = containerHeight! / 2;
      final initialOffset =
          initialIndex * (itemHeight + itemSpacing) -
          (centerPadding - (itemHeight / 2));
      scrollController.jumpTo(
        initialOffset.clamp(0.0, scrollController.position.maxScrollExtent),
      );
    });
  }

  @override
  void onClose() {
    _debounceTimer?.cancel(); // Cancel timer
    scrollController.removeListener(_onScroll);
    scrollController.dispose();
    super.onClose();
  }
}
