import 'package:bloodfit/constants/text_font_style.dart';
import 'package:bloodfit/features/choose_from_our_suggested_meals/data/controller/choose_from_our_suggested_meal_controller.dart';
import 'package:bloodfit/features/choose_from_our_suggested_meals/presentation/widgets/food_item_showing_widget.dart';
import 'package:bloodfit/helper/logger_util.dart';
import 'package:bloodfit/routes/routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../../helper/ui_helpers.dart';
import '../../data/model/ai_suggested_meals_model.dart';

class MealPlanTypeWidget extends StatelessWidget {
  final String mealPlanType;
  final String itemImagePath;
  final void Function()? retryOnTap;
  final RxList<HealthyComforting> itemsList;

  MealPlanTypeWidget({
    super.key,
    required this.mealPlanType,
    required this.itemImagePath,
    this.retryOnTap,
    required this.itemsList,
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
              return FoodItemShowingWidget(
                onTap: () {
                  LoggerUtils.debug(
                    "Navigate to Selected Item Description Screen",
                  );
                  
                  /// Pass the meal data directly to the details screen
                  Get.toNamed(Routes.mealDetailscreen, arguments: {
                    'mealData': {
                      'mealName': data.mealName ?? '',
                      'mealType': mealPlanType.toLowerCase(),
                      'totalCalories': data.totalCalories ?? 0,
                      'description': data.description ?? '',
                      'ingredients': data.ingredients?.map((ing) => {
                        'name': ing.name ?? '',
                        'quantity': ing.quantity ?? '',
                        'icon': ing.icon ?? '',
                      }).toList() ?? [],
                      'macronutrients': {
                        'carbohydrates': data.macronutrients?.carbohydrates ?? 0,
                        'protein': data.macronutrients?.protein ?? 0,
                        'fat': data.macronutrients?.fat ?? 0,
                      },
                      'numberOfServings': data.numberOfServings ?? 1,
                      'image': itemImagePath,
                      'category': data.category?.name ?? '',
                      'subCategory': data.subCategory?.name ?? '',
                    },
                  });
                },
                isSelected: true,
                onChanged: (value) {},
                isImageLinkBase64: true,
                itemImagePath: itemImagePath,
                itemTitle: data.mealName ?? 'Test name',
                kcalValue: data.totalCalories ?? 0,
                servingValue: data.numberOfServings ?? 0,
              );
            },
          ),
        ),
      ],
    );
  }
}
