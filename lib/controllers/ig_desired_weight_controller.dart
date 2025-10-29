import 'package:get/get.dart';

class IgDesiredWeightController extends GetxController {
  final selectedIndex = 0.obs;
  final selectedValue = ''.obs;

  void initialize(List<String> items, {int initialIndex = 0}) {
    if (items.isEmpty) return;
    selectedIndex.value = initialIndex;
    selectedValue.value = items[initialIndex];
  }

  void changeIndex(int index, List<String> items) {
    if (index < 0 || index >= items.length) return;
    selectedIndex.value = index;
    selectedValue.value = items[index];
  }

  String getValue() => selectedValue.value;
}
