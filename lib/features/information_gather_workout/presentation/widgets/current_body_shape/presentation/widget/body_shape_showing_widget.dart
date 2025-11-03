import 'package:bloodfit/constants/text_font_style.dart';
import 'package:bloodfit/gen/assets.gen.dart';
import 'package:bloodfit/gen/colors.gen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class BodyShapeShowingWidget extends StatelessWidget {
  final String boydType;
  final String bodyImage;
  final void Function()? onTap;
  final bool isSelected;

  const BodyShapeShowingWidget({
    super.key,
    required this.boydType,
    required this.bodyImage,
    this.onTap,
    required this.isSelected,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.only(left: 32.w, right: 10.w),
        decoration: BoxDecoration(
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
          borderRadius: BorderRadius.circular(10.r),
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
                  width: 137.w,
                  fit: BoxFit.cover,
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
