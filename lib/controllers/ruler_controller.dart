import 'package:flutter/material.dart';
import 'package:get/get.dart';

class RulerController extends GetxController {
  final ScrollController scrollController = ScrollController();
  final RxInt selectedValue = 0.obs;

  List<int> numbers = [];
  bool _isFixingPosition = false;

  void resetFixFlag() => _isFixingPosition = false;

  void fixScrollPosition() {
    if (_isFixingPosition) return;
    _isFixingPosition = true;

    final itemWidth = 10.0; // should match `scaleItemWidth`
    final scrollPixels = scrollController.offset;
    final index = (scrollPixels / itemWidth).round();

    scrollController.animateTo(
      index * itemWidth,
      duration: const Duration(milliseconds: 150),
      curve: Curves.easeOut,
    );
  }

  @override
  void onInit() {
    super.onInit();
    numbers = List.generate(201, (index) => index);
  }
}
