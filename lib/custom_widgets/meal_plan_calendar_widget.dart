import 'package:bloodfit/extensions/date_time_extension.dart';
import 'package:bloodfit/features/meal_plan_feature_options/presentation/widgets/meal_plan_calender_shape_widget.dart';
import 'package:bloodfit/gen/colors.gen.dart';
import 'package:bloodfit/helper/ui_helpers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../controllers/home_screen_controller.dart';

class MealPlanCalendarWidget extends StatelessWidget {
  MealPlanCalendarWidget({super.key});

  final HomeScreenController homeController = Get.find<HomeScreenController>();

  @override
  Widget build(BuildContext context) {
    final todayDate = DateTime.now().dateOnly;

    return Obx(
      () => SizedBox(
        width: 1.sw,
        height: 100.h,
        child: ListView.separated(
          itemCount: homeController.allCalendarDays.length,
          scrollDirection: Axis.horizontal,
          separatorBuilder: (context, index) => UIHelper.horizontalSpace(10.w),

          itemBuilder: (context, index) {
            final calendarDay = homeController.allCalendarDays[index];
            final currentDayDate = DateTime(
              calendarDay.year,
              calendarDay.month,
              calendarDay.day,
            );

            final isTodayDate = currentDayDate.isSameCalendarDay(todayDate);
            final isSelectedDate =
                homeController.selectedCalendarDate.value?.isSameCalendarDay(
                  currentDayDate,
                ) ??
                false;

            // Container background color
            final Color dayContainerColor = isSelectedDate
                ? AppColors.cb20000
                : isTodayDate &&
                      homeController.selectedCalendarDate.value != null &&
                      !homeController.selectedCalendarDate.value!
                          .isSameCalendarDay(todayDate)
                ? AppColors.cd7d7d7
                : isTodayDate
                ? AppColors.cb20000
                : AppColors.scaffoldBackgroundColor;

            // Highlight logic for inner circle
            final bool shouldHighlight =
                isSelectedDate ||
                (isTodayDate &&
                    homeController.selectedCalendarDate.value == null);

            // Date text color
            final Color dateColor = isSelectedDate
                ? AppColors.cb20000
                : isTodayDate
                ? AppColors.cfefefe
                : AppColors.c999999;

            // Day name text color
            final Color dayNameColor = isSelectedDate
                ? AppColors.cFFFFFF
                : isTodayDate
                ? AppColors.c111111
                : AppColors.cfefefe;

            return MealPlanCalenderShapeWidget(
              onTap: () =>
                  homeController.toggleCalendarDateSelection(currentDayDate),
              dayName: calendarDay.dayName.substring(0, 3),
              date: calendarDay.day.toString(),
              isToday: shouldHighlight,
              backgroundColor: dayContainerColor,
              dateColor: dateColor,
              dayNameColor: dayNameColor,
            );
          },
        ),
      ),
    );
  }
}
