// import 'package:bloodfit/features/choose_from_our_suggested_meals/data/controller/choose_from_our_suggested_meal_controller.dart';
// import 'package:bloodfit/features/choose_from_our_suggested_meals/presentation/widgets/food_item_showing_widget.dart';
// import 'package:bloodfit/features/choose_from_our_suggested_meals/presentation/widgets/show_meal_plan_tracker_snackbar.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:get/get.dart';

// import '../../../../constants/text_font_style.dart';
// import '../../../../helper/ui_helpers.dart';

// class MealPlanTypeWidget extends StatelessWidget {
//   final String mealPlanType;
//   final bool isSelected;
//   final String itemTitle;
//   final String itemImagePath;
//   final int kcalValue;
//   final int servingValue;

//   MealPlanTypeWidget({
//     super.key,
//     required this.mealPlanType,
//     required this.isSelected,
//     required this.itemImagePath,
//     required this.kcalValue,
//     required this.servingValue,
//     required this.itemTitle,
//   });

//   final ChooseFromOurSuggestedMealController
//   chooseFromOurSuggestedMealController =
//       Get.find<ChooseFromOurSuggestedMealController>();

//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Text(
//           mealPlanType,
//           style: TextFontStyle.headline18w500cfefefeStylePoppins,
//         ),
//         UIHelper.verticalSpace(10.h),

//         SizedBox(
//           width: 1.sw,
//           height: 250.h,
//           child: ListView.separated(
//             itemCount: chooseFromOurSuggestedMealController
//                 .proteinPackedItemsList
//                 .length,
//             scrollDirection: Axis.horizontal,
//             separatorBuilder: (context, index) =>
//                 UIHelper.horizontalSpace(16.w),
//             itemBuilder: (context, index) {
//               return Obx(() {
//                 return FoodItemShowingWidget(
//                   isSelected: chooseFromOurSuggestedMealController
//                       .isCheckBoxSelectedList[index]
//                       .value,
//                   onChanged: (value) {
//                     chooseFromOurSuggestedMealController
//                         .setIsCheckBoxSelectedValue(index, value ?? false);
//                   },
//                   itemImagePath: itemImagePath,
//                   itemTitle:
//                       chooseFromOurSuggestedMealController
//                           .proteinPackedItemsList[index]
//                           .mealName ??
//                       '',
//                   kcalValue:
//                       chooseFromOurSuggestedMealController
//                           .proteinPackedItemsList[index]
//                           .totalCalories ??
//                       0,
//                   servingValue:
//                       chooseFromOurSuggestedMealController
//                           .proteinPackedItemsList[index]
//                           .numberOfServings ??
//                       0,
//                 );
//               });
//             },
//           ),
//         ),

//         ///Section : ----------///BuildMealPlanSnackBar///----------------
//         Obx(() {
//           bool anySelected = chooseFromOurSuggestedMealController
//               .isCheckBoxSelectedList
//               .any((rxBool) => rxBool.value);

//           if (anySelected) {
//             WidgetsBinding.instance.addPostFrameCallback((_) {
//               showMealPlanTracker();
//             });
//           }

//           return SizedBox.shrink();
//         }),
//       ],
//     );
//   }
// }


import 'package:bloodfit/features/choose_from_our_suggested_meals/data/controller/choose_from_our_suggested_meal_controller.dart';
import 'package:bloodfit/features/choose_from_our_suggested_meals/presentation/widgets/food_item_showing_widget.dart';
import 'package:bloodfit/features/choose_from_our_suggested_meals/presentation/widgets/show_meal_plan_tracker_snackbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../../constants/text_font_style.dart';
import '../../../../custom_widgets/custom_shimmer_effect.dart';
import '../../../../helper/ui_helpers.dart';

class MealPlanTypeWidget extends StatelessWidget {
  final String mealPlanType;
  final String itemImagePath;

  MealPlanTypeWidget({
    super.key,
    required this.mealPlanType, required this.itemImagePath,
  });

  final ChooseFromOurSuggestedMealController controller =
      Get.find<ChooseFromOurSuggestedMealController>();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          mealPlanType,
          style: TextFontStyle.headline18w500cfefefeStylePoppins,
        ),
        UIHelper.verticalSpace(10.h),

        Obx(() {
          /// 1️⃣ Loader state
          if (controller.isAiSuggestedMealsLoading.value) {
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

          /// Pick correct list
          final items = controller.proteinPackedItemsList;

          /// 2️⃣ Empty state (after loading)
          if (items.isEmpty) {
            return SizedBox(
              height: 120.h,
              child: Center(
                child: Text(
                  'No meals available',
                  style: TextFontStyle.headline14w600cc6c6c6StylePoppins,
                ),
              ),
            );
          }

          /// 3️⃣ Data state
          return SizedBox(
            width: 1.sw,
            height: 250.h,
            child: ListView.separated(
              itemCount: items.length,
              scrollDirection: Axis.horizontal,
              separatorBuilder: (_, __) =>
                  UIHelper.horizontalSpace(16.w),
              itemBuilder: (context, index) {
                return Obx(() {
                  return FoodItemShowingWidget(
                    isSelected:
                        controller.isCheckBoxSelectedList[index].value,
                    onChanged: (value) {
                      controller.setIsCheckBoxSelectedValue(
                        index,
                        value ?? false,
                      );
                    },
                    itemImagePath: itemImagePath,
                    itemTitle: items[index].mealName ?? '',
                    kcalValue: items[index].totalCalories ?? 0,
                    servingValue: items[index].numberOfServings ?? 0,
                  );
                });
              },
            ),
          );
        }),

        /// Snackbar trigger — SAFE version
        Obx(() {
          final anySelected = controller.isCheckBoxSelectedList
              .any((e) => e.value);

          if (!anySelected) return const SizedBox.shrink();

          WidgetsBinding.instance.addPostFrameCallback((_) {
            showMealPlanTracker();
          });

          return const SizedBox.shrink();
        }),
      ],
    );
  }
}
