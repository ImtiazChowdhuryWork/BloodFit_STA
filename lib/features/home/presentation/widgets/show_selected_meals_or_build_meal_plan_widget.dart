import 'dart:developer';

import 'package:bloodfit/controllers/home_screen_controller.dart';
import 'package:bloodfit/features/home/presentation/widgets/build_meal_plan_icon_widget.dart';
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
      return enumsController.isMealPlanAvailable
          ? ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: AppList.reviewMealList.length,
              separatorBuilder: (context, index) =>
                  UIHelper.verticalSpace(24.h),
              itemBuilder: (context, index) {
                var data = AppList.reviewMealList[index];
                return MealPlanItemCard(
                  leftButtonTitle: data.leftButtonTitle,
                  leftButtonOnTap: () {
                    log("Button Taped : I Ate This");
                  },
                  rightButtonTitle: data.rightButtonTitle,
                  rightButtonOnTap: () {
                    log("Button Taped : Swap Meal");
                    showSwapMealBottomSheet();
                  },
                  mealType: data.mealType,
                  mealTitle: data.mealTitle,
                  kcalValue: data.kcalValue,
                  mealImagePath: data.imagePath,
                );
              },
            )
          : BuildMealPlanWidget(
              onTap: () {
                log("Button Taped : Get Started !");
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
