import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SignUpScreenController extends GetxController {
  // Text Editing Controllers
  TextEditingController firstNameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController contactNumberController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();

  // Reactive States
  RxBool isChecked = false.obs;
  RxBool isLoading = false.obs;
  var errorMessage = ''.obs;

  void setCheckBoxValue({required bool newValue}) {
    isChecked.value = newValue;
  }

  // Validation method
  String? validateFields() {
    if (firstNameController.text.isEmpty) {
      return "Please enter your first name";
    }
    if (lastNameController.text.isEmpty) {
      return "Please enter your last name";
    }
    if (emailController.text.isEmpty) {
      return "Please enter your email";
    }
    if (!GetUtils.isEmail(emailController.text)) {
      return "Please enter a valid email";
    }
    if (contactNumberController.text.isEmpty) {
      return "Please enter your contact number";
    }
    if (passwordController.text.isEmpty) {
      return "Please enter your password";
    }
    if (passwordController.text.length < 6) {
      return "Password must be at least 6 characters";
    }
    if (confirmPasswordController.text.isEmpty) {
      return "Please confirm your password";
    }
    if (passwordController.text != confirmPasswordController.text) {
      return "Passwords do not match";
    }
    if (!isChecked.value) {
      return "Please agree to the terms & conditions";
    }
    return null;
  }

  @override
  void onClose() {
    // Clean up controllers
    firstNameController.dispose();
    lastNameController.dispose();
    emailController.dispose();
    contactNumberController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.onClose();
  }
}

// ✅ HELPER METHOD TO EXTRACT TOKENS FROM HEADERS
String? _extractToken(Map<String, dynamic> headers, String tokenName) {
  try {
    if (headers.containsKey(tokenName)) {
      final tokenHeader = headers[tokenName];
      if (tokenHeader is List && tokenHeader.isNotEmpty) {
        return tokenHeader.first;
      } else if (tokenHeader is String) {
        return tokenHeader;
      }
    }
    return null;
  } catch (e) {
    log("⚠️ Error extracting $tokenName: $e");
    return null;
  }
}
