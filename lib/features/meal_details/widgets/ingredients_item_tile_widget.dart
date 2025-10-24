import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

import '../../../constants/text_font_style.dart';
import '../../../gen/colors.gen.dart';
import '../../../helper/ui_helpers.dart';

class IngredientItemTileWidget extends StatelessWidget {
  final String imagePath;
  final String title;
  final double gValue;
  final String recommendedConsumable;

  const IngredientItemTileWidget({
    super.key,
    required this.imagePath,
    required this.title,
    required this.gValue,
    required this.recommendedConsumable,
  });

  String get formattedGValue {
    // ✅ Show without decimals if it's a whole number
    if (gValue % 1 == 0) {
      return gValue.toStringAsFixed(0);
    } else {
      return gValue.toStringAsFixed(1); // show 1 decimal place for fractions
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          padding: EdgeInsets.all(10.sp),
          decoration: BoxDecoration(
            color: AppColors.c363636,
            shape: BoxShape.circle,
          ),
          child: SvgPicture.asset(imagePath),
        ),
        UIHelper.verticalSpace(8.h),

        /// Section : Ingredient Name
        Text(title, style: TextFontStyle.headline14w400cfefefeStylePoppins),
        UIHelper.verticalSpace(2.h),

        Text(
          "$formattedGValue ($recommendedConsumable)",
          style: TextFontStyle.headline12w400cc6c6c6StylePoppins,
        ),
        UIHelper.verticalSpace(8.h),
      ],
    );
  }
}
