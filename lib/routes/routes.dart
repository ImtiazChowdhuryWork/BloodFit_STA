import 'dart:io';

import 'package:bloodfit/features/add_promo_code/presentation/add_promo_code_screen.dart';
import 'package:bloodfit/features/auth/forgot_password/presentation/forgot_password_screen.dart';
import 'package:bloodfit/features/auth/reset_password/presentation/reset_password_screen.dart';
import 'package:bloodfit/features/auth/sign_in/presentation/sign_in_screen.dart';
import 'package:bloodfit/features/auth/sign_up/presentation/sign_up_screen.dart';
import 'package:bloodfit/features/auth/verify_otp/presentation/verify_otp_screen.dart';
import 'package:bloodfit/features/change_password/presentation/change_password_screen.dart';
import 'package:bloodfit/features/cost_details_for_upgrade_plan/presentation/cost_details_for_upgrade_plan_screen.dart';
import 'package:bloodfit/features/edit_profil/presentation/edit_profile_screen.dart';
import 'package:bloodfit/features/enter_your_details/presentation/enter_your_details_screen.dart';
import 'package:bloodfit/features/fitness/presentation/fitness_screen.dart';
import 'package:bloodfit/features/home/presentation/home_screen.dart';
import 'package:bloodfit/features/information_gather/presentation/widgets/select_weight/presentation/select_weight_screen.dart';
import 'package:bloodfit/features/profile_mealplan/presentation/profile_mealplan_screen.dart';
import 'package:bloodfit/features/my_profile/presentation/my_profile_screen.dart';
import 'package:bloodfit/features/notification/presentation/notification_screen.dart';
import 'package:bloodfit/features/onboarding/presentation/onboarding_screen.dart';
import 'package:bloodfit/features/privacy_policy/presentation/privacy_policy_screen.dart';
import 'package:bloodfit/features/report_a_problem/presentation/report_a_problem_screen.dart';
import 'package:bloodfit/features/settings/presentation/settings_screen.dart';
import 'package:bloodfit/features/subscription/presentation/subscription_screen.dart';
import 'package:bloodfit/features/terms_and_conditions/presentation/terms_and_conditions_screen.dart';
import 'package:bloodfit/features/you_are_all_set/presentation/you_are_all_set_screen.dart';
import 'package:bloodfit/features/your_daily_calories_intake/presentation/your_daily_calories_intake_screen.dart';
import 'package:bloodfit/navigation_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../features/change_password/bindings/change_password_bindings.dart';
import '../features/choose_from_our_suggested_meals/presentation/choose_from_our_suggested_meals_screen.dart';
import '../features/faq/presentation/faq_screen.dart';
import '../features/information_gather/presentation/information_gather_screen.dart';
import '../features/report_a_problem/bindings/report_a_problem_screen_binging.dart';
import '../features/welcome/presentation/welcome_screen.dart';

class Routes {
  ///Section : Common Screens Routing
  ///Section : Normal Users Routing

  static const String welcomeScreen = '/';
  static const String onboardingScreen = '/onboarding_screen';
  static const String signInScreen = '/sign_in_screen';
  static const String signUpScreen = '/sign_up_screen';
  static const String signOut = '/sign_out';
  static const String forgotPasswordScreen = '/forgot_password_screen';
  static const String verifyOtpScreen = '/verify_otp_screen';
  static const String resetPasswordScreen = '/reset_password_screen';
  static const String enterYourDetailsScreen = '/enter_your_details_screen';
  static const String notificationScreen = '/notifications_screen';
  static const String myProfileScreen = '/my_profile_screen';
  static const String editProfileScreen = '/edit_profile_screen';
  static const String settingsScreen = '/settings_screen';
  static const String mealPlanScreen = '/meal_plan_screen';
  static const String fitnessScreen = '/fit_ness_screen';
  static const String subscriptionScreen = '/subs_cription_screen';
  static const String viewProfileInfoScreen = '/view_profile_info_screen';
  static const String changePasswordScreen = '/change_password_screen';
  static const String termsAndConditionsScreen = '/terms_and_conditions_screen';
  static const String privacyPolicyScreen = '/privacy_policy_screen';
  static const String reportProbelmScreen = '/repor_a_problem_screen';
  static const String faqScreen = '/faq_screen';
  static const String costDetailsForUpgradePlanScreen =
      '/cost_details_for_upgrade_plan_screen';
  static const String addPromoCodeScreen = '/add_promo_code_screen';
  static const String informationGatherScreen = '/information_gather_screen';
  static const String selectWeightScreen = '/select_weight_screen';
  static const String dailyCaloriesIntakeScreen =
      '/your_daily_calories_intake_screen';
  static const String youAreAllSetScreen = '/you_are_all_set_screen';
  static const String navigationScreen = '/navigation_screen';
  static const String homeScreen = '/home_screen';
  static const String chooseFromOurSuggestedMealsScreen =
      '/choose_from_our_suggested_meals_screen';

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

    ///myProfileScreen
    GetPage(
      name: myProfileScreen,
      page: () => MyProfileScreen(),
      transition: _transition(),
      customTransition: _customTransition(),
      transitionDuration: _duration(),
    ),

    ///editProfileScreen
    GetPage(
      name: editProfileScreen,
      page: () => EditProfileScreen(),
      transition: _transition(),
      customTransition: _customTransition(),
      transitionDuration: _duration(),
    ),

    ///settingsScreen
    GetPage(
      name: settingsScreen,
      page: () => SettingsScreen(),
      transition: _transition(),
      customTransition: _customTransition(),
      transitionDuration: _duration(),
    ),

    ///mealPlanScreen
    GetPage(
      name: mealPlanScreen,
      page: () => ProfileMealplanScreen(),
      transition: _transition(),
      customTransition: _customTransition(),
      transitionDuration: _duration(),
    ),

    ///fitnessScreen
    GetPage(
      name: fitnessScreen,
      page: () => FitnessScreen(),
      transition: _transition(),
      customTransition: _customTransition(),
      transitionDuration: _duration(),
    ),

    ///subscriptionScreen
    GetPage(
      name: subscriptionScreen,
      page: () => SubscriptionScreen(),
      transition: _transition(),
      customTransition: _customTransition(),
      transitionDuration: _duration(),
    ),

    ///signOut
    GetPage(
      name: signOut,
      page: () => SignInScreen(),
      transition: _transition(),
      customTransition: _customTransition(),
      transitionDuration: _duration(),
    ),

    ///changePasswordScreen
    GetPage(
      name: changePasswordScreen,
      page: () => ChangePasswordScreen(),
      binding: ChangePasswordBinding(),
      transition: _transition(),
      customTransition: _customTransition(),
      transitionDuration: _duration(),
    ),

    ///termsAndConditionsScreen
    GetPage(
      name: termsAndConditionsScreen,
      page: () => TermsAndConditionsScreen(),

      transition: _transition(),
      customTransition: _customTransition(),
      transitionDuration: _duration(),
    ),

    ///privacyPolicyScreen
    GetPage(
      name: privacyPolicyScreen,
      page: () => PrivacyPolicyScreen(),

      transition: _transition(),
      customTransition: _customTransition(),
      transitionDuration: _duration(),
    ),

    ///reportProbelmScreen
    GetPage(
      name: reportProbelmScreen,
      page: () => ReportAProblemScreen(),
      binding: ReportAProblemScreenBinging(),
      transition: _transition(),
      customTransition: _customTransition(),
      transitionDuration: _duration(),
    ),

    ///faqScreen
    GetPage(
      name: faqScreen,
      page: () => FaqScreen(),
      binding: ReportAProblemScreenBinging(),
      transition: _transition(),
      customTransition: _customTransition(),
      transitionDuration: _duration(),
    ),

    ///costDetailsForUpgradePlanScreen
    GetPage(
      name: costDetailsForUpgradePlanScreen,
      page: () => CostDetailsForUpgradePlanScreen(),
      transition: _transition(),
      customTransition: _customTransition(),
      transitionDuration: _duration(),
    ),

    ///addPromoCodeScreen
    GetPage(
      name: addPromoCodeScreen,
      page: () => AddPromoCodeScreen(),
      transition: _transition(),
      customTransition: _customTransition(),
      transitionDuration: _duration(),
    ),

    ///informationGatherScreen
    GetPage(
      name: informationGatherScreen,
      page: () => InformationGatherScreen(),
      transition: _transition(),
      customTransition: _customTransition(),
      transitionDuration: _duration(),
    ),

    ///selectWeightScreen
    GetPage(
      name: selectWeightScreen,
      page: () => SelectWeightScreen(),
      transition: _transition(),
      customTransition: _customTransition(),
      transitionDuration: _duration(),
    ),

    ///selectWeightScreen
    GetPage(
      name: dailyCaloriesIntakeScreen,
      page: () => YourDailyCaloriesIntakeScreen(),
      transition: _transition(),
      customTransition: _customTransition(),
      transitionDuration: _duration(),
    ),

    ///selectWeightScreen
    GetPage(
      name: youAreAllSetScreen,
      page: () => YouAreAllSetScreen(),
      transition: _transition(),
      customTransition: _customTransition(),
      transitionDuration: _duration(),
    ),

    ///navigationScreen
    GetPage(
      name: navigationScreen,
      page: () => NavigationScreen(),
      transition: _transition(),
      customTransition: _customTransition(),
      transitionDuration: _duration(),
    ),

    ///homeScreen
    GetPage(
      name: homeScreen,
      page: () => HomeScreen(),
      transition: _transition(),
      customTransition: _customTransition(),
      transitionDuration: _duration(),
    ),

    ///chooseFromOurSuggestedMealsScreen
    GetPage(
      name: chooseFromOurSuggestedMealsScreen,
      page: () => ChooseFromOurSuggestedMealsScreen(),
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
