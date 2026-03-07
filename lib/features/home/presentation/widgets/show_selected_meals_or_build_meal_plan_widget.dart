import 'dart:developer';

import 'package:bloodfit/constants/text_font_style.dart';
import 'package:bloodfit/endpoints.dart';
import 'package:bloodfit/features/home/data/controller/home_screen_controller.dart';
import 'package:bloodfit/features/home/presentation/widgets/build_meal_plan_icon_widget.dart';
import 'package:bloodfit/features/home/presentation/widgets/meal_showing_widget_shimmer_effect.dart';
import 'package:bloodfit/gen/colors.gen.dart';
import 'package:bloodfit/helper/logger_util.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../../../custom_widgets/meal_plan_item_card.dart';
import '../../../../gen/assets.gen.dart';
import '../../../../helper/ui_helpers.dart';
import '../../../../routes/routes.dart';
import '../../../meal_plan_feature_options/presentation/widgets/swap_meal_bottom_sheet.dart';

class ShowSelectedMealsOrBuildMealPlanWidget extends StatelessWidget {
  ShowSelectedMealsOrBuildMealPlanWidget({super.key});

  final HomeScreenController homeScreenController =
      Get.find<HomeScreenController>();

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      // API Loading State
      if (homeScreenController.isTodaysSelectedMealsLoading.value) {
        return ListView.separated(
          itemCount: 3,
          separatorBuilder: (context, index) => UIHelper.verticalSpace(20.h),
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemBuilder: (context, index) {
            return MealShowingWidgetShimmerEffect();
          },
        );
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
                child: Text('retry'.tr),
              ),
            ],
          ),
        );
      }

      ///------->>> Section : Todays Meal Plan For ("Breakfast", "Lunch", "Dinner")
      if (homeScreenController.selectedMealPlanAvailable.value) {
        LoggerUtils.debug(
          "Image URL : $imageBaseUrl${homeScreenController.breakFastImage}",
        );
        LoggerUtils.debug(
          "Breakfast: ${homeScreenController.breakfastName}, Lunch: ${homeScreenController.lunchName}, Dinner: ${homeScreenController.dinerName}",
        );
        LoggerUtils.debug(
          "selectedMealPlanAvailable: ${homeScreenController.selectedMealPlanAvailable.value}",
        );
        LoggerUtils.debug(
          "todaysSelectedMealsList length: ${homeScreenController.todaysSelectedMealsList.length}",
        );

        ///------->>> Section : Breakfast
        return Column(
          children: [
            ///------->>> Section : Breakfast
            MealPlanItemCard(
              onTap: () {
                Get.toNamed(
                  Routes.mealDetailscreen,
                  arguments: {'mealID': homeScreenController.breakfastMealID},
                );
              },
              isMealEaten:
                  homeScreenController.breakFastMealEatenStatus ==
                      'not_yet_done'
                  ? false
                  : homeScreenController.breakFastMealEatenStatus == 'done'
                  ? true
                  : false,
              leftButtonTitle: 'i_ate_this'.tr,
              leftButtonOnTap: () {
                homeScreenController.patchUpdateMealConsumptionApi(
                  mealID: homeScreenController.breakfastMealID ?? '',
                );
                LoggerUtils.debug(
                  "Button Tapped: I Ate This, Meal Type :: ${homeScreenController.itemBreakFast.value?.mealType} Meal Name :: ${homeScreenController.itemBreakFast.value?.mealName}",
                );
              },
              rightButtonTitle: 'swap_meal'.tr,
              rightButtonOnTap: () {
                LoggerUtils.debug(
                  "Button Tapped: Swap Meal, Meal Type :: ${homeScreenController.itemBreakFast.value?.mealType} Meal Name :: ${homeScreenController.itemBreakFast.value?.mealName}",
                );
                showSwapMealBottomSheet();
              },
              mealType:
                  homeScreenController
                      .itemBreakFast
                      .value
                      ?.mealType
                      ?.capitalizeFirst ??
                  'failed_to_get_meal_type'.tr,
              mealTitle: homeScreenController.breakfastName ?? '',
              kcalValue: homeScreenController.breakfastTotalKcal ?? 0,
              mealImagePath:
                  "$imageBaseUrl${homeScreenController.breakFastImage}",
            ),
            UIHelper.verticalSpace(24.h),

            ///------->>> Section : Lunch
            MealPlanItemCard(
              onTap: () {
                Get.toNamed(
                  Routes.mealDetailscreen,
                  arguments: {'mealID': homeScreenController.lunchMealID},
                );
              },
              isMealEaten:
                  homeScreenController.lunchMealEatenStatus == 'not_yet_done'
                  ? false
                  : homeScreenController.lunchMealEatenStatus == 'done'
                  ? true
                  : false,
              leftButtonTitle: 'i_ate_this'.tr,

              leftButtonOnTap: () async {
                LoggerUtils.debug(
                  "BreakFast Meal ID : ${homeScreenController.lunchMealID} ",
                );
                await homeScreenController.patchUpdateMealConsumptionApi(
                  mealID: homeScreenController.lunchMealID ?? '',
                );
                LoggerUtils.debug(
                  "Button Tapped: I Ate This, Meal Type :: ${homeScreenController.itemBreakFast.value?.mealType} Meal Name :: ${homeScreenController.itemBreakFast.value?.mealName}",
                );
              },
              rightButtonTitle: 'swap_meal'.tr,
              rightButtonOnTap: () {
                LoggerUtils.debug(
                  "Button Tapped: Swap Meal, Meal Type :: ${homeScreenController.itemBreakFast.value?.mealType} Meal Name :: ${homeScreenController.itemBreakFast.value?.mealName}",
                );
                showSwapMealBottomSheet();
              },
              mealType:
                  homeScreenController
                      .itemLunch
                      .value
                      ?.mealType
                      ?.capitalizeFirst ??
                  'failed_to_get_meal_type'.tr,
              mealTitle: homeScreenController.lunchName ?? '',
              kcalValue: homeScreenController.lunchTotalKcal ?? 0,
              mealImagePath: "$imageBaseUrl${homeScreenController.lunchImage}",
            ),
            UIHelper.verticalSpace(24.h),

            ///------->>> Section : Dinner
            MealPlanItemCard(
              onTap: () {
                Get.toNamed(
                  Routes.mealDetailscreen,
                  arguments: {'mealID': homeScreenController.dinerMealID},
                );
              },
              isMealEaten:
                  homeScreenController.dinerMealEatenStatus == 'not_yet_done'
                  ? false
                  : homeScreenController.dinerMealEatenStatus == 'done'
                  ? true
                  : false,
              leftButtonTitle: 'i_ate_this'.tr,
              leftButtonOnTap: () {
                homeScreenController.patchUpdateMealConsumptionApi(
                  mealID: homeScreenController.dinerMealID ?? '',
                );
                LoggerUtils.debug(
                  "Button Tapped: I Ate This, Meal Type :: ${homeScreenController.itemDinner.value?.mealType} Meal Name :: ${homeScreenController.itemBreakFast.value?.mealName}",
                );
              },
              rightButtonTitle: 'swap_meal'.tr,
              rightButtonOnTap: () {
                LoggerUtils.debug(
                  "Button Tapped: Swap Meal, Meal Type :: ${homeScreenController.itemDinner.value?.mealType} Meal Name :: ${homeScreenController.itemBreakFast.value?.mealName}",
                );
                showSwapMealBottomSheet();
              },
              mealType:
                  homeScreenController
                      .itemDinner
                      .value
                      ?.mealType
                      ?.capitalizeFirst ??
                  'failed_to_get_meal_type'.tr,
              mealTitle: homeScreenController.dinerName ?? '',
              kcalValue: homeScreenController.dinerKcal ?? 0,
              mealImagePath: "$imageBaseUrl${homeScreenController.dinerImage}",
            ),
          ],
        );
      }

      // Default state: Build Meal Plan Widget
      return BuildMealPlanWidget(
        onTap: () {
          final DateTime now = DateTime.now();
          final String formatedCurrentDate = DateFormat('yyyy-MM-dd').format(now);
          Get.toNamed(
            Routes.chooseFromOurSuggestedMealsScreen,
            arguments: {'mealGenerationDate': formatedCurrentDate},
          );
        },
        showSectionTitle: true,
        sectionTitle: 'choose_from_suggested_meals'.tr,
        buttonTitle: 'get_started'.tr,
        positionTop: -36.h,
        positionRight: -20.w,
        imageIconPath: Assets.icons.chickeMealIcon,
        title: 'build_your_daily_meals'.tr,
        subTitle: 'select_meals_description'.tr,
      );
    });
  }
}
