import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../constants/text_font_style.dart';
import '../../../../gen/colors.gen.dart';
import '../../../../helper/ui_helpers.dart';

class MealStatusCardWidget extends StatelessWidget {
  final double totalMeal;
  final double selectedMeal;
  final String mealType;
  const MealStatusCardWidget({
    super.key,
    required this.totalMeal,
    required this.selectedMeal,
    required this.mealType,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 80.w,
      padding: EdgeInsets.all(10.sp),
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: AppColors.c909090,
        borderRadius: BorderRadius.circular(8.r),
      ),
      child: Column(
        children: [
          Text(
            "${selectedMeal % 1 == 0 ? selectedMeal.toInt() : selectedMeal}/${totalMeal % 1 == 0 ? totalMeal.toInt() : totalMeal}",
            style: TextFontStyle.headline12w400cfefefeStylePoppins,
          ),
          UIHelper.verticalSpace(8.h),
          Text(
            mealType,
            style: TextFontStyle.headline12w400cfefefeStylePoppins,
          ),
        ],
      ),
    );
  }
}
