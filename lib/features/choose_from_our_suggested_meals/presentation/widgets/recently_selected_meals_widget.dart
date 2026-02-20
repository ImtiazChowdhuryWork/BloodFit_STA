

import 'package:bloodfit/features/choose_from_our_suggested_meals/presentation/widgets/food_item_showing_widget.dart';
import 'package:bloodfit/routes/routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:bloodfit/features/choose_from_our_suggested_meals/data/model/recent_chosen_meals_model.dart';

import '../../../../constants/text_font_style.dart';
import '../../../../custom_widgets/custom_shimmer_effect.dart';
import '../../../../helper/ui_helpers.dart';


class RecentlySelectedMealsWidget extends StatelessWidget {
  final RxList<Datum> meals;
  final RxBool isLoading;
  final String title;

  const RecentlySelectedMealsWidget({
    super.key,
    required this.meals,
    required this.isLoading,
    this.title = "Previously Selected Meals",
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextFontStyle.headline18w500cfefefeStylePoppins,
        ),
        UIHelper.verticalSpace(32.h),

        Obx(() {
          /// 1️⃣ Loading state (shimmer)
          if (isLoading.value) {
            return SizedBox(
              height: 120.h,
              width: 1.sw,
              child: ListView.separated(
                itemCount: 2,
                scrollDirection: Axis.horizontal,
                separatorBuilder: (_, __) =>
                    UIHelper.horizontalSpace(10.w),
                itemBuilder: (_, __) {
                  return CustomShimmerEffect(
                    height: 120.h,
                    width: 0.4.sw,
                    child: Padding(
                      padding: const EdgeInsets.all(8),
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

          /// 2️⃣ Empty state
          if (meals.isEmpty) {
            return Text(
              "No recent meal available!",
              textAlign: TextAlign.center,
              style: TextFontStyle.headline14w600cc6c6c6StylePoppins,
            );
          }

          /// 3️⃣ Data state
          return SizedBox(
            width: 1.sw,
            height: 250.h,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: meals.length,
              separatorBuilder: (_, __) =>
                  UIHelper.horizontalSpace(15.w),
              itemBuilder: (_, index) {
                final meal = meals[index];
                final mealID = meals[index].id;

                return FoodItemShowingWidget(
                  isSelected: true,
                  onChanged: (_) {},
                  onTap: (){
                    Get.toNamed(Routes.mealDetailscreen, arguments: {'mealID': mealID});
                  },
                  itemImagePath: meal.image ?? '',
                  itemTitle: meal.mealName ?? 'N/A',
                  kcalValue: meal.kcal ?? 0,
                  servingValue: meal.kcal ?? 1,
                );
              },
            ),
          );
        }),
      ],
    );
  }
}
