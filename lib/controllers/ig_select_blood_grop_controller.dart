import 'package:get/get.dart';

class IgSelectBloodGropController extends GetxController {
  RxInt selectedIndex = (-1).obs;
  void getSelectedIndex({required int newValue}) {
    selectedIndex.value = newValue;
  }
}
