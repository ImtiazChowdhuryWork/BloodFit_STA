import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../../../constants/text_font_style.dart';
import '../../../../../../../gen/colors.gen.dart';

class WorkoutMainGoalTile extends StatelessWidget {
  final String boydType;
  final String bodyImage;
  final double? imageWidth;
  final void Function()? onTap;
  final bool isSelected;

  const WorkoutMainGoalTile({
    super.key,
    required this.boydType,
    required this.bodyImage,
    this.onTap,
    required this.isSelected,
    this.imageWidth,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.only(left: 32.w, right: 10.w),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.cde0000 : AppColors.cfefefe,
          borderRadius: BorderRadius.circular(10.r),
          border: isSelected
              ? Border.all(color: AppColors.cde0000, width: 2.w)
              : null,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              boydType,
              style: isSelected
                  ? TextFontStyle.headline22w500cfefefeStylePoppins
                  : TextFontStyle.headline22w500c111111StylePoppins,
            ),
            Stack(
              children: [
                Image.asset(
                  bodyImage,
                  height: 130.h,
                  width: imageWidth ?? 137.w,
                  fit: BoxFit.contain,
                ),

                /// Selection indicator
                if (isSelected)
                  Positioned(
                    top: 10.h,
                    right: 10.w,
                    child: Container(
                      width: 24.w,
                      height: 24.h,
                      decoration: BoxDecoration(
                        color: AppColors.cfefefe,
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: AppColors.cde0000,
                          width: 2.w,
                        ),
                      ),
                      child: Icon(
                        Icons.check,
                        color: AppColors.cde0000,
                        size: 16.h,
                      ),
                    ),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
