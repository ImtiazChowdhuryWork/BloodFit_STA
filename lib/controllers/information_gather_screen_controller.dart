// import 'package:flutter/material.dart';
// import 'package:get/get.dart';

// class InformationGatherMealPlanController extends GetxController {
//   final PageController pageController = PageController();

//   final RxInt currentIndex = 0.obs;

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
