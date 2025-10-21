import 'dart:developer';

import 'package:bloodfit/controllers/home_screen_controller.dart';
import 'package:bloodfit/gen/assets.gen.dart';
import 'package:bloodfit/gen/colors.gen.dart';
import 'package:bloodfit/helper/ui_helpers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../features/home/presentation/widgets/calendar_with_progress_bar_widget.dart';

class CustomCalenderWidget extends StatelessWidget {
  const CustomCalenderWidget({super.key});

  @override
  Widget build(BuildContext context) {
    HomeScreenController homeScreenController =
        Get.find<HomeScreenController>();

    return SizedBox(
      height: 0.1.sh,
      width: 1.sw,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: homeScreenController.allDays.length,
        separatorBuilder: (context, index) => UIHelper.horizontalSpace(20.w),
        itemBuilder: (context, index) {
          var data = homeScreenController.allDays[index];
          return InkWell(
            onTap: () {
              log("Date Data : ");
              log("${data.day} day");
              log("${data.dayName} dayName");
              log("${data.month} month");
              log("${data.year} year");
            },
            child: CalenderWithProgressbarWidget(
              height: 44.h,
              width: 44.w,
              srokeWidth: 4.sp,
              progress: 0.6,
              dayName: data.dayName.substring(0, 3),
              date: data.day.toString(),
              backgroundColor: AppColors.c363636,
              progressColor: AppColors.cb20000,
              completedCaloriesIconPath: Assets.icons.fireGray,
              isCalorieTaskCompleted: false,
              isCheatDay: false,
            ),
          );
        },
      ),
    );
  }
}
