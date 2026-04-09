import 'package:bloodfit/constants/text_font_style.dart';
import 'package:bloodfit/features/progress/data/controller/weight_history_controller.dart';
import 'package:bloodfit/features/progress/data/controller/weight_progress_showing_controller.dart';
import 'package:bloodfit/features/progress/presentation/widget/custom_progress_indicator.dart';
import 'package:bloodfit/features/progress/presentation/widget/overall_progress_showing_widget.dart';
import 'package:bloodfit/features/progress/presentation/widget/weight_history_chart.dart';
import 'package:bloodfit/features/progress/presentation/widget/weight_progress_failed_widget.dart';
import 'package:bloodfit/features/progress/presentation/widget/weight_progress_loading_showing_widget.dart';
import 'package:bloodfit/gen/colors.gen.dart';
import 'package:bloodfit/routes/routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../custom_widgets/custom_shimmer_effect.dart';
import '../../../helper/logger_util.dart';
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
    final WeightHistoryController weightHistoryController =
        Get.find<WeightHistoryController>();

    controller.getWeightProgressDataApi();
    controller.getProgressReportApi();
    weightHistoryController.getWeightHistory();

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
                child: Obx(() {
                  if (controller.isProgressReportDataLoading.value) {
                    return CircularProgressIndicator();
                  }

                  if (controller
                      .progressReportDataErrorMessag
                      .value
                      .isNotEmpty) {
                    return WeightProgressFailedWidget(
                      controller: ProgressShowingController(
                        Get.find(),
                        Get.find(),
                      ),
                      onTap: () {
                        LoggerUtils.debug("Retry Button Taped!");
                        controller.getProgressReportApi();
                      },
                    );
                  }

                  return OverAllProgressShowingWidget(
                    overAllProgress: controller.totalProgressValue / 100.0,
                    inforTypeOne: 'mealplan'.tr,
                    infoTypeOneProgress: controller.totalMealProgressValue / 100.0,
                    infoTypeTwo: 'workout'.tr,
                    infoTypeTwoProgress: controller.totalWorkoutProgressValue / 100.0,
                  );
                }),
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
              Obx(() {
                if (controller.isWeightProgressDataLoading.value) {
                  return Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: UIHelper.kDefaulutPadding(),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        CustomShimmerEffect(height: 10.h, width: 0.4.sw),
                        CustomShimmerEffect(height: 10.h, width: 0.3.sw),
                      ],
                    ),
                  );
                }
                return Padding(
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
                          style:
                              TextFontStyle.headline14w400cfefefeStylePoppins,
                        ),
                      ),
                    ],
                  ),
                );
              }),
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
                    return WeightProgressFailedWidget(
                      controller: ProgressShowingController(
                        Get.find(),
                        Get.find(),
                      ),
                      onTap: () {
                        LoggerUtils.debug("Retry Button Taped!");
                        controller.getWeightProgressDataApi();
                      },
                    );
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
              Obx(() {
                LoggerUtils.debug('📊 Weight History Section - Building...');
                LoggerUtils.debug('   - isWeightHistoryLoading: ${weightHistoryController.isWeightHistoryLoading.value}');
                LoggerUtils.debug('   - weightHistoryErrorMessage: ${weightHistoryController.weightHistoryErrorMessage.value}');
                LoggerUtils.debug('   - weightHistoryModel data count: ${weightHistoryController.weightHistoryModel.value?.data?.length ?? 0}');
                
                if (weightHistoryController.isWeightHistoryLoading.value) {
                  return Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: UIHelper.kDefaulutPadding(),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        CustomShimmerEffect(height: 10.h, width: 0.4.sw),
                        CustomShimmerEffect(height: 10.h, width: 0.3.sw),
                      ],
                    ),
                  );
                }

                if (weightHistoryController.weightHistoryErrorMessage.value.isNotEmpty) {
                  return Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: UIHelper.kDefaulutPadding(),
                    ),
                    child: WeightProgressFailedWidget(
                      controller: ProgressShowingController(
                        Get.find(),
                        Get.find(),
                      ),
                      onTap: () {
                        LoggerUtils.debug("Retry Button Taped!");
                        weightHistoryController.getWeightHistory();
                      },
                    ),
                  );
                }

                final entries = weightHistoryController.getWeightEntries();
                LoggerUtils.debug('📊 Weight History - Entries count: ${entries.length}');
                if (entries.isNotEmpty) {
                  LoggerUtils.debug('📊 First 3 entries: ${entries.take(3).toList()}');
                  if (entries.length >= 3) {
                    LoggerUtils.debug('📊 Last 3 entries: ${entries.sublist(entries.length - 3)}');
                  } else {
                    LoggerUtils.debug('📊 All entries: $entries');
                  }
                }

                // If no entries, return empty container or show a message
                if (entries.isEmpty) {
                  return Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: UIHelper.kDefaulutPadding(),
                    ),
                    child: Text(
                      'No weight history available',
                      style: TextFontStyle.headline14w400cfefefeStylePoppins,
                    ),
                  );
                }

                return Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: UIHelper.kDefaulutPadding(),
                  ),
                  child: WeightHistoryChart(
                    title: 'Your Weight History',
                    targetTitle: 'Weight Loss',
                    goalWeight: weightHistoryController.getGoalWeight(),
                    currentWeight: weightHistoryController.getCurrentWeight(),
                    entries: entries,
                    onMonthChanged: (m) => debugPrint('Month → $m'),
                  ),
                );
              }),

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
