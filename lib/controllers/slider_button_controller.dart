import 'package:get/get.dart';

class SliderButtonController extends GetxController {
  /// Reactive index and value
  final selectedIndex = 0.obs;
  final selectedValue = ''.obs;

  /// Optional default setup (for reuse)
  void initialize(List<String> items, {int initialIndex = 0}) {
    if (items.isEmpty) return;
    selectedIndex.value = initialIndex;
    selectedValue.value = items[initialIndex];
  }

  /// Change handler when user taps
  void changeIndex(int index, List<String> items) {
    if (index < 0 || index >= items.length) return;
    selectedIndex.value = index;
    selectedValue.value = items[index];
  }

  /// Getter for safe access
  String getValue() => selectedValue.value;
}
