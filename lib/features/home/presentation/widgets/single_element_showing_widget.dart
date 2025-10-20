import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

import '../../../../constants/text_font_style.dart';
import '../../../../gen/assets.gen.dart';
import '../../../../gen/colors.gen.dart';
import '../../../../helper/ui_helpers.dart';

class SingleElementShowingWidget extends StatelessWidget {
  final String elementIconPath;
  final String elementTitle;
  final double elementAmount;
  const SingleElementShowingWidget({
    super.key,
    required this.elementIconPath,
    required this.elementTitle,
    required this.elementAmount,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(10.sp),
      decoration: BoxDecoration(
        color: AppColors.c3c3c3c,
        border: Border.all(color: AppColors.c999999),
        borderRadius: BorderRadius.circular(16.r),
      ),

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ///--------///Section : Item Icon///--------------
          Container(
            padding: EdgeInsets.all(8.sp),
            decoration: BoxDecoration(
              color: AppColors.c0e0e0e,
              border: Border.all(color: AppColors.cfefefe),
              shape: BoxShape.circle,
            ),
            child: SvgPicture.asset(elementIconPath),
          ),
          UIHelper.verticalSpace(8.h),

          ///------------///Section : Text -> Item Name///-----------
          Text(
            elementTitle,
            style: TextFontStyle.headline12w400cfefefeStylePoppins,
          ),

          UIHelper.verticalSpace(8.h),

          RichText(
            text: TextSpan(
              children: <InlineSpan>[
                TextSpan(
                  text: elementAmount % 1 == 0
                      ? elementAmount.toInt().toString()
                      : elementAmount.toString(),
                  style: TextFontStyle.headline16w500cfefefeStylePoppins,
                ),
                WidgetSpan(child: UIHelper.horizontalSpace(6.w)),
                TextSpan(
                  text: "gm",
                  style: TextFontStyle.headline10w500cfefefeStylePoppins,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
