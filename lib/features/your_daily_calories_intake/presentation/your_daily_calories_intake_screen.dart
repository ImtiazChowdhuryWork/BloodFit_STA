import 'dart:developer';

import 'package:bloodfit/constants/text_font_style.dart';
import 'package:bloodfit/custom_widgets/custom_elevated_button.dart';
import 'package:bloodfit/custom_widgets/go_back_widget.dart';
import 'package:bloodfit/gen/colors.gen.dart';
import 'package:bloodfit/helper/ui_helpers.dart';
import 'package:bloodfit/routes/routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class YourDailyCaloriesIntakeScreen extends StatelessWidget {
  const YourDailyCaloriesIntakeScreen({super.key});

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
                "To Achieve Your Goal You Should Consume 1500 Calories Everyday",
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
                      Text(
                        "1500",
                        style: TextFontStyle.headline24w700cfefefeStylePoppins,
                      ),
                      UIHelper.verticalSpace(2.h),
                      Text(
                        "Cal Per Day",
                        style: TextFontStyle.headline14w500cfefefeStylePoppins,
                      ),
                    ],
                  ),
                ),
              ),
              Spacer(),

              CustomElevatedButton(
                onTap: () {
                  log("Continue Button Taped");
                  Get.toNamed(Routes.youAreAllSetScreen);
                },
                buttonTitle: "Continue",
              ),
              UIHelper.verticalSpace(UIHelper.kDefaulutPadding()),
            ],
          ),
        ),
      ),
    );
  }
}
