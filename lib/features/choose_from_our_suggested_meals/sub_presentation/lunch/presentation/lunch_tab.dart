import 'package:bloodfit/features/choose_from_our_suggested_meals/data/controller/choose_from_our_suggested_meal_controller.dart';
import 'package:bloodfit/features/choose_from_our_suggested_meals/presentation/widgets/meal_plan_type_widget.dart';
import 'package:bloodfit/features/choose_from_our_suggested_meals/presentation/widgets/recently_selected_meals_widget.dart';
import 'package:bloodfit/helper/logger_util.dart';
import 'package:bloodfit/helper/ui_helpers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class LunchTab extends StatefulWidget {
  const LunchTab({super.key});

  @override
  State<LunchTab> createState() => _LunchTabState();
}

class _LunchTabState extends State<LunchTab> {
  final ChooseFromOurSuggestedMealController
  chooseFromOurSuggestedMealController =
      Get.find<ChooseFromOurSuggestedMealController>();

  @override
  Widget build(BuildContext context) {
    LoggerUtils.debug("╔═══════════════════════════════════════════════════════════");
    LoggerUtils.debug("🍱 [BUILD] Lunch tab build() called");
    LoggerUtils.debug("╚═══════════════════════════════════════════════════════════");

    return Obx(() {
      LoggerUtils.debug("🍱 [OBX] Rebuilding with Obx...");

      // Check if meals are available
      final proteinCount = chooseFromOurSuggestedMealController.lunchProteinPackedMeals.length;
      final lightCount = chooseFromOurSuggestedMealController.lunchLightAndFreshMeals.length;
      final healthyCount = chooseFromOurSuggestedMealController.lunchHealthyAndComfortingMeals.length;
      final hasMeals = proteinCount > 0 || lightCount > 0 || healthyCount > 0;
      final isLoading = chooseFromOurSuggestedMealController.isAiSuggestedMealsLoading.value;
      final hasError = chooseFromOurSuggestedMealController.aiSuggestedMealsErrorMessage.value.isNotEmpty;
      final hasJobId = chooseFromOurSuggestedMealController.jobID.value.isNotEmpty;

      LoggerUtils.debug("🍱 [OBX] hasMeals=$hasMeals");
      LoggerUtils.debug("🍱 [OBX] isLoading=$isLoading");
      LoggerUtils.debug("🍱 [OBX] hasError=$hasError");
      LoggerUtils.debug("🍱 [OBX] hasJobId=$hasJobId");
      LoggerUtils.debug("🍱 [OBX] Meal counts - Protein: $proteinCount, Light: $lightCount, Healthy: $healthyCount");

      // Handle error state (show error with retry button)
      if (hasError && !hasMeals) {
        LoggerUtils.debug("🍱 [OBX] >>> Showing ERROR state (hasError=$hasError, hasMeals=$hasMeals)");
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
                  LoggerUtils.debug("🔄 [LUNCH] User tapped Retry button");
                  LoggerUtils.debug("🔄 [LUNCH] Calling initializeAiMeals()...");
                  chooseFromOurSuggestedMealController.initializeAiMeals();
                },
                child: const Text('Retry'),
              ),
            ],
          ),
        );
      }

      // Show loader ONLY when:
      // 1. Loading is in progress, OR
      // 2. No jobId yet (need to fetch)
      if (isLoading || !hasJobId) {
        LoggerUtils.debug("🍱 [OBX] >>> Showing LOADING indicator (loading=$isLoading, hasJobId=$hasJobId)");
        return const Center(
          child: CircularProgressIndicator(),
        );
      }

      // Loading completed but no meals - show refresh button
      if (!hasMeals) {
        LoggerUtils.debug("⚠️ [OBX] >>> Showing EMPTY STATE with Refresh button");
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
                  LoggerUtils.debug("🔄 [LUNCH] User tapped Refresh button");
                  LoggerUtils.debug("🔄 [LUNCH] Calling initializeAiMeals()...");
                  chooseFromOurSuggestedMealController.initializeAiMeals();
                },
                child: const Text('Refresh'),
              ),
            ],
          ),
        );
      }

      // Display meals
      LoggerUtils.debug("🍱 [OBX] >>> Displaying MEALS (hasMeals=$hasMeals)");
      return SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ///Section : ------------///Previously Selected Meals///----------------
            RecentlySelectedMealsWidget(
              isLoading: chooseFromOurSuggestedMealController.isPreviouslySelectedMealsLoading,
              meals: chooseFromOurSuggestedMealController.lunchRecentChosenMeals,
            ),
            UIHelper.verticalSpace(32.h),

            ///Section : ------------///Protein-Packed ///----------------
            if (proteinCount > 0)
              MealPlanTypeWidget(
                mealPlanType: "Protein-Packed",
                itemImagePath: chooseFromOurSuggestedMealController.lunchMealImage,
                itemsList: chooseFromOurSuggestedMealController.lunchProteinPackedMeals,
                retryOnTap: () {
                  LoggerUtils.debug("🔄 Refreshing lunch meals...");
                  chooseFromOurSuggestedMealController.initializeAiMeals();
                },
              ),
            UIHelper.verticalSpace(32.h),

            ///Section : ------------///Light & Fresh ///----------------
            if (lightCount > 0)
              MealPlanTypeWidget(
                mealPlanType: "Light & Fresh",
                itemImagePath: chooseFromOurSuggestedMealController.lunchMealImage,
                itemsList: chooseFromOurSuggestedMealController.lunchLightAndFreshMeals,
                retryOnTap: () {
                  LoggerUtils.debug("🔄 Refreshing lunch meals...");
                  chooseFromOurSuggestedMealController.initializeAiMeals();
                },
              ),
            UIHelper.verticalSpace(32.h),

            ///Section : ------------///Hearty & Comforting///----------------
            if (healthyCount > 0)
              MealPlanTypeWidget(
                mealPlanType: "Hearty & Comforting",
                itemImagePath: chooseFromOurSuggestedMealController.lunchMealImage,
                itemsList: chooseFromOurSuggestedMealController.lunchHealthyAndComfortingMeals,
                retryOnTap: () {
                  LoggerUtils.debug("🔄 Refreshing lunch meals...");
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
