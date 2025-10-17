import 'package:get/get.dart';

class EditProfileScreenController extends GetxController {
  // Selected blood group
  final selectedBlood = RxnString();

  void setBloodGroup(String? value) {
    selectedBlood.value = value;
  }

  ///Select Gender
  final selectdGender = RxnString();

  void setGenderType(String? value) {
    selectdGender.value = value;
  }

  ///Height dropdown
  final selectedHeight = RxnString();
  void setUserHeight(String? value) {
    selectedHeight.value = value;
  }

  ///Weight dropdown
  final selectedWeight = RxnString();
  void setUserWeight(String? value) {
    selectedWeight.value = value;
  }
}
