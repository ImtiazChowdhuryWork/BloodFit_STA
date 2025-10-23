// import 'package:get/get.dart';

// class ChooseFromOurSuggestedMealController extends GetxController {
//   RxBool isCheckBoxSelected = false.obs;
//   void setIsCheckBoxSelectedValue({
//     required int index,
//     required bool newValue,
//   }) {
//     isCheckBoxSelected.value = newValue;
//   }
// }

import 'package:get/get.dart';

class ChooseFromOurSuggestedMealController extends GetxController {
  // Each tab/item has a checkbox
  RxList<RxBool> isCheckBoxSelectedList = List.generate(
    10,
    (_) => false.obs,
  ).obs;

  void setIsCheckBoxSelectedValue(int index, bool value) {
    isCheckBoxSelectedList[index].value = value;
  }
}
