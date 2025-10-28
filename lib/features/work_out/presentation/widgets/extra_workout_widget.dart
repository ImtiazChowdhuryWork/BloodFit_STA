import 'package:bloodfit/constants/text_font_style.dart';
import 'package:bloodfit/gen/colors.gen.dart';
import 'package:bloodfit/helper/ui_helpers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ExtraWorkoutWidget extends StatelessWidget {
  const ExtraWorkoutWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Great Job! Ready for More?",
          style: TextFontStyle.headline20w500cfefefeStylePoppins,
        ),
        UIHelper.verticalSpace(16.h),

        ///Section : ------------///Background Container///--------------
        Container(
          width: 1.sw,
          padding: EdgeInsets.all(20.sp),
          decoration: BoxDecoration(
            color: AppColors.c262626,
            borderRadius: BorderRadius.circular(8.r),
          ),
          child: Container(
            width: 1.sw,
            padding: EdgeInsets.symmetric(vertical: 16.h, horizontal: 20.w),
            decoration: BoxDecoration(
              color: AppColors.c111111,
              borderRadius: BorderRadius.circular(10.r),
              border: Border.all(color: AppColors.c999999),
            ),
          ),
        ),
      ],
    );
  }
}
