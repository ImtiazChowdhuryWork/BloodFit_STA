import 'package:flutter/widgets.dart';
import 'package:get/get.dart';

class SignUpScreenController extends GetxController {
  TextEditingController firstNameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController contactNumberController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();

  ///Section : CheckBox
  RxBool isChecked = false.obs;
  void setCheckBoxValue({required bool newValue}) {
    isChecked.value = newValue;
  }
}
