import 'dart:developer';

import 'package:bloodfit/constants/text_font_style.dart';
import 'package:bloodfit/endpoints.dart';
import 'package:bloodfit/features/home/data/controller/home_screen_controller.dart';
import 'package:bloodfit/features/home/presentation/widgets/build_meal_plan_icon_widget.dart';
import 'package:bloodfit/gen/colors.gen.dart';
import 'package:bloodfit/helper/logger_util.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../../controllers/enums_controller.dart';
import '../../../../custom_widgets/meal_network_image_showing_widget.dart';
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
        return Center(child: CircularProgressIndicator(color: Colors.red));
      }

      // API Error State
      if (homeScreenController
          .todaysSelectedMealsErrorMessage
          .value
          .isNotEmpty) {
        return Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                homeScreenController.todaysSelectedMealsErrorMessage.value,
                textAlign: TextAlign.center,
                style: TextFontStyle.headline14w500cFFFFFFStylePoppins.copyWith(
                  color: AppColors.cb20000,
                ),
              ),
              UIHelper.verticalSpace(16.h),
              ElevatedButton(
                onPressed: () =>
                    homeScreenController.getTodaysSelectedMealsApi(),
                child: const Text("Retry"),
              ),
            ],
          ),
        );
      }

      ///------->>> Section : Todays Meal Plan For ("Breakfast", "Lunch", "Dinner")
      if (homeScreenController.selectedMealPlanAvailable.value) {


        LoggerUtils.debug("Image URL : $imageBaseUrl${homeScreenController.breakFastImage}");
        
        ///------->>> Section : Breakfast
        return Column(
          children: [


            ///------->>> Section : Breakfast
            MealPlanItemCard(
              leftButtonTitle: "I Ate This",
              leftButtonOnTap: () {
                LoggerUtils.debug(
                  "Button Tapped: I Ate This, Meal Type :: ${homeScreenController.itemBreakFast.value?.mealType} Meal Name :: ${homeScreenController.itemBreakFast.value?.mealName}",
                );
              },
              rightButtonTitle: "Swap Meal",
              rightButtonOnTap: () {
                LoggerUtils.debug(
                  "Button Tapped: Swap Meal, Meal Type :: ${homeScreenController.itemBreakFast.value?.mealType} Meal Name :: ${homeScreenController.itemBreakFast.value?.mealName}",
                );
                showSwapMealBottomSheet();
              },
              mealType:
                  homeScreenController.itemBreakFast.value?.mealType ??
                  "Failed to Get Meal Type..",
              mealTitle: homeScreenController.breakfastName ?? '',
              kcalValue: homeScreenController.breakfastTotalKcal ?? 0,
              mealImagePath: "$imageBaseUrl${homeScreenController.breakFastImage}",
            ),


            ///------->>> Section : Lunch
            MealPlanItemCard(
              leftButtonTitle: "I Ate This",
              leftButtonOnTap: () {
                LoggerUtils.debug(
                  "Button Tapped: I Ate This, Meal Type :: ${homeScreenController.itemBreakFast.value?.mealType} Meal Name :: ${homeScreenController.itemBreakFast.value?.mealName}",
                );
              },
              rightButtonTitle: "Swap Meal",
              rightButtonOnTap: () {
                LoggerUtils.debug(
                  "Button Tapped: Swap Meal, Meal Type :: ${homeScreenController.itemBreakFast.value?.mealType} Meal Name :: ${homeScreenController.itemBreakFast.value?.mealName}",
                );
                showSwapMealBottomSheet();
              },
              mealType:
                  homeScreenController.itemBreakFast.value?.mealType ??
                  "Failed to Get Meal Type..",
              mealTitle: homeScreenController.breakfastName ?? '',
              kcalValue: homeScreenController.breakfastTotalKcal ?? 0,
              mealImagePath: "$imageBaseUrl${homeScreenController.breakFastImage}",
            ),



            ///------->>> Section : Dinner
            MealPlanItemCard(
              leftButtonTitle: "I Ate This",
              leftButtonOnTap: () {
                LoggerUtils.debug(
                  "Button Tapped: I Ate This, Meal Type :: ${homeScreenController.itemBreakFast.value?.mealType} Meal Name :: ${homeScreenController.itemBreakFast.value?.mealName}",
                );
              },
              rightButtonTitle: "Swap Meal",
              rightButtonOnTap: () {
                LoggerUtils.debug(
                  "Button Tapped: Swap Meal, Meal Type :: ${homeScreenController.itemBreakFast.value?.mealType} Meal Name :: ${homeScreenController.itemBreakFast.value?.mealName}",
                );
                showSwapMealBottomSheet();
              },
              mealType:
                  homeScreenController.itemBreakFast.value?.mealType ??
                  "Failed to Get Meal Type..",
              mealTitle: homeScreenController.breakfastName ?? '',
              kcalValue: homeScreenController.breakfastTotalKcal ?? 0,
              mealImagePath: "$imageBaseUrl${homeScreenController.breakFastImage}",
            ),



            ///------->>> Section : Image Debuger
            MealNetworkImage(
  imageUrl: '$imageBaseUrl${homeScreenController.lunchImage}',
  width: 140.w,
  height: 140.h,
  fit: BoxFit.contain,
)

          ],
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
