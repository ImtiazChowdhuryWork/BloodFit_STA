import 'package:bloodfit/custom_widgets/custom_shimmer_effect.dart';
import 'package:bloodfit/features/choose_from_our_suggested_meals/presentation/widgets/food_item_showing_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../../constants/text_font_style.dart';
import '../../../../helper/ui_helpers.dart';
import '../../data/controller/choose_from_our_suggested_meal_controller.dart';

class RecentlySelectedMealsWidget extends StatelessWidget {
  RecentlySelectedMealsWidget({super.key});

  final ChooseFromOurSuggestedMealController
  chooseFromOurSuggestedMealController =
      Get.find<ChooseFromOurSuggestedMealController>();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Previously Selected Meals",
          style: TextFontStyle.headline18w500cfefefeStylePoppins,
        ),
        UIHelper.verticalSpace(32.h),

        Obx(() {
          // 1️⃣ Show loader while API is running
          if (chooseFromOurSuggestedMealController
              .isPreviouslySelectedMealsLoading
              .value) {
            return SizedBox(
              height: 120.h,
              width: 1.sw,
              child: ListView.separated(
                itemCount: 2,
                scrollDirection: Axis.horizontal,
                separatorBuilder: (context, index) =>
                    UIHelper.horizontalSpace(10.w),
                itemBuilder: (context, index) {
                  return CustomShimmerEffect(
                    height: 120.h,
                    width: 0.4.sw,

                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          CustomShimmerEffect(
                            height: 50.h,
                            width: 50.w,
                            isShapUsed: true,
                            shapType: BoxShape.circle,
                          ),
                          UIHelper.verticalSpace(10.h),
                          CustomShimmerEffect(height: 10.h, width: 0.3.sw),
                          UIHelper.verticalSpace(10.h),

                          Row(
                            children: [
                              CustomShimmerEffect(height: 10.h, width: 0.10.sw),
                              UIHelper.horizontalSpace(10.w),
                              CustomShimmerEffect(height: 10.h, width: 0.10.sw),
                            ],
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            );
          }

          final meals =
              chooseFromOurSuggestedMealController.breakfastRecentChosenMeals;

          // 2️⃣ Empty state (after loading finishes)
          if (meals.isEmpty) {
            return Text(
              "No recent meal available!",
              textAlign: TextAlign.center,
              style: TextFontStyle.headline14w600cc6c6c6StylePoppins,
            );
          }

          // 3️⃣ Data state
          return SizedBox(
            width: 1.sw,
            height: 250.h,
            child: ListView.separated(
              shrinkWrap: true,
              
              itemCount: meals.length,
              scrollDirection: Axis.horizontal,
              separatorBuilder: (context,index)=> UIHelper.horizontalSpace(15.w),
              itemBuilder: (context, index) {
                final meal = meals[index];
            
                return FoodItemShowingWidget(
                  isSelected: true,
                  onChanged: (value) {},
                  itemImagePath: meal.image ?? '',
                  itemTitle: meal.mealName ?? 'N/A',
                  kcalValue: meal.kcal ?? 0,
                  personValue: meal.v ?? 1,
                );
              },
            ),
          );
        }),
      ],
    );
  }
}
