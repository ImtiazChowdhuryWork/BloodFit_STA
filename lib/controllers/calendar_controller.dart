// import 'package:bloodfit/extensions/date_time_extension.dart';
// import 'package:get/get.dart';
// import '../utils/calander_logic.dart';

// class CalandarController extends GetxController {
//   /// List of all generated calendar days
//   final allCalendarDays = <CalendarDay>[].obs;

//   /// Currently selected date in the calendar (if any)
//   final selectedCalendarDate = Rx<DateTime?>(null);

//   /// Calendar logic handler
//   late final CalendarDateManager calendarManager;

//   /// Define the calendar year range
//   final int calendarStartYear = 2025;
//   final int calendarEndYear = 2040;

//   @override
//   void onInit() {
//     super.onInit();
//     calendarManager = CalendarDateManager(
//       startYear: calendarStartYear,
//       endYear: calendarEndYear,
//     );
//     _loadCalendarDays();
//   }

//   void _loadCalendarDays() {
//     allCalendarDays.value = calendarManager.generateAllDays();
//   }

//   /// Handles tap selection on a calendar date
//   void toggleCalendarDateSelection(DateTime tappedDate) {
//     final normalizedDate = tappedDate.dateOnly;

//     // Toggle off if the same date is tapped again
//     if (selectedCalendarDate.value?.isSameCalendarDay(normalizedDate) ??
//         false) {
//       selectedCalendarDate.value = null;
//     } else {
//       selectedCalendarDate.value = normalizedDate;
//     }

//     // Force UI update
//     update();
//   }
// }

import 'package:bloodfit/extensions/date_time_extension.dart';
import 'package:bloodfit/extensions/week_days_extension.dart';
import 'package:get/get.dart';
import '../utils/calander_logic.dart';
import '../constants/app_enums.dart';

class CalandarController extends GetxController {
  /// List of all generated calendar days
  final allCalendarDays = <CalendarDay>[].obs;

  /// Currently selected date in the calendar (if any)
  final selectedCalendarDate = Rx<DateTime?>(null);

  /// Calendar logic handler
  late final CalendarDateManager calendarManager;

  /// Define the calendar year range
  final int calendarStartYear = 2025;
  final int calendarEndYear = 2040;

  @override
  void onInit() {
    super.onInit();
    calendarManager = CalendarDateManager(
      startYear: calendarStartYear,
      endYear: calendarEndYear,
    );
    _loadCalendarDays();
  }

  void _loadCalendarDays() {
    allCalendarDays.value = calendarManager.generateAllDays();
  }

  /// Handles tap selection on a calendar date
  void toggleCalendarDateSelection(DateTime tappedDate) {
    final normalizedDate = tappedDate.dateOnly;

    // Toggle off if the same date is tapped again
    if (selectedCalendarDate.value?.isSameCalendarDay(normalizedDate) ??
        false) {
      selectedCalendarDate.value = null;
    } else {
      selectedCalendarDate.value = normalizedDate;
    }

    // Force UI update
    update();
  }

  // Current date properties - accessible like currentDate.day, currentDate.week, etc.

  /// Get current day (1-31)
  int get day => DateTime.now().day;

  /// Get current week (list of 7 days starting from Monday)
  List<DateTime> get week {
    final now = DateTime.now();
    final firstDayOfWeek = now.subtract(Duration(days: now.weekday % 7));
    return List.generate(7, (i) => firstDayOfWeek.add(Duration(days: i)));
  }

  /// Get current month (DateTime object representing first day of current month)
  DateTime get month => DateTime(DateTime.now().year, DateTime.now().month, 1);

  /// Get current year
  int get year => DateTime.now().year;

  /// Get current month name
  String get monthName {
    final months = [
      'January',
      'February',
      'March',
      'April',
      'May',
      'June',
      'July',
      'August',
      'September',
      'October',
      'November',
      'December',
    ];
    return months[DateTime.now().month - 1];
  }

  /// Get current weekday name using your WeekDayEnum extension
  String get weekdayName {
    final weekdayIndex = DateTime.now().weekday;
    // Convert DateTime weekday (1-7 where 1=Monday) to your WeekDayEnum
    final weekDayEnum = _convertToWeekDayEnum(weekdayIndex);
    return weekDayEnum.dayNames;
  }

  /// Helper method to convert DateTime weekday to WeekDayEnum
  WeekDayEnum _convertToWeekDayEnum(int dateTimeWeekday) {
    switch (dateTimeWeekday) {
      case 1:
        return WeekDayEnum.mon;
      case 2:
        return WeekDayEnum.tue;
      case 3:
        return WeekDayEnum.wed;
      case 4:
        return WeekDayEnum.thu;
      case 5:
        return WeekDayEnum.fri;
      case 6:
        return WeekDayEnum.sat;
      case 7:
        return WeekDayEnum.sun;
      default:
        return WeekDayEnum.mon;
    }
  }

  /// Get the full current DateTime object
  DateTime get dateTime => DateTime.now();

  /// Bonus: Get weekday name for any DateTime using your extension
  String getWeekdayName(DateTime date) {
    final weekDayEnum = _convertToWeekDayEnum(date.weekday);
    return weekDayEnum.dayNames;
  }

  /// Bonus: Get short weekday name (first 3 letters)
  String get shortWeekdayName => weekdayName.substring(0, 3);
}
