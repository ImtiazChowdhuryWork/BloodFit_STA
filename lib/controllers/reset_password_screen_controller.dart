import 'dart:developer';

import 'package:bloodfit/helper/logger_util.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

class ResetPasswordScreenController extends GetxController {
  late String otpToken;
  RxBool isLoading = false.obs;
  var errorMessage = ''.obs;

  @override
  void onInit() {
    super.onInit();
    // Get token from route arguments
    otpToken = Get.arguments?['token'] ?? '';
    log('Token received for OTP verification: $otpToken');

    if (otpToken.isEmpty) {
      LoggerUtils.error('OTP Token not found. Please try again.');
      Get.back();
    }
  }

  TextEditingController newPasswordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();

  ///Section : New Password Visibility
  RxBool isNewPasswordVisible = false.obs;
  void setNewPasswordVisibility() {
    isNewPasswordVisible.value = !isNewPasswordVisible.value;
  }

  ///Section : Confirm New Password Visibility
  RxBool isConfirmNewPasswordVisible = false.obs;
  void setConfirmNewPasswordVisibility() {
    isConfirmNewPasswordVisible.value = !isConfirmNewPasswordVisible.value;
  }

  // Password validation methods
  String? validateNewPassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter new password';
    }
    if (value.length < 8) {
      return 'Password must be at least 8 characters long';
    }
    return null;
  }

  String? validateConfirmPassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please confirm your password';
    }
    if (value != newPasswordController.text) {
      return 'Passwords do not match';
    }
    return null;
  }

  void validateSamePassword() {
    if (newPasswordController.text != confirmPasswordController.text) {
      errorMessage.value = 'Passwords do not match';
      LoggerUtils.error('Passwords do not match');
    } else {
      errorMessage.value = '';
    }
  }

  // Check if form is valid
  bool isFormValid() {
    final newPasswordError = validateNewPassword(newPasswordController.text);
    final confirmPasswordError = validateConfirmPassword(
      confirmPasswordController.text,
    );

    return newPasswordError == null &&
        confirmPasswordError == null &&
        newPasswordController.text == confirmPasswordController.text;
  }

  @override
  void onClose() {
    newPasswordController.dispose();
    confirmPasswordController.dispose();
    super.onClose();
  }
}
