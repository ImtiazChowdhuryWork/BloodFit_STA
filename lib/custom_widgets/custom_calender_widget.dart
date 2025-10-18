import 'package:bloodfit/constants/app_enums.dart';
import 'package:bloodfit/gen/assets.gen.dart';
import 'package:bloodfit/gen/colors.gen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../features/home/presentation/widgets/calender_container_widget.dart';
import '../features/home/presentation/widgets/not_free_user_calender_container.dart';

class CustomCalenderWidget extends StatelessWidget {
  final UserSubscriptionType userSubscriptionType;
  const CustomCalenderWidget({super.key, required this.userSubscriptionType});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        userSubscriptionType == UserSubscriptionType.free
            ? CalenderContainerWidget(
                dayName: "Stu",
                height: 44.h,
                width: 44.w,
                progress: 0.6,
                srokeWidth: 4.sp,
                backgroundColor: AppColors.c363636,
                progressColor: AppColors.cb20000,
                completedCaloriesIconPath: Assets.icons.fireGray,
                isCalorieTaskCompleted: false,
                isCheatDay: true,
                userSubscriptionType: UserSubscriptionType.elite,
              )
            : NotFreeUserCalendarContainer(
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
