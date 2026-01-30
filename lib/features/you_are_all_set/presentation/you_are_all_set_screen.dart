import 'package:bloodfit/constants/text_font_style.dart';
import 'package:bloodfit/custom_widgets/go_back_widget.dart';
import 'package:bloodfit/gen/colors.gen.dart';
import 'package:bloodfit/helper/ui_helpers.dart';
import 'package:bloodfit/routes/routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class YouAreAllSetScreen extends StatefulWidget {
  const YouAreAllSetScreen({super.key});

  @override
  State<YouAreAllSetScreen> createState() => _YouAreAllSetScreenState();
}

class _YouAreAllSetScreenState extends State<YouAreAllSetScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();

    // Create animation controller
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2000),
    );

    // Create a tween that goes from 0.5 (zoom out) to 1.0 (normal size)
    _animation = Tween<double>(begin: 0.5, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeOutBack, // You can change this to different curves
      ),
    );

    // Start the animation
    _controller.forward();

    // Optional: Add a listener to restart animation when it completes
    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        // You can reverse and forward again for continuous animation
        // _controller.reverse().then((_) => _controller.forward());
        Get.toNamed(Routes.navigationScreen);
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldBackgroundColor,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(UIHelper.kDefaulutPadding()),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              ///Section : ------------///CustomBackButton///----------
              Align(alignment: Alignment.centerLeft, child: CustomBackButton()),
              UIHelper.verticalSpace(66.h),

              ///Section : ----------///Text-> you are all set///---------
              Text(
                "You Are All Set",
                style: TextFontStyle.headline22w500cfefefeStylePoppins,
              ),
              UIHelper.verticalSpace(22.h),

              ///Section : ----------///Text-> you are all set///---------
              Text(
                "Your Personalized Plans Are Ready",
                style: TextFontStyle.headline18w500cfefefeStylePoppins,
              ),
              UIHelper.verticalSpace(200.h),

              ///Section : ---------///Animated Circle of All Set///---------
              AnimatedBuilder(
                animation: _animation,
                builder: (context, child) {
                  return Transform.scale(
                    scale: _animation.value,
                    child: Container(
                      width: 88.w,
                      height: 88.h,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: AppColors.cb20000,
                      ),
                      child: Icon(Icons.done, color: AppColors.c000000),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
