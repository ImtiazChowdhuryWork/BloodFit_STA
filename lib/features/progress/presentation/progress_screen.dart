import 'package:bloodfit/constants/text_font_style.dart';
import 'package:bloodfit/custom_widgets/custom_elevated_button.dart';
import 'package:bloodfit/features/progress/data/controller/weight_progress_showing_controller.dart';
import 'package:bloodfit/features/progress/presentation/widget/custom_progress_indicator.dart';
import 'package:bloodfit/features/progress/presentation/widget/overall_progress_showing_widget.dart';
import 'package:bloodfit/features/progress/presentation/widget/weight_history_chart.dart';
import 'package:bloodfit/features/progress/presentation/widget/weight_progress_failed_widget.dart';
import 'package:bloodfit/features/progress/presentation/widget/weight_progress_loading_showing_widget.dart';
import 'package:bloodfit/gen/colors.gen.dart';
import 'package:bloodfit/helper/logger_util.dart';
import 'package:bloodfit/routes/routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../custom_widgets/custom_shimmer_effect.dart';
import '../../../helper/ui_helpers.dart';
import '../../home/presentation/widgets/app_bar_section_widget.dart';
import '../../home/presentation/widgets/consistancy_stake_preview.dart';
import '../../home/presentation/widgets/custom_calender_widget.dart';

class ProgressScreen extends StatelessWidget {
  const ProgressScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final ProgressShowingController controller =
        Get.find<ProgressShowingController>();

    controller.getWeightProgressDataApi();

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
                  inforTypeOne: 'mealplan'.tr,
                  infoTypeOneProgress: 0.7,
                  infoTypeTwo: 'workout'.tr,
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

              ///Section : -----------//// your weight progress ///-------------
              Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: UIHelper.kDefaulutPadding(),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Your Weight Progress',
                      style: TextFontStyle.headline20w500cfefefeStylePoppins,
                    ),
                    InkWell(
                      onTap: () {
                        Get.toNamed(Routes.weightHistoryScreen);
                      },
                      child: Text(
                        'View All',
                        style: TextFontStyle.headline14w400cfefefeStylePoppins,
                      ),
                    ),
                  ],
                ),
              ),
              UIHelper.verticalSpace(20.h),

              ///Section : -----------//// Liner Progress Bar ///-------------
              Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: UIHelper.kDefaulutPadding(),
                ),
                child: Obx(() {
                  if (controller.isWeightProgressDataLoading.value) {
                    return WeightProgressLoadingShowingWidget();
                  }

                  if (controller
                      .weightProgressDataErrorMessage
                      .value
                      .isNotEmpty) {
                    return WeightProgressFailedWidget(controller: ProgressShowingController(Get.find()),);
                  }

                  return ProgressIndicatorWithMarkers(
                    startValue: controller.initialWeight.toDouble(),
                    currentValue: controller.currentWeight.toDouble(),
                    goalValue: controller.goalWeight.toDouble(),
                    unit: 'kg',
                  );
                }),
              ),
              UIHelper.verticalSpace(20.h),

              ///Section : -----------//// Your Weight History ///-------------
              Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: UIHelper.kDefaulutPadding(),
                ),
                child: WeightHistoryChart(
                  title: 'Your Weight History',
                  targetTitle: 'Weight Loss',
                  goalWeight: 58,
                  currentWeight: 83,
                  // initialMonth: DateTime(2025, 9),
                  entries: const [
                    WeightEntry(5, 83),
                    WeightEntry(8, 79),
                    WeightEntry(10, 75),
                    WeightEntry(13, 77),
                    WeightEntry(15, 72),
                    WeightEntry(17, 60),
                    WeightEntry(19, 68),
                    WeightEntry(21, 65),
                    WeightEntry(23, 72),
                    WeightEntry(25, 63),
                    WeightEntry(27, 67),
                    WeightEntry(30, 70),
                  ],
                  onMonthChanged: (m) => debugPrint('Month → $m'),
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
            ],
          ),
        ),
      ),
    );
  }
}
