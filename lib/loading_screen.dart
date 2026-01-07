import 'dart:developer';
import 'package:bloodfit/constants/app_constant_text.dart';
import 'package:bloodfit/features/auth/sign_in/data/controller/sign_in_screen_controller.dart';
import 'package:bloodfit/features/auth/sign_in/data/repository/sign_in_repository.dart';
import 'package:bloodfit/features/auth/sign_in/presentation/sign_in_screen.dart';
import 'package:bloodfit/features/onboarding/presentation/onboarding_screen.dart';
import 'package:bloodfit/features/welcome/presentation/welcome_screen.dart';
import 'package:bloodfit/helper/helper_methods.dart';
import 'package:bloodfit/helper/logger_util.dart';
import 'package:bloodfit/helper/post_login.dart';
import 'package:bloodfit/navigation_screen.dart';
import 'package:bloodfit/networks/network_caller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'helper/di.dart';

final class Loading extends StatefulWidget {
  const Loading({super.key});

  @override
  State<Loading> createState() => _LoadingState();
}

class _LoadingState extends State<Loading> {
  bool _isLoading = true;
  late Widget _startScreen;

  @override
  void initState() {
    super.initState();
    _initializeApp();
  }

  Future<void> _initializeApp() async {
    // Initialize default values first
    await setInitValue();

    // Read the current state after initialization
    // Use access token as the authoritative source for login state
    final bool isLoggedIn = appData.read(kKeyAccessToken) != null;
    final bool isFirstTime = appData.read(kKeyfirstTime) ?? false;

    log('isFirstTime: $isFirstTime');
    log('isLoggedIn: $isLoggedIn');

    if (isLoggedIn) {
      await performPostLoginActions();
    }

    _startScreen = _determineStartScreen();

    setState(() => _isLoading = false);
  }

  Widget _determineStartScreen() {
    // Use the same logic as _initializeApp() for consistency
    final bool isLoggedIn = appData.read(kKeyAccessToken) != null;
    LoggerUtils.debug(
      "Access Token 🧐🧐🧐🧐🧐🧐🧐: ${appData.read(kKeyAccessToken)}",
    );
    final bool isFirstTime = appData.read(kKeyfirstTime) ?? false;

    log('isFirstTime: $isFirstTime');
    log('isLoggedIn: $isLoggedIn');

    // Always register NetworkCaller regardless of login state
    if (!Get.isRegistered<NetworkCaller>()) {
      Get.put(NetworkCaller());
    }

    if (!isLoggedIn) {
      // Step 2: Register repository
      if (!Get.isRegistered<SignInRepository>()) {
        Get.put(SignInRepository(Get.find()));
      }

      // Step 3: Register controller
      if (!Get.isRegistered<SignInScreenController>()) {
        Get.put(SignInScreenController(Get.find()));
      }

      return isFirstTime ? OnboardingScreen() : SignInScreen();
    }

    return const NavigationScreen();
  }

  @override
  Widget build(BuildContext context) {
    return _isLoading ? const WelcomeScreen() : _startScreen;
  }
}
