import 'dart:developer';

import 'package:flutter/widgets.dart';
import 'package:get/get.dart';

class SignInScreenController extends GetxController {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  ///Section : password visibility
  RxBool isPasswordVisible = false.obs;
  void setPasswordVisibility() {
    isPasswordVisible.value = !isPasswordVisible.value;
  }

  ///Section : ------///CheckBox///
  RxBool isChecked = false.obs;

  void setCheckBoxValue({required bool newValue}) {
    isChecked.value = newValue;
  }
}
