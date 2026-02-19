import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../../../gen/assets.gen.dart';
import '../../../../../helper/ui_helpers.dart';
import '../../../data/controller/choose_from_our_suggested_meal_controller.dart';
import '../../../presentation/widgets/meal_plan_type_widget.dart';
import '../../../presentation/widgets/recently_selected_meals_widget.dart';

class LunchTab extends StatelessWidget {
  final VoidCallback? onMealSelected;
 LunchTab({super.key, this.onMealSelected});

  final ChooseFromOurSuggestedMealController
  chooseFromOurSuggestedMealController =
      Get.find<ChooseFromOurSuggestedMealController>();

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ///Section : ------------///Previously Selected Meals///----------------
          RecentlySelectedMealsWidget(
            isLoading: chooseFromOurSuggestedMealController.isPreviouslySelectedMealsLoading,
            meals: chooseFromOurSuggestedMealController.lunchRecentChosenMeals,
          ),
          UIHelper.verticalSpace(32.h),

          ///Section : ------------///Protein-Packed ///----------------
          MealPlanTypeWidget(
            mealPlanType: "Protein-Packed",
            // isSelected: true,
            itemImagePath: Assets.images.omletEgg.path,
            // itemTitle: "Avocado Toast and Poached Eggs",
            // kcalValue: 302,
            // servingValue: 1,
          ),
          UIHelper.verticalSpace(32.h),

          ///Section : ------------///Light & Fresh ///----------------
          MealPlanTypeWidget(
            mealPlanType: "Light & Fresh",
            // isSelected: true,
            itemImagePath: Assets.images.omletEgg.path,
            // itemTitle: "Avocado Toast and Poached Eggs",
            // kcalValue: 302,
            // servingValue: 1,
          ),
          UIHelper.verticalSpace(32.h),

          ///Section : ------------///Hearty & Comforting///----------------
          MealPlanTypeWidget(
            mealPlanType: "Hearty & Comforting",
            // isSelected: true,
            itemImagePath: Assets.images.omletEgg.path,
            // itemTitle: "Avocado Toast and Poached Eggs",
            // kcalValue: 302,
            // servingValue: 1,
          ),
          UIHelper.verticalSpace(32.h),
        ],
      ),
    );
  }
}
