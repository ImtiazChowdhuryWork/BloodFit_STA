import 'package:bloodfit/features/choose_from_our_suggested_meals/data/controller/choose_from_our_suggested_meal_controller.dart';
import 'package:bloodfit/features/choose_from_our_suggested_meals/presentation/widgets/meal_plan_type_widget.dart';
import 'package:bloodfit/features/choose_from_our_suggested_meals/presentation/widgets/recently_selected_meals_widget.dart';
import 'package:bloodfit/helper/logger_util.dart';
import 'package:bloodfit/helper/ui_helpers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class DinnerTab extends StatelessWidget {
 DinnerTab({super.key});

  final ChooseFromOurSuggestedMealController
  chooseFromOurSuggestedMealController =
      Get.find<ChooseFromOurSuggestedMealController>();

  @override
  Widget build(BuildContext context) {
    // Initialize AI meals on first build if jobId is empty
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (chooseFromOurSuggestedMealController.jobID.isEmpty) {
        LoggerUtils.debug("🍽️ Dinner tab: jobId is empty, initializing AI meals...");
        chooseFromOurSuggestedMealController.initializeAiMeals();
      } else {
        LoggerUtils.debug("🍽️ Dinner tab: jobId already exists: ${chooseFromOurSuggestedMealController.jobID.value}");
      }
    });

    return Obx(() {
      // Handle loading state
      if (chooseFromOurSuggestedMealController.isAiSuggestedMealsLoading.value) {
        return const Center(
          child: CircularProgressIndicator(),
        );
      }

      // Handle error state
      if (chooseFromOurSuggestedMealController.aiSuggestedMealsErrorMessage.value.isNotEmpty) {
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Error: ${chooseFromOurSuggestedMealController.aiSuggestedMealsErrorMessage.value}',
                style: const TextStyle(color: Colors.red),
                textAlign: TextAlign.center,
              ),
              UIHelper.verticalSpace(16.h),
              ElevatedButton(
                onPressed: () {
                  LoggerUtils.debug("🔄 Refreshing dinner meals...");
                  chooseFromOurSuggestedMealController.initializeAiMeals();
                },
                child: const Text('Retry'),
              ),
            ],
          ),
        );
      }

      // Check if meals are available
      final proteinCount = chooseFromOurSuggestedMealController.dinnerProteinPackedMeals.length;
      final lightCount = chooseFromOurSuggestedMealController.dinnerLightAndFreshMeals.length;
      final healthyCount = chooseFromOurSuggestedMealController.dinnerHealthyAndComfortingMeals.length;

      LoggerUtils.debug("🍽️ Building Dinner tab - Protein: $proteinCount, Light: $lightCount, Healthy: $healthyCount");

      // Handle empty state
      if (proteinCount == 0 && lightCount == 0 && healthyCount == 0) {
        LoggerUtils.debug("⚠️ No meals found in dinner, showing empty state");
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'No meals available',
                style: TextStyle(fontSize: 16),
              ),
              UIHelper.verticalSpace(16.h),
              ElevatedButton(
                onPressed: () {
                  LoggerUtils.debug("🔄 Refreshing dinner meals...");
                  chooseFromOurSuggestedMealController.initializeAiMeals();
                },
                child: const Text('Refresh'),
              ),
            ],
          ),
        );
      }

      // Display meals
      return SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ///Section : ------------///Previously Selected Meals///----------------
            RecentlySelectedMealsWidget(
              isLoading: chooseFromOurSuggestedMealController.isPreviouslySelectedMealsLoading,
              meals: chooseFromOurSuggestedMealController.dinnerRecentChosenMeals,
            ),
            UIHelper.verticalSpace(32.h),

            ///Section : ------------///Protein-Packed ///----------------
            if (proteinCount > 0)
              MealPlanTypeWidget(
                mealPlanType: "Protein-Packed",
                itemImagePath: chooseFromOurSuggestedMealController.dinnerMealImage,
                itemsList: chooseFromOurSuggestedMealController.dinnerProteinPackedMeals,
                retryOnTap: () {
                  LoggerUtils.debug("🔄 Refreshing dinner meals...");
                  chooseFromOurSuggestedMealController.initializeAiMeals();
                },
              ),
            UIHelper.verticalSpace(32.h),

            ///Section : ------------///Light & Fresh ///----------------
            if (lightCount > 0)
              MealPlanTypeWidget(
                mealPlanType: "Light & Fresh",
                itemImagePath: chooseFromOurSuggestedMealController.dinnerMealImage,
                itemsList: chooseFromOurSuggestedMealController.dinnerLightAndFreshMeals,
                retryOnTap: () {
                  LoggerUtils.debug("🔄 Refreshing dinner meals...");
                  chooseFromOurSuggestedMealController.initializeAiMeals();
                },
              ),
            UIHelper.verticalSpace(32.h),

            ///Section : ------------///Hearty & Comforting///----------------
            if (healthyCount > 0)
              MealPlanTypeWidget(
                mealPlanType: "Hearty & Comforting",
                itemImagePath: chooseFromOurSuggestedMealController.dinnerMealImage,
                itemsList: chooseFromOurSuggestedMealController.dinnerHealthyAndComfortingMeals,
                retryOnTap: () {
                  LoggerUtils.debug("🔄 Refreshing dinner meals...");
                  chooseFromOurSuggestedMealController.initializeAiMeals();
                },
              ),
            UIHelper.verticalSpace(32.h),
          ],
        ),
      );
    });
  }
}
