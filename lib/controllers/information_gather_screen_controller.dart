// import 'package:flutter/material.dart';
// import 'package:get/get.dart';

// import '../helper/logger_util.dart';
// import '../utils/page_indicator_interface.dart';

// class InformationGatherMealPlanController extends GetxController
//     implements PageIndicatorInterface {
//   final PageController pageController = PageController();

//   @override
//   final RxInt currentIndex = 0.obs;

//   @override
//   final int totalPages = 9;

//   void nextPage() {
//     if (currentIndex.value < totalPages - 1) {
//       pageController.nextPage(
//         duration: const Duration(milliseconds: 300),
//         curve: Curves.easeInOut,
//       );
//     }
//   }

//   void previousPage() {
//     if (currentIndex.value > 0) {
//       pageController.previousPage(
//         duration: const Duration(milliseconds: 300),
//         curve: Curves.easeInOut,
//       );
//     }
//   }

//   void skipToLastPage() {
//     pageController.jumpToPage(totalPages - 1);
//   }

//   void updateCurrentIndex(int index) {
//     currentIndex.value = index;
//   }

//   bool get isFirstPage => currentIndex.value == 0;
//   bool get isLastPage => currentIndex.value == totalPages - 1;

//   ///------->>> Page Status Update Code Start Here

//   // Reactive variable to trigger button rebuild when data changes
//   final RxBool _dataUpdated = false.obs;

//   // Method to trigger button update from child widgets
//   void triggerButtonUpdate() {
//     _dataUpdated.toggle(); // Toggle to trigger Obx rebuild
//     LoggerUtils.debug("Button update triggered");
//   }

//   // Getter for the reactive variable (used in Obx)
//   RxBool get dataUpdated => _dataUpdated;

//   ///------->>> Page Status Update Code Ends Here

//   @override
//   void onClose() {
//     pageController.dispose();
//     super.onClose();
//   }
// }

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../constants/app_constant_text.dart';
import '../features/information_gather_meal_plan/data/repository/information_gather_meal_repository.dart';
import '../helper/di.dart';
import '../helper/logger_util.dart';
import '../utils/page_indicator_interface.dart';

class InformationGatherMealPlanController extends GetxController
    implements PageIndicatorInterface {
  final PageController pageController = PageController();

  @override
  final RxInt currentIndex = 0.obs;

  @override
  final int totalPages = 9;

  // Reactive variable to trigger button rebuild when data changes
  final RxBool _dataUpdated = false.obs;

  // Method to trigger button update from child widgets
  void triggerButtonUpdate() {
    _dataUpdated.toggle(); // Toggle to trigger Obx rebuild
    LoggerUtils.debug("Button update triggered");
  }

  // Getter for the reactive variable (used in Obx)
  RxBool get dataUpdated => _dataUpdated;

  void nextPage() {
    if (currentIndex.value < totalPages - 1) {
      pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  void previousPage() {
    if (currentIndex.value > 0) {
      pageController.previousPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  void skipToLastPage() {
    pageController.jumpToPage(totalPages - 1);
  }

  void updateCurrentIndex(int index) {
    currentIndex.value = index;
  }

  bool get isFirstPage => currentIndex.value == 0;
  bool get isLastPage => currentIndex.value == totalPages - 1;

  @override
  void onClose() {
    pageController.dispose();
    super.onClose();
  }
}
