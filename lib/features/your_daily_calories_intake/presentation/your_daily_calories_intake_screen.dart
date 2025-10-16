import 'package:bloodfit/constants/text_font_style.dart';
import 'package:bloodfit/custom_widgets/go_back_widget.dart';
import 'package:bloodfit/gen/colors.gen.dart';
import 'package:bloodfit/helper/ui_helpers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class YourDailyCaloriesIntakeScreen extends StatelessWidget {
  const YourDailyCaloriesIntakeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldBackgroundColor,

      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          ///Section : -------------///Back Button///--------
          Align(alignment: Alignment.centerLeft, child: CustomBackButton()),
          UIHelper.verticalSpace(86.h),

          ///Section : ---------///Text-> your daily calorie intake///-------
          Text(
            "your daily calorie intake",
            style: TextFontStyle.headline22w500cfefefeStylePoppins,
          ),
          UIHelper.verticalSpace(16.h),

          ///Section : ---------///Text-> to achieve your goal you should consume 1500 calories everyday///-------
          Text(
            "To Achieve Your Goal You Should Consume 1500 Calories Everyday",
            style: TextFontStyle.headline22w500cfefefeStylePoppins,
          ),
          UIHelper.verticalSpace(16.h),
        ],
      ),
    );
  }
}
