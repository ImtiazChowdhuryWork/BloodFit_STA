import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class ErrorMessageWidget extends StatelessWidget {
  final RxString errorMessage;
  final VoidCallback onClear;
  final EdgeInsets? margin;
  final Color? backgroundColor;
  final Color? textColor;

  const ErrorMessageWidget({
    Key? key,
    required this.errorMessage,
    required this.onClear,
    this.margin,
    this.backgroundColor,
    this.textColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (errorMessage.value.isEmpty) {
        return const SizedBox.shrink();
      }

      return Container(
        width: double.infinity,
        padding: EdgeInsets.all(12.r),
        margin: margin ?? EdgeInsets.only(bottom: 16.h),
        decoration: BoxDecoration(
          color: backgroundColor ?? Colors.red.withOpacity(0.1),
          border: Border.all(color: textColor ?? Colors.red),
          borderRadius: BorderRadius.circular(8.r),
        ),
        child: Row(
          children: [
            Icon(Icons.error, color: textColor ?? Colors.red, size: 18.sp),
            SizedBox(width: 8.w),
            Expanded(
              child: Text(
                errorMessage.value,
                style: TextStyle(
                  color: textColor ?? Colors.red,
                  fontSize: 14.sp,
                ),
              ),
            ),
            GestureDetector(
              onTap: onClear,
              child: Icon(
                Icons.cancel,
                color: textColor ?? Colors.red,
                size: 18.sp,
              ),
            ),
          ],
        ),
      );
    });
  }
}
