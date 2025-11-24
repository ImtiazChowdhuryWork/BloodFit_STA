import 'dart:developer';

import 'package:bloodfit/constants/app_constant_text.dart';
import 'package:bloodfit/helper/advanced_custom_toast_message.dart';
import 'package:bloodfit/helper/di.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../networks/dio/dio.dart';
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

      log("----------📦 Repository response: $response-----------------");

      // Extract data and headers
      final responseData = response['data'];
      final headers = response['headers'];
      final responseStatusCode = response['status-code'];

      // Extract tokens
      final accessToken = _extractToken(headers, 'access-token');
      final refreshToken = _extractToken(headers, 'refresh-token');

      // Handle success response
      if (responseData != null && responseStatusCode == 201) {
        // Store tokens
        if (accessToken != null) {
          appData.write(kKeyAccessToken, accessToken);
          log("------Access Token stored successfully-----------");
          log(
            "--------------Access Token : ${appData.read(kKeyAccessToken)}-----------",
          );
        }

        if (refreshToken != null) {
          appData.write(kKeyRefreshToken, refreshToken);
          log("-----------Refresh Token stored successfully----------------");
          log(
            "--------------Access Token : ${appData.read(kKeyRefreshToken)}-----------",
          );
        }

        // ✅ CRITICAL FIX: Update Dio instance with new tokens
        DioSingleton.instance.update();

        // Extract user verification status from nested user object
        final isUserVerified = responseData['isVerified'] ?? false;
        appData.write(kKeyIsUserVerified, isUserVerified);
        log("--------------Is User Verified : $isUserVerified----------------");

        // Check if tokens were stored successfully
        if (appData.read(kKeyAccessToken) != null &&
            appData.read(kKeyRefreshToken) != null &&
            appData.read(kKeyIsUserVerified) == false) {
          ///Show Toast Message On Creating Account Successfully
          CustomToast.success("Account Created Successfully!");

          // Navigate to appropriate screen
          Get.offAllNamed(Routes.verifyUserScreen);
        } else {
          CustomToast.error(
            "Authentication failed - tokens not stored properly",
          );
        }
      } else {
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
