import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../constants/text_font_style.dart';
import '../../../../gen/colors.gen.dart';
import '../../../../helper/ui_helpers.dart';

class CurrentDayWorkoutDetailsTileWidget extends StatelessWidget {
  final String title;
  final bool isDividerVisible;
  const CurrentDayWorkoutDetailsTileWidget({
    super.key,
    required this.title,
    this.isDividerVisible = true,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(title, style: TextFontStyle.headline14w400cc6c6c6StylePoppins),
        isDividerVisible ? UIHelper.horizontalSpace(6.w) : SizedBox.shrink(),

        isDividerVisible
            ? Container(width: 1.w, height: 10.h, color: AppColors.c6a6a6a)
            : SizedBox.shrink(),
        isDividerVisible ? UIHelper.horizontalSpace(6.w) : SizedBox.shrink(),
      ],
    );
  }
}
