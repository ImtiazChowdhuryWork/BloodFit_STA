// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:get/get.dart';

// class SelectHeightScreenController extends GetxController {
//   final ScrollController scrollController = ScrollController();
//   final RxDouble centerValue = 150.0.obs;
//   final RxString unit = "cm".obs;

//   double lastValidCenterValue = 150.0;

//   // Ruler configuration
//   double itemHeight = 20.0;
//   double itemSpacing = 2.0;
//   double minValue = 0.0;
//   double maxValue = 250.0;
//   int totalItems = 0;
//   int bigDividerInterval = 5;
//   double smallDividerValue = 1.0;

//   void initializeRuler({
//     double? minValue,
//     double? maxValue,
//     double? smallDividerValue,
//     int? bigDividerInterval,
//   }) {
//     this.minValue = minValue ?? this.minValue;
//     this.maxValue = maxValue ?? this.maxValue;
//     this.smallDividerValue = smallDividerValue ?? this.smallDividerValue;
//     this.bigDividerInterval = bigDividerInterval ?? this.bigDividerInterval;

//     double totalRange = this.maxValue - this.minValue;
//     totalItems = totalRange.toInt() + 1;

//     centerValue.value = this.minValue + (totalRange / 2);
//     lastValidCenterValue = centerValue.value;

//     update();
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

//   void toggleUnit() {
//     if (unit.value == "cm") {
//       unit.value = "ft";
//     } else {
//       unit.value = "cm";
//     }
//     update();
//   }

//   // SIMPLIFIED: Direct calculation without center padding
//   double getCenteredValue(double scrollOffset, double containerHeight) {
//     final double centerY = containerHeight / 2;

//     // Calculate which item is at the center
//     // Formula: scrollOffset + centerY = position of center line in list coordinates
//     final double centerPosition = scrollOffset + centerY;

//     // Calculate which item index is at the center position
//     final int centeredIndex = (centerPosition / (itemHeight + itemSpacing))
//         .floor();

//     // Ensure index is within bounds
//     if (centeredIndex >= 0 && centeredIndex < totalItems) {
//       return getValueFromIndex(centeredIndex);
//     }

//     return lastValidCenterValue;
//   }

//   void _updateCenterIndex() {
//     final double scrollOffset = scrollController.offset;
//     final double containerHeight = 0.8.sh - 200.h;
//     final double calculatedValue = getCenteredValue(
//       scrollOffset,
//       containerHeight,
//     );

//     if (calculatedValue != centerValue.value) {
//       if (calculatedValue >= minValue && calculatedValue <= maxValue) {
//         centerValue.value = calculatedValue;
//         lastValidCenterValue = calculatedValue;
//       }
//     }
//   }

//   @override
//   void onInit() {
//     super.onInit();
//     scrollController.addListener(_updateCenterIndex);
//     WidgetsBinding.instance.addPostFrameCallback((_) {
//       _updateCenterIndex();
//       // Scroll to initial position
//       final initialIndex = getIndexFromValue(centerValue.value);
//       final initialOffset = initialIndex * (itemHeight + itemSpacing);
//       scrollController.jumpTo(initialOffset);
//     });
//   }

//   @override
//   void onClose() {
//     scrollController.removeListener(_updateCenterIndex);
//     scrollController.dispose();
//     super.onClose();
//   }
// }

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class SelectHeightScreenController extends GetxController {
  final ScrollController scrollController = ScrollController();
  final RxDouble centerValue = 150.0.obs;
  final RxString unit = "cm".obs;

  double lastValidCenterValue = 150.0;
  double? containerHeight;

  // Ruler configuration
  double itemHeight = 20.0;
  double itemSpacing = 2.0;
  double minValue = 0.0;
  double maxValue = 250.0;
  int totalItems = 0;
  int bigDividerInterval = 5;
  double smallDividerValue = 1.0;

  bool _isInitialized = false;

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

    // Use a small delay to avoid build phase conflicts
    Future.delayed(Duration.zero, () {
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

  void toggleUnit() {
    if (unit.value == "cm") {
      unit.value = "ft";
    } else {
      unit.value = "cm";
    }
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
      final initialIndex = getIndexFromValue(initialValue);
      // Calculate offset considering the center padding
      final double centerPadding = (containerHeight! / 2) - 12.h;
      final initialOffset =
          initialIndex * (itemHeight + itemSpacing) - centerPadding;
      scrollController.jumpTo(
        initialOffset.clamp(0.0, scrollController.position.maxScrollExtent),
      );
    });
  }

  @override
  void onInit() {
    super.onInit();
    scrollController.addListener(_updateCenterIndex);
  }

  @override
  void onClose() {
    scrollController.removeListener(_updateCenterIndex);
    scrollController.dispose();
    super.onClose();
  }
}
