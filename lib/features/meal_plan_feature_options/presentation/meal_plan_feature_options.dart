/**
import 'package:bloodfit/constants/text_font_style.dart';
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

  /// Helper method to resolve image URL (handles base64, relative paths, and full URLs)
  String _resolveImageUrl(String? image) {
    if (image == null || image.isEmpty) {
      return '$imageBaseUrl/images/cucumber.jpeg';
    }

    // If it's already a full URL (starts with http), return as is
    if (image.startsWith('http://') || image.startsWith('https://')) {
      return image;
    }

    // If it's base64 data (starts with "data:image" or looks like base64), return default
    // Base64 typically starts with iVBORw0KGgo... for PNG or /9j/... for JPEG
    if (image.startsWith('data:image') ||
        image.startsWith('iVBORw0KGgo') ||
        image.startsWith('/9j/')) {
      return '$imageBaseUrl/images/cucumber.jpeg';
    }

    // If it's a relative path (starts with /), concatenate with base URL
    if (image.startsWith('/')) {
      return '$imageBaseUrl$image';
    }

    // Otherwise, assume it's already a path and concatenate
    return '$imageBaseUrl/$image';
  }

  @override
  void initState() {
    super.initState();
    // Set default date (today) and fetch meals on load
    // Wrapped in addPostFrameCallback to avoid updating reactive state during build
    final today = DateFormat('yyyy/MM/dd').format(DateTime.now());
    WidgetsBinding.instance.addPostFrameCallback((_) {
      mealPlanFeatureOptionsController.setSelectedDate(date: today);
      mealPlanFeatureOptionsController.postGetMealsBySelectedDate();
    });
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
                  mealPlanFeatureOptionsController.setSelectedDate(
                    date: formattedDate,
                  );
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
                if (mealPlanFeatureOptionsController
                    .selectedDateDataError
                    .value
                    .isNotEmpty) {
                  return MealShowingWidgetShimmerEffect(
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text('Failed Get Meal Plans!',style: TextFontStyle.headline14w500cFFFFFFStylePoppins,),
                          UIHelper.verticalSpace(8.h),
                          CustomElevatedButton(
                            buttonWidth: 120.w,
                            buttonHeight: 40.h,
                            buttonTitle: "Retry",
                            isLoading: mealPlanFeatureOptionsController.isLoading.value,
                            onTap: () {
                              mealPlanFeatureOptionsController
                                  .postGetMealsBySelectedDate();
                            },
                          ),
                        ],
                      ),
                    ),
                  );
                }

                // No Data State
                if (mealPlanFeatureOptionsController.mealsByDateList.isEmpty) {
                  // Check if the selected date is a past date
                  final selectedDate = DateFormat('yyyy/MM/dd').parse(
                    mealPlanFeatureOptionsController.selectedDate.value,
                  );
                  final today = DateTime.now();
                  final isPastDate = DateTime(
                    selectedDate.year,
                    selectedDate.month,
                    selectedDate.day,
                  ).isBefore(DateTime(today.year, today.month, today.day));

                  return BuildMealPlanWidget(
                    onTap: () {
                      LoggerUtils.debug("Button Tapped : Get Started !");
                      final selectedDate = DateFormat('yyyy/MM/dd').parse(
                    mealPlanFeatureOptionsController.selectedDate.value,
                  );
                      Get.toNamed(Routes.chooseFromOurSuggestedMealsScreen, arguments: {'selectedDate' : selectedDate.toString()});
                    },
                    showSectionTitle: true,
                    sectionTitle: "Choose From Our Suggested Meals",
                    buttonTitle: "Get Started",
                    positionTop: -36.h,
                    positionRight: -20.w,
                    imageIconPath: Assets.icons.chickeMealIcon,
                    title: "Build Your Daily Meals",
                    subTitle: isPastDate
                        ? "Meal Plan was not build for selected date!"
                        : "Select Your Breakfast, Lunch, And Dinner From Personalized Meal Suggestions",
                    isShowButton: !isPastDate,
                  );
                }

                // Success State - Show meals from API response
                final selectedDatecs1 = DateFormat('yyyy/MM/dd').parse(
                  mealPlanFeatureOptionsController.selectedDate.value,
                );
                final todayCs1 = DateTime.now();
                final isPastDateCs1 = DateTime(
                  selectedDatecs1.year,
                  selectedDatecs1.month,
                  selectedDatecs1.day,
                ).isBefore(DateTime(todayCs1.year, todayCs1.month, todayCs1.day));

                return Column(
                  children: mealPlanFeatureOptionsController.mealsByDateList.map((
                    meal,
                  ) {
                    return Column(
                      children: [
                        MealPlanItemCard(
                          onTap: () {
                            Get.toNamed(
                              Routes.mealDetailscreen,
                              arguments: {
                                'mealID': meal.id,
                                'hideGenerateImageButton': isPastDateCs1,
                              },
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
                          mealType:
                              meal.mealType?.capitalizeFirst ??
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
*/





///
///
///
/// todo:: adding korean
///
///
///




import 'package:bloodfit/constants/text_font_style.dart';
import 'package:bloodfit/custom_widgets/custom_elevated_button.dart';
import 'package:bloodfit/features/choose_from_our_suggested_meals/data/controller/choose_from_our_suggested_meal_controller.dart';
import 'package:bloodfit/features/home/data/controller/home_screen_controller.dart';
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

class MealPlanFeatureOptions extends StatefulWidget {
  MealPlanFeatureOptions({super.key});

  @override
  State<MealPlanFeatureOptions> createState() => _MealPlanFeatureOptionsState();
}

class _MealPlanFeatureOptionsState extends State<MealPlanFeatureOptions> {
  final MealPlanFeatureOptionsController mealPlanFeatureOptionsController =
  Get.find<MealPlanFeatureOptionsController>();
  final HomeScreenController homeScreenController =
  Get.find<HomeScreenController>();

  /// Helper method to convert image to URL (handles base64, relative paths, etc.)
  String _convertImageToUrl(String imageData) {
    if (imageData.isEmpty) {
      return defaultMealImage;
    }

    // If it's already a URL (starts with http), return as is
    if (imageData.startsWith('http://') || imageData.startsWith('https://')) {
      return imageData;
    }

    // If it's base64 data (starts with "data:image" or looks like base64), return AS-IS
    // Base64 typically starts with iVBORw0KGgo... for PNG or /9j/... for JPEG
    // We need to pass base64 directly to MealDataModel for the details screen to handle
    if (imageData.startsWith('data:image') ||
        imageData.startsWith('iVBORw0KGgo') ||
        imageData.startsWith('/9j/')) {
      return imageData; // Return base64 as-is, don't convert to default image
    }

    // If it's a relative path (starts with /), concatenate with base URL
    if (imageData.startsWith('/')) {
      return 'https://faisal5000.merinasib.shop$imageData';
    }

    // Otherwise, assume it's already a path and concatenate
    return 'https://faisal5000.merinasib.shop/$imageData';
  }

  @override
  void initState() {
    super.initState();
    // Set default date (today) and fetch meals on load
    // Wrapped in addPostFrameCallback to avoid updating reactive state during build
    final today = DateFormat('yyyy/MM/dd').format(DateTime.now());
    WidgetsBinding.instance.addPostFrameCallback((_) {
      mealPlanFeatureOptionsController.setSelectedDate(date: today);
      mealPlanFeatureOptionsController.postGetMealsBySelectedDate();
    });
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
                  mealPlanFeatureOptionsController.setSelectedDate(
                    date: formattedDate,
                  );
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
                if (mealPlanFeatureOptionsController
                    .selectedDateDataError
                    .value
                    .isNotEmpty) {
                  return MealShowingWidgetShimmerEffect(
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text('failed_get_meal_plans'.tr, style: TextFontStyle.headline14w500cFFFFFFStylePoppins,),
                          UIHelper.verticalSpace(8.h),
                          CustomElevatedButton(
                            buttonWidth: 120.w,
                            buttonHeight: 40.h,
                            buttonTitle: 'retry'.tr,
                            isLoading: mealPlanFeatureOptionsController.isLoading.value,
                            onTap: () {
                              mealPlanFeatureOptionsController
                                  .postGetMealsBySelectedDate();
                            },
                          ),
                        ],
                      ),
                    ),
                  );
                }

                // No Data State
                if (mealPlanFeatureOptionsController.mealsByDateList.isEmpty) {
                  // Check if the selected date is a past date
                  final selectedDate = DateFormat('yyyy/MM/dd').parse(
                    mealPlanFeatureOptionsController.selectedDate.value,
                  );
                  final today = DateTime.now();
                  final isPastDate = DateTime(
                    selectedDate.year,
                    selectedDate.month,
                    selectedDate.day,
                  ).isBefore(DateTime(today.year, today.month, today.day));

                  return BuildMealPlanWidget(
                    onTap: () {
                      LoggerUtils.debug("Button Tapped : Get Started !");
                      final selectedDate = DateFormat('yyyy/MM/dd').parse(
                        mealPlanFeatureOptionsController.selectedDate.value,
                      );
                      final String formattedDate = DateFormat('yyyy-MM-dd').format(selectedDate);
                      // Clear previous selections so the new date starts fresh
                      // (only if already registered — first-time navigation initialises fresh via binding)
                      if (Get.isRegistered<ChooseFromOurSuggestedMealController>()) {
                        Get.find<ChooseFromOurSuggestedMealController>().clearAllSelections();
                      }
                      Get.toNamed(Routes.chooseFromOurSuggestedMealsScreen, arguments: {'mealGenerationDate' : formattedDate});
                    },
                    showSectionTitle: true,
                    sectionTitle: 'choose_from_suggested_meals'.tr,
                    buttonTitle: 'get_started'.tr,
                    positionTop: -36.h,
                    positionRight: -20.w,
                    imageIconPath: Assets.icons.chickeMealIcon,
                    title: 'build_your_daily_meals'.tr,
                    subTitle: isPastDate
                        ? 'meal_plan_not_built'.tr
                        : 'select_meals_description'.tr,
                    isShowButton: !isPastDate,
                  );
                }

                // Success State - Show meals from API response
                // Check if selected date is a past date to disable buttons
                final selectedDate = DateFormat('yyyy/MM/dd').parse(
                  mealPlanFeatureOptionsController.selectedDate.value,
                );
                final today = DateTime.now();
                final selectedDateOnly = DateTime(
                  selectedDate.year,
                  selectedDate.month,
                  selectedDate.day,
                );
                final todayOnly = DateTime(today.year, today.month, today.day);
                final isPastDate = selectedDateOnly.isBefore(todayOnly);
                final isToday = selectedDateOnly.isAtSameMomentAs(todayOnly);

                return Column(
                  children: mealPlanFeatureOptionsController.mealsByDateList.map((
                      meal,
                      ) {
                    return Column(
                      children: [
                        MealPlanItemCard(
                          onTap: () {
                            Get.toNamed(
                              Routes.mealDetailscreen,
                              arguments: {
                                'mealID': meal.id,
                                'hideSelectButton': true,
                                'hideGenerateImageButton': isPastDate,
                              },
                            );
                          },
                          isMealEaten: meal.status == 'done',
                          leftButtonTitle: 'i_ate_this'.tr,
                          leftButtonOnTap: isToday
                              ? () async {
                                  LoggerUtils.debug(
                                    "Button Tapped: I Ate This, Meal Type: ${meal.mealType}, Meal Name: ${meal.mealName}",
                                  );
                                  await homeScreenController.patchUpdateMealConsumptionApi(
                                    mealID: meal.id ?? '',
                                  );
                                  // Refresh the meals list for the selected date
                                  mealPlanFeatureOptionsController.postGetMealsBySelectedDate();
                                }
                              : () {},
                          leftButtonColor: !isToday ? AppColors.c262626 : null,
                          leftButtonBorderColor: !isToday ? AppColors.c999999 : null,
                          isLeftButtonBorderUsed: !isToday,
                          rightButtonTitle: 'swap_meal'.tr,
                          rightButtonOnTap: isPastDate
                              ? () {}
                              : () {
                                  LoggerUtils.debug(
                                    "Button Tapped: Swap Meal, Meal Type: ${meal.mealType}, Meal Name: ${meal.mealName}",
                                  );
                                  showSwapMealBottomSheet(
                                    mealType: meal.mealType ?? 'breakfast',
                                    mealName: meal.mealName ?? '',
                                    mealId: meal.id,
                                    mealCalories: meal.kcal ?? 0,
                                    category: meal.mealType ?? 'breakfast',
                                    subCategory: meal.mealType ?? 'breakfast',
                                  );
                                },
                          rightButtonBorderColor: isPastDate ? AppColors.c999999 : null,
                          mealType:
                          meal.mealType?.capitalizeFirst ??
                              'failed_to_get_meal_type'.tr,
                          mealTitle: meal.mealName ?? '',
                          kcalValue: meal.kcal ?? 0,
                          mealImagePath: _convertImageToUrl(meal.image ?? ''),
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