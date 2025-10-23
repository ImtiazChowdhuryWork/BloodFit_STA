import 'dart:developer';

import 'package:bloodfit/constants/text_font_style.dart';
import 'package:bloodfit/gen/assets.gen.dart';
import 'package:bloodfit/gen/colors.gen.dart';
import 'package:bloodfit/helper/ui_helpers.dart';
import 'package:bloodfit/routes/routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

import '../../../../custom_widgets/custom_elevated_button.dart';

void showMealPlanBuildConfirmationBottomSheet() {
  Get.bottomSheet(
    isDismissible: false,
    backgroundColor: AppColors.c111111,
    Container(
      width: 1.sw,
      height: 0.3.sh,
      padding: EdgeInsets.only(
        left: 20.w,
        right: 20.w,
        top: 23.h,
        bottom: 27.h,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          ///Section : -------///Top Divider///--------
          Container(
            width: 76.w,
            height: 3.h,
            decoration: BoxDecoration(
              color: AppColors.c999999,
              borderRadius: BorderRadius.circular(10.r),
            ),
          ),
          UIHelper.verticalSpace(20.h),

          ///Section : -------///Icon -> AI///--------
          ///Section : -------///Text -> Great! You’ve Build Your Mealplan.///--------
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SvgPicture.asset(Assets.icons.aiIcon),
              UIHelper.horizontalSpace(10.w),
              Text(
                "Great! You’ve Build Your Mealplan.",
                style: TextFontStyle.headline18w500cfefefeStylePoppins,
              ),
            ],
          ),
          UIHelper.verticalSpace(16.h),

          ///Section : -------------///Text -> You’ve taken the first step toward a healthier, stronger you. Let’s get started and turn your plan into real progress.///---------
          Text(
            "You’ve Taken The First Step Toward A Healthier, Stronger You. Let’s Get Started And Turn Your Plan Into Real Progress.",
            textAlign: TextAlign.center,
            style: TextFontStyle.headline12w400cfefefeStylePoppins,
          ),
          Spacer(),

          ///Section : -----------///Button -> Confirm Meal Plan///------------
          CustomElevatedButton(
            onTap: () {
              log("Button Taped -> Continue");
              Get.back();
              Get.toNamed(Routes.navigationScreen);
            },
            buttonWidth: 1.sw,
            buttonHeight: 52.h,
            borderRadius: 24.r,
            buttonTitle: "Continue",
          ),
          UIHelper.verticalSpace(20.h),
        ],
      ),
    ),
  );
}
