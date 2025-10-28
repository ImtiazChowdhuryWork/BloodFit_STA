import 'dart:developer';
import 'package:bloodfit/constants/app_list.dart';
import 'package:bloodfit/constants/text_font_style.dart';
import 'package:bloodfit/controllers/calendar_controller.dart';
import 'package:bloodfit/controllers/work_out_screen_controller.dart';
import 'package:bloodfit/features/work_out/presentation/widgets/current_day_workout_type_widget.dart';
import 'package:bloodfit/features/work_out/presentation/widgets/extra_workout_widget.dart';
import 'package:bloodfit/features/work_out/presentation/widgets/work_out_completed_bottom_sheet.dart';
import 'package:bloodfit/custom_widgets/workout_video_showing_widget.dart';
import 'package:bloodfit/gen/assets.gen.dart';
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
                        workoutImage: Assets.icons.absIcon,
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
              UIHelper.verticalSpace(24.h),

              ///Section : ----------///Current Day Workout Type Widget///-----------------
              Obx(() {
                final selectedDate =
                    calandarController.selectedCalendarDate.value;
                final isCurrentDaySelected =
                    selectedDate != null &&
                    workOutScreenController.isDateToday(selectedDate);

                if (selectedDate == null) {
                  // If no date is selected, show current day workout
                  return CurrentDayWorkoutTypeWidget();
                } else if (isCurrentDaySelected) {
                  // If selected date is current day
                  return workOutScreenController.isExtraWorkoutVisible.value
                      ? ExtraWorkoutWidget()
                      : CurrentDayWorkoutTypeWidget();
                } else {
                  // If selected date is not current day
                  final selectedDayName = calandarController.getWeekdayName(
                    selectedDate,
                  );
                  return Text(
                    "You're $selectedDayName Workouts",
                    style: TextFontStyle.headline20w500cfefefeStylePoppins,
                  );
                }
              }),
              UIHelper.verticalSpace(16.h),

              ///Section : -----------///Workout Video Showing Widget - ALWAYS VISIBLE///------------
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Obx(() {
                    final selectedDate =
                        calandarController.selectedCalendarDate.value;
                    final isCurrentDaySelected =
                        selectedDate != null &&
                        workOutScreenController.isDateToday(selectedDate);

                    // Show "Warmup" for current day, or specific workout type for other days
                    if (selectedDate == null || isCurrentDaySelected) {
                      return Text(
                        "Warmup",
                        style: TextFontStyle.headline18w500cfefefeStylePoppins,
                      );
                    } else {
                      final selectedDayName = calandarController.getWeekdayName(
                        selectedDate,
                      );
                      return Text(
                        "$selectedDayName Workout", // Or fetch actual workout type for that day
                        style: TextFontStyle.headline18w500cfefefeStylePoppins,
                      );
                    }
                  }),
                  UIHelper.verticalSpace(16.h),

                  ListView.separated(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: AppList.videoDetailsList.length,
                    separatorBuilder: (context, index) =>
                        UIHelper.verticalSpace(20.h),
                    itemBuilder: (context, index) {
                      var data = AppList.videoDetailsList[index];
                      return WorkoutVideoShowingWidget(
                        onPlayVideoPressed: () {
                          log("Button Taped : Play Video!");
                          showWorkOutCompletedBottomSheet();
                        },
                        onChanged: (value) {},
                        isChecked: index % 2 == 0 ? true : false,
                        imagePath: data.imagePath,
                        videoTitle: data.videoTitle,
                        duration: "03",
                        totalSets: 3,
                        totalCal: 500,
                      );
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
