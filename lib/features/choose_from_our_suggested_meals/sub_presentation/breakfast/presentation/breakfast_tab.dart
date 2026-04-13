import 'package:bloodfit/features/choose_from_our_suggested_meals/data/controller/choose_from_our_suggested_meal_controller.dart';
import 'package:bloodfit/features/choose_from_our_suggested_meals/presentation/widgets/meal_plan_type_widget.dart';
import 'package:bloodfit/features/choose_from_our_suggested_meals/presentation/widgets/meals_loading_shimmer_card.dart';
import 'package:bloodfit/features/choose_from_our_suggested_meals/presentation/widgets/recently_selected_meals_widget.dart';
import 'package:bloodfit/helper/logger_util.dart';
import 'package:bloodfit/helper/ui_helpers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class BreakfastTab extends StatefulWidget {
  const BreakfastTab({super.key});

  @override
  State<BreakfastTab> createState() => _BreakfastTabState();
}

class _BreakfastTabState extends State<BreakfastTab> {
  final ChooseFromOurSuggestedMealController
  chooseFromOurSuggestedMealController =
      Get.find<ChooseFromOurSuggestedMealController>();

  @override
  Widget build(BuildContext context) {
    LoggerUtils.debug(
      "╔═══════════════════════════════════════════════════════════",
    );
    LoggerUtils.debug("🍳 [BUILD] Breakfast tab build() called");
    LoggerUtils.debug(
      "╚═══════════════════════════════════════════════════════════",
    );

    return Obx(() {
      LoggerUtils.debug("🍳 [OBX] Rebuilding with Obx...");

      // Check if AI meals are available
      final obxProteinCount = chooseFromOurSuggestedMealController
          .breakfastProteinPackedMeals
          .length;
      final obxLightCount = chooseFromOurSuggestedMealController
          .breakfastLightAndFreshMeals
          .length;
      final obxHealthyCount = chooseFromOurSuggestedMealController
          .breakfastHealthyAndComfortingMeals
          .length;
      final obxHasAiMeals =
          obxProteinCount > 0 || obxLightCount > 0 || obxHealthyCount > 0;

      // Check if previously selected meals exist
      final obxHasPreviouslySelectedMeals = chooseFromOurSuggestedMealController
          .breakfastRecentChosenMeals
          .isNotEmpty;

      // Show content if either AI meals OR previously selected meals exist
      final obxHasMeals = obxHasAiMeals || obxHasPreviouslySelectedMeals;

      final obxIsLoading =
          chooseFromOurSuggestedMealController.isAiSuggestedMealsLoading.value;
      final obxHasError = chooseFromOurSuggestedMealController
          .aiSuggestedMealsErrorMessage
          .value
          .isNotEmpty;
      final hasJobId =
          chooseFromOurSuggestedMealController.jobID.value.isNotEmpty;
      final hasLoadedInitially =
          chooseFromOurSuggestedMealController.hasLoadedAiMealsInitially.value;
      final hasJobGenerationFailed =
          chooseFromOurSuggestedMealController.hasJobGenerationFailed.value;
      final jobGenerationFailureReason =
          chooseFromOurSuggestedMealController.jobGenerationFailureReason.value;

      LoggerUtils.debug("🍳 [OBX] obxHasAiMeals=$obxHasAiMeals");
      LoggerUtils.debug(
        "🍳 [OBX] obxHasPreviouslySelectedMeals=$obxHasPreviouslySelectedMeals",
      );
      LoggerUtils.debug("🍳 [OBX] obxHasMeals=$obxHasMeals");
      LoggerUtils.debug("🍳 [OBX] obxIsLoading=$obxIsLoading");
      LoggerUtils.debug("🍳 [OBX] obxHasError=$obxHasError");
      LoggerUtils.debug("🍳 [OBX] hasJobId=$hasJobId");
      LoggerUtils.debug("🍳 [OBX] hasLoadedInitially=$hasLoadedInitially");
      LoggerUtils.debug("🍳 [OBX] hasJobGenerationFailed=$hasJobGenerationFailed");
      LoggerUtils.debug(
        "🍳 [OBX] Meal counts - Protein: $obxProteinCount, Light: $obxLightCount, Healthy: $obxHealthyCount",
      );

      // Handle error state (show error with retry button)
      if (obxHasError && !obxHasMeals) {
        LoggerUtils.debug(
          "🍳 [OBX] >>> Showing ERROR state (hasError=$obxHasError, hasMeals=$obxHasMeals)",
        );
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
                  LoggerUtils.debug("🔄 [BREAKFAST] User tapped Retry button");
                  LoggerUtils.debug(
                    "🔄 [BREAKFAST] Calling initializeAiMeals()...",
                  );
                  chooseFromOurSuggestedMealController.initializeAiMeals();
                },
                child: const Text('Retry'),
              ),
            ],
          ),
        );
      }

      // Show loader when:
      // 1. Loading is in progress, OR
      // 2. No jobId yet AND initial load hasn't completed
      if (obxIsLoading || (!hasJobId && !hasLoadedInitially)) {
        LoggerUtils.debug(
          "🍳 [OBX] >>> Showing LOADING indicator (loading=$obxIsLoading, hasJobId=$hasJobId, hasLoadedInitially=$hasLoadedInitially)",
        );
        return const Center(child: CircularProgressIndicator());
      }

      // Show shimmer while waiting for AI meals to be generated (jobId exists but meals not ready yet)
      // This happens when backend status is "waiting" or "active"
      if (hasJobId && !obxHasAiMeals && hasLoadedInitially) {
        LoggerUtils.debug(
          "🍳 [OBX] >>> Showing SHIMMER (waiting for AI meals - jobId exists but meals not loaded yet)",
        );
        return SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /// Previously Selected Meals (show if available)
              if (obxHasPreviouslySelectedMeals) ...[
                RecentlySelectedMealsWidget(
                  isLoading: chooseFromOurSuggestedMealController
                      .isPreviouslySelectedMealsLoading,
                  meals: chooseFromOurSuggestedMealController
                      .breakfastRecentChosenMeals,
                  tabName: 'breakfast',
                ),
                UIHelper.verticalSpace(32.h),
              ],

              /// AI meals progress card
              const AiMealsProgressCard(),
            ],
          ),
        );
      }

      // Show failure state when job generation has failed/timed out
      if (hasJobGenerationFailed) {
        LoggerUtils.debug(
          "🍳 [OBX] >>> Showing FAILURE STATE (job generation failed/timed out)",
        );
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.error_outline,
                color: Colors.orange,
                size: 64,
              ),
              UIHelper.verticalSpace(24.h),
              const Text(
                'Meal Generation Failed',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              UIHelper.verticalSpace(12.h),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 32.w),
                child: Text(
                  jobGenerationFailureReason,
                  style: const TextStyle(color: Colors.grey, fontSize: 14),
                  textAlign: TextAlign.center,
                ),
              ),
              UIHelper.verticalSpace(24.h),
              ElevatedButton.icon(
                onPressed: () {
                  LoggerUtils.debug(
                    "🔄 [BREAKFAST] User tapped 'Try Again' button",
                  );
                  LoggerUtils.debug(
                    "🔄 [BREAKFAST] Calling retryAiMealGeneration()...",
                  );
                  chooseFromOurSuggestedMealController
                      .retryAiMealGeneration();
                },
                icon: const Icon(Icons.refresh),
                label: const Text('Try Again with New Job ID'),
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(horizontal: 32.w, vertical: 16.h),
                ),
              ),
            ],
          ),
        );
      }

      // Loading completed but no meals from ANY source - show refresh button
      if (!obxHasMeals) {
        LoggerUtils.debug(
          "⚠️ [OBX] >>> Showing EMPTY STATE with Refresh button (no AI meals, no previously selected meals)",
        );
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text('No meals available', style: TextStyle(fontSize: 16)),
              UIHelper.verticalSpace(16.h),
              ElevatedButton(
                onPressed: () {
                  LoggerUtils.debug(
                    "🔄 [BREAKFAST] User tapped Refresh button",
                  );
                  LoggerUtils.debug(
                    "🔄 [BREAKFAST] Calling initializeAiMeals()...",
                  );
                  chooseFromOurSuggestedMealController.initializeAiMeals();
                },
                child: const Text('Refresh'),
              ),
            ],
          ),
        );
      }

      // Display meals
      LoggerUtils.debug(
        "🍳 [OBX] >>> Displaying MEALS (hasMeals=$obxHasMeals)",
      );
      return Obx(() {
        return SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ///Section : ------------///Previously Selected Meals///----------------
              if (chooseFromOurSuggestedMealController
                      .breakfastRecentChosenMeals.isNotEmpty ||
                  chooseFromOurSuggestedMealController
                      .isPreviouslySelectedMealsLoading.value) ...[
                RecentlySelectedMealsWidget(
                  isLoading: chooseFromOurSuggestedMealController
                      .isPreviouslySelectedMealsLoading,
                  meals: chooseFromOurSuggestedMealController
                      .breakfastRecentChosenMeals,
                  tabName: 'breakfast',
                ),
                UIHelper.verticalSpace(32.h),
              ],

            ///Section : ------------///Protein-Packed ///----------------
            if (obxProteinCount > 0)
              MealPlanTypeWidget(
                mealPlanType: "Protein-Packed",
                itemImagePath:
                    chooseFromOurSuggestedMealController.breakFastMealImage,
                itemsList: chooseFromOurSuggestedMealController
                    .breakfastProteinPackedMeals,
                tabName: 'breakfast',
                retryOnTap: () {
                  LoggerUtils.debug("🔄 Refreshing breakfast meals...");
                  chooseFromOurSuggestedMealController.initializeAiMeals();
                },
              ),
            UIHelper.verticalSpace(32.h),

            ///Section : ------------///Light & Fresh ///----------------
            if (obxLightCount > 0)
              MealPlanTypeWidget(
                mealPlanType: "Light & Fresh",
                itemImagePath:
                    chooseFromOurSuggestedMealController.breakFastMealImage,
                itemsList: chooseFromOurSuggestedMealController
                    .breakfastLightAndFreshMeals,
                tabName: 'breakfast',
                retryOnTap: () {
                  LoggerUtils.debug("🔄 Refreshing breakfast meals...");
                  chooseFromOurSuggestedMealController.initializeAiMeals();
                },
              ),
            UIHelper.verticalSpace(32.h),

            ///Section : ------------///Hearty & Comforting///----------------
            if (obxHealthyCount > 0)
              MealPlanTypeWidget(
                mealPlanType: "Hearty & Comforting",
                itemImagePath:
                    chooseFromOurSuggestedMealController.breakFastMealImage,
                itemsList: chooseFromOurSuggestedMealController
                    .breakfastHealthyAndComfortingMeals,
                tabName: 'breakfast',
                retryOnTap: () {
                  LoggerUtils.debug("🔄 Refreshing breakfast meals...");
                  chooseFromOurSuggestedMealController.initializeAiMeals();
                },
              ),
            UIHelper.verticalSpace(32.h),
          ],
        ),
      );
      });
    });
  }
}
