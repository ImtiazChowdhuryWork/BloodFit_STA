

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../utils/page_indicator_interface.dart';
import '../../../../helper/logger_util.dart';

class InformationGatherWorkOutController extends GetxController
    implements PageIndicatorInterface {
  late PageController pageController;

  @override
  final RxInt currentIndex = 0.obs;

  @override
  final int totalPages = 4; // Updated to match the 4 pages in PageView

  // Reactive variable to trigger button rebuild when data changes
  final RxBool _dataUpdated = false.obs;

  // Method to trigger button update from child widgets
  void triggerButtonUpdate() {
    _dataUpdated.toggle(); // Toggle to trigger Obx rebuild
    LoggerUtils.debug("Workout button update triggered");
  }

  // Getter for the reactive variable (used in Obx)
  RxBool get dataUpdated => _dataUpdated;

  @override
  void onInit() {
    super.onInit();
    pageController = PageController();
  }

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

  /// Reset the controller state for fresh start
  void reset() {
    currentIndex.value = 0;
    if (pageController.hasClients) {
      pageController.jumpToPage(0);
    }
  }

  @override
  void onClose() {
    pageController.dispose();
    super.onClose();
  }
}
