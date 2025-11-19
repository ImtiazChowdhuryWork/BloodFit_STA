import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../networks/exception_handler/data_source.dart';
import '../repositories/sign_up_repository.dart';
import '../routes/routes.dart';

class SignUpScreenController extends GetxController {
  // Text Editing Controllers
  TextEditingController firstNameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController contactNumberController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();

  // Repository
  final SignUpRepository _signUpRepository = Get.find<SignUpRepository>();

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

  Future<void> signUp() async {
    try {
      // Validate form
      final validationError = validateFields();
      if (validationError != null) {
        errorMessage.value = validationError;
        Get.snackbar(
          'Validation Error',
          validationError,
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.orange,
          colorText: Colors.white,
        );
        return;
      }

      isLoading.value = true;
      errorMessage.value = '';

      // Call repository to perform signup
      final response = await _signUpRepository.signup(
        firstNameController.text.trim(),
        lastNameController.text.trim(),
        contactNumberController.text.trim(),
        emailController.text.trim(),
        passwordController.text,
      );

      log("📦 Repository response: $response");
      log("📦 Response type: ${response.runtimeType}");

      // Let's see what keys are available in the response
      if (response is Map) {
        log("📦 Response keys: ${response.keys}");
      }

      // Extract data and headers from ApiService response format
      final responseData = response['data'];
      final responseStatusCode = response['status-code'];

      // Handle success response
      if (responseData != null && responseStatusCode == 201) {
        Get.snackbar(
          'Success',
          responseData['message'] ?? 'Account created successfully!',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );

        // Navigate to next screen
        Get.offAllNamed(Routes.signInScreen);
      } else {
        // Handle unexpected response format
        throw Failure(500, 'Unexpected response format from server');
      }
    } on Failure catch (failure) {
      errorMessage.value = failure.responseMessage;
      log("❌ SIGNUP FAILED: ${failure.responseMessage}");

      Get.snackbar(
        'Signup Failed',
        failure.responseMessage,
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } catch (e) {
      errorMessage.value = 'An unexpected error occurred';
      log("🚨 UNEXPECTED ERROR: $e");
      log("🚨 ERROR TYPE: ${e.runtimeType}");

      Get.snackbar(
        'Error',
        'An unexpected error occurred',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
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
