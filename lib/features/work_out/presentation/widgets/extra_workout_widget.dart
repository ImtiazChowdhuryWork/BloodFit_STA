import 'dart:developer';

import 'package:bloodfit/constants/text_font_style.dart';
import 'package:bloodfit/custom_widgets/custom_elevated_button.dart';
import 'package:bloodfit/gen/assets.gen.dart';
import 'package:bloodfit/gen/colors.gen.dart';
import 'package:bloodfit/helper/ui_helpers.dart';
import 'package:bloodfit/routes/routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

class ExtraWorkoutWidget extends StatelessWidget {
  const ExtraWorkoutWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Great Job! Ready For More?",
          style: TextFontStyle.headline20w500cfefefeStylePoppins,
        ),
        UIHelper.verticalSpace(16.h),

        ///Section : ------------///Background Container with Image///--------------
        Stack(
          clipBehavior: Clip.none,
          children: [
            /// Outer Container
            Container(
              width: 1.sw,
              padding: EdgeInsets.all(20.sp),
              decoration: BoxDecoration(
                color: AppColors.c262626,
                borderRadius: BorderRadius.circular(8.r),
              ),
              child: Container(
                width: 1.sw,
                padding: EdgeInsets.symmetric(vertical: 16.h, horizontal: 20.w),
                decoration: BoxDecoration(
                  color: AppColors.c111111,
                  borderRadius: BorderRadius.circular(10.r),
                  border: Border.all(color: AppColors.c999999),
                ),
                child: Column(
                  children: [
                    ///Section : ---------///Text -> Boost Results With Extra Workouts///----------------
                    Text(
                      "Boost Results With Extra Workouts",
                      style: TextFontStyle.headline16w500cfefefeStylePoppins,
                    ),
                    UIHelper.verticalSpace(8.h),

                    ///Section : -----------///Text -> You're Crushing Your Goals! Let's Add Some Extra Workouts To Push Further///----------------
                    Text(
                      "You're Crushing Your Goals! Let's Add Some Extra Workouts To Push Further",
                      textAlign: TextAlign.start,
                      style: TextFontStyle.headline14w400cfefefeStylePoppins,
                    ),
                    UIHelper.verticalSpace(24.h),

                    ///Section : ---------///Button -> Add Extra Workouts///-------------
                    CustomElevatedButton(
                      onTap: () {
                        log("Button Taped : Add Extra Workouts");
                        Get.toNamed(Routes.chooseExtraWorkoutScreen);
                      },
                      buttonHeight: 40.h,
                      borderRadius: 24.r,
                      buttonTitle: "Add Extra Workouts",
                    ),
                  ],
                ),
              ),
            ),

            ///Section : ----------///Image -> Dumble in Top Right Corner///-------------
            Positioned(
              top: -20.h, // Adjust this value to position between containers
              right: 10.w, // Adjust this value to position between containers
              child: SvgPicture.asset(Assets.icons.dumbleIcon),
            ),
          ],
        ),
      ],
    );
  }
}
