import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../constants/text_font_style.dart';
import '../../../gen/colors.gen.dart';
import '../../../helper/ui_helpers.dart';

class ActivePackageHeader extends StatelessWidget {
  final String packageType;
  final double packagePrice;
  final String? packageDuration;
  const ActivePackageHeader({
    super.key,
    required this.packageType,
    required this.packagePrice,
    this.packageDuration,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              packageType,
              style: TextFontStyle.headline24w700cfefefeStylePoppins,
            ),
            Container(
              padding: EdgeInsets.all(10.sp),
              decoration: BoxDecoration(
                color: AppColors.c2f772f,
                borderRadius: BorderRadius.circular(8.r),
              ),
              child: Text(
                "Active",
                style: TextFontStyle.headline14w500cfefefeStylePoppins,
              ),
            ),
          ],
        ),
        UIHelper.verticalSpace(8.h),

        ///Section : ----///Package Price and Duration///-------
        Text(
          "£$packagePrice/${packageDuration!.isEmpty == true ? "" : packageDuration}",
          style: TextFontStyle.headline14w500cfefefeStylePoppins,
        ),
      ],
    );
  }
}
