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
            return MealStatusCardWidget(
              selectedMeal: 1.0,
              totalMeal: 1,
              mealType: "Breakfast",
            );
          }),
          UIHelper.horizontalSpace(8.w),

          ///Section : --------///Item -> Breakfast///--------------
          Obx(() {
            return MealStatusCardWidget(
              selectedMeal: 1.0,
              totalMeal: 1,
              mealType: "Lunch",
            );
          }),
          UIHelper.horizontalSpace(8.w),

          ///Section : --------///Item -> Breakfast///--------------
          Obx(() {
            return MealStatusCardWidget(
              selectedMeal: 1.0,
              totalMeal: 1,
              mealType: "Dinner",
            );
          }),
          Spacer(),

          ///Section : -------///Button -> Build Meal Plan///-------------
          Obx(() {
            // final isMealPlanComplete = controller.isMealPlanComplete;
            return CustomElevatedButton(
              onTap: () {
                log("Button Taped : Build Meal Plan!");
                // log("Selected Meals: ${controller.getSelectedMeals().length}");
                Get.closeCurrentSnackbar(); // dismiss snackbar immediately
                Get.toNamed(Routes.reviewYourChoosenMealScreen);
              },
              buttonTitle: "Build Meal Plan",
              textStyle: TextFontStyle.headline12w400cfefefeStylePoppins,
              buttonHeight: 64.h,
              buttonWidth: 100.w,
              borderRadius: 8.r,
              isDisabled: false,
            );
          }),
        ],
      ),
    );
  }
}
