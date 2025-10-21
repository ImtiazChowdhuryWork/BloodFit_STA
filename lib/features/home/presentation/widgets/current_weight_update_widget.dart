import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../constants/text_font_style.dart';
import '../../../../gen/colors.gen.dart';
import '../../../../helper/ui_helpers.dart';

class CurrentWeightUpdateWidget extends StatelessWidget {
  const CurrentWeightUpdateWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Update Your Current Weight",
          style: TextFontStyle.headline20w500cfefefeStylePoppins,
        ),
        UIHelper.verticalSpace(8.h),
        Container(
          padding: EdgeInsets.symmetric(vertical: 12.h, horizontal: 15.w),
          decoration: BoxDecoration(
            color: AppColors.c262626,
            borderRadius: BorderRadius.circular(16.r),
          ),
          child: TextFormField(
            decoration: InputDecoration(
              hintText: "Enter Your Weight",
              hintStyle: TextFontStyle.headline12w500c999999StylePoppins,
              border: OutlineInputBorder(
                borderSide: BorderSide(color: AppColors.cb20000),
                borderRadius: BorderRadius.circular(8.r),
              ),
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: AppColors.cb20000),
                borderRadius: BorderRadius.circular(8.r),
              ),

              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: AppColors.cb20000),
                borderRadius: BorderRadius.circular(8.r),
              ),

              disabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: AppColors.cb20000),
                borderRadius: BorderRadius.circular(8.r),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
