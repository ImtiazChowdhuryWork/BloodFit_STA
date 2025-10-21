import 'package:bloodfit/features/meal_plan_feature_options/presentation/widgets/meal_plan_calender_shape_widget.dart';
import 'package:bloodfit/gen/colors.gen.dart';
import 'package:bloodfit/helper/ui_helpers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../controllers/home_screen_controller.dart';

class MealPlanCalendarWidget extends StatelessWidget {
  MealPlanCalendarWidget({super.key});

  final HomeScreenController homeScreenController =
      Get.find<HomeScreenController>();

  @override
  Widget build(BuildContext context) {
    // Normalize current date to remove time component
    final DateTime today = DateTime.now();
    final DateTime currentDateOnly = DateTime(
      today.year,
      today.month,
      today.day,
    );

    return SizedBox(
      width: 1.sw,
      height: 100.h,
      child: ListView.separated(
        itemCount: homeScreenController.allDays.length,
        scrollDirection: Axis.horizontal,
        separatorBuilder: (context, index) => UIHelper.horizontalSpace(10.w),
        itemBuilder: (context, index) {
          final data = homeScreenController.allDays[index];

          // Normalize day for comparison
          final DateTime dataDateOnly = DateTime(
            data.year,
            data.month,
            data.day,
          );

          final bool isToday = dataDateOnly == currentDateOnly;

          return MealPlanCalenderShapeWidget(
            dayName: data.dayName.substring(0, 3),
            date: data.day.toString(),
            backgroundColor: isToday
                ? AppColors.cb20000
                : AppColors.scaffoldBackgroundColor,
          );
        },
      ),
    );
  }
}
