// import 'package:bloodfit/constants/app_constant_text.dart';
// import 'package:bloodfit/helper/di.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';

// class IgAgePickerScreenController extends GetxController {
//   final ScrollController scrollController = ScrollController();
//   final RxDouble currentScroll = 0.0.obs;

//   final double itemWidth;
//   final double itemSpacing;
//   final int minValue;
//   final int maxValue;

//   late final List<int> numbers;

//   IgAgePickerScreenController({
//     required this.itemWidth,
//     required this.minValue,
//     required this.maxValue,
//     this.itemSpacing = 12,
//   });

//   @override
//   void onInit() {
//     super.onInit();
//     numbers = List.generate(maxValue - minValue + 1, (index) {
//       return combineMinValueAndIndex(minValue: minValue, indexValue: index);
//     });

//     scrollController.addListener(() {
//       currentScroll.value = scrollController.offset;
//     });
//   }

//   bool isIndexCentered(int index, double scrollOffset, double containerWidth) {
//     final horizontalPadding = (containerWidth - (itemWidth + itemSpacing)) / 2;
//     final centerX = containerWidth / 2;
//     final itemCenter =
//         horizontalPadding +
//         index * (itemWidth + itemSpacing) +
//         (itemWidth / 2) -
//         scrollOffset;
//     return (itemCenter - centerX).abs() <= (itemWidth / 2);
//   }

//   /// Returns currently centered index
//   int getCenteredIndex(double scrollOffset, double containerWidth) {
//     for (int i = 0; i < numbers.length; i++) {
//       if (isIndexCentered(i, scrollOffset, containerWidth)) return i;
//     }
//     return 0;
//   }

//   int combineMinValueAndIndex({
//     required int minValue,
//     required int indexValue,
//   }) {
//     int combinedValue = minValue + indexValue;
//     return combinedValue;
//   }

//   @override
//   void onClose() {
//     scrollController.dispose();
//     super.onClose();
//   }
// }

import 'package:bloodfit/controllers/information_gather_screen_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dart:async'; // Add this import

import '../constants/app_constant_text.dart';
import '../helper/di.dart';
import '../helper/logger_util.dart';

class IgAgePickerScreenController extends GetxController {
  final ScrollController scrollController = ScrollController();
  final RxDouble currentScroll = 0.0.obs;

  final double itemWidth;
  final double itemSpacing;
  final int minValue;
  final int maxValue;

  late final List<int> numbers;
  RxInt selectedAge = 0.obs;

  Timer? _debounceTimer; // Add debounce timer
  double _lastContainerWidth = 0; // Store container width

  IgAgePickerScreenController({
    required this.itemWidth,
    required this.minValue,
    required this.maxValue,
    this.itemSpacing = 12,
  });

  @override
  void onInit() {
    super.onInit();
    numbers = List.generate(maxValue - minValue + 1, (index) {
      return combineMinValueAndIndex(minValue: minValue, indexValue: index);
    });

    // Add scroll listener for auto-saving
    scrollController.addListener(_onScroll);

    // Load saved age if exists
    loadSavedAge();
  }

  void _onScroll() {
    // Check if scroll controller is attached to any scroll views before accessing
    if (!scrollController.hasClients) return;

    currentScroll.value = scrollController.offset;

    // Debounce saving - only save when scrolling stops
    _debounceTimer?.cancel();
    _debounceTimer = Timer(const Duration(milliseconds: 300), () {
      // Check again if controller is still valid when timer executes
      if (_lastContainerWidth > 0 && Get.isRegistered<IgAgePickerScreenController>()) {
        final age = getCenteredAge(currentScroll.value, _lastContainerWidth);
        saveAge(age);
      }
    });
  }

  /// Set container width for calculations
  void setContainerWidth(double width) {
    _lastContainerWidth = width;
  }

  /// Load saved age from storage
  void loadSavedAge() {
    try {
      final savedAge = appData.read(kKeyUserAge);
      if (savedAge != null) {
        final age = int.tryParse(savedAge.toString());
        if (age != null && age >= minValue && age <= maxValue) {
          // Find index of saved age
          final index = numbers.indexOf(age);
          if (index != -1) {
            // Scroll to saved age position
            WidgetsBinding.instance.addPostFrameCallback((_) {
              // Check if scroll controller is still attached before accessing
              if (!scrollController.hasClients) return;

              final scrollPosition = index * (itemWidth + itemSpacing);
              scrollController.jumpTo(scrollPosition);
              selectedAge.value = age;
            });
            LoggerUtils.debug("Loaded saved age: $age");
          }
        }
      }
    } catch (e) {
      LoggerUtils.error("Error loading age: $e");
    }
  }

  /// Save age to storage
  void saveAge(int age) {
    try {
      appData.write(kKeyUserAge, age);

      ///----------->>> Update the controller
      Get.find<InformationGatherMealPlanController>().triggerButtonUpdate();
      selectedAge.value = age;
      LoggerUtils.debug("Saved age: $age");
    } catch (e) {
      LoggerUtils.error("Error saving age: $e");
    }
  }

  bool isIndexCentered(int index, double scrollOffset, double containerWidth) {
    final horizontalPadding = (containerWidth - (itemWidth + itemSpacing)) / 2;
    final centerX = containerWidth / 2;
    final itemCenter =
        horizontalPadding +
        index * (itemWidth + itemSpacing) +
        (itemWidth / 2) -
        scrollOffset;
    return (itemCenter - centerX).abs() <= (itemWidth / 2);
  }

  /// Returns currently centered index
  int getCenteredIndex(double scrollOffset, double containerWidth) {
    for (int i = 0; i < numbers.length; i++) {
      if (isIndexCentered(i, scrollOffset, containerWidth)) return i;
    }
    return 0;
  }

  /// Get currently centered age
  int getCenteredAge(double scrollOffset, double containerWidth) {
    // Check if scroll controller is attached to any scroll views before accessing
    if (!scrollController.hasClients) return selectedAge.value;

    final index = getCenteredIndex(scrollOffset, containerWidth);
    return numbers[index];
  }

  int combineMinValueAndIndex({
    required int minValue,
    required int indexValue,
  }) {
    int combinedValue = minValue + indexValue;
    return combinedValue;
  }

  @override
  void onClose() {
    _debounceTimer?.cancel(); // Cancel timer
    scrollController.dispose();
    super.onClose();
  }
}
