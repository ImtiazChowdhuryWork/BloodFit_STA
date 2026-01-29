import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../../../../../constants/app_constant_text.dart';
import '../../../../../../../controllers/information_gather_screen_controller.dart';
import '../../../../../../../controllers/weight_picker_widget_controller.dart';
import '../../../../../../../helper/di.dart';
import '../../../../../../../helper/logger_util.dart';

class IgSelectDesiredWeightWidgetController extends GetxController {
  // current selected weight value
  RxDouble currentWeight = 60.0.obs;

  // current selected unit (true = lb, false = kg)
  RxBool isLbSelected = false.obs;

  // Track if user has interacted with the weight picker
  final RxBool hasUserInteracted = false.obs;

  ///Section : Weight Controller
  final ScrollController scrollController = ScrollController();
  final RxDouble centerValue = 1.0.obs; // Change default to 1.0
  double lastValidCenterValue = 1.0;

  // For debouncing save operations
  Timer? _debounceTimer;
  double _lastContainerWidth = 0;

  // Make these instance variables instead of static constants
  double itemWidth = 2;
  double itemSpacing = 10;
  double minValue = 1.0; // Change minValue to 1.0
  double maxValue = 99;
  int totalItems = 0; // Will be calculated
  int bigDividerInterval = 5; // Every 5 small dividers = 1 big divider
  double smallDividerValue = 0.2; // Each small divider represents 0.2

  String get unit => isLbSelected.value ? "lb" : "kg";

  void updateWeight(double value) {
    currentWeight.value = value;
  }

  void toggleUnit() {
    isLbSelected.value = !isLbSelected.value;
    // Save when unit changes
    saveWeightAndUnit();
  }

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

    // Initialize with default values first
    initializeRuler();

    scrollController.addListener(_onScroll);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _updateCenterIndex();
    });

    // Load saved weight when controller initializes
    loadSavedWeight();
  }

  void _onScroll() {
    // Check if scroll controller is attached to any scroll views before accessing
    if (!scrollController.hasClients) return;

    _updateCenterIndex();

    // Debounce saving - save when scrolling stops
    _debounceTimer?.cancel();
    _debounceTimer = Timer(const Duration(milliseconds: 300), () {
      // Check again if controller is still valid when timer executes
      if (_lastContainerWidth > 0 &&
          Get.isRegistered<IgSelectDesiredWeightWidgetController>()) {
        saveWeightAndUnit();
      }
    });
  }

  /// Set container width for calculations
  void setContainerWidth(double width) {
    _lastContainerWidth = width;
  }

  /// Load saved weight from storage
  void loadSavedWeight() {
    try {
      // final savedWeightWithUnit = appData.read(kKeyUserWeight);
      final savedWeightWithUnit = appData.read(kKeyDesiredWeight);
      // final savedWeightWithoutUnit = appData.read(kKeyUserWeightWithoutUnit);
      final savedWeightWithoutUnit = appData.read(kKeyDesiredWeightWithoutUnit);
      // final savedUnit = appData.read('${kKeyUserWeight}_unit');
      final savedUnit = appData.read('${kKeyDesiredWeight}_unit');

      bool hasValidSavedData = false;
      double weightToDisplay = 60.0; // Default for display only

      if (savedWeightWithUnit != null || savedWeightWithoutUnit != null) {
        double? weightWithUnit;
        double? weightWithoutUnit;

        // Try to parse both values
        if (savedWeightWithUnit != null) {
          weightWithUnit = double.tryParse(savedWeightWithUnit.toString());
        }

        if (savedWeightWithoutUnit != null) {
          weightWithoutUnit = double.tryParse(
            savedWeightWithoutUnit.toString(),
          );
        }

        // Priority: Use weight with unit if available, else use weight without unit
        if (weightWithUnit != null) {
          weightToDisplay = weightWithUnit;
          hasValidSavedData = true;
        } else if (weightWithoutUnit != null) {
          weightToDisplay = weightWithoutUnit;
          hasValidSavedData = true;
        }

        // Check what unit was last selected for display
        if (savedUnit == 'lb') {
          isLbSelected.value = true;
        } else {
          isLbSelected.value = false;
        }

        // Mark that user has interacted if we have saved data
        if (hasValidSavedData) {
          hasUserInteracted.value = true;
        }
      }

      // If we have valid saved data, use it for display
      if (hasValidSavedData) {
        // Ensure weight is within range
        if (weightToDisplay >= minValue && weightToDisplay <= maxValue) {
          // Set the weight for display
          centerValue.value = weightToDisplay;
          currentWeight.value = weightToDisplay;

          // Scroll to saved weight position
          WidgetsBinding.instance.addPostFrameCallback((_) {
            // Check if scroll controller is still attached before accessing
            if (!scrollController.hasClients) return;

            final index = getIndexFromValue(weightToDisplay);
            final scrollPosition =
                index * (computedItemWidth + computedItemSpacing);
            scrollController.jumpTo(scrollPosition);
          });

          LoggerUtils.debug(
            "Loaded saved desired weight: $weightToDisplay ${isLbSelected.value ? 'lb' : 'kg'} (User has interacted: ${hasUserInteracted.value})",
          );
        }
      } else {
        // No valid saved weight - set default for display only
        WidgetsBinding.instance.addPostFrameCallback((_) {
          // Check if scroll controller is still attached before accessing
          if (!scrollController.hasClients) return;

          // Set default weight for display only
          centerValue.value = weightToDisplay;
          currentWeight.value = weightToDisplay;
          isLbSelected.value = false;

          // Scroll to default position
          final index = getIndexFromValue(weightToDisplay);
          final scrollPosition =
              index * (computedItemWidth + computedItemSpacing);
          scrollController.jumpTo(scrollPosition);

          LoggerUtils.debug(
            "No saved desired weight found. Set display default: $weightToDisplay kg (User has NOT interacted)",
          );
        });
      }
    } catch (e) {
      LoggerUtils.error("Error loading weight: $e");

      // Fallback to default on error
      WidgetsBinding.instance.addPostFrameCallback((_) {
        // Check if scroll controller is still attached before accessing
        if (!scrollController.hasClients) return;

        centerValue.value = 60.0;
        currentWeight.value = 60.0;
        isLbSelected.value = false;
      });
    }
  }

  /// Save weight and unit to storage
  void saveWeightAndUnit() {
    try {
      // Mark that user has interacted
      hasUserInteracted.value = true;

      final double selectedValue = centerValue.value;
      final String selectedUnit = isLbSelected.value ? 'lb' : 'kg';

      double weightToSaveInKg;
      double weightToSaveWithUnit = selectedValue; // Exact value user sees

      if (selectedUnit == 'lb') {
        // Convert lb to kg (1 lb = 0.453592 kg)
        weightToSaveInKg = selectedValue * 0.453592;
      } else {
        // Already in kg, no conversion needed
        weightToSaveInKg = selectedValue;
      }

      // Save TWO values to local storage:

      // 1. WITH UNIT: The exact value user sees (e.g., 150 lb or 70 kg)
      // appData.write(kKeyUserWeight, weightToSaveWithUnit);
      appData.write(kKeyDesiredWeight, weightToSaveWithUnit);

      // 2. WITHOUT UNIT: Always in kg (converted if needed)
      // appData.write(kKeyUserWeightWithoutUnit, weightToSaveInKg);
      appData.write(kKeyDesiredWeightWithoutUnit, weightToSaveInKg);

      // Also save the unit user selected (for UI display when loading)
      // appData.write('${kKeyUserWeight}_unit', selectedUnit);
      appData.write('${kKeyDesiredWeight}_unit', selectedUnit);

      currentWeight.value = selectedValue; // Keep UI value as is

      ///----------->>> Update the controller
      Get.find<InformationGatherMealPlanController>().triggerButtonUpdate();

      LoggerUtils.debug(
        "Saved desired weight - WithUnit: $weightToSaveWithUnit $selectedUnit, WithoutUnit: $weightToSaveInKg kg (User interaction recorded)",
      );
    } catch (e) {
      LoggerUtils.error("Error saving desired weight: $e");
    }
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
    // Check if scroll controller is attached to any scroll views before accessing
    if (!scrollController.hasClients) return;

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
    _debounceTimer?.cancel(); // Cancel timer
    scrollController.removeListener(_onScroll);
    scrollController.dispose();
    super.onClose();
  }
}
