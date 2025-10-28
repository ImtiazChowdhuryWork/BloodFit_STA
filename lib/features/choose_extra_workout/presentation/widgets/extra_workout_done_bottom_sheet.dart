import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

import '../../../../constants/text_font_style.dart';
import '../../../../custom_widgets/custom_elevated_button.dart';
import '../../../../gen/assets.gen.dart';
import '../../../../gen/colors.gen.dart';
import '../../../../helper/ui_helpers.dart';
import '../../../../routes/routes.dart';

void showExtraWorkoutDoneBottomSheet() {
  Get.bottomSheet(
    Container(
      width: 1.sw,
      height: 0.25.sh,
      padding: EdgeInsets.all(20.sp),
      decoration: BoxDecoration(color: AppColors.c111111),
      child: Column(
        children: [
          //Section : Top Divider
          Container(
            width: 76.w,
            height: 3.h,
            decoration: BoxDecoration(
              color: AppColors.c999999,
              borderRadius: BorderRadius.circular(10.r),
            ),
          ),
          UIHelper.verticalSpace(20.h),

          ///Section : ----------///Text-> Great! You’ve Completed Your Workout///---------------
          Row(
            children: [
              SvgPicture.asset(Assets.icons.aiIcon),
              UIHelper.horizontalSpace(8.w),
              Text(
                "Gwesome! You’ve Done Extra Workout",
                style: TextFontStyle.headline18w500cfefefeStylePoppins,
              ),
            ],
          ),
          UIHelper.verticalSpace(16.h),

          ///Section : ----------///Text-> Every Workout Brings You One Step...///---------------
          Text(
            "Extra Effort Today Means Even Greater Results Tomorrow! Let’s Stay MotivatedLike This. ",
            textAlign: TextAlign.center,
            style: TextFontStyle.headline12w400cfefefeStylePoppins,
          ),
          Spacer(),

          ///Sectio: ---------///Button : Continue///-------------------
          CustomElevatedButton(
            onTap: () {
              log("Button Taped : Continue");
              Get.back();
              Get.toNamed(Routes.navigationScreen);
            },
            buttonHeight: 52.h,
            borderRadius: 24.w,
            buttonTitle: "Continue",
          ),
          UIHelper.verticalSpace(UIHelper.kDefaulutPadding()),
        ],
      ),
    ),
  );
}
