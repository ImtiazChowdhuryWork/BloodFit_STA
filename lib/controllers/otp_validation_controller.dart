import 'dart:developer';

import 'package:get/get.dart';

import '../repositories/verify_otp_repository.dart';
import '../routes/routes.dart';

class VerifyOtpScreenController extends GetxController {
  var pin = ''.obs;
  var isLoading = false.obs;
  final VerifyOtpRepository _repository = VerifyOtpRepository();

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
    log('Entered OTP: $value');
  }

  // Verify OTP with API
  Future<void> verifyOtp() async {
    if (pin.value.isEmpty || pin.value.length != 6) {
      Get.snackbar('Error', 'Please enter a valid 6-digit OTP');
      return;
    }

    try {
      isLoading.value = true;

      final response = await _repository.verifyOtp(pin.value);

      // Extract data from the response structure
      final responseData = response['data'];
      final statusCode = response['status-code'];

      if (responseData != null && statusCode == 200 ||
          responseData != null && statusCode == 201) {
        Get.snackbar('Success', 'OTP verified successfully');
        // Navigate to reset password screen
        Get.toNamed(Routes.resetPasswordScreen);
      } else {
        Get.snackbar('Error', 'Invalid OTP or verification failed');
      }
    } catch (e) {
      log('OTP Verification Error: $e');
      // The error handling is already done in ApiService, so we just show a generic message
      Get.snackbar('Error', 'Failed to verify OTP. Please try again.');
    } finally {
      isLoading.value = false;
    }
  }
}
