import 'package:bloodfit/controllers/enums_controller.dart';
import 'package:bloodfit/features/home/data/controller/home_screen_controller.dart';
import 'package:bloodfit/gen/colors.gen.dart';
import 'package:bloodfit/helper/ui_helpers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../home/presentation/widgets/app_bar_section_widget.dart';
import '../../home/presentation/widgets/show_selected_meals_or_build_meal_plan_widget.dart';

class MealPlanFeatureOptions extends StatelessWidget {
  MealPlanFeatureOptions({super.key});

  final EnumsController enumsController = Get.find<EnumsController>();
  final HomeScreenController homeScreenController = Get.find<HomeScreenController>();

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

              ShowSelectedMealsOrBuildMealPlanWidget(),
              UIHelper.verticalSpace(24.h),
            ],
          ),
        ),
      ),
    );
  }
}
