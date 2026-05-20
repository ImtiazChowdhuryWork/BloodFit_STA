import 'dart:developer';
import 'package:bloodfit/constants/app_constant_text.dart';
import 'package:bloodfit/features/auth/google_sign_in/data/controller/google_sign_in_controller.dart';
import 'package:bloodfit/features/auth/google_sign_in/data/repository/google_sign_in_repository.dart';
import 'package:bloodfit/features/auth/sign_in/data/controller/sign_in_screen_controller.dart';
import 'package:bloodfit/features/auth/sign_in/data/repository/sign_in_repository.dart';
import 'package:bloodfit/features/auth/sign_in/presentation/sign_in_screen.dart';
import 'package:bloodfit/features/onboarding/presentation/onboarding_screen.dart';
import 'package:bloodfit/features/welcome/presentation/welcome_screen.dart';
import 'package:bloodfit/navigation_screen.dart';
import 'package:bloodfit/networks/network_caller.dart';
import 'package:bloodfit/routes/routes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'helper/di.dart';
import 'helper/logger_util.dart';
import 'helper/helper_methods.dart';
import 'helper/post_login.dart';
import 'iap.dart';

final class Loading extends StatefulWidget {
  const Loading({super.key});

  @override
  State<Loading> createState() => _LoadingState();
}

class _LoadingState extends State<Loading> {
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _initializeApp();
  }

  Future<void> _initializeApp() async {
    // Initialize default values first
    await setInitValue();

    final bool isLoggedIn = appData.read(kKeyAccessToken) != null;
    final bool isFirstTime = appData.read(kKeyfirstTime) ?? false;

    log('isFirstTime: $isFirstTime');
    log('isLoggedIn: $isLoggedIn');

    if (isLoggedIn) {
      await performPostLoginActions();

      // Navigate via GetX so bindings are applied
      Get.offAllNamed(Routes.navigationScreen); // Make sure this route is in GetMaterialApp
    } else {
      // Not logged in
      if (!Get.isRegistered<NetworkCaller>()) Get.put(NetworkCaller());

      if (!Get.isRegistered<SignInRepository>()) Get.put(SignInRepository(Get.find()));

      if (!Get.isRegistered<SignInScreenController>()) {
        Get.put(SignInScreenController(Get.find()));
      }

      if (!Get.isRegistered<GoogleSignInRepository>()) {
        Get.put(GoogleSignInRepository(Get.find()));
      }
      if (!Get.isRegistered<GoogleSignInController>()) {
        Get.put(GoogleSignInController(Get.find()));
      }

      final Widget startScreen = isFirstTime ? OnboardingScreen() : SignInScreen();
      
      // Navigate via GetX
      Get.offAll(() => startScreen);
    }

    setState(() => _isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    // Show a loading/welcome screen until navigation is done
    return _isLoading ? const WelcomeScreen() : const SizedBox.shrink();
  }
}
