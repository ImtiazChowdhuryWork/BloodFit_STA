import 'dart:developer';

import 'package:bloodfit/constants/app_constant_text.dart';
import 'package:bloodfit/helper/advanced_custom_toast_message.dart';
import 'package:bloodfit/helper/di.dart';
import 'package:get/get.dart';
import '../repositories/verify_user_repository.dart';
import '../routes/routes.dart';

class VerifyUserOtpScreenController extends GetxController {
  var pin = ''.obs;
  var isLoading = false.obs;
  final VerifyUserRepository _repository = VerifyUserRepository();

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

      // final response = await _repository.verifyUserOtp(pin.value);
      final response = await _repository.verifyUser(pin.value);

      // Extract data from the response structure
      final responseData = response['data'];
      final statusCode = response['status-code'];

      if (responseData != null && statusCode == 200 ||
          responseData != null && statusCode == 201) {
        Get.snackbar('Success', 'OTP verified successfully');

        if (appData.read(kKeyAccessToken) &&
            appData.read(kKeyRefreshToken) != null) {
          log("Access Token Or Refresh Token Not Found!");
          log("Access Token : ${appData.read(kKeyAccessToken)}");
          log("Refresh Token : ${appData.read(kKeyRefreshToken)}");
          CustomToast.error("User Not Found");
        } else {
          // Navigate to reset password screen
          Get.toNamed(Routes.homeScreen);
        }
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
