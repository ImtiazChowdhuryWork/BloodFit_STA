import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import '../../../../../../../constants/text_font_style.dart';
import '../../../../../../../gen/colors.gen.dart';
import '../../../../../../../helper/ui_helpers.dart';

class PreferedWorkOutLevelShowingWidget extends StatelessWidget {
  final String iconPath;
  final String title;
  final bool isSelected;
  final VoidCallback onTap;

  const PreferedWorkOutLevelShowingWidget({
    super.key,
    required this.iconPath,
    required this.title,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        width: 1.sw,
        padding: EdgeInsets.all(12.sp),
        margin: EdgeInsets.only(bottom: 12.h),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10.r),
          color: !isSelected ? AppColors.cfefefe : null,
          gradient: isSelected
              ? LinearGradient(
                  colors: [
                    AppColors.cb20000, // Left side
                    AppColors.c4e000b, // Right side
                  ],
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                )
              : null,
        ),
        child: Row(
          children: [
            SvgPicture.asset(
              iconPath,
              color: isSelected ? AppColors.cfefefe : AppColors.c111111,
            ),
            UIHelper.horizontalSpace(10.w),
            Expanded(
              child: Text(
                title,
                style: TextFontStyle.headline22w500c111111StylePoppins
                    ?.copyWith(
                      color: isSelected ? AppColors.cfefefe : AppColors.c111111,
                    ),
              ),
            ),
            Container(
              width: 24.w,
              height: 24.h,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: isSelected ? Colors.white : AppColors.c3c3c3c,
              ),
              child: isSelected
                  ? Icon(Icons.done, color: AppColors.c111111, size: 20.sp)
                  : SizedBox.shrink(),
            ),
          ],
        ),
      ),
    );
  }
}
