import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

import '../../../constants/text_font_style.dart';
import '../../../gen/colors.gen.dart';
import '../../../helper/ui_helpers.dart';

class FoodMenarelItemTileWidget extends StatelessWidget {
  final String imagePath;
  final int value;
  final String menaralName;
  const FoodMenarelItemTileWidget({
    super.key,
    required this.imagePath,
    required this.value,
    required this.menaralName,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
        top: 10.h,
        bottom: 10.h,
        left: 10.w,
        right: 20.w,
      ),
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.cfefefe),
        borderRadius: BorderRadius.circular(10.r),
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFF111111), // top-left tint
            Color(0xFF2B1010), // main color
          ],
          stops: [0.0, 0.50], // small corner effect
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          SvgPicture.asset(imagePath),
          UIHelper.horizontalSpace(8.w),
          Text(
            "$value$menaralName",
            style: TextFontStyle.headline14w400cfefefeStylePoppins,
          ),
        ],
      ),
    );
  }
}
