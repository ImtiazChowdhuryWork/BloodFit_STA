import 'package:bloodfit/features/choose_from_our_suggested_meals/data/controller/choose_from_our_suggested_meal_controller.dart';
import 'package:bloodfit/features/choose_from_our_suggested_meals/presentation/widgets/food_item_showing_widget.dart';
import 'package:bloodfit/features/home/data/model/get_todays_meal_model.dart';
import 'package:bloodfit/helper/logger_util.dart';
import 'package:bloodfit/routes/routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../../custom_widgets/custom_shimmer_effect.dart';
import '../../../../helper/ui_helpers.dart';

class MealPlanTypeWidget extends StatelessWidget {
  final String mealPlanType;
  final String itemImagePath;
  final void Function()? retryOnTap;
  final RxList<String> itemsList;

  MealPlanTypeWidget({
    super.key,
    required this.mealPlanType,
    required this.itemImagePath,
    this.retryOnTap,
    required this.itemsList,
  });

  final ChooseFromOurSuggestedMealController controller =
      Get.find<ChooseFromOurSuggestedMealController>();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 1.sw,
          height: 250.h,
          child: ListView.separated(
            itemCount: 10,
            scrollDirection: Axis.horizontal,
            separatorBuilder: (_, __) => UIHelper.horizontalSpace(16.w),
            itemBuilder: (context, index) {
              return FoodItemShowingWidget(
                onTap: () {
                  LoggerUtils.debug(
                    "Navigate to Selected Item Description Screen",
                  );
                  Get.toNamed(Routes.mealDetailscreen);
                },
                isSelected: true,
                onChanged: (value) {},
                isImageLinkBase64: false,
                itemImagePath: itemImagePath,
                itemTitle: 'test name',
                kcalValue: 0,
                servingValue: 0,
              );
            },
          ),
        ),
      ],
    );
  }
}
