import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../constants/text_font_style.dart';
import '../../../../gen/colors.gen.dart';
import '../../../../helper/ui_helpers.dart';

class MealPlanCalenderShapeWidget extends StatelessWidget {
  final String dayName;
  final String date;
  final Color? backgroundColor;
  const MealPlanCalenderShapeWidget({
    super.key,
    required this.dayName,
    required this.date,
    this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
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
          Text(dayName, style: TextFontStyle.headline16w500cfefefeStylePoppins),
          UIHelper.verticalSpace(10.h),

          Container(
            width: 44.w,
            height: 44.h,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: AppColors.cFFFFFF,
              shape: BoxShape.circle,
            ),
            child: Text(
              date,
              style: TextFontStyle.headline14w400cb20000StylePoppins,
            ),
          ),
        ],
      ),
    );
  }
}
