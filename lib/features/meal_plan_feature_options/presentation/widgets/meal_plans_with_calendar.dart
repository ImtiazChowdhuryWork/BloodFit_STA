import 'package:bloodfit/controllers/profile_screen_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../custom_widgets/custom_calender_widget.dart';
import '../../../../custom_widgets/meal_plan_calendar_widget.dart';

class MealPlansWithCalendar extends StatelessWidget {
  MealPlansWithCalendar({super.key});

  final ProfileScreenController profileScreenController =
      Get.find<ProfileScreenController>();

  @override
  Widget build(BuildContext context) {
    return Column(children: [MealPlanCalendarWidget()]);
  }
}
