import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

import '../constants/text_font_style.dart';
import '../helper/ui_helpers.dart';

class FoodItemDataHelperWidget extends StatelessWidget {
  final String iconPath;
  final double value;
  final bool isValueVisible;
  final String title;
  final Color? iconColor;

  const FoodItemDataHelperWidget({
    super.key,
    required this.iconPath,
    required this.value,
    required this.title,
    this.iconColor,
    this.isValueVisible = true,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SvgPicture.asset(iconPath, color: iconColor),
        UIHelper.horizontalSpace(4.w),
        isValueVisible
            ? Text(
                "${value % 1 == 0 ? value.toInt() : value} $title",
                style: TextFontStyle.headline14w500cfefefeStylePoppins,
              )
            : Text(
                title,
                style: TextFontStyle.headline14w500cfefefeStylePoppins,
              ),
      ],
    );
  }
}
