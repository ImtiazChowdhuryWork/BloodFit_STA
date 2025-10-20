import 'dart:developer';

import 'package:bloodfit/constants/app_enums.dart';
import 'package:bloodfit/controllers/home_screen_controller.dart';
import 'package:bloodfit/gen/assets.gen.dart';
import 'package:bloodfit/gen/colors.gen.dart';
import 'package:bloodfit/helper/ui_helpers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../features/home/presentation/widgets/calender_container_widget.dart';
import '../features/home/presentation/widgets/elite_uesr_workout_calender.dart';

class CustomCalenderWidget extends StatelessWidget {
  final UserSubscriptionType userSubscriptionType;
  const CustomCalenderWidget({super.key, required this.userSubscriptionType});

  @override
  Widget build(BuildContext context) {
    HomeScreenController homeScreenController =
        Get.find<HomeScreenController>();
    return Column(
      children: [
        SizedBox(
          height: 0.2.sh,
          width: 1.sw,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: homeScreenController.allDays.length,
            separatorBuilder: (context, index) =>
                UIHelper.horizontalSpace(20.w),
            itemBuilder: (context, index) {
              var data = homeScreenController.allDays[index];
              return InkWell(
                onTap: () {
                  log("Date Data : ");
                  log("${data.day}");
                  log(data.dayName);
                  log("${data.year}");
                },
                child: CalenderContainerWidget(
                  dayName: data.dayName,
                  date: data.day.toString(),
                  height: 44.h,
                  width: 44.w,
                  progress: 0.6,
                  srokeWidth: 4.sp,
                  backgroundColor: AppColors.c363636,
                  progressColor: AppColors.cb20000,
                  completedCaloriesIconPath: Assets.icons.fireGray,
                  isCalorieTaskCompleted: false,
                  isCheatDay: false,
                  userSubscriptionType: UserSubscriptionType.free,
                ),
              );
            },
          ),
        ),

        UIHelper.verticalSpace(40.w),
        EliteUserWorkoutCalender(
          isCheatDay: true,
          height: 44.h,
          width: 44.w,
          backgroundColor: AppColors.c363636,
          isCalorieTaskCompleted: false,
          progress: 0.6,
          progressColor: AppColors.cb20000,
          strokeWidth: 4,
        ),
      ],
    );
  }
}
