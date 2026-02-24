import 'package:bloodfit/constants/app_constant_text.dart';
import 'package:bloodfit/custom_widgets/custom_elevated_button.dart';
import 'package:bloodfit/features/information_gather_workout/presentation/widgets/activity_level/presentation/activity_level_widget.dart';
import 'package:bloodfit/features/information_gather_workout/presentation/widgets/current_body_shape/presentation/current_body_shape_widget.dart';
import 'package:bloodfit/features/information_gather_workout/presentation/widgets/prefered_workout_level/presentation/prefered_workout_level_widget.dart';
import 'package:bloodfit/features/information_gather_workout/presentation/widgets/workout_focus_area/presentation/workout_focus_area_widget.dart';
import 'package:bloodfit/gen/colors.gen.dart';
import 'package:bloodfit/helper/di.dart';
import 'package:bloodfit/helper/logger_util.dart';
import 'package:bloodfit/helper/ui_helpers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../custom_widgets/go_back_widget.dart';
import '../../../custom_widgets/page_indicator.dart';
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
    controller = Get.put(InformationGatherWorkOutController(Get.find()));
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
          ///------->>> Listen to controller state for page status update
          controller.currentIndex.value;
          controller.dataUpdated.value; // Listen to data changes to rebuild button

          final currentIndex = controller.currentIndex.value;

          // Helper function to check if current page data is valid
          bool isCurrentPageDataValid() {
            LoggerUtils.debug("Validating workout page $currentIndex");

            switch (currentIndex) {
              case 0:
                ///---------->>> Current Body Shape
                final currentBodyShape = appData.read(kKeyCurrentBodyShape);
                LoggerUtils.debug("Current Body Shape validation: $currentBodyShape");
                return currentBodyShape != null && currentBodyShape is String;

              case 1:
                ///---------->>> Activity Level
                final activityLevel = appData.read(kKeyActivityLevel);
                LoggerUtils.debug("Activity Level validation: $activityLevel");
                return activityLevel != null && activityLevel is String;

              case 2:
                ///---------->>> Preferred Workout Level
                final preferredWorkout = appData.read(kKeyPreffredWorkout);
                LoggerUtils.debug("Preferred Workout validation: $preferredWorkout");
                return preferredWorkout != null && preferredWorkout is String;

              case 3:
                ///---------->>> Workout Focus Area
                final workoutFocusArea = appData.read(kKeyWorkoutFocusArea);
                LoggerUtils.debug("Workout Focus Area validation: $workoutFocusArea");
                
                // Workout focus area is saved as a List<String>, check if it's not empty
                if (workoutFocusArea == null) {
                  LoggerUtils.debug("Workout Focus Area is null - validation failed");
                  return false;
                }
                if (workoutFocusArea is List) {
                  final isValid = workoutFocusArea.isNotEmpty;
                  LoggerUtils.debug("Workout Focus Area is List with ${workoutFocusArea.length} items - validation: $isValid");
                  return isValid;
                }
                LoggerUtils.debug("Workout Focus Area is not a List - validation failed");
                return false;

              default:
                LoggerUtils.debug("Default case - validation false");
                return false;
            }
          }

          final isValid = isCurrentPageDataValid();
          final isLastPage = currentIndex == controller.totalPages - 1;
          final isLoading = controller.isInfoWorkoutFlowLoading.value;
          final isButtonEnabled = !isLoading && isValid;

          LoggerUtils.debug(
            "Page $currentIndex - IsValid: $isValid, IsLoading: $isLoading, ButtonEnabled: $isButtonEnabled",
          );

          return CustomElevatedButton(
            onTap: isButtonEnabled
                ? () {
                    LoggerUtils.debug("Button tapped on page $currentIndex");

                    if (isLastPage) {
                      LoggerUtils.debug("Workout information gathering completed!");
                      _logAllStoredData();
                      // Call the API to submit workout information
                      controller.postInfoGatherWorkoutApi();
                    } else {
                      LoggerUtils.debug("Navigating to next page");
                      controller.nextPage();
                    }
                  }
                : null,
            buttonTitle: isLastPage ? "Finish" : "Continue",
            buttonHeight: 60.h,
            buttonColor: isButtonEnabled ? null : Colors.grey[300],
            isDisabled: !isButtonEnabled,
            isLoading: isLoading && isLastPage,
          );
        }),
      ),
    );
  }

  void _logAllStoredData() {
    LoggerUtils.debug(
      "Current Body Shape from Storage: ${appData.read(kKeyCurrentBodyShape)}",
    );
    LoggerUtils.debug(
      "Activity Level from Storage: ${appData.read(kKeyActivityLevel)}",
    );
    LoggerUtils.debug(
      "Preferred Workout from Storage: ${appData.read(kKeyPreffredWorkout)}",
    );
    LoggerUtils.debug(
      "Workout Focus Area from Storage: ${appData.read(kKeyWorkoutFocusArea)}",
    );
  }
}
