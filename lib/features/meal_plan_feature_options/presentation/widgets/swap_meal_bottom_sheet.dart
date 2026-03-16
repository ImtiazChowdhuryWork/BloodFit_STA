import 'package:bloodfit/constants/text_font_style.dart';
import 'package:bloodfit/custom_widgets/custom_elevated_button.dart';
import 'package:bloodfit/custom_widgets/custom_shimmer_effect.dart';
import 'package:bloodfit/custom_widgets/meal_plan_item_card.dart';
import 'package:bloodfit/features/home/data/controller/home_screen_controller.dart';
import 'package:bloodfit/features/meal_plan_feature_options/presentation/widgets/swap_meal_options_loader.dart';
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
                  return SwapMealOptionsLoader();
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
                        Get.toNamed(
                          Routes.mealDetailscreen,
                          arguments: {
                            'mealID': alternative.mealName,
                            'hideSelectButton': true,
                          },
                        );
                      },
                      showSectionTitle: false,
                      mealType:
                          alternative.category?.capitalizeFirst ?? mealType,
                      mealTitle: alternative.mealName ?? 'Unknown Meal',
                      kcalValue: alternative.totalCalories ?? 0,
                      mealImagePath:
                          '', // You can add image handling if available in the model
                      isImageLinkBase64: false,
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
