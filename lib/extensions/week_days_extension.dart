import '../constants/app_enums.dart';

extension WeekDayEnumExtension on WeekDayEnum {
  String get dayNames {
    switch (this) {
      case WeekDayEnum.sat:
        return "Saturday";
      case WeekDayEnum.sun:
        return "Sunday";
      case WeekDayEnum.mon:
        return "Monday";
      case WeekDayEnum.tue:
        return "Tuesday";
      case WeekDayEnum.wed:
        return "Wednesday";
      case WeekDayEnum.thu:
        return "Thursday";
      case WeekDayEnum.fri:
        return "Friday";
    }
  }
}
