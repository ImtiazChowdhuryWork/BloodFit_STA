import 'package:bloodfit/custom_widgets/custom_snackbar/app_snackbar_config.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../constants/app_enums.dart';

/// A toast-style message widget.
///
/// Displayed via [AppSnackBarController.show()] which handles auto-dismiss
/// after a set duration — no manual close button needed.
class AppSnackBarWidget extends StatelessWidget {
  final String message;
  final AppSnackBarType type;

  const AppSnackBarWidget({
    super.key,
    required this.message,
    required this.type,
  });

  @override
  Widget build(BuildContext context) {
    final config = getSnackBarConfig(type);

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 32.w),
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
      decoration: BoxDecoration(
        color: config.backgroundColor,
        borderRadius: BorderRadius.circular(24.r),
        border: Border.all(color: config.borderColor),
        boxShadow: const [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 8,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(config.icon, color: config.textColor, size: 18.sp),
          SizedBox(width: 8.w),
          Flexible(
            child: Text(
              message,
              style: TextStyle(
                color: config.textColor,
                fontSize: 13.sp,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
