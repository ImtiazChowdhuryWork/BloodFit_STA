import 'package:get/get.dart';

class IgPreferedActivityLevelController extends GetxController {
  RxInt selectedIndex = (-1).obs; // -1 = none selected

  void selectLevel(int index) {
    selectedIndex.value = index;
  }
}
