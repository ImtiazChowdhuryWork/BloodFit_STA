import 'package:bloodfit/gen/assets.gen.dart';
import 'package:bloodfit/gen/colors.gen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../features/home/presentation/widgets/calender_container_widget.dart';

class CustomCalenderWidget extends StatelessWidget {
  const CustomCalenderWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        CalenderContainerWidget(
          iconPath: Assets.icons.fireWhite,
          dayName: "Stu",
          height: 44.h,
          width: 44.w,
          progress: 0.6,
          srokeWidth: 4.sp,
          backgroundColor: AppColors.c363636,
          progressColor: AppColors.cb20000,
        ),
      ],
    );
  }
}
