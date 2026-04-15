import 'dart:developer';
import 'package:bloodfit/constants/text_font_style.dart';
import 'package:bloodfit/controllers/enums_controller.dart';
import 'package:bloodfit/custom_widgets/current_weight_update_widget.dart';
import 'package:bloodfit/features/choose_from_our_suggested_meals/data/controller/choose_from_our_suggested_meal_controller.dart';
import 'package:bloodfit/features/home/data/controller/home_screen_controller.dart';
import 'package:bloodfit/features/home/presentation/widgets/app_bar_section_widget.dart';
import 'package:bloodfit/features/home/presentation/widgets/build_meal_plan_icon_widget.dart';
import 'package:bloodfit/features/home/presentation/widgets/consistancy_stake_preview.dart';
import 'package:bloodfit/features/home/presentation/widgets/received_three_meal_plan_widget.dart';
import 'package:bloodfit/features/home/presentation/widgets/select_your_days_for_meal_plan_widget.dart';
import 'package:bloodfit/features/home/presentation/widgets/show_selected_meals_or_build_meal_plan_widget.dart';
import 'package:bloodfit/features/home/presentation/widgets/single_element_showing_widget.dart';
import 'package:bloodfit/features/home/presentation/widgets/total_k_cal_widget.dart';
import 'package:bloodfit/gen/assets.gen.dart';
import 'package:bloodfit/gen/colors.gen.dart';
import 'package:bloodfit/helper/logger_util.dart';
import 'package:bloodfit/helper/ui_helpers.dart';
import 'package:bloodfit/routes/routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import 'widgets/custom_calender_widget.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final EnumsController enumsController = Get.find<EnumsController>();

  @override
  void initState() {
    super.initState();
    // Preload AI meals data in background when home screen loads
    WidgetsBinding.instance.addPostFrameCallback((_) {
      LoggerUtils.debug(
        "╔═══════════════════════════════════════════════════════════",
      );
      LoggerUtils.debug("🏠 [HOME] initState() - HomeScreen loaded");
      LoggerUtils.debug("🏠 [HOME] Preloading AI meals data...");
      LoggerUtils.debug(
        "╚═══════════════════════════════════════════════════════════",
      );

      // Check if controller exists before calling
      if (Get.isRegistered<ChooseFromOurSuggestedMealController>()) {
        LoggerUtils.debug(
          "✅ [HOME] ChooseFromOurSuggestedMealController is registered",
        );
        final mealController = Get.find<ChooseFromOurSuggestedMealController>();
        LoggerUtils.debug("🏠 [HOME] Calling initializeAiMeals()...");
        mealController.initializeAiMeals();
        LoggerUtils.debug("🏠 [HOME] initializeAiMeals() called successfully");
      } else {
        LoggerUtils.debug(
          "⚠️ [HOME] ChooseFromOurSuggestedMealController NOT registered yet, skipping preload",
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    HomeScreenController controller = Get.find<HomeScreenController>();
    // WidgetsBinding.instance.addPostFrameCallback((_) {
    //   controller.getDailyCaloriesApi();
    //   controller.getTodaysSelectedMealsApi();
    // });
    return Scaffold(
      backgroundColor: AppColors.scaffoldBackgroundColor,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// Section : ---------------------///AppLogo///-----------
            ///Section : ---------------------///Notification///-----------
            ///Section : ---------------------///Profile///-----------
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: UIHelper.kDefaulutPadding(),
              ),
              child: AppBarSectionWidget(),
            ),
            UIHelper.verticalSpace(20.h),

            ///Section : -------///Stake Section///----------
            ///This section check the consistancy of the user. If the consistancy is broken
            ///then the stack will return to it's original value. Which -> "0"
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: UIHelper.kDefaulutPadding(),
              ),
              child: ConsistancyStakePreviewWidget(numberValue: 4),
            ),
            UIHelper.verticalSpace(14.h),

            ///Section : -----------///Calender Widget with progress, cheat day,...///--------------
            CustomCalenderWidget(),
            UIHelper.verticalSpace(24.h),

            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: UIHelper.kDefaulutPadding(),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ///Section : --------///Text -> your daily calories///----------
                  Text(
                    'your_daily_calories'.tr,
                    style: TextFontStyle.headline20w500cfefefeStylePoppins,
                  ),
                  UIHelper.verticalSpace(12.h),

                  ///Sectiopn : --------///Calorie Progressbar///------------
                  Container(
                    width: 1.sw,
                    padding: EdgeInsets.all(10.sp),
                    decoration: BoxDecoration(
                      color: AppColors.c262626,
                      borderRadius: BorderRadius.circular(16.r),
                    ),
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        // mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          ///Section : ------------///Total Calories///---------------
                          Obx(() {
                            return TotalKCalWidget(
                              isSuccess: controller.isSuccess.value,
                              onTap:
                                  controller.isSuccess.value ||
                                      controller.isDailyCaloriesLoading.value
                                  ? null
                                  : () {
                                      LoggerUtils.debug(
                                        "Home Calories Datra Reload Taped!",
                                      );
                                      controller.getDailyCaloriesApi();
                                    },
                              size: 120.w,
                              progress: controller.completationPercentage / 100.0,
                              strokeWidth: 8,
                              capColor: AppColors.cFFFFFF,
                              capSizeMultiplier: 0.3,
                              capPadding: 0,
                              capRadialOffset: 0,
                              progressColor: AppColors.cb20000,
                              progressBoldColor: AppColors.c7e0101,
                              isLoading:
                                  controller.isDailyCaloriesLoading.value,
                              totalCalories:
                                  controller.isDailyCaloriesLoading.value
                                  ? 'loading'.tr
                                  : controller.totalCalories,
                            );
                          }),
                          UIHelper.horizontalSpace(16.w),

                          ///Section : ------------///Total Carbs///---------------
                          Row(
                            children: [
                              ///Section : ------------///Total Carbs///---------------
                              Obx(() {
                                return SingleElementShowingWidget(
                                  elementIconPath: Assets.icons.glutenIcon,
                                  elementTitle: 'carbs'.tr,
                                  isLoading:
                                      controller.isDailyCaloriesLoading.value,
                                  elementAmount: controller.consumedCarbs
                                      .toDouble(),
                                );
                              }),
                              UIHelper.horizontalSpace(8.w),

                              ///Section : ------------///Total protein///---------------
                              Obx(() {
                                return SingleElementShowingWidget(
                                  elementIconPath: Assets.icons.meatIcon,
                                  elementTitle: 'protein'.tr,
                                  isLoading:
                                      controller.isDailyCaloriesLoading.value,
                                  elementAmount: controller.consumedProtein
                                      .toDouble(),
                                );
                              }),
                              UIHelper.horizontalSpace(8.w),

                              ///Section : ------------///Total Carbs///---------------
                              Obx(() {
                                return SingleElementShowingWidget(
                                  elementIconPath: Assets.icons.fatIcon,
                                  elementTitle: 'fat'.tr,
                                  isLoading:
                                      controller.isDailyCaloriesLoading.value,
                                  elementAmount: controller.consumedFat
                                      .toDouble(),
                                );
                              }),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  UIHelper.verticalSpace(24.h),

                  ///Section : --------------///Selectable Days for Meal Plan,///--------------------
                  /// Not Available only for Free Subscription Type of User///----------
                  SelectYourDaysForMealPlanWidget(),
                  UIHelper.verticalSpace(32.h),

                  ///Section : ----------------///Text -> update your current weight///------------
                  ///Section : --------------///Weight Drop Down///----------
                  CurrentWeightUpdateWidget(),
                  UIHelper.verticalSpace(24.h),

                  ///Section : -------------///received 3 meal plan///--------------
                  Obx(() {
                    if (controller.todaysSelectedMealsList.isNotEmpty) {
                      return Column(
                        children: [
                          ReceivedThreeMealPlansWidget(),
                          UIHelper.verticalSpace(24.h),
                        ],
                      );
                    }
                    return const SizedBox.shrink();
                  }),

                  ///Section : -------------///Build Your Meal Plan////------------
                  ///Section : -------------///Show Selected Meals////------------
                  ShowSelectedMealsOrBuildMealPlanWidget(),
                  UIHelper.verticalSpace(24.h),

                  ///Section : -------------///Build Your Meal Plan////------------
                  BuildMealPlanWidget(
                    onTap: () {
                      log("Button Taped : Subscribe Now !");
                      Get.toNamed(Routes.subscriptionScreen);
                    },
                    buttonTitle: 'subscribe_now'.tr,
                    isBorderUsed: true,
                    borderWidth: 2.sp,
                    borderColor: AppColors.cb20000,
                    buttonColor: AppColors.c000000,
                    positionTop: -20.h,
                    positionRight: -20.w,
                    imageIconPath: Assets.icons.workoutDumbleIcon,
                    title: 'unlock_personalized_workouts'.tr,
                    subTitle: 'subscribe_description'.tr,
                  ),

                  UIHelper.verticalSpace(144.h),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
