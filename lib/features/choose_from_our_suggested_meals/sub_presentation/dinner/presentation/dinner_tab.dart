import 'package:bloodfit/features/choose_from_our_suggested_meals/data/controller/choose_from_our_suggested_meal_controller.dart';
import 'package:bloodfit/features/choose_from_our_suggested_meals/presentation/widgets/meal_plan_type_widget.dart';
import 'package:bloodfit/features/choose_from_our_suggested_meals/presentation/widgets/recently_selected_meals_widget.dart';
import 'package:bloodfit/helper/logger_util.dart';
import 'package:bloodfit/helper/ui_helpers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class DinnerTab extends StatefulWidget {
  const DinnerTab({super.key});

  @override
  State<DinnerTab> createState() => _DinnerTabState();
}

class _DinnerTabState extends State<DinnerTab> {
  final ChooseFromOurSuggestedMealController
  chooseFromOurSuggestedMealController =
      Get.find<ChooseFromOurSuggestedMealController>();

  @override
  void initState() {
    super.initState();
    // Initialize AFTER build completes to avoid setState during build
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _checkAndInitialize();
    });
  }

  void _checkAndInitialize() {
    final proteinCount = chooseFromOurSuggestedMealController.dinnerProteinPackedMeals.length;
    final lightCount = chooseFromOurSuggestedMealController.dinnerLightAndFreshMeals.length;
    final healthyCount = chooseFromOurSuggestedMealController.dinnerHealthyAndComfortingMeals.length;
    final hasMeals = proteinCount > 0 || lightCount > 0 || healthyCount > 0;
    final isLoading = chooseFromOurSuggestedMealController.isAiSuggestedMealsLoading.value;
    
    LoggerUtils.debug("🍽️ [INIT] hasMeals=$hasMeals, isLoading=$isLoading");
    
    if (!hasMeals && !isLoading) {
      LoggerUtils.debug("🍽️ [INIT] No meals + Not loading → Calling initializeAiMeals()");
      chooseFromOurSuggestedMealController.initializeAiMeals();
    } else if (hasMeals) {
      LoggerUtils.debug("🍽️ [INIT] Meals already in memory, skipping init");
    } else if (isLoading) {
      LoggerUtils.debug("🍽️ [INIT] Already loading, skipping init");
    }
  }

  @override
  Widget build(BuildContext context) {
    LoggerUtils.debug("🍽️ [BUILD] Dinner tab build() called");

    return Obx(() {
      // Check if meals are available
      final proteinCount = chooseFromOurSuggestedMealController.dinnerProteinPackedMeals.length;
      final lightCount = chooseFromOurSuggestedMealController.dinnerLightAndFreshMeals.length;
      final healthyCount = chooseFromOurSuggestedMealController.dinnerHealthyAndComfortingMeals.length;
      final hasMeals = proteinCount > 0 || lightCount > 0 || healthyCount > 0;
      final isLoading = chooseFromOurSuggestedMealController.isAiSuggestedMealsLoading.value;
      final hasError = chooseFromOurSuggestedMealController.aiSuggestedMealsErrorMessage.value.isNotEmpty;

      LoggerUtils.debug("🍽️ [OBX] hasMeals=$hasMeals, isLoading=$isLoading, protein=$proteinCount, light=$lightCount, healthy=$healthyCount");

      // Handle loading state (only show if no meals yet)
      if (isLoading && !hasMeals) {
        return const Center(
          child: CircularProgressIndicator(),
        );
      }

      // Handle error state
      if (hasError) {
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

      // Handle empty state (only show if not loading, has jobId, and still no meals)
      // If no jobId exists, we need to fetch - show loading instead
      final hasJobId = chooseFromOurSuggestedMealController.jobID.value.isNotEmpty;
      
      if (!hasMeals && !isLoading) {
        if (!hasJobId) {
          // No jobId means we need to fetch - show loading
          LoggerUtils.debug("🍽️ [OBX] No jobId, showing loading (will fetch)");
          return const Center(
            child: CircularProgressIndicator(),
          );
        } else {
          // Has jobId but no meals - show empty state with refresh
          LoggerUtils.debug("⚠️ [OBX] Showing EMPTY STATE with Refresh button");
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
