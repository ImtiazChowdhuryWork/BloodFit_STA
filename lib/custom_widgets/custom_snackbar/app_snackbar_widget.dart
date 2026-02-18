import 'package:bloodfit/custom_widgets/custom_snackbar/app_snackbar_config.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../constants/app_enums.dart';

class AppSnackBarWidget extends StatelessWidget {
  final String message;
  final AppSnackBarType type;
  final VoidCallback onClose;

  const AppSnackBarWidget({
    super.key,
    required this.message,
    required this.type,
    required this.onClose,
  });

  @override
  Widget build(BuildContext context) {
    final config = getSnackBarConfig(type);

    return Material(
      color: Colors.transparent,
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 16.w),
        padding: EdgeInsets.all(12.r),
        decoration: BoxDecoration(
          color: config.backgroundColor,
          borderRadius: BorderRadius.circular(10.r),
          border: Border.all(color: config.borderColor),
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            Icon(config.icon, color: config.textColor, size: 20.sp),
            SizedBox(width: 10.w),
            Expanded(
              child: Text(
                message,
                style: TextStyle(
                  color: config.textColor,
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            GestureDetector(
              onTap: onClose,
              child: Icon(
                Icons.close,
                size: 18.sp,
                color: config.textColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
