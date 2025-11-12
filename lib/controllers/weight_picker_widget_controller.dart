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
  final RxInt centerIndex = 0.obs;
  int lastValidCenterIndex = 0;

  // Constants - make them public
  static const double itemWidth = 2;
  static const double itemSpacing = 10;
  static const int minValue = 0;
  static const int maxValue = 99;
  static const int totalItems = 100;
  static const int bigDividerInterval = 5;

  // Computed values
  double get computedItemWidth => itemWidth.sp;
  double get computedItemSpacing => itemSpacing.w;

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

  int getCenteredIndex(double scrollOffset, double containerWidth) {
    for (int i = 0; i < totalItems; i++) {
      if (isIndexCentered(i, scrollOffset, containerWidth)) return i;
    }
    return -1; // Return -1 when no item is centered
  }

  void _updateCenterIndex() {
    final double scrollOffset = scrollController.offset;
    final double containerWidth = 1.sw - 20.sp;
    final int calculatedIndex = getCenteredIndex(scrollOffset, containerWidth);

    if (calculatedIndex != centerIndex.value) {
      // Only update centerIndex if we found a valid centered item
      // Otherwise keep the last valid value
      if (calculatedIndex >= 0) {
        centerIndex.value = calculatedIndex;
        lastValidCenterIndex = calculatedIndex; // Update last valid value
      } else {
        // When between items, use the last valid centered index
        centerIndex.value = lastValidCenterIndex;
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
