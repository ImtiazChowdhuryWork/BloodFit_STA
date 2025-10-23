import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:bloodfit/features/choose_from_our_suggested_meals/presentation/widgets/meal_plan_selection_tracker.dart';

void showMealPlanTracker() {
  // Prevent multiple overlays
  if (Get.isSnackbarOpen) return;

  Get.showSnackbar(
    GetSnackBar(
      maxWidth: 1.sw,
      messageText: MealPlanSelectionTracker(),
      snackPosition: SnackPosition.BOTTOM,
      // margin: const EdgeInsets.all(16),
      borderRadius: 12,
      backgroundColor: Colors.transparent,
      duration: const Duration(seconds: 2),
      animationDuration: const Duration(milliseconds: 900),
      isDismissible: true,
      dismissDirection: DismissDirection.horizontal,
    ),
  );
}
