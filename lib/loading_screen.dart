import 'dart:developer';
import 'package:bloodfit/constants/app_constant_text.dart';
import 'package:bloodfit/features/auth/sign_in/presentation/sign_in_screen.dart';
import 'package:bloodfit/features/onboarding/presentation/onboarding_screen.dart';
import 'package:bloodfit/features/welcome/presentation/welcome_screen.dart';
import 'package:bloodfit/helper/helper_methods.dart';
import 'package:bloodfit/helper/post_login.dart';
import 'package:bloodfit/navigation_screen.dart';
import 'package:flutter/material.dart';

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
    final bool isLoggedIn = appData.read(kKeyIsLoggedIn);
    final bool isFirstTime = appData.read(kKeyfirstTime) ?? false;

    log('isFirstTime: $isFirstTime');
    log('isLoggedIn: $isLoggedIn');

    await setInitValue();

    if (appData.read(kKeyAccessToken) != null) {
      await performPostLoginActions();
    }

    _startScreen = _determineStartScreen();

    setState(() => _isLoading = false);
  }

  Widget _determineStartScreen() {
    final bool isLoggedIn = appData.read(kKeyAccessToken) != null;
    final bool isFirstTime = appData.read(kKeyfirstTime) ?? false;

    log('isFirstTime: $isFirstTime');
    log('isLoggedIn: $isLoggedIn');

    if (!isLoggedIn) {
      return isFirstTime ? OnboardingScreen() : SignInScreen();
    }

    return const NavigationScreen();
  }

  @override
  Widget build(BuildContext context) {
    return _isLoading ? const WelcomeScreen() : _startScreen;
  }
}
