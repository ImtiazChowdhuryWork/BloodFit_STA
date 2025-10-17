import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

import '../../../../constants/text_font_style.dart';
import '../../../../gen/assets.gen.dart';
import '../../../../gen/colors.gen.dart';
import '../../../../helper/ui_helpers.dart';

class NumberSectionWidget extends StatelessWidget {
  final int numberValue;
  const NumberSectionWidget({super.key, required this.numberValue});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 3.h),
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.cc6c6c6),
        borderRadius: BorderRadius.circular(16.r),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          SvgPicture.asset(Assets.icons.fireGray),
          UIHelper.horizontalSpace(6.w),
          Text(
            numberValue.toString(),
            style: TextFontStyle.headline16w500cc6c6c6StylePoppins,
          ),
        ],
      ),
    );
  }
}
