import 'dart:developer';
import 'package:bloodfit/constants/text_font_style.dart';
import 'package:bloodfit/custom_widgets/custom_elevated_button.dart';
import 'package:bloodfit/features/meal_plan_feature_options/presentation/widgets/meal_plan_item_card.dart';
import 'package:bloodfit/gen/colors.gen.dart';
import 'package:bloodfit/routes/routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../../gen/assets.gen.dart';
import '../../../../helper/ui_helpers.dart';

void showSwapMealBottomSheet() {
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
            /// ---- Scrollable Content (Header + Meal List)
            Expanded(
              child: ListView(
                padding: EdgeInsets.zero,
                children: [
                  /// --- Header ---
                  Text(
                    "Swap Your Meal with Equal Calories",
                    style: TextFontStyle.headline20w500cfefefeStylePoppins,
                    textAlign: TextAlign.center,
                  ),
                  UIHelper.verticalSpace(20.h),

                  /// --- Meal List ---
                  ListView.separated(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: 10,
                    separatorBuilder: (_, __) => UIHelper.verticalSpace(16.h),
                    itemBuilder: (context, index) {
                      return MealPlanItemCard(
                        redButtonTitle: "Swap This Meal",
                        redButtonOnTap: () {
                          log("Button Tapped : I Ate This");
                          Get.toNamed(Routes.mealSwapOnboardingScreen);
                        },
                        transparentButtonTitle: "Details",
                        transperentButtonOnTap: () {
                          log("Button Tapped : Swap Meal");
                        },
                        showSectionTitle: false,
                        mealType: "Lunch",
                        mealTitle: "Avocado Toast & Poached Eggs",
                        kcalValue: 302,
                        mealImagePath: Assets.images.foodImage.path,
                      );
                    },
                  ),
                  UIHelper.verticalSpace(20.h),
                ],
              ),
            ),

            /// --- Sticky Confirm Button ---
            CustomElevatedButton(
              onTap: () {
                log("Button Tapped : Confirm");
              },
              buttonHeight: 52.h,
              buttonWidth: 1.sw,
              borderRadius: 24.r,
              buttonTitle: "confirm",
              buttonColor: AppColors.c262626,
            ),
          ],
        ),
      ),
    ),
  );
}
