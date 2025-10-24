import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../constants/text_font_style.dart';
import '../../../../gen/colors.gen.dart';
import '../../../../helper/ui_helpers.dart';

class HomeScreenSelectableDaysShowingWidget extends StatelessWidget {
  final String title;
  final bool isSelected;
  final void Function()? onTap;
  const HomeScreenSelectableDaysShowingWidget({
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
        padding: EdgeInsets.all(10.sp),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: isSelected ? AppColors.c3c3c3c : AppColors.c111111,
          border: Border.all(
            color: isSelected ? AppColors.cb20000 : AppColors.c999999,
          ),
          borderRadius: BorderRadius.circular(8.r),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: EdgeInsets.all(4.sp),
              alignment: Alignment.center,
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
            UIHelper.verticalSpace(10.h),
            Text(title, style: TextFontStyle.headline16w500cfefefeStylePoppins),
          ],
        ),
      ),
    );
  }
}
