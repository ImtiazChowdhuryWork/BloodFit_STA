extension DateTimeComparison on DateTime {
  /// Returns a copy of this DateTime without time information (removes hours, minutes, seconds).
  DateTime get dateOnly => DateTime(year, month, day);

  /// Returns true if both DateTimes represent the same calendar day.
  bool isSameCalendarDay(DateTime other) =>
      year == other.year && month == other.month && day == other.day;
}
