import 'dart:developer';

import 'package:bloodfit/constants/app_list.dart';
import 'package:bloodfit/constants/app_text.dart';
import 'package:bloodfit/constants/text_font_style.dart';
import 'package:bloodfit/custom_widgets/custom_elevated_button.dart';
import 'package:bloodfit/gen/assets.gen.dart';
import 'package:bloodfit/gen/colors.gen.dart';
import 'package:bloodfit/helper/ui_helpers.dart';
import 'package:bloodfit/routes/routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../custom_widgets/food_item_data_helper_widget.dart';
import '../widgets/food_menarel_item_tile_widget.dart';
import '../widgets/ingredients_item_tile_widget.dart';
import '../widgets/item_image_and_title_widget.dart';

class MealDetailsScreen extends StatelessWidget {
  const MealDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldBackgroundColor,
      body: SingleChildScrollView(
        child: Column(
          children: [
            ///Section : ----------///Item Image///-------------
            ///Section : ----------///Item Title///-------------
            ItemImageAndTitleWidget(
              imagePath: Assets.images.eggOmletImage.path,
              title: "Avocado Toast & Poached Eggs",
            ),
            UIHelper.verticalSpace(8.h),

            ///Section : -----------///Meal Type -> Breakfast,Lunc,Dinner///------------
            Row(
              mainAxisSize: MainAxisSize.min, // ✅ Row doesn’t stretch
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                /// Food Total Kcal & Serving
                FoodItemDataHelperWidget(
                  iconPath: Assets.icons.mealIcon,
                  iconColor: AppColors.cfefefe,
                  title: "Breakfast",
                  value: 302,
                  isValueVisible: false,
                ),
                UIHelper.horizontalSpace(20.w),

                /// Divider
                Container(width: 2.sp, height: 20.h, color: AppColors.c282828),
                UIHelper.horizontalSpace(20.w),

                FoodItemDataHelperWidget(
                  title: "Kcal",
                  iconPath: Assets.icons.fireRed,
                  value: 302,
                ),
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
                  Text(
                    foodDetailsText,
                    textAlign: TextAlign.center,
                    style: TextFontStyle.headline14w500c999999StylePoppins,
                  ),
                  UIHelper.verticalSpace(32.h),

                  ///Section : ---------///Text -> Calory Count For This Meal ///---------------
                  Text(
                    "Calory Count For This Meal",
                    style: TextFontStyle.headline20w500cfefefeStylePoppins,
                  ),
                  UIHelper.verticalSpace(16.h),

                  ///Section : -----///Carbs,Protein,Fat///-----------
                  Center(
                    child: Wrap(
                      spacing: 15.w,
                      alignment: WrapAlignment.center,
                      children: AppList.foodMenarelList
                          .map(
                            (menarel) => FoodMenarelItemTileWidget(
                              imagePath: menarel.imagePath,
                              value: menarel.value,
                              menaralName: menarel.menaralName,
                            ),
                          )
                          .toList(),
                    ),
                  ),
                  UIHelper.verticalSpace(32.h),

                  ///Section : --------------///Text -> Ingredients///-------------
                  Text(
                    "Ingredients",
                    style: TextFontStyle.headline20w500cfefefeStylePoppins,
                  ),
                  UIHelper.verticalSpace(16.h),

                  ///Section : -----------///Ingredients Images,Name, Weight, amount///-------
                  Wrap(
                    spacing: 42.w,
                    runSpacing: 16.h,
                    alignment: WrapAlignment.center,
                    children: AppList.foodIngredientsDetailsList
                        .map(
                          (ingredient) => IngredientItemTileWidget(
                            imagePath: ingredient.imagePath,
                            title: ingredient.title,
                            gValue: ingredient.gValue,
                            recommendedConsumable:
                                ingredient.recommendedConsumable,
                          ),
                        )
                        .toList(),
                  ),
                  UIHelper.verticalSpace(24.h),

                  ///Section : ----------///Button -> Select This Meal///----------
                  CustomElevatedButton(
                    onTap: () {
                      log("Button Taped : Select This Meal!");
                      Get.toNamed(Routes.reviewYourChoosenMealScreen);
                    },
                    buttonWidth: 1.sw,
                    buttonHeight: 52.h,
                    borderRadius: 24.r,
                    buttonTitle: "Select This Meal",
                  ),
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
