import 'dart:developer';

import 'package:bloodfit/constants/text_font_style.dart';
import 'package:bloodfit/features/work_out/presentation/widgets/current_day_workout_details_tile_widget.dart';
import 'package:bloodfit/gen/assets.gen.dart';
import 'package:bloodfit/gen/colors.gen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../../helper/ui_helpers.dart';

class WorkoutVideoShowingWidget extends StatelessWidget {
  final bool isChecked;
  final void Function(bool?)? onChanged;
  const WorkoutVideoShowingWidget({
    super.key,
    required this.isChecked,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Warmup", style: TextFontStyle.headline18w500cfefefeStylePoppins),
        UIHelper.verticalSpace(16.h),

        Container(
          width: 1.sw,
          padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 10.h),
          decoration: BoxDecoration(
            color: AppColors.c000000,
            border: Border.all(color: AppColors.c191919),
            borderRadius: BorderRadius.circular(8.r),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ///Section : ------------///Work-Out Image///-------------
              ClipRRect(
                borderRadius: BorderRadius.circular(8.r),
                child: Image.asset(
                  Assets.images.workoutImage.path,
                  height: 130.h,
                  width: 153.w,
                  fit: BoxFit.cover,
                ),
              ),
              UIHelper.horizontalSpace(26.w),

              ///Section : ----------------///Workout Title///----------------
              Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Leg Stretching",
                        style: TextFontStyle.headline16w500cfefefeStylePoppins,
                      ),
                      Spacer(),

                      ///Section : -----------------///Checkbox///----------------
                      Checkbox(
                        value: isChecked,
                        onChanged: onChanged,
                        activeColor: AppColors.cde0000,
                        checkColor: AppColors.cd7d7d7,
                        side: BorderSide(color: AppColors.cd7d7d7),
                      ),
                    ],
                  ),
                  UIHelper.verticalSpace(16.h),

                  ///Section : ---------------///Workout Details///----------------------///Section : ---------///Workout Type Details Widget///---------------
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
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}
