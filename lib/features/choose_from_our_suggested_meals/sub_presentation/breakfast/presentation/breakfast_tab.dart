import 'package:bloodfit/gen/assets.gen.dart';
import 'package:bloodfit/helper/ui_helpers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../constants/text_font_style.dart';
import '../../../presentation/widgets/food_item_showing_widget.dart';
import '../../../presentation/widgets/meal_plan_type_widget.dart';

class BreakfastTab extends StatelessWidget {
  final VoidCallback? onMealSelected;
  const BreakfastTab({super.key, this.onMealSelected});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ///Section : ------------///Previously Selected Meals///----------------
          // MealPlanTypeWidget(
          //   mealPlanType: "Previously Selected Meals",
          //   isSelected: true,
          //   itemImagePath: Assets.images.omletEgg.path,
          //   itemTitle: "Avocado Toast and Poached Eggs",
          //   kcalValue: 302,
          //   personValue: 1,
          // ),
          Text(
            "Previously Selected Meals",
            style: TextFontStyle.headline18w500cfefefeStylePoppins,
          ),
          UIHelper.verticalSpace(32.h),

          FoodItemShowingWidget(
            isSelected: true,
            onChanged: (value) {},
            itemImagePath: Assets.images.appLogo.path,
            itemTitle: "TEst",
            kcalValue: 110,
            personValue: 231,
          ),

          ///Section : ------------///Protein-Packed ///----------------
          MealPlanTypeWidget(
            mealPlanType: "Protein-Packed",
            isSelected: true,
            itemImagePath: Assets.images.omletEgg.path,
            itemTitle: "Avocado Toast and Poached Eggs",
            kcalValue: 302,
            personValue: 1,
          ),
          UIHelper.verticalSpace(32.h),

          ///Section : ------------///Light & Fresh ///----------------
          MealPlanTypeWidget(
            mealPlanType: "Light & Fresh",
            isSelected: true,
            itemImagePath: Assets.images.omletEgg.path,
            itemTitle: "Avocado Toast and Poached Eggs",
            kcalValue: 302,
            personValue: 1,
          ),
          UIHelper.verticalSpace(32.h),

          ///Section : ------------///Hearty & Comforting///----------------
          MealPlanTypeWidget(
            mealPlanType: "Hearty & Comforting",
            isSelected: true,
            itemImagePath: Assets.images.omletEgg.path,
            itemTitle: "Avocado Toast and Poached Eggs",
            kcalValue: 302,
            personValue: 1,
          ),
          UIHelper.verticalSpace(32.h),
        ],
      ),
    );
  }
}
