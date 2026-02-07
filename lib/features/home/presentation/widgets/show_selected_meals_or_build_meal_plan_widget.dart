import 'dart:developer';

import 'package:bloodfit/constants/text_font_style.dart';
import 'package:bloodfit/endpoints.dart';
import 'package:bloodfit/features/choose_from_our_suggested_meals/data/controller/choose_from_our_suggested_meal_controller.dart';
import 'package:bloodfit/features/home/data/controller/home_screen_controller.dart';
import 'package:bloodfit/features/home/presentation/widgets/build_meal_plan_icon_widget.dart';
import 'package:bloodfit/gen/colors.gen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../../constants/app_list.dart';
import '../../../../controllers/enums_controller.dart';
import '../../../../custom_widgets/meal_plan_item_card.dart';
import '../../../../gen/assets.gen.dart';
import '../../../../helper/ui_helpers.dart';
import '../../../../routes/routes.dart';
import '../../../meal_plan_feature_options/presentation/widgets/swap_meal_bottom_sheet.dart';

class ShowSelectedMealsOrBuildMealPlanWidget extends StatelessWidget {
  ShowSelectedMealsOrBuildMealPlanWidget({super.key});

  final EnumsController enumsController = Get.find<EnumsController>();
  final HomeScreenController homeScreenController =
      Get.find<HomeScreenController>();

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      // API Loading State
      if (homeScreenController.isTodaysSelectedMealsLoading.value) {
        return Center(
          child: CircularProgressIndicator(
            color: Colors.red,
          ),
        );
      }

      // API Error State
      if (homeScreenController.todaysSelectedMealsErrorMessage.value.isNotEmpty) {
        return Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                homeScreenController.todaysSelectedMealsErrorMessage.value,
                textAlign: TextAlign.center,
              style: TextFontStyle.headline14w500cFFFFFFStylePoppins.copyWith(color: AppColors.cb20000),
              ),
              UIHelper.verticalSpace(16.h),
              ElevatedButton(
                onPressed: () => homeScreenController.getTodaysSelectedMealsApi(),
                child: const Text("Retry"),
              ),
            ],
          ),
        );
      }

      // If meal plan is available
      if (homeScreenController.selectedMealPlanAvailable.value) {
        final meals = [
          homeScreenController.itemBreakFast.value,
          homeScreenController.itemLunch.value,
          homeScreenController.itemDinner.value,
        ];

        return ListView.separated(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: meals.length,
          separatorBuilder: (context, index) => UIHelper.verticalSpace(24.h),
          itemBuilder: (context, index) {
            final meal = meals[index];
            if (meal == null) return const SizedBox.shrink();

            return MealPlanItemCard(
              leftButtonTitle: "I Ate This",
              leftButtonOnTap: () {
                log("Button Tapped: I Ate This - ${meal.mealType}");
              },
              rightButtonTitle: "Swap Meal",
              rightButtonOnTap: () {
                log("Button Tapped: Swap Meal - ${meal.mealType}");
                showSwapMealBottomSheet();
              },
              mealType: meal.mealType ?? '',
              mealTitle: meal.mealType ?? '',
              kcalValue: meal.caloryCount?[index].kcal ?? 0,
              mealImagePath: "$imageBaseUrl${meal.image}",
            );
          },
        );
      }

      // Default state: Build Meal Plan Widget
      return BuildMealPlanWidget(
        onTap: () {
          log("Button Tapped : Get Started !");
          Get.toNamed(Routes.chooseFromOurSuggestedMealsScreen);
        },
        showSectionTitle: true,
        sectionTitle: "Choose From Our Suggested Meals",
        buttonTitle: "Get Started",
        positionTop: -36.h,
        positionRight: -20.w,
        imageIconPath: Assets.icons.chickeMealIcon,
        title: "Build Your Daily Meals",
        subTitle:
            "Select Your Breakfast, Lunch, And Dinner From Personalized Meal Suggestions",
      );
    });
  }
}
