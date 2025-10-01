import 'package:bloodfit/gen/assets.gen.dart';
import 'package:bloodfit/gen/colors.gen.dart';
import 'package:bloodfit/routes/routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../onboarding/presentation/onboarding_screen.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key});

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController animationController;
  late Animation<double> scaleAnimation;

  bool showDrop = true;

  @override
  void initState() {
    super.initState();

    animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );

    scaleAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: animationController, curve: Curves.easeOutBack),
    );

    Future.delayed(const Duration(milliseconds: 800), () {
      setState(() => showDrop = false);
      animationController.forward();
    });

    /// 🔑 Navigate after 3 seconds
    Future.delayed(const Duration(seconds: 3), () {
      Get.offAllNamed(Routes.onboardingScreen);
    });
  }

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldBackgroundColor,
      body: Align(
        alignment: const Alignment(0, -0.1),
        child: AnimatedSwitcher(
          duration: const Duration(milliseconds: 600),
          switchInCurve: Curves.easeIn,
          switchOutCurve: Curves.easeOut,
          transitionBuilder: (child, animation) =>
              FadeTransition(opacity: animation, child: child),
          child: showDrop
              ? Image.asset(
                  Assets.images.bloodDropTransparent.path,
                  key: const ValueKey("drop"),
                  width: 0.5.sw,
                  fit: BoxFit.contain,
                )
              : Align(
                  alignment: const Alignment(0, 0.1),
                  child: ScaleTransition(
                    scale: scaleAnimation,
                    alignment: Alignment.center,
                    child: Image.asset(
                      Assets.images.bloodFitSplashText.path,
                      key: const ValueKey("text"),
                      width: 0.9.sw,
                    ),
                  ),
                ),
        ),
      ),
    );
  }
}
