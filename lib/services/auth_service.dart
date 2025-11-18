// services/auth_service.dart
import 'dart:developer';

import 'package:get/get.dart';
import 'package:flutter/foundation.dart';
import '../helper/di.dart';
import '../constants/app_constant_text.dart';
import '../helper/api_service.dart';

class AuthService extends GetxService {
  final ApiService _apiService = ApiService.instance;

  // Observable authentication state
  var isLoggedIn = false.obs;

  @override
  void onInit() {
    // Check initial auth state
    isLoggedIn.value = appData.read(kKeyAccessToken) != null;
    super.onInit();
  }

  Future<void> performLogout() async {
    // 1. Cancel any ongoing API requests
    _apiService.cancelRequests();

    // 2. Clear authentication tokens
    _clearTokens();

    // 3. Update auth state
    isLoggedIn.value = false;

    if (kDebugMode) {
      log("🔒 AuthService - Logout completed");
    }
  }

  void _clearTokens() {
    appData.remove(kKeyAccessToken);
    appData.remove(kKeyRefreshToken);

    // Update Dio headers to remove authorization
    _apiService.updateHeaders();
  }

  // Helper method to check if user is authenticated
  bool get isAuthenticated => appData.read(kKeyAccessToken) != null;

  // Method to handle login (update state when user logs in)
  void handleLogin() {
    isLoggedIn.value = true;
    if (kDebugMode) {
      log("🔑 AuthService - User logged in");
    }
  }

  // Method to update tokens (useful for token refresh)
  void updateTokens(String newAccessToken, [String? newRefreshToken]) {
    appData.write(kKeyAccessToken, newAccessToken);
    if (newRefreshToken != null) {
      appData.write(kKeyRefreshToken, newRefreshToken);
    }
    _apiService.updateHeaders();

    if (kDebugMode) {
      log("🔄 AuthService - Tokens updated");
    }
  }
}
