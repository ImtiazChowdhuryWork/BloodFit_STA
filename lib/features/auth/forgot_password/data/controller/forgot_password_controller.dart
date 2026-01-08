import 'package:get/get.dart';
import 'package:flutter/material.dart';

class ForgotPasswordController extends GetxController {
  TextEditingController accountEmail = TextEditingController();

  // Reactive States
  RxBool isLoading = false.obs;
  var errorMessage = ''.obs;

  // Validation method
  String? validateEmail() {
    if (accountEmail.text.isEmpty) {
      return "Please enter your email";
    }
    if (!GetUtils.isEmail(accountEmail.text)) {
      return "Please enter a valid email";
    }
    return null;
  }

  @override
  void onClose() {
    accountEmail.dispose();
    super.onClose();
  }
}
