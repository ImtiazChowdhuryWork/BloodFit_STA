import 'dart:io';
import 'package:bloodfit/features/auth/forgot_password/presentation/forgot_password_screen.dart';
import 'package:bloodfit/features/auth/reset_password/presentation/reset_password_screen.dart';
import 'package:bloodfit/features/auth/sign_in/presentation/sign_in_screen.dart';
import 'package:bloodfit/features/auth/sign_up/presentation/sign_up_screen.dart';
import 'package:bloodfit/features/auth/verify_otp/presentation/verify_otp_screen.dart';
import 'package:bloodfit/features/enter_your_details/presentation/enter_your_details_screen.dart';
import 'package:bloodfit/features/notification/presentation/notification_screen.dart';
import 'package:bloodfit/features/onboarding/presentation/onboarding_screen.dart';
import 'package:flutter/material.dart'; // 👈 Needed for BuildContext, Widget, FadeTransition
import 'package:get/get.dart';

import '../features/welcome/presentation/welcome_screen.dart';

class Routes {
  ///Section : Common Screens Routing
  ///Section : Normal Users Routing

  static const String welcomeScreen = '/';
  static const String onboardingScreen = '/onboarding_screen';
  static const String signInScreen = '/sign_in_screen';
  static const String signUpScreen = '/sign_up_screen';
  static const String forgotPasswordScreen = '/forgot_password_screen';
  static const String verifyOtpScreen = '/verify_otp_screen';
  static const String resetPasswordScreen = '/reset_password_screen';
  static const String enterYourDetailsScreen = '/enter_your_details_screen';
  static const String notificationScreen = '/notifications_screen';

  static final appRoutes = [
    ///Splash Screen
    GetPage(
      name: welcomeScreen,
      page: () => WelcomeScreen(),
      transition: _transition(),
      customTransition: _customTransition(),
      transitionDuration: _duration(),
    ),

    ///OnBoardingScreen
    GetPage(
      name: onboardingScreen,
      page: () => OnboardingScreen(),
      transition: _transition(),
      customTransition: _customTransition(),
      transitionDuration: _duration(),
    ),

    ///Sign In Screen
    GetPage(
      name: signInScreen,
      page: () => SignInScreen(),
      transition: _transition(),
      customTransition: _customTransition(),
      transitionDuration: _duration(),
    ),

    ///signUpScreen
    GetPage(
      name: signUpScreen,
      page: () => SignUpScreen(),
      transition: _transition(),
      customTransition: _customTransition(),
      transitionDuration: _duration(),
    ),

    ///forgotPasswordScreen
    GetPage(
      name: forgotPasswordScreen,
      page: () => ForgotPasswordScreen(),
      transition: _transition(),
      customTransition: _customTransition(),
      transitionDuration: _duration(),
    ),

    ///verifyOtpScreen
    GetPage(
      name: verifyOtpScreen,
      page: () => VerifyOtpScreen(),
      transition: _transition(),
      customTransition: _customTransition(),
      transitionDuration: _duration(),
    ),

    ///resetPasswordScreen
    GetPage(
      name: resetPasswordScreen,
      page: () => ResetPasswordScreen(),
      transition: _transition(),
      customTransition: _customTransition(),
      transitionDuration: _duration(),
    ),

    ///enterYourDetailsScreen
    GetPage(
      name: enterYourDetailsScreen,
      page: () => EnterYourDetailsScreen(),
      transition: _transition(),
      customTransition: _customTransition(),
      transitionDuration: _duration(),
    ),

    ///notificationScreen
    GetPage(
      name: notificationScreen,
      page: () => NotificationScreen(),
      transition: _transition(),
      customTransition: _customTransition(),
      transitionDuration: _duration(),
    ),
  ];
}

/// Custom ultra-fast fade for Android
class FastFadeTransition extends CustomTransition {
  @override
  Widget buildTransition(
    BuildContext context,
    Curve? curve,
    Alignment? alignment,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child,
  ) {
    return FadeTransition(opacity: animation, child: child);
  }
}

/// Utility method to apply platform-aware transitions
Transition _transition() =>
    Platform.isAndroid ? Transition.fade : Transition.cupertino;

CustomTransition? _customTransition() =>
    Platform.isAndroid ? FastFadeTransition() : null;

Duration _duration() => Platform.isAndroid
    ? const Duration(milliseconds: 1)
    : const Duration(milliseconds: 300);


// /// All GetPages in your app
// final List<GetPage> appRoutes = [
  
//   GetPage(
//     name: AppRoutes.notificationsScreen,
//     page: () => NotificationsScreen(),
//     transition: _transition(),
//     customTransition: _customTransition(),
//     transitionDuration: _duration(),
//   ),

//   /// 🟢 Example: Using typed arguments model
//   GetPage(
//     name: AppRoutes.editProfileScreen,
//     page: () {
//       final args = Get.arguments as EditProfileArgs;
//       return EditProfileScreen(
//         firstName: args.firstName,
//         lastName: args.lastName,
//         email: args.email,
//         phone: args.phone,
//         address: args.address,
//         profileImage: args.profileImage,
//         age: args.age,
//         city: args.city,
//         country: args.country,
//       );
//     },
//     transition: _transition(),
//     customTransition: _customTransition(),
//     transitionDuration: _duration(),
//   ),

  
// ];
