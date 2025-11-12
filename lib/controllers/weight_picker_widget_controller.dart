import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class WeightController extends GetxController {
  // current selected weight value
  RxDouble currentWeight = 60.0.obs;

  // current selected unit (true = lb, false = kg)
  RxBool isLbSelected = false.obs;

  String get unit => isLbSelected.value ? "lb" : "kg";

  void updateWeight(double value) {
    currentWeight.value = value;
  }

  void toggleUnit() {
    isLbSelected.value = !isLbSelected.value;
  }

  ///Section : Weight Controller
  final ScrollController scrollController = ScrollController();
  final RxDouble centerValue = 1.0.obs; // Change default to 1.0
  double lastValidCenterValue = 1.0;

  // Make these instance variables instead of static constants
  double itemWidth = 2;
  double itemSpacing = 10;
  double minValue = 1.0; // Change minValue to 1.0
  double maxValue = 99;
  int totalItems = 0; // Will be calculated
  int bigDividerInterval = 5; // Every 5 small dividers = 1 big divider
  double smallDividerValue = 0.2; // Each small divider represents 0.2

  // Method to initialize with custom values
  void initializeRuler({
    double? itemWidth,
    double? itemSpacing,
    double? minValue,
    double? maxValue,
    int? bigDividerInterval,
    double? smallDividerValue,
  }) {
    this.itemWidth = itemWidth ?? this.itemWidth;
    this.itemSpacing = itemSpacing ?? this.itemSpacing;
    this.minValue = minValue ?? 1.0; // Ensure minValue is at least 1.0
    this.maxValue = maxValue ?? this.maxValue;
    this.bigDividerInterval = bigDividerInterval ?? this.bigDividerInterval;
    this.smallDividerValue = smallDividerValue ?? this.smallDividerValue;

    // Calculate total items based on min and max values
    double totalRange = this.maxValue - this.minValue;
    int bigDividerCount =
        (totalRange ~/ (this.bigDividerInterval * this.smallDividerValue))
            .toInt() +
        1;
    totalItems = bigDividerCount * this.bigDividerInterval;

    // Reset center value to min value (which is now 1.0)
    centerValue.value = this.minValue;

    update(); // Notify listeners
  }

  // Computed values
  double get computedItemWidth => itemWidth.sp;
  double get computedItemSpacing => itemSpacing.w;

  // Helper methods to get value from index and vice versa
  double getValueFromIndex(int index) {
    return minValue + (index * smallDividerValue);
  }

  int getIndexFromValue(double value) {
    return ((value - minValue) / smallDividerValue).round();
  }

  bool isBigDivider(int itemIndex) {
    return itemIndex % bigDividerInterval == 0;
  }

  String getDisplayValue(int itemIndex) {
    double value = getValueFromIndex(itemIndex);
    if (isBigDivider(itemIndex)) {
      return value.toInt().toString(); // Show whole numbers for big dividers
    } else {
      return value.toStringAsFixed(1); // Show decimal for small dividers
    }
  }

  @override
  void onInit() {
    super.onInit();
    scrollController.addListener(_updateCenterIndex);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _updateCenterIndex();
    });
  }

  bool isIndexCentered(int index, double scrollOffset, double containerWidth) {
    final double centerX = containerWidth / 2;
    final double centerPadding = containerWidth / 2;
    final double itemCenter =
        centerPadding +
        index * (computedItemWidth + computedItemSpacing) +
        (computedItemWidth / 2);
    final double visibleItemCenter = itemCenter - scrollOffset;
    return (visibleItemCenter - centerX).abs() <= (computedItemWidth / 2);
  }

  double getCenteredValue(double scrollOffset, double containerWidth) {
    for (int i = 0; i < totalItems; i++) {
      if (isIndexCentered(i, scrollOffset, containerWidth)) {
        return getValueFromIndex(i);
      }
    }
    return -1; // Return -1 when no item is centered
  }

  void _updateCenterIndex() {
    final double scrollOffset = scrollController.offset;
    final double containerWidth = 1.sw - 20.sp;
    final double calculatedValue = getCenteredValue(
      scrollOffset,
      containerWidth,
    );

    if (calculatedValue != centerValue.value) {
      // Only update centerValue if we found a valid centered item
      // Otherwise keep the last valid value
      if (calculatedValue >= minValue && calculatedValue <= maxValue) {
        centerValue.value = calculatedValue;
        lastValidCenterValue = calculatedValue; // Update last valid value
      } else {
        // When between items, use the last valid centered value
        centerValue.value = lastValidCenterValue;
      }
    }
  }

  @override
  void onClose() {
    scrollController.removeListener(_updateCenterIndex);
    scrollController.dispose();
    super.onClose();
  }
}
