import 'dart:developer';

import 'package:bloodfit/constants/text_font_style.dart';
import 'package:bloodfit/custom_widgets/custom_elevated_button.dart';
import 'package:bloodfit/features/choose_from_our_suggested_meals/data/controller/choose_from_our_suggested_meal_controller.dart';
import 'package:bloodfit/features/choose_from_our_suggested_meals/presentation/widgets/meal_status_card_widget.dart';
import 'package:bloodfit/gen/colors.gen.dart';
import 'package:bloodfit/helper/ui_helpers.dart';
import 'package:bloodfit/routes/routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class MealPlanSelectionTracker extends StatelessWidget {
  const MealPlanSelectionTracker({super.key});

  @override
  Widget build(BuildContext context) {
    final ChooseFromOurSuggestedMealController controller =
        Get.find<ChooseFromOurSuggestedMealController>();

    return Obx(() {
      // Only show tracker when all 3 meals are selected
      if (!controller.isMealPlanComplete) {
        return const SizedBox.shrink();
      }
      
      return Container(
        width: 1.sw,
        padding: EdgeInsets.all(10.sp),
        decoration: BoxDecoration(
          color: AppColors.c727272,
          borderRadius: BorderRadius.circular(10.r),
        ),
        child: Row(
          children: [
            ///Section : --------///Item -> Breakfast///--------------
            Obx(() {
              final isSelected = controller.selectedBreakfastMealId.value.isNotEmpty;
              final mealName = controller.selectedBreakfastMealName.value;
              
              return MealStatusCardWidget(
                isSelected: isSelected,
                mealName: isSelected ? mealName : 'Not selected',
                mealType: "Breakfast",
              );
            }),
            UIHelper.horizontalSpace(8.w),

            ///Section : --------///Item -> Lunch///--------------
            Obx(() {
              final isSelected = controller.selectedLunchMealId.value.isNotEmpty;
              final mealName = controller.selectedLunchMealName.value;
              
              return MealStatusCardWidget(
                isSelected: isSelected,
                mealName: isSelected ? mealName : 'Not selected',
                mealType: "Lunch",
              );
            }),
            UIHelper.horizontalSpace(8.w),

            ///Section : --------///Item -> Dinner///--------------
            Obx(() {
              final isSelected = controller.selectedDinnerMealId.value.isNotEmpty;
              final mealName = controller.selectedDinnerMealName.value;
              
              return MealStatusCardWidget(
                isSelected: isSelected,
                mealName: isSelected ? mealName : 'Not selected',
                mealType: "Dinner",
              );
            }),
            const Spacer(),

            ///Section : -------///Button -> Build Meal Plan///-------------
            Obx(() {
              final isMealPlanComplete = controller.isMealPlanComplete;
              final selectedCount = controller.getSelectedMealsCount();
              
              return CustomElevatedButton(
                onTap: () {
                  log("Button Taped : Build Meal Plan!");
                  log("Selected Meals: $selectedCount/3");
                  log("Breakfast: ${controller.selectedBreakfastMealName.value}");
                  log("Lunch: ${controller.selectedLunchMealName.value}");
                  log("Dinner: ${controller.selectedDinnerMealName.value}");
                  
                  Get.toNamed(Routes.reviewYourChoosenMealScreen);
                },
                buttonTitle: "Build Meal Plan",
                textStyle: TextFontStyle.headline12w400cfefefeStylePoppins,
                buttonHeight: 64.h,
                buttonWidth: 100.w,
                borderRadius: 8.r,
                isDisabled: !isMealPlanComplete,

                buttonColor: Colors.amber,
              );
            }),
          ],
        ),
      );
    });
  }
}
