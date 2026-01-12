import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../../../constants/text_font_style.dart';
import '../../../../../../../gen/colors.gen.dart';

class FocusAreaItem extends StatelessWidget {
  final void Function()? onTap;
  final double buttonTopPosition;
  final double buttonLeftPosition;
  final String title;
  final double pointerTopPosition;
  final double pointerRightPosition;
  final String pointerImagPath;
  final bool isSelected;
  final double buttonWidth;
  final double buttonHeight;
  final double pointerImageHeight;
  final double pointerImageWidth;

  const FocusAreaItem({
    super.key,
    this.onTap,
    required this.buttonTopPosition,
    required this.buttonLeftPosition,
    required this.title,
    required this.pointerTopPosition,
    required this.pointerRightPosition,
    required this.pointerImagPath,
    this.isSelected = false,
    required this.buttonWidth,
    this.buttonHeight = 44,
    required this.pointerImageHeight,
    required this.pointerImageWidth,
  });

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: buttonTopPosition.h,
      left: buttonLeftPosition.w,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          ///Section : Pointer
          Positioned(
            right: pointerRightPosition.w,
            top: pointerTopPosition.h,
            child: Opacity(
              opacity: 0.9,
              child: Image.asset(
                pointerImagPath,
                height: pointerImageHeight.h,
                width: pointerImageWidth.w,
                fit: BoxFit.cover,
              ),
            ),
          ),
          InkWell(
            onTap: onTap,
            child: Container(
              width: buttonWidth.w,
              height: buttonHeight.h,
              padding: EdgeInsets.all(10.sp),
              decoration: BoxDecoration(
                color: AppColors.cFFFFFF,
                gradient: isSelected
                    ? LinearGradient(
                        colors: [AppColors.cb20000, AppColors.c4e000b],
                        begin: Alignment.centerLeft,
                        end: Alignment.centerRight,
                      )
                    : null,
                borderRadius: BorderRadius.circular(4.r),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ///Section :--------///Button Title///----------------
                  Text(
                    title,
                    style: isSelected
                        ? TextFontStyle.headline14w500cfefefeStylePoppins
                        : TextFontStyle.headline14w500c111111StylePoppins,
                  ),

                  ///section : ---------///Circle Shape///--------
                  isSelected
                      ? Container(
                          width: 22.w,
                          height: 22.h,
                          decoration: BoxDecoration(
                            color: AppColors.cfefefe,
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            Icons.done_rounded,
                            color: AppColors.c3c3c3c,
                            size: 12.sp,
                          ),
                        )
                      : SizedBox.shrink(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
