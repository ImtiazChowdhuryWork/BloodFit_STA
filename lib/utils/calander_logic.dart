import 'package:intl/intl.dart';

/// Represents a single day in the calendar
class CalendarDay {
  final String dayName;
  final int day;
  final int month;
  final int year;

  CalendarDay({
    required this.dayName,
    required this.day,
    required this.month,
    required this.year,
  });

  String get formatted => '$dayName - $day/$month/$year';
}

/// A clean, structured calendar date generator
class CalendarDateManager {
  final int startYear;
  final int endYear;

  CalendarDateManager({required this.startYear, required this.endYear}) {
    if (endYear < startYear) {
      throw ArgumentError('endYear must be >= startYear');
    }
  }

  /// Today's date
  DateTime get today => DateTime.now();

  int get currentDay => today.day;
  int get currentMonth => today.month;
  int get currentYear => today.year;

  /// Total days in a month
  int daysInMonth(int year, int month) => DateTime(year, month + 1, 0).day;

  /// Generate all days across the year range
  List<CalendarDay> generateAllDays() {
    final List<CalendarDay> allDays = [];
    final formatter = DateFormat('EEEE');

    for (int year = startYear; year <= endYear; year++) {
      for (int month = 1; month <= 12; month++) {
        final totalDays = daysInMonth(year, month);
        for (int day = 1; day <= totalDays; day++) {
          final date = DateTime(year, month, day);
          allDays.add(
            CalendarDay(
              dayName: formatter.format(date),
              day: day,
              month: month,
              year: year,
            ),
          );
        }
      }
    }

    return allDays;
  }

  /// Generate days of a specific month
  List<CalendarDay> generateMonthDays(int year, int month) {
    final totalDays = daysInMonth(year, month);
    final formatter = DateFormat('EEEE');

    return List.generate(totalDays, (i) {
      final date = DateTime(year, month, i + 1);
      return CalendarDay(
        dayName: formatter.format(date),
        day: date.day,
        month: date.month,
        year: date.year,
      );
    });
  }

  /// List of years in the range
  List<int> get availableYears =>
      List.generate(endYear - startYear + 1, (i) => startYear + i);
}
