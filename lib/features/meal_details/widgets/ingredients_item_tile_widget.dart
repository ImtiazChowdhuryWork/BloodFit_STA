import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

import '../../../constants/text_font_style.dart';
import '../../../gen/colors.gen.dart';
import '../../../helper/ui_helpers.dart';

class IngredientItemTileWidget extends StatelessWidget {
  final String imagePath;
  final String title;

  final String recommendedConsumable;

  const IngredientItemTileWidget({
    super.key,
    required this.imagePath,
    required this.title,

    required this.recommendedConsumable,
  });

  

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
          child: Text(imagePath),
        ),
        UIHelper.verticalSpace(8.h),

        /// Section : Ingredient Name
        Text(title, style: TextFontStyle.headline14w400cfefefeStylePoppins),
        UIHelper.verticalSpace(2.h),

        Text(
          recommendedConsumable,
          style: TextFontStyle.headline12w400cc6c6c6StylePoppins,
        ),
        UIHelper.verticalSpace(8.h),
      ],
    );
  }
}
