import 'dart:developer';

import 'package:bloodfit/constants/text_font_style.dart';
import 'package:bloodfit/custom_widgets/custom_elevated_button.dart';
import 'package:bloodfit/features/information_gather_workout/presentation/widgets/current_body_shape/presentation/widgets/activity_level/presentation/activity_level_widget.dart';
import 'package:bloodfit/features/information_gather_workout/presentation/widgets/current_body_shape/presentation/widgets/current_body_shape/current_body_shape_widget.dart';
import 'package:bloodfit/gen/colors.gen.dart';
import 'package:bloodfit/helper/ui_helpers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../controllers/information_gather_work_out_controller.dart';
import '../../../custom_widgets/go_back_widget.dart';
import '../../../custom_widgets/page_indicator.dart';

class InformationGatherWorkoutScreen extends StatelessWidget {
  const InformationGatherWorkoutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final InformationGatherWorkOutController controller =
        Get.find<InformationGatherWorkOutController>();

    return Scaffold(
      backgroundColor: AppColors.scaffoldBackgroundColor,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(UIHelper.kDefaulutPadding()),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /// Top bar (Back button only)
              CustomBackButton(
                onTap: () {
                  if (controller.currentIndex.value > 0) {
                    controller.previousPage();
                  } else {
                    // Exit current flow (go back)
                    Get.back();
                  }
                },
              ),
              UIHelper.verticalSpace(26.h),

              /// Page Indicators
              PageIndicator(controller: controller),
              UIHelper.verticalSpace(16.h),

              /// PageView section
              Expanded(
                child: PageView(
                  controller: controller.pageController,
                  onPageChanged: controller.updateCurrentIndex,
                  physics: const NeverScrollableScrollPhysics(),
                  children: [CurrentBodyShapeWidget(), ActivityLevelWidget()],
                ),
              ),
            ],
          ),
        ),
      ),

      bottomNavigationBar: Container(
        width: 1.sw,
        height: 100.h,
        padding: EdgeInsets.only(
          left: UIHelper.kDefaulutPadding(),
          right: UIHelper.kDefaulutPadding(),
          bottom: 40.h,
        ),
        decoration: BoxDecoration(color: AppColors.scaffoldBackgroundColor),
        child: Obx(() {
          final isLastPage =
              controller.currentIndex.value == controller.totalPages - 1;
          return CustomElevatedButton(
            onTap: () {
              if (isLastPage) {
                // Finish onboarding or navigate to next screen
                log("Information Gathering Completed!");
                // Example navigation:
                // Get.toNamed(Routes.dailyCaloriesIntakeScreen);
              } else {
                // Go to next page
                controller.nextPage();
              }
            },
            buttonTitle: isLastPage ? "Finish" : "Continue",
            buttonHeight: 60.h,
          );
        }),
      ),
    );
  }
}
