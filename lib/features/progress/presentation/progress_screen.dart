import 'package:bloodfit/constants/text_font_style.dart';
import 'package:bloodfit/features/progress/presentation/widget/custom_progress_indicator.dart';
import 'package:bloodfit/features/progress/presentation/widget/infotile_widget.dart';
import 'package:bloodfit/features/progress/presentation/widget/overall_progress_showing_widget.dart';
import 'package:bloodfit/gen/colors.gen.dart';
import 'package:bloodfit/routes/routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../custom_widgets/custom_shimmer_effect.dart';
import '../../../gen/assets.gen.dart';
import '../../../helper/ui_helpers.dart';
import '../../home/presentation/widgets/app_bar_section_widget.dart';
import '../../home/presentation/widgets/consistancy_stake_preview.dart';
import '../../home/presentation/widgets/custom_calender_widget.dart';

class ProgressScreen extends StatelessWidget {
  const ProgressScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldBackgroundColor,
      body: SingleChildScrollView(
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ///Section : ---------------------///AppLogo///-----------
              ///Section : ---------------------///Notification///-----------
              ///Section : ---------------------///Profile///-----------
              Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: UIHelper.kDefaulutPadding(),
                ),
                child: AppBarSectionWidget(),
              ),
              UIHelper.verticalSpace(20.h),

              Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: UIHelper.kDefaulutPadding(),
                ),
                child: OverAllProgressShowingWidget(
                  overAllProgress: 0.7,
                  inforTypeOne: 'Mealplan',
                  infoTypeOneProgress: 0.7,
                  infoTypeTwo: 'Workout',
                  infoTypeTwoProgress: 0.4,
                ),
              ),
              UIHelper.verticalSpace(32.h),

              ///Section : -------///Stake Section///----------
              ///This section check the consistancy of the user. If the consistancy is broken
              ///then the stack will return to it's original value. Which -> "0"
              ///
              Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: UIHelper.kDefaulutPadding(),
                ),
                child: ConsistancyStakePreviewWidget(numberValue: 4),
              ),
              UIHelper.verticalSpace(14.h),

              ///Section : -----------///Calender Widget with progress, cheat day,...///--------------
              CustomCalenderWidget(),
              UIHelper.verticalSpace(24.h),

              ///Section : ----------/// Your Weight Progress ///-----------
              Container(
                padding: EdgeInsets.all(10.sp),
                decoration: BoxDecoration(
                  color: AppColors.c262626,
                  borderRadius: BorderRadius.circular(16.r),
                ),
                child: ProgressIndicatorWithMarkers(
                  startValue: 50,
                  currentValue: 80,
                  goalValue: 120,
                  unit: 'kg',
                ),
              ),

              CustomShimmerEffect(
                height: 120.h,
                width: 0.4.sw,
                child: Padding(
                  padding: const EdgeInsets.all(8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CustomShimmerEffect(
                        height: 50.h,
                        width: 50.w,
                        isShapUsed: true,
                        shapType: BoxShape.circle,
                      ),
                      UIHelper.verticalSpace(10.h),
                      CustomShimmerEffect(height: 10.h, width: 0.3.sw),
                      UIHelper.verticalSpace(10.h),
                      Row(
                        children: [
                          CustomShimmerEffect(height: 10.h, width: 0.10.sw),
                          UIHelper.horizontalSpace(10.w),
                          CustomShimmerEffect(height: 10.h, width: 0.10.sw),
                        ],
                      ),
                    ],
                  ),
                ),
              ),

              InkWell(
                onTap: () {
                  Get.toNamed(Routes.weightHistoryScreen);
                },
                child: Container(
                  width: 1.sw,
                  height: 0.2.sh,
                  decoration: BoxDecoration(
                    color: AppColors.cb20000,
                    borderRadius: BorderRadius.circular(10.r),
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    "Weight History",
                    style: TextFontStyle.headline24w700cFFFFFFStylePoppins,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
