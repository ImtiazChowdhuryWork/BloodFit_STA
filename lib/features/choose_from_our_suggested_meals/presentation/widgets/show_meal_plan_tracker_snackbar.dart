import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:bloodfit/features/choose_from_our_suggested_meals/data/controller/choose_from_our_suggested_meal_controller.dart';
import 'package:bloodfit/features/choose_from_our_suggested_meals/presentation/widgets/meal_status_card_widget.dart';
import 'package:bloodfit/custom_widgets/custom_elevated_button.dart';
import 'package:bloodfit/constants/text_font_style.dart';
import 'package:bloodfit/helper/ui_helpers.dart';
import 'package:bloodfit/routes/routes.dart';
import 'package:bloodfit/helper/logger_util.dart';
import 'dart:developer';

void showMealPlanTracker() {
  final controller = Get.find<ChooseFromOurSuggestedMealController>();
  final isComplete = controller.isMealPlanComplete;

  LoggerUtils.debug("╔═══════════════════════════════════════════════════════════");
  LoggerUtils.debug("📢 [SHOW_SNACKBAR] showMealPlanTracker() CALLED");
  LoggerUtils.debug("📢 [SHOW_SNACKBAR] isComplete: $isComplete");
  LoggerUtils.debug("╚═══════════════════════════════════════════════════════════");

  // Get the current context from Get
  final context = Get.context;
  if (context == null) {
    LoggerUtils.error("❌ [SNACKBAR] Get.context is null");
    return;
  }

  // Show as a bottom sheet-style dialog
  showGeneralDialog(
    context: context,
    barrierColor: Colors.black54,
    transitionDuration: const Duration(milliseconds: 300),
    transitionBuilder: (context, animation, secondaryAnimation, child) {
      return SlideTransition(
        position: Tween<Offset>(
          begin: const Offset(0, 1),
          end: Offset.zero,
        ).animate(CurvedAnimation(
          parent: animation,
          curve: Curves.easeOutCubic,
        )),
        child: child,
      );
    },
    pageBuilder: (context, animation, secondaryAnimation) {
      return SafeArea(
        child: Align(
          alignment: Alignment.bottomCenter,
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            constraints: BoxConstraints(maxHeight: 100.h),
            decoration: BoxDecoration(
              color: const Color(0xFF1A1A1A),
              borderRadius: BorderRadius.circular(12),
            ),
            // Add Material widget for InkWell to work
            child: Material(
              color: Colors.transparent,
              child: _MealPlanTrackerContent(controller: controller),
            ),
          ),
        ),
      );
    },
  );

  LoggerUtils.debug("📢 [SNACKBAR] Dialog shown successfully");

  // Auto-close after duration if not complete
  if (!isComplete) {
    Future.delayed(const Duration(seconds: 3), () {
      // Close if dialog is still open
      try {
        Navigator.of(context).pop();
        LoggerUtils.debug("📢 [SNACKBAR] Auto-closed dialog");
      } catch (e) {
        // Dialog already closed
      }
    });
  }
}

// Separate widget to show tracker content
class _MealPlanTrackerContent extends StatelessWidget {
  final ChooseFromOurSuggestedMealController controller;

  const _MealPlanTrackerContent({required this.controller});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 1.sw,
      padding: EdgeInsets.symmetric(horizontal: 8.sp, vertical: 8.sp),
      decoration: BoxDecoration(
        color: const Color(0xFF727272),
        borderRadius: BorderRadius.circular(10.r),
      ),
      child: Row(
        children: [
          ///Section : --------///Item -> Breakfast///--------------
          Expanded(
            child: Obx(() {
              final isSelected = controller.selectedBreakfastMealId.value.isNotEmpty;
              final mealName = controller.selectedBreakfastMealName.value;

              return MealStatusCardWidget(
                isSelected: isSelected,
                mealName: isSelected ? mealName : 'Bfast',
                mealType: "Breakfast",
              );
            }),
          ),
          UIHelper.horizontalSpace(4.w),

          ///Section : --------///Item -> Lunch///--------------
          Expanded(
            child: Obx(() {
              final isSelected = controller.selectedLunchMealId.value.isNotEmpty;
              final mealName = controller.selectedLunchMealName.value;

              return MealStatusCardWidget(
                isSelected: isSelected,
                mealName: isSelected ? mealName : 'Lunch',
                mealType: "Lunch",
              );
            }),
          ),
          UIHelper.horizontalSpace(4.w),

          ///Section : --------///Item -> Dinner///--------------
          Expanded(
            child: Obx(() {
              final isSelected = controller.selectedDinnerMealId.value.isNotEmpty;
              final mealName = controller.selectedDinnerMealName.value;

              return MealStatusCardWidget(
                isSelected: isSelected,
                mealName: isSelected ? mealName : 'Dinner',
                mealType: "Dinner",
              );
            }),
          ),
          UIHelper.horizontalSpace(4.w),

          ///Section : -------///Button -> Build Meal Plan///-------------
          Obx(() {
            final isMealPlanComplete = controller.isMealPlanComplete;

            return SizedBox(
              width: 70.w,
              height: 80.h,
              child: CustomElevatedButton(
                onTap: isMealPlanComplete ? () {
                  log("Button Taped : Build Meal Plan!");
                  Get.toNamed(Routes.reviewYourChoosenMealScreen);
                } : null,
                buttonTitle: "Build",
                textStyle: TextFontStyle.headline12w400cfefefeStylePoppins.copyWith(fontSize: 9.sp),
                buttonHeight: 40.h,
                buttonWidth: 70.w,
                borderRadius: 8.r,
                isDisabled: !isMealPlanComplete,
              ),
            );
          }),
        ],
      ),
    );
  }
}
