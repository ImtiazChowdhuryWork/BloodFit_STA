import 'dart:developer';

import 'package:bloodfit/constants/app_constant_text.dart';
import 'package:bloodfit/helper/di.dart';
import 'package:get/get.dart';

class VerifyUserOtpScreenController extends GetxController {
  var pin = ''.obs;
  var isLoading = false.obs;
  var errorMessage = ''.obs;

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
    errorMessage.value = ''; // Clear previous errors
    log('Entered OTP: $value');
  }

  // Debug storage method
  void _debugStorage(String context) {
    log('🔍 STORAGE DEBUG ($context):');
    log('Access Token: ${appData.read(kKeyAccessToken) != null ? "✓" : "✗"}');
    log('Refresh Token: ${appData.read(kKeyRefreshToken) != null ? "✓" : "✗"}');
    log('Is User Verified: ${appData.read(kKeyIsUserVerified) ?? "NULL"}');
    log('Is User Verified (raw): ${appData.read(kKeyIsUserVerified)}');
    log('Type: ${appData.read(kKeyIsUserVerified)?.runtimeType}');
  }
}
