import 'package:bloodfit/constants/text_font_style.dart';
import 'package:bloodfit/gen/colors.gen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../helper/ui_helpers.dart';
import '../../home/presentation/widgets/app_bar_section_widget.dart';
import 'widgets/elite_uesr_workout_calender.dart';

class WorkOutScreen extends StatelessWidget {
  const WorkOutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldBackgroundColor,

      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(UIHelper.kDefaulutPadding()),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ///Section : ---------------------///AppLogo///-----------
              ///Section : ---------------------///Notification///-----------
              ///Section : ---------------------///Profile///-----------
              AppBarSectionWidget(),
              UIHelper.verticalSpace(20.h),

              ///Section : ----------///Text ->Your workouts This Week///-----------
              Text(
                "Your workouts This Week",
                style: TextFontStyle.headline20w500cfefefeStylePoppins,
              ),
              UIHelper.verticalSpace(20.h),

              ///Section : -------------------///Workout Calendar///-------------
              EliteUserWorkoutCalender(
                isCheatDay: true,
                height: 44.h,
                width: 44.w,
                backgroundColor: AppColors.c363636,
                isCalorieTaskCompleted: false,
                progress: 0.6,
                progressColor: AppColors.cb20000,
                strokeWidth: 4,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
