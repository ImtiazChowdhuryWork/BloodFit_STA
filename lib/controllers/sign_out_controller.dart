// controllers/sign_out_controller.dart
import 'package:bloodfit/helper/loading_helper.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import '../repositories/sign_out_repository.dart';
import '../services/auth_service.dart';
import '../routes/routes.dart';

class SignOutController extends GetxService {
  final SignOutRepository _signOutRepository = SignOutRepository();
  final AuthService _authService = Get.find<AuthService>();
  var isLoading = false.obs;

  Future<void> signOut() async {
    try {
      isLoading.value = true;

      if (kDebugMode) {
        debugPrint("🚪 SignOutController - Starting logout process");
      }

      // 1. Optional: Call logout API if your backend requires it
      await _signOutRepository.logout().waitingForFutureWithoutBg();

      if (kDebugMode) {
        debugPrint("✅ SignOutController - API logout successful");
      }
    } catch (error) {
      // Even if API call fails, we still logout locally
      if (kDebugMode) {
        debugPrint("⚠️ SignOutController - API logout failed: $error");
        debugPrint("🔄 SignOutController - Proceeding with local logout");
      }
    } finally {
      // 2. Always perform local logout
      await _authService.performLogout();

      isLoading.value = false;

      // 3. Navigate to sign-in screen safely
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Get.offAndToNamed(Routes.signInScreen);
      });

      Get.snackbar(
        'Success',
        'Logged out successfully',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green,
        colorText: Colors.white,
        duration: Duration(seconds: 2),
      );

      if (kDebugMode) {
        debugPrint("🎯 SignOutController - Logout process completed");
      }
    }
  }

  // Force logout without API call (for token refresh failures, etc.)
  // void forceLogout() {
  //   if (kDebugMode) {
  //     debugPrint("🚨 SignOutController - Force logout initiated");
  //   }

  //   _authService.performLogout();

  //   WidgetsBinding.instance.addPostFrameCallback((_) {
  //     Get.offAllNamed(Routes.signInScreen);
  //   });

  //   Get.snackbar(
  //     'Logged Out',
  //     'You have been logged out',
  //     snackPosition: SnackPosition.BOTTOM,
  //     backgroundColor: Colors.blue,
  //     colorText: Colors.white,
  //   );
  // }
}
