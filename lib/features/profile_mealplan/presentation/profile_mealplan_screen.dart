import 'dart:developer';

import 'package:bloodfit/custom_widgets/custom_elevated_button.dart';
import 'package:bloodfit/features/profile_mealplan/presentation/widgets/search_and_select_widget.dart';
import 'package:bloodfit/features/profile_mealplan/presentation/widgets/selectable_wrap_box_widget.dart';
import 'package:bloodfit/helper/ui_helpers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../constants/app_list.dart';
import '../../../constants/text_font_style.dart';
import '../../../controllers/meal_plan_screen_controller.dart';
import '../../../custom_widgets/custom_drop_down_field_widget.dart';
import '../../../custom_widgets/go_back_widget.dart';
import '../../../gen/colors.gen.dart';

class ProfileMealplanScreen extends StatelessWidget {
  ProfileMealplanScreen({super.key});

  final MealPlanScreenController controller =
      Get.find<MealPlanScreenController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: AppColors.scaffoldBackgroundColor,
        centerTitle: true,
        automaticallyImplyLeading: false,
        leading: const CustomBackButton(),
        title: FittedBox(
          fit: BoxFit.scaleDown,
          child: Text(
            "Mealplan",
            style: TextFontStyle.headline24w700cFFFFFFStylePoppins.copyWith(
              fontSize: 22.sp,
            ),
          ),
        ),
      ),

      body: SingleChildScrollView(
        padding: EdgeInsets.all(UIHelper.kDefaulutPadding()),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// Section: Pick Your Diet Type
            Obx(
              () => CustomDropdownField<String>(
                labelText: "What's Your Desired Diet Type?",
                hintText: "Select your desired diet type",
                value: controller.selectedDietType.value,
                onChanged: (val) => controller.setSelectedDietType(val),
                items: AppList.dietTypesList
                    .map(
                      (dietType) => DropdownMenuItem(
                        value: dietType,
                        child: Text(
                          dietType,
                          style: TextFontStyle.headline14w400cfefefeStylePoppins
                              .copyWith(fontSize: 13.sp),
                        ),
                      ),
                    )
                    .toList(),
              ),
            ),
            UIHelper.verticalSpace(24.h),

            /// Section: --------------///Weekly Meal Plan///----------------
            SelectableWrapBoxWidget(
              title: "Mealplan Days (Any Three)",
              items: AppList.daysOfWeekList,
              selectedItems: controller.selectedMealplanDays,
              maxSelectable: 3,
              onTap: (day) {
                print("Tapped: $day");
              },
            ),
            UIHelper.verticalSpace(24.h),

            /// Section: --------------///Cheat Day///----------------
            SelectableWrapBoxWidget(
              title: "Cheat Day (Any One)",
              items: AppList.daysOfWeekList,
              selectedItems: controller.selectedCheatDay,
              maxSelectable: 1,
              onTap: (day) {
                log("Tapped: $day");
              },
            ),
            UIHelper.verticalSpace(24.h),

            ///Section : -----------///Meal Allergies///-------------
            SearchAndSelectWidget(
              title: "Allergies",
              allItems: AppList.mealAllergiesList.obs,
              selectedItems: controller.selectedAllergicFoods,
              searchQuery: controller.allergicFoodSearchQuery,
              onItemToggle: controller.toggleAllergicFoodSelection,
              onItemRemove: controller.removeAllergicFood,
            ),

            ///Section : -----------///Meal Allergies///-------------
            SearchAndSelectWidget(
              title: "Dislikes",
              allItems: AppList.dislikedFoodList.obs,
              selectedItems: controller.selectedDislikedFoods,
              searchQuery: controller.dislikeFoodSearchQuery,
              onItemToggle: controller.toggleDislikedFoodSelection,
              onItemRemove: controller.removeDislikedFood,
            ),
            UIHelper.verticalSpace(24.h),

            ///Section : ---------///Button -> Svae Changes///------------
            CustomElevatedButton(
              onTap: () {
                log("Button Taped -> Save Changes Button Taped!");
              },
              borderRadius: 24.r,
              buttonTitle: "Save Changes",
            ),
            UIHelper.verticalSpace(24.h),
          ],
        ),
      ),
    );
  }
}
