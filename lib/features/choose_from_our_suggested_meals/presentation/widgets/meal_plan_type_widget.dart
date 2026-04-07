import 'package:bloodfit/constants/text_font_style.dart';
import 'package:bloodfit/features/choose_from_our_suggested_meals/data/controller/choose_from_our_suggested_meal_controller.dart';
import 'package:bloodfit/features/choose_from_our_suggested_meals/data/model/meal_data_model.dart';
import 'package:bloodfit/features/choose_from_our_suggested_meals/presentation/widgets/food_item_showing_widget.dart';
import 'package:bloodfit/helper/logger_util.dart';
import 'package:bloodfit/routes/routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../../endpoints.dart';
import '../../../../helper/ui_helpers.dart';
import '../../data/model/ai_suggested_meals_model.dart';

class MealPlanTypeWidget extends StatelessWidget {
  final String mealPlanType;
  final String itemImagePath;
  final void Function()? retryOnTap;
  final RxList<HealthyComforting> itemsList;
  final String tabName; // 'breakfast', 'lunch', or 'dinner'

  MealPlanTypeWidget({
    super.key,
    required this.mealPlanType,
    required this.itemImagePath,
    this.retryOnTap,
    required this.itemsList,
    required this.tabName,
  });

  final ChooseFromOurSuggestedMealController controller =
      Get.find<ChooseFromOurSuggestedMealController>();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [

        ///----------->>> Section : MealType
        Text(mealPlanType,style: TextFontStyle.headline18w500cfefefeStylePoppins,),
        UIHelper.verticalSpace(8.h),

        SizedBox(
          width: 1.sw,
          height: 250.h,
          child: ListView.separated(
            itemCount: itemsList.length,
            scrollDirection: Axis.horizontal,
            separatorBuilder: (context, index) => UIHelper.horizontalSpace(16.w),
            itemBuilder: (context, index) {
              var data = itemsList[index];
              final mealName = data.mealName ?? 'Test name';
              final mealId = data.id ?? '';
              // Priority: 1) meal's own image  2) tab default base64 image  3) defaultMealImage URL
              final mealImage = (data.image != null && data.image.toString().isNotEmpty)
                  ? data.image.toString()
                  : itemImagePath.isNotEmpty
                      ? itemImagePath
                      : defaultMealImage;

              // Detect if the image is base64 — only base64 strings should be decoded.
              // URLs (http/https) and the defaultMealImage must NOT be treated as base64,
              // otherwise base64Decode throws FormatException on URL characters like ':'.
              final isMealImageBase64 = mealImage.startsWith('data:image') ||
                  mealImage.startsWith('iVBORw0KGgo') || // PNG
                  mealImage.startsWith('/9j/') ||         // JPEG
                  mealImage.startsWith('R0lGOD');         // GIF

              return Obx(() {
                final isSelected = controller.isMealSelected(
                  tabName: tabName,
                  mealId: mealId,
                );

                return FoodItemShowingWidget(
                  onTap: () {
                    LoggerUtils.debug(
                      "Navigate to Selected Item Description Screen",
                    );

                    /// Create a MealDataModel from the AI suggested meal data
                    final mealDataModel = MealDataModel(
                      mealName: mealName,
                      mealType: tabName,
                      totalCalories: data.totalCalories ?? 0,
                      description: data.description ?? '',
                      ingredients: data.ingredients?.map((ing) => MealIngredientData(
                        name: ing.name ?? '',
                        quantity: ing.quantity ?? '',
                        icon: ing.icon ?? '',
                      )).toList() ?? [],
                      macronutrients: MealMacronutrientsData(
                        carbohydrates: (data.macronutrients?.carbohydrates ?? 0).toDouble(),
                        protein: (data.macronutrients?.protein ?? 0).toDouble(),
                        fat: (data.macronutrients?.fat ?? 0).toDouble(),
                      ),
                      numberOfServings: data.numberOfServings ?? 1,
                      image: mealImage,
                      category: data.category?.name,
                      subCategory: data.subCategory?.name,
                      mealId: mealId,
                    );

                    LoggerUtils.debug("✅ [MEAL DATA] Created MealDataModel with:");
                    LoggerUtils.debug("   • mealName: ${mealDataModel.mealName}");
                    LoggerUtils.debug("   • mealType: ${mealDataModel.mealType}");
                    LoggerUtils.debug("   • mealId: ${mealDataModel.mealId}");

                    /// Pass the model to the details screen
                    Get.toNamed(Routes.mealDetailscreen, arguments: {
                      'mealData': mealDataModel,
                    });
                  },
                  isSelected: isSelected,
                  onChanged: (value) {
                    LoggerUtils.debug("✅ [CHECKBOX] onChanged called with value: $value");
                    LoggerUtils.debug("✅ [CHECKBOX] tabName: $tabName, mealId: $mealId, mealName: $mealName");
                    if (value == true) {
                      LoggerUtils.debug("✅ [CHECKBOX] Calling controller.setSelectedMeal()");
                      controller.setSelectedMeal(
                        tabName: tabName,
                        mealId: mealId,
                        mealName: mealName,
                      );
                    }
                  },
                  isImageLinkBase64: isMealImageBase64,
                  itemImagePath: mealImage,
                  itemTitle: mealName,
                  kcalValue: data.totalCalories ?? 0,
                  servingValue: data.numberOfServings ?? 0,
                );
              });
            },
          ),
        ),
      ],
    );
  }
}
