import 'package:bloodfit/constants/text_font_style.dart';
import 'package:bloodfit/gen/colors.gen.dart';
import 'package:bloodfit/helper/ui_helpers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

class CalenderContainerWidget extends StatelessWidget {
  final String iconPath;
  final String dayName;
  const CalenderContainerWidget({
    super.key,
    required this.iconPath,
    required this.dayName,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        ///Section : ------///DayName///----------
        Text(dayName, style: TextFontStyle.headline16w500cfefefeStylePoppins),
        UIHelper.verticalSpace(10.h),

        ///Section : -------///Container Box///-----------------
        Container(
          width: 44.w,
          height: 44.h,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: AppColors.cb20000,
            shape: BoxShape.circle,
          ),
          child: SvgPicture.asset(iconPath),
        ),
      ],
    );
  }
}
