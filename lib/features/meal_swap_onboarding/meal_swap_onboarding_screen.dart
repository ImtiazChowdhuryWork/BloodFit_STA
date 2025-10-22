import 'package:bloodfit/constants/text_font_style.dart';
import 'package:bloodfit/gen/colors.gen.dart';
import 'package:flutter/material.dart';

class MealSwapOnboardingScreen extends StatelessWidget {
  const MealSwapOnboardingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldBackgroundColor,
      body: SafeArea(
        child: Center(
          child: Text(
            "Meal Swap Onboarding!",
            style: TextFontStyle.headline24w700cFFFFFFStylePoppins,
          ),
        ),
      ),
    );
  }
}
