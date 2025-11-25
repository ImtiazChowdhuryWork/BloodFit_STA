import 'dart:developer';

import 'package:bloodfit/helper/loading_helper.dart';
import 'package:bloodfit/repositories/reset_password_repository.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import '../helper/advanced_custom_toast_message.dart';
import '../routes/routes.dart';

class ResetPasswordScreenController extends GetxController {
  final ResetPasswordRepository _repository = ResetPasswordRepository();

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
      CustomToast.error('OTP Token not found. Please try again.');
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
      CustomToast.error('Passwords do not match');
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

  Future<void> resetNewPassword() async {
    try {
      // Validate form first
      if (!isFormValid()) {
        validateSamePassword();
        return;
      }

      isLoading.value = true;
      errorMessage.value = '';

      final response = await _repository
          .resetPassword(otpToken, newPasswordController.text.toString())
          .waitingForFutureWithoutBg();

      // Extract data from the response structure
      final responseData = response['data'];
      final statusCode = response['status-code'];

      if (statusCode == 200 || statusCode == 201) {
        final message =
            responseData['message'] ?? 'Password reset successfully';
        CustomToast.success(message);

        // Clear controllers
        newPasswordController.clear();
        confirmPasswordController.clear();

        // Navigate to sign in screen
        Get.offAllNamed(Routes.signInScreen);
      } else {
        final errorMsg = responseData['message'] ?? 'Failed to reset password';
        throw Exception(errorMsg);
      }
    } on Exception catch (e) {
      errorMessage.value = e.toString();
      log("❌ RESET PASSWORD FAILED: $e");
      CustomToast.error('Failed to reset password: ${e.toString()}');
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
    newPasswordController.dispose();
    confirmPasswordController.dispose();
    super.onClose();
  }
}
