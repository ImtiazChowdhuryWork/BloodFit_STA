import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

import '../../../../constants/text_font_style.dart';
import '../../../../gen/assets.gen.dart';
import '../../../../gen/colors.gen.dart';
import '../../../../helper/ui_helpers.dart';

class ReceivedThreeMealPlansWidget extends StatelessWidget {
  const ReceivedThreeMealPlansWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 1.sw,
      padding: EdgeInsets.all(10.sp),
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.cfefefe),
        borderRadius: BorderRadius.circular(16.r),
        gradient: LinearGradient(
          colors: [
            AppColors.cb20000, // Left side
            AppColors.c220e0e, // Right side
          ],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: RichText(
              text: TextSpan(
                children: [
                  TextSpan(
                    text: "You’ve Received ",
                    style: TextFontStyle.headline16w400cd7d7d7StylePoppins,
                  ),
                  TextSpan(
                    text: "${3} free Meal Plans ",
                    style: TextFontStyle.headline16w500cfefefeStylePoppins,
                  ),
                  TextSpan(
                    text: "for Today!",
                    style: TextFontStyle.headline16w400cd7d7d7StylePoppins,
                  ),
                ],
              ),
            ),
          ),
          UIHelper.horizontalSpace(10.w),
          SvgPicture.asset(Assets.icons.giftBoxIcon),
        ],
      ),
    );
  }
}
