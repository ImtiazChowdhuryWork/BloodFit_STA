import 'package:flutter/material.dart';
import 'package:get/get.dart';

class OnboardingAgePickerScreenController extends GetxController {
  final ScrollController scrollController = ScrollController();
  final RxDouble currentScroll = 0.0.obs;

  final double itemWidth;
  final double itemSpacing;
  final int minValue;
  final int maxValue;

  late final List<int> numbers;

  OnboardingAgePickerScreenController({
    required this.itemWidth,
    required this.minValue,
    required this.maxValue,
    this.itemSpacing = 12,
  });

  @override
  void onInit() {
    super.onInit();
    numbers = List.generate(
      maxValue - minValue + 1,
      (index) => minValue + index,
    );

    scrollController.addListener(() {
      currentScroll.value = scrollController.offset;
    });
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

  @override
  void onClose() {
    scrollController.dispose();
    super.onClose();
  }
}
