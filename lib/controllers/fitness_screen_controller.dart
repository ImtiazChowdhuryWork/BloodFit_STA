import 'package:get/get.dart';

class FitnessScreenController extends GetxController {
  ///User Body Shape
  final selectedBodyShape = RxnString();
  void setUserBodyShape(String? value) {
    selectedBodyShape.value = value;
  }

  ///User Activity Level
  final selectedActivictyLevel = RxnString();
  void setUserActivityLevel(String? value) {
    selectedActivictyLevel.value = value;
  }

  ///User WorkOut Level
  final selectedWorkOutLevel = RxnString();
  void setUserWorkOutLevel(String? value) {
    selectedWorkOutLevel.value = value;
  }

  ///User WorkOut Goal
  final selectedWorkOutGoal = RxnString();
  void setUserWorkOutGoal(String? value) {
    selectedWorkOutGoal.value = value;
  }

  ///User Desired Weight
  final selectedDesiredWeight = RxnString();
  void setUserDesiredWeight(String? value) {
    selectedDesiredWeight.value = value;
  }

  ///User Desired Weight
  final selectedFocusArea = RxnString();
  void setUserFocusArea(String? value) {
    selectedDesiredWeight.value = value;
  }
}
