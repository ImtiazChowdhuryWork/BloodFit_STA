import 'dart:developer';

import 'package:bloodfit/helper/advanced_custom_toast_message.dart';
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

        CustomToast.error(validationError);

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
        CustomToast.success('OTP sent successfully to your email');

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
      ;

      CustomToast.showFromFailure(failure);
    } catch (e) {
      errorMessage.value = 'An unexpected error occurred';
      log("🚨 UNEXPECTED ERROR: $e");

      CustomToast.error('An unexpected error occurred');
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
