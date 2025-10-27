import 'dart:developer';

import 'package:bloodfit/constants/text_font_style.dart';
import 'package:bloodfit/controllers/calendar_controller.dart';
import 'package:bloodfit/controllers/work_out_screen_controller.dart';
import 'package:bloodfit/gen/colors.gen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../helper/ui_helpers.dart';
import '../../home/presentation/widgets/app_bar_section_widget.dart';
import 'widgets/elite_uesr_workout_calender.dart';

class WorkOutScreen extends StatelessWidget {
  final CalandarController calandarController = Get.find<CalandarController>();
  final WorkOutScreenController workOutScreenController =
      Get.find<WorkOutScreenController>();
  WorkOutScreen({super.key});

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
              AppBarSectionWidget(),
              UIHelper.verticalSpace(20.h),

              Text(
                "Your Workouts This Week",
                style: TextFontStyle.headline20w500cfefefeStylePoppins,
              ),
              UIHelper.verticalSpace(20.h),

              ///Section : -------------------///Workout Calendar///-------------
              Obx(() {
                final selectedDate =
                    calandarController.selectedCalendarDate.value;

                return SizedBox(
                  width: 1.sw,
                  height: 100.h,
                  child: ListView.separated(
                    itemCount: calandarController.week.length,
                    scrollDirection: Axis.horizontal,
                    separatorBuilder: (context, index) =>
                        UIHelper.horizontalSpace(8.w),
                    itemBuilder: (context, index) {
                      final day = calandarController.week[index];
                      final weekdayName = calandarController.getWeekdayName(
                        day,
                      );

                      // In your WorkOutScreen itemBuilder:
                      return EliteUserWorkoutCalender(
                        onTap: () {
                          log("Day : $weekdayName");
                          log("Date : $day");
                          log("Month : ${day.month}");
                          log("Month : ${day.year}");
                          workOutScreenController.handleDayTap(
                            date: day,
                            onCalendarSelection: () => calandarController
                                .toggleCalendarDateSelection(day),
                          );
                        },
                        height: 44.h,
                        width: 44.w,
                        backgroundColor: AppColors.c111111,
                        dayName: weekdayName.substring(0, 3),
                        isCheatDay: true,
                        isCalorieTaskCompleted: false,
                        day: day.day,
                        month: day.month,
                        year: day.year,
                        isToday: workOutScreenController.isDateToday(day),
                        isSelected: workOutScreenController.isDateSelected(
                          date: day,
                          selectedDate: selectedDate,
                        ),
                        isAnyDateSelected:
                            selectedDate !=
                            null, // This is the key for initial state
                      );
                    },
                  ),
                );
              }),
            ],
          ),
        ),
      ),
    );
  }
}
