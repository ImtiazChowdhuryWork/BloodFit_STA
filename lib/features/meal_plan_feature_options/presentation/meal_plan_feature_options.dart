import 'dart:developer';

import 'package:bloodfit/controllers/enums_controller.dart';
import 'package:bloodfit/features/meal_plan_feature_options/presentation/widgets/meal_plans_with_calendar.dart';
import 'package:bloodfit/gen/colors.gen.dart';
import 'package:bloodfit/helper/ui_helpers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../gen/assets.gen.dart';
import '../../../routes/routes.dart';
import '../../home/presentation/widgets/app_bar_section_widget.dart';
import '../../home/presentation/widgets/build_meal_plan_icon_widget.dart';

class MealPlanFeatureOptions extends StatelessWidget {
  MealPlanFeatureOptions({super.key});

  final EnumsController enumsController = Get.find<EnumsController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldBackgroundColor,

      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(UIHelper.kDefaulutPadding()),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ///Section : ---------------------///AppLogo///-----------
              ///Section : ---------------------///Notification///-----------
              ///Section : ---------------------///Profile///-----------
              AppBarSectionWidget(),
              UIHelper.verticalSpace(20.h),

              Obx(() {
                return enumsController.isMealPlanAvailable
                    ? MealPlansWithCalendar()
                    : BuildMealPlanWidget(
                        onTap: () {
                          log("Button Taped : Get Started !");
                          log(
                            "Is Meal Plan Available : ${enumsController.isMealPlanAvailable}",
                          );
                          Get.toNamed(Routes.chooseFromOurSuggestedMealsScreen);
                        },
                        showSectionTitle: true,
                        sectionTitle: "Meal Plan",
                        buttonTitle: "Get Started",
                        positionTop: -37.h,
                        positionRight: -20.w,
                        imageIconPath: Assets.icons.disIcon,
                        title: "Build Your Daily Meals",
                        subTitle:
                            "Select Your Breakfast, Lunch, And Dinner From Personalized Meal Suggestions",
                      );
              }),
              UIHelper.verticalSpace(24.h),
            ],
          ),
        ),
      ),
    );
  }
}
