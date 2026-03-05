import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../constants/text_font_style.dart';
import '../../../../gen/colors.gen.dart';
import '../../../../helper/ui_helpers.dart';

class MealStatusCardWidget extends StatelessWidget {
  final bool isSelected;
  final String mealName;
  final String mealType;
  
  const MealStatusCardWidget({
    super.key,
    required this.isSelected,
    required this.mealName,
    required this.mealType,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 120.w,
      padding: EdgeInsets.all(10.sp),
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: isSelected ? AppColors.cb20000 : AppColors.c909090,
        borderRadius: BorderRadius.circular(8.r),
      ),
      child: Column(
        children: [
          Text(
            isSelected ? '✓' : '○',
            style: TextFontStyle.headline22w600cfefefeStylePoppins.copyWith(
              fontSize: 14.sp,
            ),
          ),
          UIHelper.verticalSpace(4.h),
          Text(
            mealName,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextFontStyle.headline14w500cfefefeStylePoppins.copyWith(
              fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
              fontSize: 12.sp,
            ),
          ),
          UIHelper.verticalSpace(4.h),
          Text(
            mealType,
            style: TextFontStyle.headline14w500cc6c6c6StylePoppins.copyWith(
              fontSize: 12.sp,
            ),
          ),
        ],
      ),
    );
  }
}
