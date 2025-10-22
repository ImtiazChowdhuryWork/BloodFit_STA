import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../constants/text_font_style.dart';
import '../../../../gen/colors.gen.dart';
import '../../../../helper/ui_helpers.dart';

class MealPlanCalenderShapeWidget extends StatelessWidget {
  final String dayName;
  final String date;
  final bool isToday;
  final Color? backgroundColor;
  final Color? dateColor;
  final Color? dayNameColor;
  final void Function()? onTap;

  const MealPlanCalenderShapeWidget({
    super.key,
    required this.dayName,
    required this.date,
    required this.isToday,
    this.backgroundColor,
    this.onTap,
    this.dateColor,
    this.dayNameColor,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16.r),
      child: Container(
        padding: EdgeInsets.all(10.sp),
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(16.r),
            topRight: Radius.circular(16.r),
            bottomLeft: Radius.circular(50.r),
            bottomRight: Radius.circular(50.r),
          ),
        ),
        child: Column(
          children: [
            Text(
              dayName,
              style: TextFontStyle.headline16w500cfefefeStylePoppins.copyWith(
                color: dayNameColor,
              ),
            ),
            UIHelper.verticalSpace(10.h),
            Container(
              width: 44.w,
              height: 44.h,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: isToday ? AppColors.cFFFFFF : AppColors.c262626,
                shape: BoxShape.circle,
              ),
              child: Text(
                date,
                style: TextFontStyle.headline14w400cb20000StylePoppins.copyWith(
                  color: dateColor,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
