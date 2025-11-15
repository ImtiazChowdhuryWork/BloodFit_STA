import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../constants/text_font_style.dart';
import '../gen/colors.gen.dart';

class CustomButton extends StatelessWidget {
  final String text;
  final VoidCallback onTap;
  final double? height;
  final double? minWidth;
  final double? borderRadius;
  final Color? color;
  final TextStyle? textStyle;
  final EdgeInsetsGeometry? padding;
  final BoxBorder? border;
  final AlignmentGeometry? alignment;

  const CustomButton({
    super.key,
    required this.text,
    required this.onTap,
    this.height,
    this.minWidth,
    this.borderRadius,
    this.color,
    this.textStyle,
    this.padding,
    this.border,
    this.alignment,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        alignment: alignment,
        width: minWidth ?? double.infinity,
        height: height ?? 50.sp,
        padding: padding ?? EdgeInsets.all(14.sp),
        decoration: BoxDecoration(
          border: border,
          color: color ?? AppColors.cb20000,
          borderRadius: BorderRadius.circular(borderRadius ?? 8.sp),
        ),
        child: Text(
          text,
          textAlign: TextAlign.center,
          style: textStyle ?? TextFontStyle.headline16w500cFFFFFFStylePoppins,
        ),
      ),
    );
  }
}
