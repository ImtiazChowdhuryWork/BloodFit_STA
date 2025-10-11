import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../constants/text_font_style.dart';
import '../../../gen/colors.gen.dart';

class InActivePackageHeader extends StatelessWidget {
  final double packagePrice;
  final String packageType;
  const InActivePackageHeader({
    super.key,
    required this.packagePrice,
    required this.packageType,
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
              "£$packagePrice",
              style: TextFontStyle.headline24w700cfefefeStylePoppins,
            ),

            Container(
              padding: EdgeInsets.all(10.sp),
              decoration: BoxDecoration(
                color: AppColors.c343434,
                borderRadius: BorderRadius.circular(8.r),
              ),
              child: Text(
                packageType,
                style: TextFontStyle.headline14w500cfefefeStylePoppins,
              ),
            ),
          ],
        ),

        ///Section : -------------///Text -> including tax & auto-renew///-----------------
        Text(
          "Including Tax & Auto-Renew",
          style: TextFontStyle.headline16w400cc6c6c6StylePoppins,
        ),
      ],
    );
  }
}
