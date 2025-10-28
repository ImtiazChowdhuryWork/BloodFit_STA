import 'dart:developer';

import 'package:bloodfit/constants/text_font_style.dart';
import 'package:bloodfit/controllers/work_out_screen_controller.dart';
import 'package:bloodfit/custom_widgets/custom_elevated_button.dart';
import 'package:bloodfit/gen/assets.gen.dart';
import 'package:bloodfit/gen/colors.gen.dart';
import 'package:bloodfit/helper/ui_helpers.dart';
import 'package:bloodfit/routes/routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

void showWorkOutCompletedBottomSheet() {
  final WorkOutScreenController workOutScreenController =
      Get.find<WorkOutScreenController>();
  Get.bottomSheet(
    backgroundColor: AppColors.c111111,

    Container(
      width: 1.sw,
      height: 0.25.sh,
      padding: EdgeInsets.all(20.sp),

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
                "Great! You’ve Completed Your Workout",
                style: TextFontStyle.headline18w500cfefefeStylePoppins,
              ),
            ],
          ),
          UIHelper.verticalSpace(16.h),

          ///Section : ----------///Text-> Every Workout Brings You One Step...///---------------
          Text(
            "Every Workout Brings You One Step Closer To Your Goal. Let’s Take Some Rest Now And Get Ready For Tomorrow.",
            textAlign: TextAlign.center,
            style: TextFontStyle.headline12w400cfefefeStylePoppins,
          ),
          Spacer(),

          ///Sectio: ---------///Button : Continue///-------------------
          CustomElevatedButton(
            onTap: () {
              log("Button Taped : Continue");
              Get.back();
              workOutScreenController.setIsExtraWorkoutVisible(newValue: true);
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
