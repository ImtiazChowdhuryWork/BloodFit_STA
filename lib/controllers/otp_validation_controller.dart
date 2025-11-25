import 'dart:developer';

import 'package:bloodfit/helper/advanced_custom_toast_message.dart';
import 'package:get/get.dart';

import '../repositories/forgot_password_verify_otp_repository.dart';
import '../routes/routes.dart';

class VerifyOtpScreenController extends GetxController {
  var pin = ''.obs;
  var isLoading = false.obs;
  late String email; // Add email field

  final ForgotPasswordVerifyOtpRepository _repository =
      ForgotPasswordVerifyOtpRepository();

  @override
  void onInit() {
    super.onInit();
    // Get email from route arguments
    email = Get.arguments?['email'] ?? '';
    log('Email received for OTP verification: $email');

    if (email.isEmpty) {
      // Get.snackbar('Error', 'Email not found. Please try again.');
      CustomToast.error('Email not found. Please try again.');
      Get.back(); // Go back if no email
    }
  }

  // Validate OTP format (6 digits)
  String? validatePin(String? value) {
    if (value == null || value.isEmpty) return 'OTP cannot be empty';
    if (value.length != 6) return 'OTP must be 6 digits';
    if (!RegExp(r'^\d+$').hasMatch(value))
      return 'OTP must contain only numbers';
    return null;
  }

  // Called when OTP completed
  void onCompleted(String value) {
    pin.value = value;
    log('Entered OTP: $value for email: $email');
  }

  // Verify OTP with API
  Future<void> verifyOtp() async {
    if (pin.value.isEmpty || pin.value.length != 6) {
      Get.snackbar('Error', 'Please enter a valid 6-digit OTP');
      return;
    }

    if (email.isEmpty) {
      Get.snackbar('Error', 'Email not found. Please try the process again.');
      return;
    }

    try {
      isLoading.value = true;

      final response = await _repository.forgotPasswordVerifyOtp(
        pin.value,
        email,
      );

      // Extract data from the response structure
      final responseData = response['data'];
      final statusCode = response['status-code'];

      if (responseData != null && (statusCode == 200 || statusCode == 201)) {
        Get.snackbar('Success', 'OTP verified successfully');
        // Navigate to reset password screen and pass the email
        Get.toNamed(
          Routes.resetPasswordScreen,
          arguments: {'email': email}, // Pass email to next screen if needed
        );
      } else {
        Get.snackbar('Error', 'Invalid OTP or verification failed');
      }
    } catch (e) {
      log('OTP Verification Error: $e');
      Get.snackbar('Error', 'Failed to verify OTP. Please try again.');
    } finally {
      isLoading.value = false;
    }
  }
}
