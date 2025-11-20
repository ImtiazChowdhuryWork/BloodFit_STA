import 'dart:developer';

import 'package:bloodfit/helper/loading_helper.dart';
import 'package:bloodfit/networks/exception_handler/data_source.dart';
import 'package:bloodfit/repositories/forgot_password_repository.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';

import '../routes/routes.dart';

class ForgotPasswordController extends GetxController {
  TextEditingController accountEmail = TextEditingController();

  final ForgotPasswordRepository _forgotPasswordRepository =
      Get.find<ForgotPasswordRepository>();

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

  Future<void> getOTP() async {
    try {
      final validationError = validateEmail();
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

      final response = await _forgotPasswordRepository
          .sendOTPAtThisEmail(accountEmail.text.trim())
          .waitingForFutureWithoutBg();

      final statusCode = response['status-code'];
      final responseBodyData = response['data'];

      if (responseBodyData != null && statusCode == 200 ||
          responseBodyData != null && statusCode == 201) {
        Get.snackbar(
          'Success',
          'OTP sent successfully to your email',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );

        // Navigate to OTP verification screen with email
        Get.toNamed(
          Routes.verifyOtpScreen,
          arguments: {'email': accountEmail.text.trim()},
        );
      } else {
        throw Failure(statusCode, 'Failed To Send OTP');
      }
    } on Failure catch (failure) {
      errorMessage.value = failure.responseMessage;
      log("❌ SEND OTP FAILED: ${failure.responseMessage}");

      Get.snackbar(
        'Failed',
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
    accountEmail.dispose();
    super.onClose();
  }
}
