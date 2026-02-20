import 'package:bloodfit/custom_widgets/custom_elevated_button.dart';
import 'package:bloodfit/features/information_gather_workout/presentation/widgets/activity_level/presentation/activity_level_widget.dart';
import 'package:bloodfit/features/information_gather_workout/presentation/widgets/current_body_shape/presentation/current_body_shape_widget.dart';
import 'package:bloodfit/features/information_gather_workout/presentation/widgets/prefered_workout_level/presentation/prefered_workout_level_widget.dart';
import 'package:bloodfit/features/information_gather_workout/presentation/widgets/workout_focus_area/presentation/workout_focus_area_widget.dart';
import 'package:bloodfit/gen/colors.gen.dart';
import 'package:bloodfit/helper/ui_helpers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../custom_widgets/go_back_widget.dart';
import '../../../custom_widgets/page_indicator.dart';
import '../../../routes/routes.dart';
import '../data/controller/information_gather_work_out_controller.dart';

class InformationGatherWorkoutScreen extends StatefulWidget {
  const InformationGatherWorkoutScreen({super.key});

  @override
  State<InformationGatherWorkoutScreen> createState() =>
      _InformationGatherWorkoutScreenState();
}

class _InformationGatherWorkoutScreenState
    extends State<InformationGatherWorkoutScreen> {
  late final InformationGatherWorkOutController controller;

  @override
  void initState() {
    super.initState();
    // Delete any existing controller first to ensure fresh instance
    Get.delete<InformationGatherWorkOutController>(force: true);
    // Create fresh controller
    controller = Get.put(InformationGatherWorkOutController());
    // Reset to first page when entering the screen
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      controller.reset();
    });
  }

  @override
  void dispose() {
    // Delete controller (this also calls onClose() which disposes PageController)
    Get.delete<InformationGatherWorkOutController>(force: true);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

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
                  children: [
                    CurrentBodyShapeWidget(),
                    ActivityLevelWidget(),
                    PreferedWorkoutLevelWidget(),
                    WorkoutFocusAreaWidget(),
                  ],
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
                // Navigate to YouAreAllSetScreen every time
                Get.toNamed(Routes.youAreAllSetScreen);
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
