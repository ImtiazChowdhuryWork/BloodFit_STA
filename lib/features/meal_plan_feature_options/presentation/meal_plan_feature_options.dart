import 'package:bloodfit/custom_widgets/custom_elevated_button.dart';
import 'package:bloodfit/features/meal_plan_feature_options/presentation/data/controller/meal_plan_feature_options_controller.dart';
import 'package:bloodfit/features/meal_plan_feature_options/presentation/widgets/swap_meal_bottom_sheet.dart';
import 'package:bloodfit/gen/assets.gen.dart';
import 'package:bloodfit/gen/colors.gen.dart';
import 'package:bloodfit/helper/ui_helpers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../../custom_widgets/meal_plan_calendar_widget.dart';
import '../../../custom_widgets/meal_plan_item_card.dart';
import '../../../endpoints.dart';
import '../../../helper/logger_util.dart';
import '../../../routes/routes.dart';
import '../../home/presentation/widgets/app_bar_section_widget.dart';
import '../../home/presentation/widgets/build_meal_plan_icon_widget.dart';
import '../../home/presentation/widgets/meal_showing_widget_shimmer_effect.dart';
import '../../home/presentation/widgets/show_selected_meals_or_build_meal_plan_widget.dart';

class MealPlanFeatureOptions extends StatefulWidget {
  MealPlanFeatureOptions({super.key});

  @override
  State<MealPlanFeatureOptions> createState() => _MealPlanFeatureOptionsState();
}

class _MealPlanFeatureOptionsState extends State<MealPlanFeatureOptions> {
  final MealPlanFeatureOptionsController mealPlanFeatureOptionsController =
      Get.find<MealPlanFeatureOptionsController>();

  @override
  void initState() {
    super.initState();
    // Set default date (today) and fetch meals on load
    final today = DateFormat('yyyy/MM/dd').format(DateTime.now());
    mealPlanFeatureOptionsController.setSelectedDate(date: today);
    mealPlanFeatureOptionsController.postGetMealsBySelectedDate();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldBackgroundColor,

      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(UIHelper.kDefaulutPadding()),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ///Section : ---------------------///AppLogo///-----------
              ///Section : ---------------------///Notification///-----------
              ///Section : ---------------------///Profile///-----------
              AppBarSectionWidget(),
              UIHelper.verticalSpace(20.h),

              ///Section : -------------<>>>>> Meal Calender
              MealPlanCalendarWidget(
                onTap: (formattedDate) {
                  // When date is selected, fetch meals for that date
                  mealPlanFeatureOptionsController.setSelectedDate(date: formattedDate);
                  mealPlanFeatureOptionsController.postGetMealsBySelectedDate();
                },
              ),
              UIHelper.verticalSpace(20.h),

              ///Section : -------------<>>>>>> Selected Date Meals List
              Obx(() {
                // Loading State
                if (mealPlanFeatureOptionsController.isLoading.value) {
                  return Column(
                    children: List.generate(
                      3,
                      (index) => Column(
                        children: [
                          MealShowingWidgetShimmerEffect(),
                          UIHelper.verticalSpace(20.h),
                        ],
                      ),
                    ),
                  );
                }

                // Error State
                if (mealPlanFeatureOptionsController.selectedDateDataError.value.isNotEmpty) {
                  return MealShowingWidgetShimmerEffect(
                    child: CustomElevatedButton(
                      buttonTitle: "Retry",
                      onTap: () {
                        mealPlanFeatureOptionsController.postGetMealsBySelectedDate();
                      },
                    ),
                  );
                }

                // No Data State
                if (mealPlanFeatureOptionsController.mealsByDateList.isEmpty) {
                  return BuildMealPlanWidget(
                    onTap: () {
                      LoggerUtils.debug("Button Tapped : Get Started !");
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
                }

                // Success State - Show meals from API response
                return Column(
                  children: mealPlanFeatureOptionsController.mealsByDateList.map((meal) {
                    return Column(
                      children: [
                        MealPlanItemCard(
                          onTap: () {
                            Get.toNamed(
                              Routes.mealDetailscreen,
                              arguments: {'mealID': meal.id},
                            );
                          },
                          isMealEaten: meal.status == 'done',
                          leftButtonTitle: "I Ate This",
                          leftButtonOnTap: () {
                            LoggerUtils.debug(
                              "Button Tapped: I Ate This, Meal Type: ${meal.mealType}, Meal Name: ${meal.mealName}",
                            );
                          },
                          rightButtonTitle: "Swap Meal",
                          rightButtonOnTap: () {
                            LoggerUtils.debug(
                              "Button Tapped: Swap Meal, Meal Type: ${meal.mealType}, Meal Name: ${meal.mealName}",
                            );
                            showSwapMealBottomSheet();
                          },
                          mealType: meal.mealType?.capitalizeFirst ??
                              "Failed to Get Meal Type..",
                          mealTitle: meal.mealName ?? '',
                          kcalValue: meal.kcal ?? 0,
                          mealImagePath: "$imageBaseUrl${meal.image}",
                        ),
                        UIHelper.verticalSpace(20.h),
                      ],
                    );
                  }).toList(),
                );
              }),

              // ShowSelectedMealsOrBuildMealPlanWidget(),
              UIHelper.verticalSpace(24.h),
            ],
          ),
        ),
      ),
    );
  }
}
