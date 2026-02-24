import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../../../gen/assets.gen.dart';
import '../../../../../helper/ui_helpers.dart';
import '../../../data/controller/choose_from_our_suggested_meal_controller.dart';
import '../../../presentation/widgets/meal_plan_type_widget.dart';
import '../../../presentation/widgets/recently_selected_meals_widget.dart';

class DinnerTab extends StatelessWidget {
 DinnerTab({super.key});

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
            meals: chooseFromOurSuggestedMealController.dinnerRecentChosenMeals,
          ),
          UIHelper.verticalSpace(32.h),

          ///Section : ------------///Protein-Packed ///----------------
          Obx(() {
            return MealPlanTypeWidget(
              mealPlanType: "Protein-Packed",
              itemImagePath: chooseFromOurSuggestedMealController.currentTabImageUrl.value.isNotEmpty 
                  ? chooseFromOurSuggestedMealController.currentTabImageUrl.value 
                  : Assets.images.omletEgg.path,
              itemsList: chooseFromOurSuggestedMealController.proteinPackedItemsList,
              retryOnTap: (){
                chooseFromOurSuggestedMealController.getAiSuggestedMealsApi();
              },
            );
          }),
          UIHelper.verticalSpace(32.h),

          ///Section : ------------///Light & Fresh ///----------------
          Obx(() {
            return MealPlanTypeWidget(
              mealPlanType: "Light & Fresh",
              itemImagePath: chooseFromOurSuggestedMealController.currentTabImageUrl.value.isNotEmpty 
                  ? chooseFromOurSuggestedMealController.currentTabImageUrl.value 
                  : Assets.images.omletEgg.path,
              itemsList: chooseFromOurSuggestedMealController.lightAndFreshItemsList,
              retryOnTap: (){
                chooseFromOurSuggestedMealController.getAiSuggestedMealsApi();
              },
            );
          }),
          UIHelper.verticalSpace(32.h),

          ///Section : ------------///Hearty & Comforting///----------------
          Obx(() {
            return MealPlanTypeWidget(
              mealPlanType: "Hearty & Comforting",
              itemImagePath: chooseFromOurSuggestedMealController.currentTabImageUrl.value.isNotEmpty 
                  ? chooseFromOurSuggestedMealController.currentTabImageUrl.value 
                  : Assets.images.omletEgg.path,
              itemsList: chooseFromOurSuggestedMealController.heartyAndConfortingItemsList,
              retryOnTap: (){
                chooseFromOurSuggestedMealController.getAiSuggestedMealsApi();
              },
            );
          }),
          UIHelper.verticalSpace(32.h),
        ],
      ),
    );
  }
}
