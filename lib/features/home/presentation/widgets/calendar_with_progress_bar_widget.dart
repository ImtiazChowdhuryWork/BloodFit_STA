import 'package:bloodfit/constants/text_font_style.dart';
import 'package:bloodfit/gen/assets.gen.dart';
import 'package:bloodfit/gen/colors.gen.dart';
import 'package:bloodfit/helper/ui_helpers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../constants/app_enums.dart';

class CalenderWithProgressbarWidget extends StatelessWidget {
  final double height;
  final double width;
  final String dayName;
  final String date;
  final String completedCaloriesIconPath;

  final double progress;
  final double srokeWidth;
  final Color? progressColor;
  final Color? backgroundColor;
  final Widget? child;
  final bool isCalorieTaskCompleted;
  final bool isCheatDay;
  final UserSubscriptionType userSubscriptionType;
  const CalenderWithProgressbarWidget({
    super.key,

    required this.dayName,
    required this.height,
    required this.width,
    required this.progress,
    required this.srokeWidth,
    this.progressColor,
    this.backgroundColor,
    this.child,
    required this.isCalorieTaskCompleted,
    required this.completedCaloriesIconPath,
    this.isCheatDay = false,
    required this.userSubscriptionType,
    required this.date,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        ///Section : ------///DayName///----------
        Text(dayName, style: TextFontStyle.headline16w500cfefefeStylePoppins),
        UIHelper.verticalSpace(10.h),

        ///Section : -------///Container Box///-----------------
        SizedBox(
          height: height,
          width: width,

          child: Stack(
            children: [
              ///Circular Background
              Container(
                width: width,
                height: height,

                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: isCalorieTaskCompleted || isCheatDay
                      ? AppColors.cb20000
                      : AppColors.c363636,
                  shape: BoxShape.circle,
                ),
                child: isCheatDay
                    ? SvgPicture.asset(Assets.icons.documentIcon)
                    : isCalorieTaskCompleted
                    ? SvgPicture.asset(completedCaloriesIconPath)
                    : Text(
                        date,
                        style: TextFontStyle.headline16w500c999999StylePoppins,
                      ),
              ),

              // Circular progress ring
              isCalorieTaskCompleted || isCheatDay
                  ? SizedBox.shrink()
                  : SizedBox(
                      width: width,
                      height: height,
                      child: CircularProgressIndicator(
                        value: progress,
                        strokeWidth: srokeWidth,
                        valueColor: AlwaysStoppedAnimation(progressColor),
                        backgroundColor: backgroundColor,
                      ),
                    ),

              // Optional child widget inside the circle
              if (child != null) child!,
            ],
          ),
        ),
      ],
    );
  }
}
