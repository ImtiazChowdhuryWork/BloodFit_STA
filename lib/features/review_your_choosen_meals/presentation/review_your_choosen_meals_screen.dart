import 'dart:developer';

import 'package:bloodfit/gen/colors.gen.dart';
import 'package:bloodfit/helper/ui_helpers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

import '../../../constants/text_font_style.dart';
import '../../../custom_widgets/custom_elevated_button.dart';
import '../../../custom_widgets/go_back_widget.dart';
import '../../../gen/assets.gen.dart';
import '../../../routes/routes.dart';
import '../../meal_plan_feature_options/presentation/widgets/meal_plan_item_card.dart';
import '../../meal_plan_feature_options/presentation/widgets/show_meal_plan_build_confirmation_bottom_sheet.dart';
import '../../meal_plan_feature_options/presentation/widgets/swap_meal_bottom_sheet.dart';

class ReviewYourChoosenMealsScreen extends StatelessWidget {
  const ReviewYourChoosenMealsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: AppColors.scaffoldBackgroundColor,
        automaticallyImplyLeading: false,
        leading: CustomBackButton(),
        centerTitle: true,
        title: Text(
          "Meal Plan",
          style: TextFontStyle.headline24w700cFFFFFFStylePoppins,
        ),
        actions: [
          InkWell(
            onTap: () {
              Get.toNamed(Routes.notificationScreen);
            },
            child: SvgPicture.asset(Assets.icons.bellIcon),
          ),
          UIHelper.horizontalSpace(15.w),
          InkWell(
            onTap: () {
              Get.toNamed(Routes.myProfileScreen);
            },
            child: Container(
              width: 48.w,
              height: 48.h,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: AppColors.cFFFFFF),
                image: DecorationImage(
                  fit: BoxFit.cover,
                  image: AssetImage(Assets.images.userImage.path),
                ),
              ),
            ),
          ),
          UIHelper.horizontalSpace(UIHelper.kDefaulutPadding()),
        ],
      ),
      body: SafeArea(
        child: SafeArea(
          child: SingleChildScrollView(
            padding: EdgeInsets.all(UIHelper.kDefaulutPadding()),
            child: Column(
              children: [
                Text(
                  "Review Your Chosen Meals",
                  style: TextFontStyle.headline20w500cfefefeStylePoppins,
                ),
                UIHelper.verticalSpace(24.h),

                ///Section : ---------------///Breakfast///--------------
                MealPlanItemCard(
                  redButtonTitle: "I Ate This",
                  redButtonOnTap: () {
                    log("Button Taped : I Ate This");
                  },
                  transparentButtonTitle: "Swap Meal",
                  transperentButtonOnTap: () {
                    log("Button Taped : Swap Meal");
                    showSwapMealBottomSheet();
                  },
                  mealType: "Breakfast",
                  mealTitle: "Avocado Toast & Poached Eggs",
                  kcalValue: 302,
                  mealImagePath: Assets.images.foodImage.path,
                ),
                UIHelper.verticalSpace(24.h),

                ///Section : ---------------///Lunch///--------------
                MealPlanItemCard(
                  redButtonTitle: "I Ate This",
                  redButtonOnTap: () {
                    log("Button Taped : I Ate This");
                  },
                  transparentButtonTitle: "Swap Meal",
                  transperentButtonOnTap: () {
                    log("Button Taped : Swap Meal");
                    showSwapMealBottomSheet();
                  },
                  mealType: "Lunch",
                  mealTitle: "Avocado Toast & Poached Eggs",
                  kcalValue: 302,
                  mealImagePath: Assets.images.foodImage.path,
                ),
                UIHelper.verticalSpace(24.h),

                ///Section : ---------------///Dinner///--------------
                MealPlanItemCard(
                  redButtonTitle: "I Ate This",
                  redButtonOnTap: () {
                    log("Button Taped : I Ate This");
                  },
                  transparentButtonTitle: "Swap Meal",
                  transperentButtonOnTap: () {
                    log("Button Taped : Swap Meal");
                    showSwapMealBottomSheet();
                  },
                  mealType: "Dinner",
                  mealTitle: "Avocado Toast & Poached Eggs",
                  kcalValue: 302,
                  mealImagePath: Assets.images.foodImage.path,
                ),
                UIHelper.verticalSpace(32.h),

                ///Section : -----------///Button -> Confirm Meal Plan///------------
                CustomElevatedButton(
                  onTap: () {
                    log("Button Taped -> Confirm Mealplan");

                    showMealPlanBuildConfirmationBottomSheet();
                  },
                  buttonWidth: 1.sw,
                  buttonHeight: 52.h,
                  borderRadius: 24.r,
                  buttonTitle: "Confirm Mealplan",
                ),
                UIHelper.verticalSpace(32.h),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
