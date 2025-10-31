import 'package:get/get.dart';

class IgWorkoutFocusAreaController extends GetxController {
  ///Section : Body Part -> Arms
  RxBool isArmsSelected = false.obs;
  void setArmsSelection() {
    if (isArmsSelected.value == true) {
      isArmsSelected.value = false;
    } else if (isArmsSelected.value == false) {
      isArmsSelected.value = true;
    } else {
      return;
    }
  }

  ///Section : Body Part -> UpperBody
  RxBool isUpperBodySelected = false.obs;
  void setUpperBodySelection() {
    if (isUpperBodySelected.value == true) {
      isUpperBodySelected.value = false;
    } else if (isUpperBodySelected.value == false) {
      isUpperBodySelected.value = true;
    } else {
      return;
    }
  }
}
