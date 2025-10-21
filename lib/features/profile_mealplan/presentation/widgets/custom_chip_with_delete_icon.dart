import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class TopRightDeleteChip extends StatelessWidget {
  final String label;
  final VoidCallback? onDelete;
  final Color chipColor;
  final TextStyle? textStyle;
  final Color deleteIconColor;
  final Color deleteBackgroundColor;
  final EdgeInsets? padding;
  final double borderRadius;

  const TopRightDeleteChip({
    Key? key,
    required this.label,
    this.onDelete,
    this.chipColor = const Color(0xFF3C3C3C),
    this.textStyle,
    this.deleteIconColor = const Color(0xFF111111),
    this.deleteBackgroundColor = const Color(0xFFFFFFFF),
    this.padding,
    this.borderRadius = 8,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Container(
          padding:
              padding ?? EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
          decoration: BoxDecoration(
            color: chipColor,
            borderRadius: BorderRadius.circular(borderRadius.r),
          ),
          child: Text(label, style: textStyle),
        ),
        if (onDelete != null)
          Positioned(
            right: -6.w,
            top: -6.h,
            child: GestureDetector(
              onTap: onDelete,
              child: Container(
                decoration: BoxDecoration(
                  color: deleteBackgroundColor,
                  shape: BoxShape.circle,
                ),
                padding: EdgeInsets.all(2.w),
                child: Icon(Icons.close, size: 14.sp, color: deleteIconColor),
              ),
            ),
          ),
      ],
    );
  }
}
