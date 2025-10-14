import 'package:get/get.dart';

class SliderButtonController extends GetxController {
  var selectedIndex = 0.obs;

  void changeIndex(int index) {
    selectedIndex.value = index;
  }

  /// Get selected value from a list
  String selectedValue(List<String> items) {
    return items[selectedIndex.value];
  }
}
