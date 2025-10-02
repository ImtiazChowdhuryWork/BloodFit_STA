import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

import '../../../../constants/text_font_style.dart';
import '../../../../gen/assets.gen.dart';
import '../../../../gen/colors.gen.dart';
import '../../../../helper/ui_helpers.dart';

class NotificatoinShowingWidget extends StatelessWidget {
  final String title;
  final String time;
  const NotificatoinShowingWidget({
    super.key,
    required this.title,
    required this.time,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 1.sw,
      // height: 50.h,
      padding: EdgeInsets.all(10.sp),
      decoration: BoxDecoration(
        color: AppColors.c3c3c3c,
        border: Border.all(color: AppColors.cb20000),
        borderRadius: BorderRadius.circular(8.r),
      ),
      child: Row(
        children: [
          ///Section : ----------------///Icon -> RedBell///------------------
          Container(
            width: 44.w,
            height: 44.h,
            padding: EdgeInsets.all(10.sp),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.c111111,
            ),
            child: SvgPicture.asset(Assets.icons.redBellIcon),
          ),
          UIHelper.horizontalSpace(8.w),

          ///Section : ----------------///Notification///------------------
          Expanded(
            child: Text(
              title,
              style: TextFontStyle.headline14w500cfefefeStylePoppins,
            ),
          ),
          UIHelper.horizontalSpace(2.w),

          Align(
            alignment: Alignment.centerRight,
            child: Text(
              time,
              style: TextFontStyle.headline12w400c999999StylePoppins,
            ),
          ),
        ],
      ),
    );
  }
}
