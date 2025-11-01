import 'package:get/get.dart';

class IgSelectGenderScreenController extends GetxController {
  RxInt selectedGenderIndex = (-1).obs;
  void setSelectedGenderIndex({required int newValue}) {
    selectedGenderIndex.value = newValue;
  }
}
