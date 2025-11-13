import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SelectHeightScreenController extends GetxController {
  // Scroll controller for the ruler
  final ScrollController scrollController = ScrollController();

  // Reactive values
  final RxDouble centerValue = 0.0.obs;
  final RxString unit = 'cm'.obs;
  final RxBool isLbSelected = false.obs;

  // Ruler configuration
  double minValue = 50.0; // Typical minimum height in cm
  double maxValue = 250.0; // Typical maximum height in cm
  double smallDividerValue = 0.5; // Each small divider = 0.5 cm
  int bigDividerInterval = 2; // Every 2 small dividers = 1 big divider (1.0 cm)

  // Calculated properties
  int get totalItems => ((maxValue - minValue) / smallDividerValue).round();
  double get totalScrollExtent => totalItems * 20.0; // 20.h per item

  @override
  void onInit() {
    super.onInit();
    _setupScrollListener();
  }

  @override
  void onClose() {
    scrollController.dispose();
    super.onClose();
  }

  // Initialize ruler with custom values
  void initializeRuler({
    required double minValue,
    required double maxValue,
    required double smallDividerValue,
    required int bigDividerInterval,
    String unit = 'cm',
  }) {
    this.minValue = minValue;
    this.maxValue = maxValue;
    this.smallDividerValue = smallDividerValue;
    this.bigDividerInterval = bigDividerInterval;
    this.unit.value = unit;

    // Set initial center value to middle of range
    final double initialValue = (minValue + maxValue) / 2;
    centerValue.value = double.parse(initialValue.toStringAsFixed(1));

    // Calculate initial scroll position
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollToValue(initialValue);
    });
  }

  // Set up scroll listener to update center value
  void _setupScrollListener() {
    scrollController.addListener(() {
      _updateCenterValueFromScroll();
    });
  }

  // Update center value based on scroll position
  void _updateCenterValueFromScroll() {
    final double scrollOffset = scrollController.offset;
    final double itemHeight = 20.0; // 20.h per divider item

    // Calculate the current value based on scroll position
    final double scrollProgress = scrollOffset / itemHeight;
    final double currentValue = maxValue - (scrollProgress * smallDividerValue);

    // Clamp the value between min and max
    final double clampedValue = currentValue.clamp(minValue, maxValue);

    // Update center value with one decimal precision
    centerValue.value = double.parse(clampedValue.toStringAsFixed(1));
  }

  // Scroll to a specific value
  void _scrollToValue(double value) {
    if (!scrollController.hasClients) return;

    // Clamp the value between min and max
    final double clampedValue = value.clamp(minValue, maxValue);

    // Calculate scroll position
    final double valueOffset = (maxValue - clampedValue) / smallDividerValue;
    final double scrollPosition = valueOffset * 20.0; // 20.h per item

    scrollController.animateTo(
      scrollPosition,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeOut,
    );
  }

  // Programmatically set value
  void setValue(double value) {
    final double clampedValue = value.clamp(minValue, maxValue);
    centerValue.value = double.parse(clampedValue.toStringAsFixed(1));
    _scrollToValue(clampedValue);
  }

  // Increment value by small divider amount
  void increment() {
    final double newValue = centerValue.value + smallDividerValue;
    if (newValue <= maxValue) {
      setValue(newValue);
    }
  }

  // Decrement value by small divider amount
  void decrement() {
    final double newValue = centerValue.value - smallDividerValue;
    if (newValue >= minValue) {
      setValue(newValue);
    }
  }

  // Change unit (cm/ft)
  void changeUnit(String newUnit) {
    unit.value = newUnit;
    isLbSelected.value = (newUnit == "ft");

    // Convert the current value when unit changes
    if (newUnit == "ft") {
      // Convert cm to feet for display
      // The ruler still works in cm internally
    } else {
      // Convert back to cm if needed
    }
  }

  // Get current value with proper formatting
  String get formattedValue => centerValue.value.toStringAsFixed(1);

  // Check if a given item index is a big divider
  bool isBigDivider(int itemIndex) {
    return itemIndex % bigDividerInterval == 0;
  }

  // Get value for a specific item index
  double getValueForIndex(int itemIndex) {
    return minValue + (itemIndex * smallDividerValue);
  }

  // Reset to default value (middle of range)
  void reset() {
    final double defaultValue = (minValue + maxValue) / 2;
    setValue(defaultValue);
  }

  // Convert height to feet and inches
  double convertToFeet() {
    // Convert cm to feet: 1 cm = 0.0328084 feet
    return centerValue.value * 0.0328084;
  }

  String getFormattedFeetInches() {
    final double totalFeet = convertToFeet();
    final int feet = totalFeet.floor();
    final int inches = ((totalFeet - feet) * 12).round();

    // Format as "6ft 9in"
    return "${feet}ft ${inches}in";
  }

  // Dispose method for cleanup
  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }
}
