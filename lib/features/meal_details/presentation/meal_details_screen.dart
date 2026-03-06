import 'dart:developer';

import 'package:bloodfit/constants/app_list.dart';
import 'package:bloodfit/constants/text_font_style.dart';
import 'package:bloodfit/custom_widgets/custom_elevated_button.dart';
import 'package:bloodfit/custom_widgets/custom_shimmer_effect.dart';
import 'package:bloodfit/features/choose_from_our_suggested_meals/data/controller/choose_from_our_suggested_meal_controller.dart';
import 'package:bloodfit/features/choose_from_our_suggested_meals/data/model/meal_data_model.dart';
import 'package:bloodfit/features/meal_details/data/controller/meal_details_screen_controller.dart';
import 'package:bloodfit/gen/assets.gen.dart';
import 'package:bloodfit/gen/colors.gen.dart';
import 'package:bloodfit/helper/logger_util.dart';
import 'package:bloodfit/helper/ui_helpers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../custom_widgets/food_item_data_helper_widget.dart';
import '../widgets/food_menarel_item_tile_widget.dart';
import '../widgets/ingredients_item_tile_widget.dart';
import '../widgets/item_image_and_title_widget.dart';

class MealDetailsScreen extends StatefulWidget {
  const MealDetailsScreen({super.key});

  @override
  State<MealDetailsScreen> createState() => _MealDetailsScreenState();
}

class _MealDetailsScreenState extends State<MealDetailsScreen> {
  MealDetailsScreenController? mealDetailsScreenController;
  ChooseFromOurSuggestedMealController? chooseFromOurSuggestedMealController;

  String mealID = '';
  String? mealIdForSelection; // Unique ID for meal selection
  String? tabNameForSelection; // Tab name (breakfast/lunch/dinner)

  @override
  void initState() {
    ///-----<>>> Section : Initialize arguments
    final arguments = Get.arguments as Map<String, dynamic>?;

    ///-----<>>> Section : Intialize Controllers
    mealDetailsScreenController = Get.find<MealDetailsScreenController>();
    chooseFromOurSuggestedMealController = Get.find<ChooseFromOurSuggestedMealController>();

    ///------<>>> Section : Get Arguments
    mealID = arguments?['mealID']?.toString() ?? '';

    ///------<>>> Section : Get Direct Meal Data (from AI suggested meals)
    final mealData = arguments?['mealData'] as MealDataModel?;

    ///------>>> Extract selection info from mealData if available
    if (mealData != null) {
      // Extract tab name from mealType
      final mealType = mealData.mealType.toLowerCase();
      if (mealType.contains('breakfast')) {
        tabNameForSelection = 'breakfast';
      } else if (mealType.contains('lunch')) {
        tabNameForSelection = 'lunch';
      } else if (mealType.contains('dinner')) {
        tabNameForSelection = 'dinner';
      }

      // Use the mealId passed from the meal card (if available)
      // This ensures the same ID is used for selection tracking
      if (mealData.mealId != null && mealData.mealId!.isNotEmpty) {
        mealIdForSelection = mealData.mealId;
        LoggerUtils.debug("🎯 [MEAL DETAILS] Using passed mealId from MealDataModel: $mealIdForSelection");
      } else {
        // Fallback: Create a unique meal ID using mealName and image
        mealIdForSelection = '${tabNameForSelection}_${mealData.mealName}_${mealData.image}';
        LoggerUtils.debug("🎯 [MEAL DETAILS] Created fallback mealId: $mealIdForSelection");
      }

      LoggerUtils.debug("🎯 [MEAL DETAILS] Selection info - tabName: $tabNameForSelection, mealId: $mealIdForSelection");
    } else if (arguments != null && arguments['tabNameForSelection'] != null && arguments['mealIdForSelection'] != null) {
      // Handle Previously Selected Meals (passed directly from recently_selected_meals_widget)
      tabNameForSelection = arguments['tabNameForSelection'] as String?;
      mealIdForSelection = arguments['mealIdForSelection'] as String?;
      LoggerUtils.debug("🎯 [MEAL DETAILS] Using selection info from Previously Selected Meals");
      LoggerUtils.debug("🎯 [MEAL DETAILS] Selection info - tabName: $tabNameForSelection, mealId: $mealIdForSelection");
    }

    ///--------<>>> Section : PostFrameCallBack Function
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      ///------>>> Send MealID to Controller
      if (mealID.isNotEmpty) {
        mealDetailsScreenController?.setMealID(mealId: mealID);
      }

      ///------>>> Send Direct Meal Data to Controller
      if (mealData != null) {
        mealDetailsScreenController?.setDirectMealData(mealData);
      }

      ///------<>>> Call The api (or use direct data)
      await mealDetailsScreenController?.getMealDetailsApi();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldBackgroundColor,
      body: SingleChildScrollView(
        child: Column(
          children: [
            ///Section : ----------///Item Image///-------------
            ///Section : ----------///Item Title///-------------
            Obx(() {
              
              if (mealDetailsScreenController!.isMealDetailsLoading.value) {
                return CustomShimmerEffect(height: 0.5.sh, width: 1.sw);
              }
              if (mealDetailsScreenController!.mealImage.isEmpty ||
                  mealDetailsScreenController!.mealName.isEmpty) {
                return CustomShimmerEffect(
                  height: 0.2.sh,
                  width: 1.sw,
                  child: Text(
                    'Failed to Get Meal Name or Image',
                    style: TextFontStyle.headline14w400cb20000StylePoppins,
                  ),
                );
              }

              return ItemImageAndTitleWidget(
                imagePath: mealDetailsScreenController!.mealImage,
                title: mealDetailsScreenController!.mealName,
                isBase64: mealDetailsScreenController!.isMealImageBase64,
              );
            }),
            UIHelper.verticalSpace(8.h),

            ///Section : -----------///Meal Type -> Breakfast,Lunc,Dinner///------------
            Row(
              mainAxisSize: MainAxisSize.min, // ✅ Row doesn’t stretch
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                /// Food Total Kcal & Serving
                Obx(() {
                  if (mealDetailsScreenController!.isMealDetailsLoading.value) {
                    return CustomShimmerEffect(height: 20.h, width: 120.w);
                  }
                  if (mealDetailsScreenController!.mealType.isEmpty) {
                    return CustomShimmerEffect(
                      height: 40.h,
                      width: 60.w,
                      child: Text(
                        'Failed to Get Meal Type',
                        style: TextFontStyle.headline14w400cb20000StylePoppins,
                      ),
                    );
                  }

                  return FoodItemDataHelperWidget(
                    iconPath: Assets.icons.mealIcon,
                    iconColor: AppColors.cfefefe,
                    title: mealDetailsScreenController!.mealType,
                    value: 0,
                    isValueVisible: false,
                  );
                }),
                UIHelper.horizontalSpace(20.w),

                /// Divider
                Container(width: 2.sp, height: 20.h, color: AppColors.c282828),
                UIHelper.horizontalSpace(20.w),

                Obx(() {
                  if (mealDetailsScreenController!.isMealDetailsLoading.value) {
                    return CustomShimmerEffect(height: 20.h, width: 120.w);
                  }
                  if (mealDetailsScreenController!.totalKcal <= 0) {
                    return CustomShimmerEffect(
                      height: 40.h,
                      width: 120.w,
                      child: Text(
                        'Failed to Get Total KCAL',
                        style: TextFontStyle.headline14w400cb20000StylePoppins,
                      ),
                    );
                  }

                  return FoodItemDataHelperWidget(
                    title: "Kcal",
                    iconPath: Assets.icons.fireRed,
                    value: mealDetailsScreenController!.totalKcal,
                  );
                }),
              ],
            ),
            UIHelper.verticalSpace(12.h),

            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: UIHelper.kDefaulutPadding(),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ///Section : ------///Text -> Mesal Details Text ///----------
                  Obx(() {
                    if (mealDetailsScreenController!
                        .isMealDetailsLoading
                        .value) {
                      return Column(
                        children: [
                          CustomShimmerEffect(height: 10.h, width: 1.sw),
                          UIHelper.verticalSpace(8.h),
                          CustomShimmerEffect(height: 10.h, width: 1.sw),
                          UIHelper.verticalSpace(8.h),
                          CustomShimmerEffect(height: 10.h, width: 1.sw),
                          UIHelper.verticalSpace(8.h),
                          CustomShimmerEffect(height: 10.h, width: 8.sw),
                          UIHelper.verticalSpace(8.h),
                          CustomShimmerEffect(height: 10.h, width: 1.sh),
                          UIHelper.verticalSpace(8.h),
                        ],
                      );
                    }
                    if (mealDetailsScreenController!.mealDescription.isEmpty) {
                      return CustomShimmerEffect(
                        height: 20.h,
                        width: 1.sw,
                        child: Text(
                          'Failed to Get Meal Description',
                          style:
                              TextFontStyle.headline14w400cb20000StylePoppins,
                        ),
                      );
                    }

                    return Text(
                      mealDetailsScreenController!.mealDescription,
                      textAlign: TextAlign.center,
                      style: TextFontStyle.headline14w500c999999StylePoppins,
                    );
                  }),
                  UIHelper.verticalSpace(32.h),

                  ///Section : ---------///Text -> Calory Count For This Meal ///---------------
                  Text(
                    "Calory Count For This Meal",
                    style: TextFontStyle.headline20w500cfefefeStylePoppins,
                  ),
                  UIHelper.verticalSpace(16.h),

                  ///Section : -----///Carbs,Protein,Fat///-----------
                  Obx(() {
                    if (mealDetailsScreenController!
                        .isMealDetailsLoading
                        .value) {
                      return SizedBox(
                        height: 30.h,
                        width: 1.sw,
                        child: ListView.separated(
                          itemCount: 3,
                          scrollDirection: Axis.horizontal,
                          separatorBuilder: (context, index) =>
                              UIHelper.horizontalSpace(10.w),
                          itemBuilder: (context, index) {
                            return CustomShimmerEffect(
                              height: 30.h,
                              width: 80.w,
                            );
                          },
                        ),
                      );
                    }

                    if (mealDetailsScreenController!.calorieCountList.isEmpty) {
                      return CustomShimmerEffect(
                        height: 20.h,
                        width: 1.sw,
                        child: Text(
                          'Failed to Get Calory Count!',
                          style:
                              TextFontStyle.headline14w400cb20000StylePoppins,
                        ),
                      );
                    }
                    return Center(
                      child: Wrap(
                        spacing: 15.w,
                        alignment: WrapAlignment.center,
                        children: List.generate(
                          mealDetailsScreenController!.calorieCountList.length,
                          (index) {
                            final menarel = mealDetailsScreenController!
                                .calorieCountList[index];

                            final iconPath =
                                AppList.foodMenarelList[index].imagePath;

                            return FoodMenarelItemTileWidget(
                              imagePath: iconPath,
                              value: menarel.kcal ?? 0,
                              menaralName: 'Kcal',
                            );
                          },
                        ),
                      ),
                    );
                  }),
                  UIHelper.verticalSpace(32.h),

                  ///Section : --------------///Text -> Ingredients///-------------
                  Text(
                    "Ingredients",
                    style: TextFontStyle.headline20w500cfefefeStylePoppins,
                  ),
                  UIHelper.verticalSpace(16.h),

                  ///Section : -----------///Ingredients Images,Name, Weight, amount///-------
                  Obx(() {
                    if (mealDetailsScreenController!
                        .isMealDetailsLoading
                        .value) {
                      return Wrap(
                        spacing: 42.w,
                        runSpacing: 16.h,
                        alignment: WrapAlignment.center,
                        children: mealDetailsScreenController!
                            .mealIngredientList
                            .map(
                              (ingredient) => Column(
                                children: [
                                  CustomShimmerEffect(
                                    height: 30.h,
                                    width: 30.w,
                                  ),
                                  UIHelper.verticalSpace(10.h),
                                  CustomShimmerEffect(
                                    height: 20.h,
                                    width: 60.w,
                                  ),
                                ],
                              ),
                            )
                            .toList(),
                      );
                    }

                    if (mealDetailsScreenController!.calorieCountList.isEmpty) {
                      return CustomShimmerEffect(
                        height: 20.h,
                        width: 1.sw,
                        child: Text(
                          'Failed to Get Calory Count!',
                          style:
                              TextFontStyle.headline14w400cb20000StylePoppins,
                        ),
                      );
                    }

                    return Wrap(
                      spacing: 42.w,
                      runSpacing: 16.h,
                      alignment: WrapAlignment.center,
                      children: mealDetailsScreenController!.mealIngredientList
                          .map(
                            (ingredient) => IngredientItemTileWidget(
                              imagePath: ingredient.icon ?? '',
                              title: ingredient.name ?? '',
                              recommendedConsumable: ingredient.quantity ?? '',
                            ),
                          )
                          .toList(),
                    );
                  }),
                  UIHelper.verticalSpace(24.h),

                  ///Section : ----------///Button -> Select This Meal///----------
                  Obx(() {
                    if (mealDetailsScreenController!
                        .isMealDetailsLoading
                        .value) {
                      return CustomShimmerEffect(height: 52.h, width: 1.sw);
                    }

                    if (mealDetailsScreenController!.calorieCountList.isEmpty) {
                      return CustomElevatedButton(
                        onTap: null,
                        buttonWidth: 1.sw,
                        buttonHeight: 52.h,
                        borderRadius: 24.r,
                        buttonTitle: "Select This Meal",
                      );
                    }

                    // Check if meal is currently selected (only for AI suggested meals)
                    final isMealSelected = tabNameForSelection != null && mealIdForSelection != null
                        ? chooseFromOurSuggestedMealController!.isMealSelected(
                            tabName: tabNameForSelection!,
                            mealId: mealIdForSelection!,
                          )
                        : false;

                    LoggerUtils.debug("🎯 [BUTTON] isMealSelected: $isMealSelected");
                    LoggerUtils.debug("🎯 [BUTTON] tabNameForSelection: $tabNameForSelection");
                    LoggerUtils.debug("🎯 [BUTTON] mealIdForSelection: $mealIdForSelection");

                    return CustomElevatedButton(
                      onTap: () {
                        log("Button Taped : Select This Meal!");
                        
                        // Only allow selection if we have valid selection info
                        if (tabNameForSelection != null && mealIdForSelection != null) {
                          final mealName = mealDetailsScreenController!.mealName;
                          
                          if (isMealSelected) {
                            // Deselect the meal
                            LoggerUtils.debug("🎯 [BUTTON] Deselecting meal...");
                            chooseFromOurSuggestedMealController!.setSelectedMeal(
                              tabName: tabNameForSelection!,
                              mealId: mealIdForSelection!,
                              mealName: mealName,
                            );
                          } else {
                            // Select the meal
                            LoggerUtils.debug("🎯 [BUTTON] Selecting meal...");
                            chooseFromOurSuggestedMealController!.setSelectedMeal(
                              tabName: tabNameForSelection!,
                              mealId: mealIdForSelection!,
                              mealName: mealName,
                            );
                          }
                        } else {
                          LoggerUtils.debug("⚠️ [BUTTON] Cannot select meal - missing selection info");
                        }
                      },
                      buttonWidth: 1.sw,
                      buttonHeight: 52.h,
                      borderRadius: 24.r,
                      buttonTitle: isMealSelected ? "Deselect This Meal" : "Select This Meal",
                    );
                  }),
                  UIHelper.verticalSpace(40.h),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
