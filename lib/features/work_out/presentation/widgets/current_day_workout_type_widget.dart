import 'dart:developer';

import 'package:bloodfit/constants/text_font_style.dart';
import 'package:bloodfit/custom_widgets/custom_elevated_button.dart';
import 'package:bloodfit/features/work_out/presentation/widgets/current_day_workout_details_tile_widget.dart';
import 'package:bloodfit/gen/assets.gen.dart';
import 'package:bloodfit/gen/colors.gen.dart';
import 'package:bloodfit/helper/ui_helpers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CurrentDayWorkoutTypeWidget extends StatelessWidget {
  const CurrentDayWorkoutTypeWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Background Image
        Container(
          width: 1.sw,
          height: 185.h,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(6.r),
            image: DecorationImage(
              fit: BoxFit.cover,
              image: AssetImage(Assets.images.workoutImage.path),
            ),
          ),
        ),
        // Gradient Overlay
        Container(
          width: 1.sw,
          height: 185.h,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(6.r),
            gradient: LinearGradient(
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
              colors: [Colors.black.withOpacity(1), Colors.transparent],
              stops: [0.0, 0.7],
            ),
          ),
        ),
        // Your content
        Container(
          width: 1.sw,
          height: 185.h,

          decoration: BoxDecoration(
            border: Border.all(color: AppColors.cc6c6c6),
            borderRadius: BorderRadius.circular(6.r),
          ),
          padding: EdgeInsets.all(10.sp),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ///Section : ---------///Workout Type Title///---------------
              Text(
                "It’s Your Upper Body Day! ",
                style: TextFontStyle.headline20w500cfefefeStylePoppins,
              ),
              UIHelper.verticalSpace(8.h),

              ///Section : ---------///Workout Type Details Widget///---------------
              Row(
                children: [
                  CurrentDayWorkoutDetailsTileWidget(title: "40 Min"),
                  CurrentDayWorkoutDetailsTileWidget(title: "Medium"),
                  CurrentDayWorkoutDetailsTileWidget(
                    title: "500 calories",
                    isDividerVisible: false,
                  ),
                ],
              ),
              UIHelper.verticalSpace(22.h),

              ///Section : ----------///Button : Start Workout///-----------------
              CustomElevatedButton(
                onTap: () {
                  log("Button Taped : Start Workout");
                },
                buttonTitle: "Start Workout",
                buttonWidth: 136.w,
                buttonHeight: 48.h,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
