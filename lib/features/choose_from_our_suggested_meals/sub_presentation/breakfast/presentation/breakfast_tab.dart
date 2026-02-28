import 'package:bloodfit/features/choose_from_our_suggested_meals/data/controller/choose_from_our_suggested_meal_controller.dart';
import 'package:bloodfit/features/choose_from_our_suggested_meals/presentation/widgets/meal_plan_type_widget.dart';
import 'package:bloodfit/features/choose_from_our_suggested_meals/presentation/widgets/recently_selected_meals_widget.dart';
import 'package:bloodfit/gen/assets.gen.dart';
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
  final ChooseFromOurSuggestedMealController chooseFromOurSuggestedMealController =
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
    final proteinCount = chooseFromOurSuggestedMealController.breakfastProteinPackedMeals.length;
    final lightCount = chooseFromOurSuggestedMealController.breakfastLightAndFreshMeals.length;
    final healthyCount = chooseFromOurSuggestedMealController.breakfastHealthyAndComfortingMeals.length;
    final hasMeals = proteinCount > 0 || lightCount > 0 || healthyCount > 0;
    final isLoading = chooseFromOurSuggestedMealController.isAiSuggestedMealsLoading.value;
    
    LoggerUtils.debug("🍳 [INIT] hasMeals=$hasMeals, isLoading=$isLoading");
    
    if (!hasMeals && !isLoading) {
      LoggerUtils.debug("🍳 [INIT] No meals + Not loading → Calling initializeAiMeals()");
      chooseFromOurSuggestedMealController.initializeAiMeals();
    } else if (hasMeals) {
      LoggerUtils.debug("🍳 [INIT] Meals already in memory, skipping init");
    } else if (isLoading) {
      LoggerUtils.debug("🍳 [INIT] Already loading, skipping init");
    }
  }

  @override
  Widget build(BuildContext context) {
    LoggerUtils.debug("🍳 [BUILD] Breakfast tab build() called");

    return Obx(() {
      LoggerUtils.debug("🍳 [OBX] Rebuilding with Obx...");
      
      // Check if meals are available (re-check inside Obx)
      final obxProteinCount = chooseFromOurSuggestedMealController.breakfastProteinPackedMeals.length;
      final obxLightCount = chooseFromOurSuggestedMealController.breakfastLightAndFreshMeals.length;
      final obxHealthyCount = chooseFromOurSuggestedMealController.breakfastHealthyAndComfortingMeals.length;
      final obxHasMeals = obxProteinCount > 0 || obxLightCount > 0 || obxHealthyCount > 0;
      final obxIsLoading = chooseFromOurSuggestedMealController.isAiSuggestedMealsLoading.value;
      final obxHasError = chooseFromOurSuggestedMealController.aiSuggestedMealsErrorMessage.value.isNotEmpty;

      LoggerUtils.debug("🍳 [OBX] obxHasMeals=$obxHasMeals, obxIsLoading=$obxIsLoading, obxHasError=$obxHasError");

      // Handle loading state (only show if no meals yet)
      if (obxIsLoading && !obxHasMeals) {
        LoggerUtils.debug("🍳 [OBX] Showing loading indicator");
        return const Center(
          child: CircularProgressIndicator(),
        );
      }

      // Handle error state
      if (obxHasError) {
        LoggerUtils.debug("🍳 [OBX] Showing error state");
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
                  LoggerUtils.debug("🔄 Refreshing breakfast meals...");
                  chooseFromOurSuggestedMealController.initializeAiMeals();
                },
                child: const Text('Retry'),
              ),
            ],
          ),
        );
      }

      // Handle empty state (only show if not loading and has jobId)
      if (!obxHasMeals && !obxIsLoading) {
        LoggerUtils.debug("⚠️ [OBX] Showing EMPTY STATE with Refresh button (THIS IS THE BUG!)");
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
                  LoggerUtils.debug("🔄 Refreshing breakfast meals...");
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
              meals: chooseFromOurSuggestedMealController.breakfastRecentChosenMeals,
            ),
            UIHelper.verticalSpace(32.h),

            ///Section : ------------///Protein-Packed ///----------------
            if (obxProteinCount > 0)
              MealPlanTypeWidget(
                mealPlanType: "Protein-Packed",
                itemImagePath: chooseFromOurSuggestedMealController.breakFastMealImage,
                itemsList: chooseFromOurSuggestedMealController.breakfastProteinPackedMeals,
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
                itemImagePath: chooseFromOurSuggestedMealController.breakFastMealImage,
                itemsList: chooseFromOurSuggestedMealController.breakfastLightAndFreshMeals,
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
                itemImagePath: chooseFromOurSuggestedMealController.breakFastMealImage,
                itemsList: chooseFromOurSuggestedMealController.breakfastHealthyAndComfortingMeals,
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
  }
}
