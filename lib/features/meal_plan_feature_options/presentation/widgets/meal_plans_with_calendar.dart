import 'dart:developer';

import 'package:bloodfit/constants/app_list.dart';
import 'package:bloodfit/constants/text_font_style.dart';
import 'package:bloodfit/controllers/enums_controller.dart';
import 'package:bloodfit/custom_widgets/meal_plan_item_card.dart';
import 'package:bloodfit/features/meal_plan_feature_options/presentation/widgets/swap_meal_bottom_sheet.dart';
import 'package:bloodfit/gen/assets.gen.dart';
import 'package:bloodfit/helper/ui_helpers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../../custom_widgets/meal_plan_calendar_widget.dart';
import '../../../../routes/routes.dart';
import '../../../home/presentation/widgets/build_meal_plan_icon_widget.dart';

class MealPlansWithCalendar extends StatelessWidget {
  MealPlansWithCalendar({super.key});

  final EnumsController enumsController = Get.find<EnumsController>();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        /// Meal Plan Calendar
        MealPlanCalendarWidget(),

        ///Section : ----------///Text -> today’s three meals///-------------
        Text(
          "Today’s Three Meals",
          style: TextFontStyle.headline20w500cfefefeStylePoppins,
        ),
        UIHelper.verticalSpace(8.h),

        ///Section : ------------///Selected Meals///-----------
        ListView.separated(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: AppList.reviewMealList.length,
          separatorBuilder: (context, index) => UIHelper.verticalSpace(24.h),
          itemBuilder: (context, index) {
            var data = AppList.reviewMealList[index];
            return MealPlanItemCard(
              isMealEaten: false,
              leftButtonTitle: data.leftButtonTitle,
              leftButtonOnTap: () {
                log("Button Taped : I Ate This");
              },
              rightButtonTitle: data.rightButtonTitle,
              rightButtonOnTap: () {
                log("Button Taped : Swap Meal");
                showSwapMealBottomSheet(
                  mealType: data.mealType ?? 'breakfast',
                  mealName: data.mealTitle ?? '',
                  mealId: null,
                  mealCalories: data.kcalValue.toInt(),
                  category: data.mealType ?? 'breakfast',
                  subCategory: data.mealType ?? 'breakfast',
                );
              },
              mealType: data.mealType,
              mealTitle: data.mealTitle,
              kcalValue: data.kcalValue.toInt(),
              mealImagePath: data.imagePath,
            );
          },
        ),
        UIHelper.verticalSpace(32.h),

        ///Section : ------------///Build Your Next Week Meal Plan///----------
        ///This section will only be available when,
        ///-> User has created his current week meal plan
        ///-> Generally this section will be available at the bottom of the three meal items card
        ///-> When The User weekly time line is nearly finished (2 day's remaining) then,
        ///-> This section will show at the top of the three meal items card
        BuildMealPlanWidget(
          onTap: () {
            log("Button Taped : Get Started !");
            log(
              "Is Meal Plan Available : ${enumsController.isMealPlanAvailable}",
            );
            Get.toNamed(Routes.chooseFromOurSuggestedMealsScreen);
          },
          showSectionTitle: true,
          sectionTitle: "Choose From Our Suggested Meals",
          buttonTitle: "Get Started",
          positionTop: -37.h,
          positionRight: -20.w,
          imageIconPath: Assets.icons.chickeMealIcon,
          title: "Build Your Daily Meals",
          subTitle:
              "Select Your Breakfast, Lunch, And Dinner From Personalized Meal Suggestions",
        ),
        UIHelper.verticalSpace(120.h),
      ],
    );
  }
}
