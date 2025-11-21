import 'dart:developer';

import 'package:bloodfit/constants/app_constant_text.dart';
import 'package:bloodfit/repositories/sign_in_repository.dart';
import 'package:bloodfit/helper/di.dart';
import 'package:bloodfit/helper/loading_helper.dart';
import 'package:bloodfit/routes/routes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../constants/validator.dart';
import '../../../../helper/api_service.dart';
import '../../../../networks/exception_handler/data_source.dart';
import '../../../../services/auth_service.dart';
import '../helper/advanced_custom_toast_message.dart';
import '../networks/exception_handler/error_response.dart';

class SignInScreenController extends GetxController {
  SignInRepository signInRepository = SignInRepository();
  final AuthService authService = Get.find<AuthService>();

  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  /// Section: password visibility
  RxBool isPasswordVisible = false.obs;
  void setPasswordVisibility() {
    isPasswordVisible.value = !isPasswordVisible.value;
  }

  /// Section: CheckBox
  RxBool isChecked = false.obs;
  void setCheckBoxValue({required bool newValue}) {
    isChecked.value = newValue;
  }

  var isLoading = false.obs;
  var errorMessage = ''.obs;

  /// Form validation using external validators
  bool validateForm() {
    final emailError = emailValidator(emailController.text);
    final passwordError = passwordValidator(passwordController.text);

    if (emailError != null || passwordError != null) {
      errorMessage.value = emailError ?? passwordError!;

      // Show validation error using UI-driven toast
      CustomToast.error(emailError ?? passwordError!);
      return false;
    }

    errorMessage.value = '';
    return true;
  }

  Future<void> signIn() async {
    try {
      clearError();

      // Validate form using external validators
      if (!validateForm()) {
        return;
      }

      isLoading.value = true;

      final email = emailController.text.trim();
      final password = passwordController.text;

      final response = await signInRepository
          .login(email, password)
          .waitingForFutureWithoutBg();

      // ✅ EXTRACT DATA AND HEADERS
      final userData = response['data'];
      final headers = response['headers'];
      final statusCode = response['status-code'];

      if (statusCode == 200 || statusCode == 201) {
        // ✅ EXTRACT TOKENS FROM HEADERS
        final accessToken = _extractToken(headers, 'access-token');
        final refreshToken = _extractToken(headers, 'refresh-token');

        // ✅ LOG SUCCESS WITH TOKENS
        log("🎉 LOGIN SUCCESS");
        log("📨 Message: ${userData['message']}");
        log("🔑 Access Token: ${accessToken != null ? '✓' : '✗'}");
        log("🔄 Refresh Token: ${refreshToken != null ? '✓' : '✗'}");
        log(
          "👤 User: ${userData['user']['firstName']} ${userData['user']['lastName']}",
        );

        // ✅ STORE TOKENS IN GET_STORAGE USING YOUR CONSTANTS
        if (accessToken != null) {
          appData.write(kKeyAccessToken, accessToken);
          log("✅ Access Token Saved");
          log("Access-Token : ${appData.read(kKeyAccessToken)}");
        } else {
          log("❌ Could Not Save Access Token");
        }

        if (refreshToken != null) {
          appData.write(kKeyRefreshToken, refreshToken);
          log("✅ Refresh Token Saved");
          log("Refresh-Token : ${appData.read(kKeyRefreshToken)}");
        } else {
          log("❌ Could Not Save Refresh Token");
        }

        // ✅ UPDATE AUTH SERVICE STATE
        if (accessToken != null) {
          authService.handleLogin();
          log("✅ AuthService updated with login state");
        }

        // ✅ UPDATE DIO HEADERS WITH NEW TOKEN
        if (accessToken != null) {
          ApiService.instance.updateHeaders();
        }

        // Show success message using UI-driven toast
        CustomToast.success(
          userData['message'] ?? 'Login successful!',
          duration: 3,
        );

        // Navigate to home screen
        Get.offAllNamed(Routes.enterYourDetailsScreen);
      } else {
        // Handle non-success status codes
        log("❌ LOGIN FAILED - Status Code: $statusCode");
        errorMessage.value =
            userData['message'] ?? 'Login failed. Please try again.';

        // Show error using UI-driven toast (since we have a specific message)
        CustomToast.error(
          userData['message'] ?? 'Login failed. Please try again.',
          duration: 4,
        );
      }
    } on Failure catch (failure) {
      // 🆕 SPECIFIC HANDLING FOR CANCELLATION
      if (failure.resonseCode == ResponseCode.CANCEL) {
        log("⏹️ LOGIN CANCELLED BY USER");
        CustomToast.info('Login cancelled', duration: 2);
        return;
      }

      errorMessage.value = failure.responseMessage;
      log("❌ LOGIN FAILED: ${failure.responseMessage}");

      // 🆕 THIS WILL NOW SHOW THE CORRECT COLOR (RED FOR 409 CONFLICT)
      CustomToast.showFromFailure(failure, duration: 4);
    } catch (e) {
      errorMessage.value = 'An unexpected error occurred';
      log("🚨 UNEXPECTED ERROR: $e");
      log("🚨 ERROR TYPE: ${e.runtimeType}");

      CustomToast.error('An unexpected error occurred', duration: 4);
    } finally {
      isLoading.value = false;
    }
  }

  void clearError() {
    errorMessage.value = '';
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

  @override
  void onClose() {
    emailController.dispose();
    passwordController.dispose();
    super.onClose();
  }
}
