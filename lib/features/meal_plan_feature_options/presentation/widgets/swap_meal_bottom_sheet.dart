import 'package:bloodfit/constants/text_font_style.dart';
import 'package:bloodfit/custom_widgets/custom_elevated_button.dart';
import 'package:bloodfit/custom_widgets/custom_shimmer_effect.dart';
import 'package:bloodfit/custom_widgets/meal_plan_item_card.dart';
import 'package:bloodfit/endpoints.dart';
import 'package:bloodfit/features/choose_from_our_suggested_meals/data/model/meal_data_model.dart';
import 'package:bloodfit/features/home/data/controller/home_screen_controller.dart';
import 'package:bloodfit/features/home/data/model/swap_meal_options_model.dart';
import 'package:bloodfit/features/choose_from_our_suggested_meals/presentation/widgets/meals_loading_shimmer_card.dart';
import 'package:bloodfit/gen/colors.gen.dart';
import 'package:bloodfit/helper/logger_util.dart';
import 'package:bloodfit/routes/routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../../helper/ui_helpers.dart';

void showSwapMealBottomSheet({
  required String mealType,
  required String mealName,
  required String? mealId,
  required int mealCalories,
  required String? category,
  required String? subCategory,
}) {
  final HomeScreenController homeScreenController =
      Get.find<HomeScreenController>();

  // Set the parameters for the API call
  homeScreenController.setCategoryName(value: category ?? '');
  homeScreenController.setSubCategoryName(value: subCategory ?? '');
  homeScreenController.setCurrentCalories(value: mealCalories);

  // Call the API to get swap meal options
  homeScreenController.getSwapMealOptionsApi();

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

  Get.bottomSheet(
    isScrollControlled: true,
    backgroundColor: AppColors.c111111,
    SafeArea(
      child: Container(
        width: 1.sw,
        height: 0.6.sh,
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
        decoration: BoxDecoration(
          color: AppColors.c111111,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24.r)),
        ),
        child: Column(
          children: [
            /// --- Header ---
            Text(
              "Swap Your Meal with Equal Calories",
              style: TextFontStyle.headline20w500cfefefeStylePoppins,
              textAlign: TextAlign.center,
            ),
            UIHelper.verticalSpace(20.h),

            /// ---- Meal Options List ----
            Expanded(
              child: Obx(() {
                // Loading State
                if (homeScreenController.isSwapMealOptionsLoading.value) {
                  return const SwapMealProgressCard();
                }

                // Error State
                if (homeScreenController
                    .swapMealOptionsErrorMessage
                    .value
                    .isNotEmpty) {
                  return Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          homeScreenController
                              .swapMealOptionsErrorMessage
                              .value,
                          textAlign: TextAlign.center,
                          style: TextFontStyle.headline14w500cFFFFFFStylePoppins
                              .copyWith(color: AppColors.cb20000),
                        ),
                        UIHelper.verticalSpace(16.h),
                        CustomElevatedButton(
                          onTap: () {
                            homeScreenController.getSwapMealOptionsApi();
                          },
                          buttonHeight: 48.h,
                          buttonWidth: 0.8.sw,
                          borderRadius: 24.r,
                          buttonTitle: "retry".tr,
                          buttonColor: AppColors.c262626,
                        ),
                      ],
                    ),
                  );
                }

                // Success State - Display Swap Meal Options
                final alternatives =
                    homeScreenController
                        .swapMealOptionsModel
                        .value
                        ?.data
                        ?.alternatives ??
                    [];

                if (alternatives.isEmpty) {
                  return Center(
                    child: Text(
                      "No Replaceable Meals Found!",
                      style: TextFontStyle.headline14w500cFFFFFFStylePoppins,
                      textAlign: TextAlign.center,
                    ),
                  );
                }

                return ListView.separated(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: alternatives.length,
                  separatorBuilder: (context, index) =>
                      UIHelper.verticalSpace(16.h),
                  itemBuilder: (context, index) {
                    final alternative = alternatives[index];
                    return MealPlanItemCard(
                      isMealEaten: false,
                      leftButtonTitle: "Swap This Meal",
                      leftButtonOnTap: () {
                        LoggerUtils.debug(
                          "Button Tapped: Swap This Meal - ${alternative.mealName}",
                        );
                        Get.back();
                        // Navigate to meal swap onboarding with the selected meal data
                        Get.toNamed(
                          Routes.mealSwapOnboardingScreen,
                          arguments: {
                            'mealId': mealId,
                            'selectedMeal': alternative,
                            'originalMealName': mealName,
                            'originalMealType': mealType,
                          },
                        );
                      },
                      rightButtonTitle: "Details",
                      rightButtonOnTap: () {
                        LoggerUtils.debug(
                          "Button Tapped: Details - ${alternative.mealName}",
                        );
                        // Convert Alternative to MealDataModel
                        final mealDataModel = MealDataModel(
                          mealName: alternative.mealName ?? 'Unknown Meal',
                          mealType: alternative.category ?? mealType,
                          totalCalories: alternative.totalCalories ?? 0,
                          description: alternative.description ?? '',
                          ingredients: (alternative.ingredients ?? []).map((ing) => MealIngredientData(
                            name: ing.name ?? '',
                            quantity: ing.quantity ?? '',
                            icon: ing.icon ?? '',
                          )).toList(),
                          macronutrients: MealMacronutrientsData(
                            carbohydrates: (alternative.macronutrients?.carbohydrates ?? 0).toDouble(),
                            protein: (alternative.macronutrients?.protein ?? 0).toDouble(),
                            fat: (alternative.macronutrients?.fat ?? 0).toDouble(),
                          ),
                          numberOfServings: alternative.numberOfServings ?? 1,
                          image: alternative.image ?? '',
                          category: alternative.category,
                          subCategory: alternative.subCategory,
                          mealId: null,
                        );
                        // Navigate to meal details with the converted meal data
                        Get.toNamed(
                          Routes.mealDetailscreen,
                          arguments: {
                            'mealData': mealDataModel,
                            'hideSelectButton': true,
                          },
                        );
                      },
                      showSectionTitle: false,
                      mealType:
                          alternative.category?.capitalizeFirst ?? mealType,
                      mealTitle: alternative.mealName ?? 'Unknown Meal',
                      kcalValue: alternative.totalCalories ?? 0,
                      mealImagePath: _resolveImagePath(alternative.image),
                      isImageLinkBase64: _isBase64Image(alternative.image),
                    );
                  },
                );
              }),
            ),
            UIHelper.verticalSpace(20.h),

            /// --- Sticky Close Button ---
            CustomElevatedButton(
              onTap: () {
                LoggerUtils.debug("Button Tapped: Close/Cancel");
                Get.back();
              },
              buttonHeight: 52.h,
              buttonWidth: 1.sw,
              borderRadius: 24.r,
              buttonTitle: "Cancel",
              buttonColor: AppColors.c262626,
            ),
          ],
        ),
      ),
    ),
  );
}
