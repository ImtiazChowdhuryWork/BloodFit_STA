import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../../../../../constants/validator.dart';

class SignInScreenController extends GetxController {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  /// Section: password visibility
  RxBool isPasswordVisible = false.obs;
  void setPasswordVisibility() {
    isPasswordVisible.value = !isPasswordVisible.value;
  }

  /// Section: CheckBox
  RxBool isChecked = false.obs;
  void setCheckBoxValue({required bool newValue}) {
    isChecked.value = newValue;
  }

  var isLoading = false.obs;
  var errorMessage = ''.obs;

  /// Form validation using external validators
  String? validateForm() {
    final emailError = emailValidator(emailController.text);
    if (emailError != null) return emailError;

    final passwordError = passwordValidator(passwordController.text);
    if (passwordError != null) return passwordError;

    return null;
  }

  void clearError() {
    errorMessage.value = '';
  }

  @override
  void onClose() {
    emailController.clear();
    passwordController.clear();
    super.onClose();
  }
}
