import 'package:flutter/widgets.dart';
import 'package:get/get.dart';

class ViewProfileSubscriptionTypeFreeScreenController extends GetxController {
  TextEditingController firstName = TextEditingController();
  TextEditingController lastName = TextEditingController();
  TextEditingController emailAddress = TextEditingController();
  TextEditingController contactNumber = TextEditingController();

  RxBool isEditModeOn = false.obs;
  void setEditMode() {
    isEditModeOn.value = !isEditModeOn.value;
  }
}
