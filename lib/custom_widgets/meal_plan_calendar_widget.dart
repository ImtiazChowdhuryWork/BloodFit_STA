// import 'package:bloodfit/extensions/date_time_extension.dart';
// import 'package:bloodfit/features/meal_plan_feature_options/presentation/widgets/meal_plan_calender_shape_widget.dart';
// import 'package:bloodfit/gen/colors.gen.dart';
// import 'package:bloodfit/helper/ui_helpers.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:get/get.dart';
// import '../controllers/calendar_controller.dart';

// class MealPlanCalendarWidget extends StatelessWidget {
//   MealPlanCalendarWidget({super.key});

//   final CalandarController calandarController = Get.find<CalandarController>();

//   @override
//   Widget build(BuildContext context) {
//     final todayDate = DateTime.now().dateOnly;

//     return Obx(
//       () => SizedBox(
//         width: 1.sw,
//         height: 100.h,
//         child: ListView.separated(
//           itemCount: calandarController.allCalendarDays.length,
//           scrollDirection: Axis.horizontal,
//           separatorBuilder: (context, index) => UIHelper.horizontalSpace(10.w),

//           itemBuilder: (context, index) {
//             final calendarDay = calandarController.allCalendarDays[index];
//             final currentDayDate = DateTime(
//               calendarDay.year,
//               calendarDay.month,
//               calendarDay.day,
//             );

//             final isTodayDate = currentDayDate.isSameCalendarDay(todayDate);
//             final isSelectedDate =
//                 calandarController.selectedCalendarDate.value?.isSameCalendarDay(
//                   currentDayDate,
//                 ) ??
//                 false;

//             // Container background color
//             final Color dayContainerColor = isSelectedDate
//                 ? AppColors.cb20000
//                 : isTodayDate &&
//                       calandarController.selectedCalendarDate.value != null &&
//                       !calandarController.selectedCalendarDate.value!
//                           .isSameCalendarDay(todayDate)
//                 ? AppColors.cd7d7d7
//                 : isTodayDate
//                 ? AppColors.cb20000
//                 : AppColors.scaffoldBackgroundColor;

//             // Highlight logic for inner circle
//             final bool shouldHighlight =
//                 isSelectedDate ||
//                 (isTodayDate &&
//                     calandarController.selectedCalendarDate.value == null);

//             // Date text color
//             final Color dateColor = isSelectedDate
//                 ? AppColors.cb20000
//                 : isTodayDate
//                 ? AppColors.cfefefe
//                 : AppColors.c999999;

//             // Day name text color
//             final Color dayNameColor = isSelectedDate
//                 ? AppColors.cFFFFFF
//                 : isTodayDate
//                 ? AppColors.c111111
//                 : AppColors.cfefefe;

//             return MealPlanCalenderShapeWidget(
//               onTap: () =>
//                   calandarController.toggleCalendarDateSelection(currentDayDate),
//               dayName: calendarDay.dayName.substring(0, 3),
//               date: calendarDay.day.toString(),
//               isToday: shouldHighlight,
//               backgroundColor: dayContainerColor,
//               dateColor: dateColor,
//               dayNameColor: dayNameColor,
//             );
//           },
//         ),
//       ),
//     );
//   }
// }

import 'package:bloodfit/extensions/date_time_extension.dart';
import 'package:bloodfit/features/meal_plan_feature_options/presentation/widgets/meal_plan_calender_shape_widget.dart';
import 'package:bloodfit/gen/colors.gen.dart';
import 'package:bloodfit/helper/ui_helpers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../controllers/calendar_controller.dart';

class MealPlanCalendarWidget extends StatefulWidget {
  MealPlanCalendarWidget({super.key});

  @override
  State<MealPlanCalendarWidget> createState() => _MealPlanCalendarWidgetState();
}

class _MealPlanCalendarWidgetState extends State<MealPlanCalendarWidget> {
  final ScrollController _scrollController = ScrollController();
  final CalandarController calandarController = Get.find<CalandarController>();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollToCurrentDay();
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollToCurrentDay() {
    final todayDate = DateTime.now().dateOnly;
    final todayIndex = calandarController.allCalendarDays.indexWhere((day) {
      final dayDate = DateTime(day.year, day.month, day.day);
      return dayDate.isSameCalendarDay(todayDate);
    });

    if (todayIndex != -1 && _scrollController.hasClients) {
      final itemWidth = 64.w; // Item width: 44.w (circle) + 20.w (padding)
      final spacingWidth = 10.w; // Separator spacing
      final totalItemWidth = itemWidth + spacingWidth;
      final scrollPosition = (todayIndex * totalItemWidth) - (MediaQuery.of(context).size.width / 2) + (itemWidth / 2);
      _scrollController.animateTo(
        scrollPosition.clamp(0, _scrollController.position.maxScrollExtent),
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final todayDate = DateTime.now().dateOnly;

    return Obx(() {
      // Force reactivity by observing the selected date
      final selectedDate = calandarController.selectedCalendarDate.value;

      return SizedBox(
        width: 1.sw,
        height: 100.h,
        child: ListView.separated(
          controller: _scrollController,
          itemCount: calandarController.allCalendarDays.length,
          scrollDirection: Axis.horizontal,
          separatorBuilder: (context, index) => UIHelper.horizontalSpace(10.w),
          itemBuilder: (context, index) {
            final calendarDay = calandarController.allCalendarDays[index];
            final currentDayDate = DateTime(
              calendarDay.year,
              calendarDay.month,
              calendarDay.day,
            );

            final isTodayDate = currentDayDate.isSameCalendarDay(todayDate);
            final isSelectedDate =
                selectedDate?.isSameCalendarDay(currentDayDate) ?? false;

            // SIMPLIFIED COLOR LOGIC:
            // Priority 1: Selected date
            // Priority 2: Today's date (when no other date is selected)
            // Priority 3: Normal date

            Color backgroundColor;
            Color dateColor;
            Color dayNameColor;
            bool shouldHighlight;

            if (isSelectedDate) {
              // SELECTED DATE STYLING
              backgroundColor = AppColors.cb20000;
              dateColor = AppColors.cb20000; // White text on red background
              dayNameColor = AppColors.cFFFFFF;
              shouldHighlight = true;
            } else if (isTodayDate && selectedDate == null) {
              // TODAY'S DATE STYLING (when no date is selected)
              backgroundColor = AppColors.cb20000;
              dateColor = AppColors.cb20000;
              dayNameColor = AppColors.cFFFFFF;
              shouldHighlight = true;
            } else if (isTodayDate && selectedDate != null) {
              // TODAY'S DATE STYLING (when another date is selected)
              backgroundColor = AppColors.cd7d7d7;
              dateColor = AppColors.cfefefe;
              dayNameColor = AppColors.c111111;
              shouldHighlight = false;
            } else {
              // NORMAL DATE STYLING
              backgroundColor = AppColors.scaffoldBackgroundColor;
              dateColor = AppColors.c999999;
              dayNameColor = AppColors.cfefefe;
              shouldHighlight = false;
            }

            return MealPlanCalenderShapeWidget(
              onTap: () => calandarController.toggleCalendarDateSelection(
                currentDayDate,
              ),
              dayName: calendarDay.dayName.substring(0, 3),
              date: calendarDay.day.toString(),
              isToday: shouldHighlight,
              backgroundColor: backgroundColor,
              dateColor: dateColor,
              dayNameColor: dayNameColor,
            );
          },
        ),
      );
    });
  }
}
