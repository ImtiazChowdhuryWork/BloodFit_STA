import 'dart:developer';

import 'package:bloodfit/helper/logger_util.dart';
import 'package:get/get.dart';

class VerifyOtpScreenController extends GetxController {
  var pin = ''.obs;
  var isLoading = false.obs;
  late String email; // Add email field

  @override
  void onInit() {
    super.onInit();
    // Get email from route arguments
    email = Get.arguments?['email'] ?? '';
    log('Email received for OTP verification: $email');

    if (email.isEmpty) {
      LoggerUtils.error('Email not found. Please try again.');
      Get.back();
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
}
