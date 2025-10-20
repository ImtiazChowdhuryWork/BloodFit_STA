import 'package:bloodfit/constants/app_enums.dart';
import 'package:bloodfit/constants/text_font_style.dart';
import 'package:bloodfit/features/home/presentation/widgets/app_bar_section_widget.dart';
import 'package:bloodfit/features/home/presentation/widgets/consistancy_stake_preview.dart';
import 'package:bloodfit/features/home/presentation/widgets/single_element_showing_widget.dart';
import 'package:bloodfit/features/home/presentation/widgets/total_k_cal_widget.dart';
import 'package:bloodfit/gen/assets.gen.dart';
import 'package:bloodfit/gen/colors.gen.dart';
import 'package:bloodfit/helper/ui_helpers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

import '../../../controllers/profile_screen_controller.dart';
import '../../../custom_widgets/custom_calender_widget.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldBackgroundColor,
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(UIHelper.kDefaulutPadding()),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ///Section : ---------------------///AppLogo///-----------
              ///Section : ---------------------///Notification///-----------
              ///Section : ---------------------///Profile///-----------
              AppBarSectionWidget(),
              UIHelper.verticalSpace(20.h),

              ///Section : -------///Stake Section///----------
              ///This section check the consistancy of the user. If the consistancy is broken
              ///then the stack will return to it's original value. Which -> "0"
              ConsistancyStakePreviewWidget(numberValue: 4),
              UIHelper.verticalSpace(14.h),

              ///Section : -----------///Calender Widget with progress, cheat day,...///--------------
              CustomCalenderWidget(
                userSubscriptionType: UserSubscriptionType.elite,
              ),
              UIHelper.verticalSpace(24.h),

              ///Section : --------///Text -> your daily calories///----------
              Text(
                "Your Daily Calories",
                style: TextFontStyle.headline20w500cfefefeStylePoppins,
              ),
              UIHelper.verticalSpace(12.h),

              ///Sectiopn : --------///Calorie Progressbar///------------
              Container(
                width: 1.sw,
                padding: EdgeInsets.all(10.sp),
                decoration: BoxDecoration(
                  color: AppColors.c262626,
                  borderRadius: BorderRadius.circular(16.r),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    ///Section : ------------///Total Calories///---------------
                    TotalKCalWidget(
                      size: 150.w,
                      progress: 0.75,
                      strokeWidth: 8,
                      capColor: AppColors.cFFFFFF,
                      capSizeMultiplier: 0.3,
                      capPadding: 0,
                      capRadialOffset: 0,
                      progressColor: AppColors.cb20000,
                      progressBoldColor: AppColors.c7e0101,
                    ),
                    UIHelper.horizontalSpace(16.w),

                    ///Section : ------------///Total Carbs///---------------
                    Expanded(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          ///Section : ------------///Total Carbs///---------------
                          SingleElementShowingWidget(
                            elementIconPath: Assets.icons.glutenIcon,
                            elementTitle: "Carbs",
                            elementAmount: 30,
                          ),

                          ///Section : ------------///Total protein///---------------
                          SingleElementShowingWidget(
                            elementIconPath: Assets.icons.meatIcon,
                            elementTitle: "Protein",
                            elementAmount: 30,
                          ),

                          ///Section : ------------///Total Carbs///---------------
                          SingleElementShowingWidget(
                            elementIconPath: Assets.icons.fatIcon,
                            elementTitle: "Fat",
                            elementAmount: 30,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              UIHelper.verticalSpace(24.h),

              ///Section : ----------------///Text -> update your current weight///------------
              Text(
                "Update Your Current Weight",
                style: TextFontStyle.headline20w500cfefefeStylePoppins,
              ),
              UIHelper.verticalSpace(8.h),

              ///Section : --------------///Weight Drop Down///----------
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
              UIHelper.verticalSpace(100.h),
            ],
          ),
        ), // comment
      ),
    );
  }
}
