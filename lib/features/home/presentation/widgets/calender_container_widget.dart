import 'package:bloodfit/constants/text_font_style.dart';
import 'package:bloodfit/gen/colors.gen.dart';
import 'package:bloodfit/helper/ui_helpers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

class CalenderContainerWidget extends StatelessWidget {
  final double height;
  final double width;
  final String inCompletedCaloriesIconPath;
  final String completedCaloriesIconPath;
  final String dayName;
  final double progress;
  final double srokeWidth;
  final Color? progressColor;
  final Color? backgroundColor;
  final Widget? child;
  final bool isCalorieTaskCompleted;
  const CalenderContainerWidget({
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
    required this.inCompletedCaloriesIconPath,
    required this.completedCaloriesIconPath,
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
                  color: isCalorieTaskCompleted
                      ? AppColors.cb20000
                      : AppColors.c363636,
                  shape: BoxShape.circle,
                ),
                child: SvgPicture.asset(
                  isCalorieTaskCompleted
                      ? completedCaloriesIconPath
                      : inCompletedCaloriesIconPath,
                ),
              ),

              // Circular progress ring
              isCalorieTaskCompleted
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
