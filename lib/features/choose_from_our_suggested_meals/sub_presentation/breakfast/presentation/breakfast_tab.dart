import 'package:bloodfit/features/choose_from_our_suggested_meals/data/controller/choose_from_our_suggested_meal_controller.dart';
import 'package:bloodfit/gen/assets.gen.dart';
import 'package:bloodfit/helper/ui_helpers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../presentation/widgets/meal_plan_type_widget.dart';
import '../../../presentation/widgets/recently_selected_meals_widget.dart';

class BreakfastTab extends StatelessWidget {
  BreakfastTab({super.key});

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
            meals: chooseFromOurSuggestedMealController.breakfastRecentChosenMeals,
          ),
          UIHelper.verticalSpace(32.h),

          ///Section : ------------///Protein-Packed ///----------------
          MealPlanTypeWidget(
              mealPlanType: "Protein-Packed",
              itemImagePath: Assets.images.omletEgg.path,
              itemsList: chooseFromOurSuggestedMealController.tesList,
              retryOnTap: (){
                
              },
            ),
          UIHelper.verticalSpace(32.h),

          ///Section : ------------///Light & Fresh ///----------------
          MealPlanTypeWidget(
              mealPlanType: "Protein-Packed",
              itemImagePath: "base64 image url",
              itemsList: chooseFromOurSuggestedMealController.tesList,
              retryOnTap: (){
                
              },
            ),
          UIHelper.verticalSpace(32.h),

          ///Section : ------------///Hearty & Comforting///----------------
          MealPlanTypeWidget(
              mealPlanType: "Protein-Packed",
              itemImagePath: "base64 image url",
              itemsList: chooseFromOurSuggestedMealController.tesList,
              retryOnTap: (){
                
              },
            ),
          UIHelper.verticalSpace(32.h),
        ],
      ),
    );
  }
}
