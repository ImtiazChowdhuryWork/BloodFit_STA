import 'package:bloodfit/constants/text_font_style.dart';
import 'package:bloodfit/endpoints.dart';
import 'package:bloodfit/features/choose_from_our_suggested_meals/data/controller/choose_from_our_suggested_meal_controller.dart';
import 'package:bloodfit/features/home/data/controller/home_screen_controller.dart';
import 'package:bloodfit/features/home/presentation/widgets/build_meal_plan_icon_widget.dart';
import 'package:bloodfit/features/home/presentation/widgets/meal_showing_widget_shimmer_effect.dart';
import 'package:bloodfit/gen/colors.gen.dart';
import 'package:bloodfit/helper/logger_util.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../../../custom_widgets/custom_elevated_button.dart';
import '../../../../custom_widgets/meal_plan_item_card.dart';
import '../../../../gen/assets.gen.dart';
import '../../../../helper/ui_helpers.dart';
import '../../../../routes/routes.dart';
import '../../../meal_plan_feature_options/presentation/widgets/swap_meal_bottom_sheet.dart';

class ShowSelectedMealsOrBuildMealPlanWidget extends StatelessWidget {
  ShowSelectedMealsOrBuildMealPlanWidget({super.key});

  final HomeScreenController homeScreenController =
      Get.find<HomeScreenController>();

  /// Detect if an image string is base64 encoded
  bool _isBase64Image(String? image) {
    if (image == null || image.isEmpty) return false;
    if (image.startsWith('data:image')) return true;
    if (image.startsWith('http://') || image.startsWith('https://')) return false;
    if (image.startsWith('/')) return false;
    final cleanPath = image.contains(',') ? image.split(',').last : image;
    return RegExp(r'^[A-Za-z0-9+/=]+$').hasMatch(cleanPath);
  }

  /// Returns the correct image path based on whether it's base64 or a URL
  String _resolveImagePath(String? image) {
    if (image == null || image.isEmpty) return '';
    if (_isBase64Image(image)) return image;
    return '$imageBaseUrl$image';
  }

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
              Icon(
                Icons.wifi_off_rounded,
                color: AppColors.cb20000,
                size: 40.sp,
              ),
              UIHelper.verticalSpace(12.h),
              Text(
                'Something went wrong.',
                textAlign: TextAlign.center,
                style: TextFontStyle.headline14w500cFFFFFFStylePoppins,
              ),
              UIHelper.verticalSpace(4.h),
              Text(
                'Please check your connection and try again.',
                textAlign: TextAlign.center,
                style: TextFontStyle.headline14w500cFFFFFFStylePoppins.copyWith(
                  color: AppColors.cc6c6c6,
                ),
              ),
              UIHelper.verticalSpace(16.h),


              CustomElevatedButton(
              onTap: () => homeScreenController.getTodaysSelectedMealsApi(),
              buttonTitle: 'retry'.tr,
              buttonWidth: 120.w,
              buttonHeight: 40.h,
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
                  arguments: {'mealID': homeScreenController.breakfastMealID, 'hideSelectButton': true,},
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
                // Use mealType as both category and subCategory for the swap API
                showSwapMealBottomSheet(
                  mealType: homeScreenController.itemBreakFast.value?.mealType ?? 'breakfast',
                  mealName: homeScreenController.breakfastName ?? '',
                  mealId: homeScreenController.breakfastMealID,
                  mealCalories: homeScreenController.breakfastTotalKcal ?? 0,
                  category: homeScreenController.itemBreakFast.value?.mealType ?? 'breakfast',
                  subCategory: homeScreenController.itemBreakFast.value?.mealType ?? 'breakfast',
                );
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
                  _resolveImagePath(homeScreenController.breakFastImage),
              isImageLinkBase64:
                  _isBase64Image(homeScreenController.breakFastImage),
            ),
            UIHelper.verticalSpace(24.h),

            ///------->>> Section : Lunch
            MealPlanItemCard(
              onTap: () {
                Get.toNamed(
                  Routes.mealDetailscreen,
                  arguments: {'mealID': homeScreenController.lunchMealID, 'hideSelectButton': true,},
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
                  "Button Tapped: Swap Meal, Meal Type :: ${homeScreenController.itemLunch.value?.mealType} Meal Name :: ${homeScreenController.itemLunch.value?.mealName}",
                );
                // Use mealType as both category and subCategory for the swap API
                showSwapMealBottomSheet(
                  mealType: homeScreenController.itemLunch.value?.mealType ?? 'lunch',
                  mealName: homeScreenController.lunchName ?? '',
                  mealId: homeScreenController.lunchMealID,
                  mealCalories: homeScreenController.lunchTotalKcal ?? 0,
                  category: homeScreenController.itemLunch.value?.mealType ?? 'lunch',
                  subCategory: homeScreenController.itemLunch.value?.mealType ?? 'lunch',
                );
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
              mealImagePath:
                  _resolveImagePath(homeScreenController.lunchImage),
              isImageLinkBase64:
                  _isBase64Image(homeScreenController.lunchImage),
            ),
            UIHelper.verticalSpace(24.h),

            ///------->>> Section : Dinner
            MealPlanItemCard(
              onTap: () {
                Get.toNamed(
                  Routes.mealDetailscreen,
                  arguments: {'mealID': homeScreenController.dinerMealID, 'hideSelectButton': true,},
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
                  "Button Tapped: Swap Meal, Meal Type :: ${homeScreenController.itemDinner.value?.mealType} Meal Name :: ${homeScreenController.itemDinner.value?.mealName}",
                );
                // Use mealType as both category and subCategory for the swap API
                showSwapMealBottomSheet(
                  mealType: homeScreenController.itemDinner.value?.mealType ?? 'dinner',
                  mealName: homeScreenController.dinerName ?? '',
                  mealId: homeScreenController.dinerMealID,
                  mealCalories: homeScreenController.dinerKcal ?? 0,
                  category: homeScreenController.itemDinner.value?.mealType ?? 'dinner',
                  subCategory: homeScreenController.itemDinner.value?.mealType ?? 'dinner',
                );
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
              mealImagePath:
                  _resolveImagePath(homeScreenController.dinerImage),
              isImageLinkBase64:
                  _isBase64Image(homeScreenController.dinerImage),
            ),
          ],
        );
      }

      // Default state: Build Meal Plan Widget
      return BuildMealPlanWidget(
        onTap: () {
          final DateTime now = DateTime.now();
          final String formatedCurrentDate = DateFormat('yyyy-MM-dd').format(now);
          // Clear previous selections so the new session starts fresh
          // (only if already registered — first-time navigation initialises fresh via binding)
          if (Get.isRegistered<ChooseFromOurSuggestedMealController>()) {
            Get.find<ChooseFromOurSuggestedMealController>().clearAllSelections();
          }
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
