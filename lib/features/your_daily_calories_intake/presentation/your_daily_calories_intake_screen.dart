import 'dart:developer';

import 'package:bloodfit/constants/text_font_style.dart';
import 'package:bloodfit/custom_widgets/custom_elevated_button.dart';
import 'package:bloodfit/custom_widgets/go_back_widget.dart';
import 'package:bloodfit/gen/assets.gen.dart';
import 'package:bloodfit/gen/colors.gen.dart';
import 'package:bloodfit/helper/ui_helpers.dart';
import 'package:bloodfit/routes/routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';

import '../data/controller/your_daily_calories_intake_screen_controller.dart';

class YourDailyCaloriesIntakeScreen extends StatefulWidget {
  const YourDailyCaloriesIntakeScreen({super.key});

  @override
  State<YourDailyCaloriesIntakeScreen> createState() =>
      _YourDailyCaloriesIntakeScreenState();
}

class _YourDailyCaloriesIntakeScreenState
    extends State<YourDailyCaloriesIntakeScreen> {


      late YourDailyCaloriesIntakeScreenController controller;
      @override
  void initState() {
    controller = Get.find<YourDailyCaloriesIntakeScreenController>();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.getYourDailyCaloriesIntakeApi();
    });
    super.initState();
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
              ///Section : -------------///Back Button///--------
              Align(alignment: Alignment.centerLeft, child: CustomBackButton()),
              UIHelper.verticalSpace(86.h),

              ///Section : ---------///Text-> your daily calorie intake///-------
              Text(
                "Your Daily Calorie Intake",
                style: TextFontStyle.headline22w500cfefefeStylePoppins,
              ),
              UIHelper.verticalSpace(16.h),

              ///Section : ---------///Text-> to achieve your goal you should consume 1500 calories everyday///-------
              Text(
                "To Achieve Your Goal You Should Consume ${controller.dailyConsumableCalories} Calories Everyday",
                textAlign: TextAlign.center,
                style: TextFontStyle.headline18w500c999999StylePoppins,
              ),
              UIHelper.verticalSpace(188.h),

              ///Section : -------------///Calories Circle///----------
              Align(
                alignment: Alignment.center,
                child: Container(
                  height: 180.h,
                  width: 180.w,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: AppColors.cb20000),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Obx(() {
                        return controller.isLoading.value
                            ? Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Lottie.asset(
                                    Assets.lottie.sandyLoading,
                                    width: 50.w,
                                    height: 50.h,
                                    fit: BoxFit.cover,
                                  ),
                                  Text(
                                    'Calculating...',
                                    textAlign: TextAlign.center,
                                    style: TextFontStyle
                                        .headline14w400cFFFFFFStylePoppins,
                                  ),
                                ],
                              )
                            : Text(
                                controller.dailyConsumableCalories,
                                textAlign: TextAlign.center,
                                style: controller.isSuccess.value
                                    ? TextFontStyle
                                          .headline24w700cfefefeStylePoppins
                                    : TextFontStyle
                                          .headline12w500cfefefeStylePoppins,
                              );
                      }),
                      UIHelper.verticalSpace(2.h),
                      Obx(() {
                        return controller.isLoading.value ||
                                controller.isSuccess.value == false
                            ? SizedBox.shrink()
                            : Text(
                                "Cal Per Day",
                                style: TextFontStyle
                                    .headline14w500cfefefeStylePoppins,
                              );
                      }),
                    ],
                  ),
                ),
              ),
              UIHelper.verticalSpace(10.h),
              Spacer(),



              ///------->>> Section : Navigation Button to Home Screen
              Obx(() {
                return CustomElevatedButton(
                  onTap: controller.isLoading.value
                      ? null
                      : () {
                          if (controller.isSuccess.value) {
                            log("Continue Button Taped");
                            Get.toNamed(Routes.youAreAllSetScreen);
                          } else {
                            controller.getYourDailyCaloriesIntakeApi();
                          }
                        },
                  buttonTitle: controller.isSuccess.value
                      ? "Continue"
                      : "Retry",
                  isLoading: controller.isLoading.value,
                  buttonColor: controller.isLoading.value
                      ? Colors.grey
                      : AppColors.cb20000,
                );
              }),
              UIHelper.verticalSpace(UIHelper.kDefaulutPadding()),
            ],
          ),
        ),
      ),
    );
  }
}
