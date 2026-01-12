import 'package:bloodfit/controllers/choose_from_our_suggested_meal_controller.dart';
import 'package:bloodfit/features/choose_from_our_suggested_meals/presentation/widgets/food_item_showing_widget.dart';
import 'package:bloodfit/features/choose_from_our_suggested_meals/presentation/widgets/show_meal_plan_tracker_snackbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../../constants/text_font_style.dart';
import '../../../../helper/ui_helpers.dart';

class MealPlanTypeWidget extends StatelessWidget {
  final String mealPlanType;
  final bool isSelected;
  final String itemImagePath;
  final String itemTitle;
  final double kcalValue;
  final double personValue;
  MealPlanTypeWidget({
    super.key,
    required this.mealPlanType,
    required this.isSelected,
    required this.itemImagePath,
    required this.itemTitle,
    required this.kcalValue,
    required this.personValue,
  });

  final ChooseFromOurSuggestedMealController
  chooseFromOurSuggestedMealController =
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

        SizedBox(
          width: 1.sw,
          height: 250.h,
          child: ListView.separated(
            itemCount: 10,
            scrollDirection: Axis.horizontal,
            separatorBuilder: (context, index) =>
                UIHelper.horizontalSpace(16.w),
            itemBuilder: (context, index) {
              return Obx(() {
                return FoodItemShowingWidget(
                  isSelected: chooseFromOurSuggestedMealController
                      .isCheckBoxSelectedList[index]
                      .value,
                  onChanged: (value) {
                    chooseFromOurSuggestedMealController
                        .setIsCheckBoxSelectedValue(index, value ?? false);
                  },
                  itemImagePath: itemImagePath,
                  itemTitle: itemTitle,
                  kcalValue: kcalValue,
                  personValue: personValue,
                );
              });
            },
          ),
        ),

        ///Section : ----------///BuildMealPlanSnackBar///----------------
        Obx(() {
          bool anySelected = chooseFromOurSuggestedMealController
              .isCheckBoxSelectedList
              .any((rxBool) => rxBool.value);

          if (anySelected) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              showMealPlanTracker();
            });
          }

          return SizedBox.shrink();
        }),
      ],
    );
  }
}
