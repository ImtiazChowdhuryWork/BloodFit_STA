import 'package:get/get.dart';

class SliderButtonController extends GetxController {
  /// Reactive index
  var selectedIndex = 0.obs;

  /// Reactive selected value
  var selectedValue = 'kg'.obs;

  /// Called when user changes the index
  void changeIndex(int index, List<String> items) {
    selectedIndex.value = index;
    selectedValue.value = items[index];
  }

  @override
  void onInit() {
    super.onInit();

    // ✅ Trigger default selection logic here
    selectedIndex.value = 0;
    selectedValue.value = 'kg';
  }
}
