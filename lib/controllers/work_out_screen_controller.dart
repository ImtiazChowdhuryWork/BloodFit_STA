import 'package:bloodfit/extensions/date_time_extension.dart';
import 'package:bloodfit/gen/colors.gen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class WorkOutScreenController extends GetxController {
  RxBool isExtraWorkoutVisible = false.obs;
  void setIsExtraWorkoutVisible({required bool newValue}) {
    isExtraWorkoutVisible.value = newValue;
  }

  RxBool isTapedOnCurrentDay = false.obs;
  final todayDate = DateTime.now().dateOnly;

  void setIsTapedOnCurrentDay({required bool newvalue}) {
    isTapedOnCurrentDay.value = newvalue;
  }

  /// Get background color based on date selection state
  Color getBackgroundColor({
    required DateTime date,
    required DateTime? selectedDate,
  }) {
    final isTodayDate = date.isSameCalendarDay(todayDate);
    final isSelectedDate = selectedDate?.isSameCalendarDay(date) ?? false;

    if (isSelectedDate) {
      // SELECTED DATE STYLING
      return AppColors.cb20000;
    } else if (isTodayDate && selectedDate == null) {
      // TODAY'S DATE STYLING (when no date is selected)
      return AppColors.cb20000;
    } else if (isTodayDate && selectedDate != null) {
      // TODAY'S DATE STYLING (when another date is selected)
      return AppColors.cd7d7d7;
    } else {
      // NORMAL DATE STYLING
      return AppColors.c111111;
    }
  }

  /// Check if date should be highlighted
  bool shouldHighlightDate({
    required DateTime date,
    required DateTime? selectedDate,
  }) {
    final isTodayDate = date.isSameCalendarDay(todayDate);
    final isSelectedDate = selectedDate?.isSameCalendarDay(date) ?? false;

    return isSelectedDate || (isTodayDate && selectedDate == null);
  }

  /// Check if date is selected
  bool isDateSelected({
    required DateTime date,
    required DateTime? selectedDate,
  }) {
    return selectedDate?.isSameCalendarDay(date) ?? false;
  }

  /// Check if date is today
  bool isDateToday(DateTime date) {
    return date.isSameCalendarDay(todayDate);
  }

  /// Handle day tap with all logic
  void handleDayTap({
    required DateTime date,
    required Function() onCalendarSelection,
  }) {
    // Handle tap on current day
    if (isDateToday(date)) {
      setIsTapedOnCurrentDay(newvalue: true);

      // Optional: Reset after some time
      Future.delayed(Duration(seconds: 2), () {
        setIsTapedOnCurrentDay(newvalue: false);
      });
    }

    // Select the day in calendar
    onCalendarSelection();
  }
}
