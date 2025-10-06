import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

import '../constants/text_font_style.dart';
import '../gen/colors.gen.dart';
import '../helper/ui_helpers.dart';

class CardTileOptionWidget extends StatelessWidget {
  final String imagePath;
  final String title;
  final Color? cardColor;
  final Color? suffixColor;
  final void Function()? onTap;
  const CardTileOptionWidget({
    super.key,
    required this.imagePath,
    required this.title,
    this.cardColor,
    this.suffixColor,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        width: 1.sw,
        decoration: BoxDecoration(
          color: cardColor ?? AppColors.c3c3c3c,
          borderRadius: BorderRadius.circular(8.r),
        ),
        padding: EdgeInsets.all(12.sp),
        child: Row(
          children: [
            ///Section : -----------------///PrefixIcon Icon///--------------
            SvgPicture.asset(imagePath),
            UIHelper.horizontalSpace(10.w),

            ///Section : -----------------///Card Title///--------------
            Text(title, style: TextFontStyle.headline14w400cfefefeStylePoppins),
            Spacer(),

            ///Section : -----------------///Suffix Icon///--------------
            Icon(
              Icons.arrow_forward_ios_rounded,
              color: suffixColor ?? AppColors.c999999,
            ),
          ],
        ),
      ),
    );
  }
}
