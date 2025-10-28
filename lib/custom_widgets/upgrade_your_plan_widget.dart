import 'dart:developer';

import 'package:bloodfit/constants/text_font_style.dart';
import 'package:bloodfit/custom_widgets/custom_elevated_button.dart';
import 'package:bloodfit/gen/colors.gen.dart';
import 'package:bloodfit/helper/ui_helpers.dart';
import 'package:bloodfit/routes/routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class UpgradeYourPlanWidget extends StatelessWidget {
  const UpgradeYourPlanWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: 1.sw,
        padding: EdgeInsets.symmetric(vertical: 26.h, horizontal: 15.w),
        decoration: BoxDecoration(
          color: AppColors.c3c3c3c,
          borderRadius: BorderRadius.circular(12.r),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// Description
            Text(
              "You're On The Plan With Meal Plans, Upgrade To Elite For Workout Suggestions!",
              textAlign: TextAlign.center,
              style: TextFontStyle.headline16w500cfefefeStylePoppins,
            ),
            UIHelper.verticalSpace(28.h),

            /// Upgrade Button
            Align(
              alignment: Alignment.center,
              child: CustomElevatedButton(
                onTap: () {
                  log("Button Tapped: Upgrade Plan");
                  Get.toNamed(Routes.informationGatherWorkoutScreen);
                },
                buttonHeight: 60.h,
                buttonWidth: 0.4.sw,
                borderRadius: 8.r,
                buttonTitle: "Upgrade Plan",
              ),
            ),
          ],
        ),
      ),
    );
  }
}
