import 'package:get/get.dart';

class SliderButtonController extends GetxController {
  final selectedIndex = 0.obs;
  final selectedValue = ''.obs;
  bool _isInitialized = false;

  void initialize(List<String> items, {int initialIndex = 0}) {
    if (_isInitialized) return; // Prevent re-initialization

    if (items.isEmpty) return;
    selectedIndex.value = initialIndex;
    selectedValue.value = items[initialIndex];
    _isInitialized = true;
  }

  void changeIndex(int index, List<String> items) {
    if (index < 0 || index >= items.length) return;
    selectedIndex.value = index;
    selectedValue.value = items[index];
  }

  String getValue() => selectedValue.value;
}
