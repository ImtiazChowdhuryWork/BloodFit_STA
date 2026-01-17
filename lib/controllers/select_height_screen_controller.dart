import 'package:flutter/material.dart';
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
