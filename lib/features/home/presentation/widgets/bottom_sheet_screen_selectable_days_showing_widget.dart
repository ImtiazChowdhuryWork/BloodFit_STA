import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../constants/text_font_style.dart';
import '../../../../gen/colors.gen.dart';
import '../../../../helper/ui_helpers.dart';

class BottomSheetScreenSelectableDaysShowingWidget extends StatelessWidget {
  final String title;
  final bool isSelected;
  final void Function()? onTap;
  const BottomSheetScreenSelectableDaysShowingWidget({
    super.key,
    required this.isSelected,
    required this.title,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        // Remove fixed padding or add constraints that allow shrinking
        padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
        constraints: BoxConstraints(
          minWidth: 60.w, // Minimum width but can expand
        ),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.c3c3c3c : AppColors.c111111,
          border: Border.all(
            color: isSelected ? AppColors.cb20000 : AppColors.c999999,
          ),
          borderRadius: BorderRadius.circular(8.r),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min, // This is correct
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: EdgeInsets.all(4.sp),
              decoration: BoxDecoration(
                color: isSelected ? AppColors.cb20000 : AppColors.c111111,
                shape: BoxShape.circle,
                border: !isSelected
                    ? Border.all(color: AppColors.cfefefe)
                    : null,
              ),
              child: Icon(
                Icons.done,
                size: 14.sp,
                color: isSelected ? AppColors.c3c3c3c : AppColors.cfefefe,
              ),
            ),
            UIHelper.horizontalSpace(8.w), // Reduced space
            Flexible(
              // Add Flexible to prevent overflow
              child: Text(
                title,
                style: TextFontStyle.headline16w500cfefefeStylePoppins,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
