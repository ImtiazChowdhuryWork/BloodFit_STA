import 'package:get/get.dart';

class SelectDietController extends GetxController {
  /// Holds the selected index (-1 means none selected yet)
  final RxInt selectedIndex = (-1).obs;

  /// Update selected diet index
  void selectDiet(int index) {
    selectedIndex.value = index;
  }
}
