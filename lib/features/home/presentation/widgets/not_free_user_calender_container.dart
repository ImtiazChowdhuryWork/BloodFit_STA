import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

import '../../../../constants/text_font_style.dart';
import '../../../../gen/assets.gen.dart';
import '../../../../gen/colors.gen.dart';
import '../../../../helper/ui_helpers.dart';

class NotFreeUserCalendarContainer extends StatelessWidget {
  final bool isCheatDay;
  final bool isCalorieTaskCompleted;
  final double height;
  final double width;
  final double progress;
  final double strokeWidth;
  final Color progressColor;
  final Color backgroundColor;
  final Widget? child;

  const NotFreeUserCalendarContainer({
    super.key,
    required this.isCheatDay,
    required this.isCalorieTaskCompleted,
    required this.height,
    required this.width,
    required this.progress,
    required this.strokeWidth,
    required this.progressColor,
    required this.backgroundColor,
    this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 8.h, horizontal: 10.w),
      decoration: BoxDecoration(
        color: AppColors.cb20000,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(8.r),
          topRight: Radius.circular(8.r),
          bottomLeft: Radius.circular(50.r),
          bottomRight: Radius.circular(50.r),
        ),
      ),
      child: Column(
        children: [
          Text("Thu", style: TextFontStyle.headline16w500cfefefeStylePoppins),
          UIHelper.verticalSpace(10.h),
          SizedBox(
            width: width,
            height: height,
            child: Stack(
              alignment: Alignment.center,
              children: [
                // Circle background
                Container(
                  width: width - strokeWidth, // So progress is visible
                  height: height - strokeWidth,
                  decoration: BoxDecoration(
                    color: AppColors.cFFFFFF,
                    shape: BoxShape.circle,
                  ),
                  alignment: Alignment.center,
                  child: isCheatDay
                      ? SvgPicture.asset(
                          Assets.icons.documentIcon,
                          color: AppColors.c000000,
                        )
                      : isCalorieTaskCompleted
                      ? SvgPicture.asset(Assets.icons.fireGray)
                      : Text(
                          "21",
                          style:
                              TextFontStyle.headline16w500cb20000StylePoppins,
                        ),
                ),

                // Circular progress indicator behind content
                !isCalorieTaskCompleted || isCheatDay || progress < 1
                    ? SizedBox(
                        width: width,
                        height: height,
                        child: CircularProgressIndicator(
                          value: progress,
                          strokeWidth: strokeWidth,
                          valueColor: AlwaysStoppedAnimation(progressColor),
                          backgroundColor: backgroundColor,
                        ),
                      )
                    : SizedBox.shrink(),

                // Optional child
                if (child != null) child!,
              ],
            ),
          ),
        ],
      ),
    );
  }
}
