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
  var errorMessage = ''.obs;
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

  // Verify OTP with API
  Future<void> verifyOtp() async {
    // Clear previous errors
    errorMessage.value = '';

    // Validate OTP
    final validationError = validatePin(pin.value);
    if (validationError != null) {
      errorMessage.value = validationError;
      CustomToast.error(validationError);
      return;
    }

    try {
      isLoading.value = true;

      // Debug storage before verification
      _debugStorage('BEFORE OTP VERIFICATION');

      final response = await _repository.verifyUser(pin.value);

      // Extract data from the response structure
      final responseData = response['data'];
      final statusCode = response['status-code'];

      log('📦 OTP Response - Status: $statusCode, Data: $responseData');

      // ✅ FIXED: Proper condition
      if (responseData != null && statusCode == 200) {
        // ✅ FIXED: Store verification status FIRST
        appData.write(kKeyIsUserVerified, true);

        // Debug immediately after writing
        log(
          '✅ IMMEDIATELY AFTER WRITING - Is Verified: ${appData.read(kKeyIsUserVerified)}',
        );

        // Debug storage after update
        _debugStorage('AFTER OTP VERIFICATION');

        // ✅ FIXED: Simplified navigation logic
        final hasAccessToken = appData.read(kKeyAccessToken) != null;
        final hasRefreshToken = appData.read(kKeyRefreshToken) != null;
        final isVerified = appData.read(kKeyIsUserVerified) == true;

        log('🎯 NAVIGATION CHECK:');
        log('  - Access Token: $hasAccessToken');
        log('  - Refresh Token: $hasRefreshToken');
        log('  - Is Verified: $isVerified');

        if (hasAccessToken && hasRefreshToken && isVerified) {
          CustomToast.success(
            responseData['message'] ?? 'OTP verified successfully',
          );

          log('🚀 Navigating to Navigation Screen');
          Get.offAllNamed(Routes.navigationScreen);
        } else {
          // If something is missing, show error and go to login
          log('❌ Missing credentials for navigation:');
          log(
            '  - Access Token: ${appData.read(kKeyAccessToken) != null ? "✓" : "✗"}',
          );
          log(
            '  - Refresh Token: ${appData.read(kKeyRefreshToken) != null ? "✓" : "✗"}',
          );
          log(
            '  - Is Verified: ${appData.read(kKeyIsUserVerified) == true ? "✓" : "✗"}',
          );

          CustomToast.error('Authentication issue. Please login again.');
          Get.offAllNamed(Routes.signInScreen);
        }
      } else {
        errorMessage.value = 'Invalid OTP or verification failed';
        CustomToast.error('Invalid OTP or verification failed');

        // Debug on failure
        _debugStorage('AFTER OTP FAILURE');
      }
    } catch (e) {
      log('❌ OTP Verification Error: $e');
      errorMessage.value = 'Failed to verify OTP. Please try again.';
      CustomToast.error('Failed to verify OTP. Please try again.');

      // Debug on error
      _debugStorage('AFTER OTP ERROR');
    } finally {
      isLoading.value = false;
    }
  }
}
