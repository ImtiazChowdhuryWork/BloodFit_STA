import 'dart:developer';
import 'package:bloodfit/constants/text_font_style.dart';
import 'package:bloodfit/custom_widgets/custom_elevated_button.dart';
import 'package:bloodfit/features/work_out/presentation/widgets/current_day_workout_details_tile_widget.dart';
import 'package:bloodfit/gen/colors.gen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../helper/ui_helpers.dart';

class WorkoutVideoShowingWidget extends StatelessWidget {
  final String imagePath;
  final String videoTitle;
  final String duration;
  final int totalSets;
  final int totalCal;
  final bool isChecked;
  final void Function(bool?)? onChanged;
  final VoidCallback? onPlayVideoPressed;

  const WorkoutVideoShowingWidget({
    super.key,
    required this.isChecked,
    this.onChanged,
    this.onPlayVideoPressed,
    required this.imagePath,
    required this.videoTitle,
    required this.duration,
    required this.totalSets,
    required this.totalCal,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        /// Main Content (Your existing code)
        Container(
          width: double.infinity,
          padding: EdgeInsets.all(16.w),
          decoration: BoxDecoration(
            color: AppColors.c191919,
            borderRadius: BorderRadius.circular(12.r),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /// Video Thumbnail and Content Row
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  /// Video Thumbnail
                  Expanded(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(8.r),
                      child: Image.asset(
                        imagePath,
                        height: 138.h,
                        width: 120.w,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  UIHelper.horizontalSpace(16.w),

                  /// Video Content
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        /// Title and Checkbox Row - PROPERLY ALIGNED
                        Row(
                          crossAxisAlignment: CrossAxisAlignment
                              .center, // This ensures proper vertical alignment
                          children: [
                            /// Title - takes available space
                            Expanded(
                              child: Text(
                                videoTitle,
                                style: TextFontStyle
                                    .headline16w500cfefefeStylePoppins,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            UIHelper.horizontalSpace(8.w),

                            /// Checkbox - properly aligned with title
                            Checkbox(
                              value: isChecked,
                              onChanged: onChanged,
                              activeColor: AppColors.cde0000,
                              checkColor: AppColors.cfefefe,
                              side: BorderSide(color: AppColors.cd7d7d7),
                              materialTapTargetSize:
                                  MaterialTapTargetSize.shrinkWrap,
                            ),
                          ],
                        ),
                        UIHelper.verticalSpace(12.h),

                        /// Workout Details
                        Row(
                          children: [
                            CurrentDayWorkoutDetailsTileWidget(
                              title: "$duration Min",
                            ),
                            CurrentDayWorkoutDetailsTileWidget(
                              title: "$totalSets Sets",
                            ),
                            CurrentDayWorkoutDetailsTileWidget(
                              title: "$totalCal Cal.",
                              isDividerVisible: false,
                            ),
                          ],
                        ),
                        UIHelper.verticalSpace(24.h),

                        /// Play Video Button
                        CustomElevatedButton(
                          onTap:
                              onPlayVideoPressed ??
                              () {
                                log("Button Tapped: Play Video!");
                              },
                          buttonHeight: 44.h,
                          buttonWidth: 1.sw,
                          borderRadius: 20.r,
                          buttonTitle: "Play Video",
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),

        /// Glass Effect Overlay when isChecked is true - FIXED VERSION
        if (isChecked)
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.7),
                borderRadius: BorderRadius.circular(12.r),
              ),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Padding(
                  padding: EdgeInsets.only(left: 36.w),
                  child: Text(
                    "Completed",
                    style: TextFontStyle.headline22w600cfefefeStylePoppins,
                  ),
                ),
              ),
            ),
          ),
      ],
    );
  }
}
