import 'package:bloodfit/extensions/date_time_extension.dart';
import 'package:get/get.dart';
import '../utils/calander_logic.dart';

class HomeScreenController extends GetxController {
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
  }
}
