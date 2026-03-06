
import 'package:bloodfit/gen/assets.gen.dart';
import 'package:bloodfit/helper/ui_helpers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lottie/lottie.dart';
import '../constants/text_font_style.dart';
import '../gen/colors.gen.dart';

class CustomElevatedButton extends StatelessWidget {
  final String? buttonTitle;
  final Widget? child;
  final double? borderRadius;
  final double? buttonHeight;
  final double? buttonWidth;
  final Color? buttonBorderColor;
  final bool isButtonBorderUsed;
  final Color? buttonColor;
  final TextStyle? textStyle;
  final double? buttonBorderWidth;
  final bool isDisabled;
  final bool isLoading;
  final List<BoxShadow>? boxShadow; // ✅ New optional property

  final void Function()? onTap;

  const CustomElevatedButton({
    super.key,
    this.buttonTitle,
    this.child,
    this.borderRadius,
    this.buttonHeight,
    this.buttonWidth,
    this.buttonBorderColor,
    this.isButtonBorderUsed = false,
    this.onTap,
    this.buttonColor,
    this.textStyle,
    this.buttonBorderWidth,
    this.isDisabled = false,
    this.isLoading = false,
    this.boxShadow, // ✅ Add to constructor
  });

  @override
  Widget build(BuildContext context) {
    final bool canTap = !isDisabled && onTap != null;

    return InkWell(
      onTap: canTap ? onTap : null,
      borderRadius: BorderRadius.circular(borderRadius ?? 8.r),
      child: Container(
        width: buttonWidth,
        height: buttonHeight ?? 60.h,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: isDisabled
              ? (buttonColor ?? AppColors.cb20000).withOpacity(0.4)
              : buttonColor ?? AppColors.cb20000,
          border: isButtonBorderUsed
              ? Border.all(
                  color: buttonBorderColor ?? AppColors.c999999,
                  width: buttonBorderWidth ?? 1.sp,
                )
              : null,
          borderRadius: BorderRadius.circular(borderRadius ?? 8.r),
          boxShadow: boxShadow, // ✅ Apply shadow if provided
        ),
        child: Center(
          child: child ??
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  isLoading
                      ? Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              buttonTitle ?? "",
                              textAlign: TextAlign.center,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: (textStyle ??
                                      TextFontStyle
                                          .headline16w500cFFFFFFStylePoppins)
                                  .copyWith(
                                color: isDisabled
                                    ? Colors.blueGrey
                                    : AppColors.cFFFFFF,
                              ),
                            ),
                            UIHelper.horizontalSpace(10.w),
                            Lottie.asset(Assets.lottie.waiting),
                          ],
                        )
                      : Text(
                          buttonTitle ?? "",
                          textAlign: TextAlign.center,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: (textStyle ??
                                  TextFontStyle
                                      .headline16w500cFFFFFFStylePoppins)
                              .copyWith(
                            color: isDisabled
                                ? AppColors.cFFFFFF.withOpacity(0.6)
                                : AppColors.cFFFFFF,
                          ),
                        ),
                ],
              ),
        ),
      ),
    );
  }
}