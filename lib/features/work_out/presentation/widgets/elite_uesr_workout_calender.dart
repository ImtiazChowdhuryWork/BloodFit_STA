// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:flutter_svg/svg.dart';

// import '../../../../constants/text_font_style.dart';
// import '../../../../gen/assets.gen.dart';
// import '../../../../gen/colors.gen.dart';
// import '../../../../helper/ui_helpers.dart';

// class EliteUserWorkoutCalender extends StatelessWidget {
//   final bool isCheatDay;
//   final String dayName;
//   final bool isCalorieTaskCompleted;
//   final double height;
//   final double width;
//   final Color backgroundColor;
//   final Widget? child;
//   final Function()? onTap;
//   final int? day;
//   final int? month;
//   final int? year;
//   final bool isToday;
//   final bool isSelected;

//   const EliteUserWorkoutCalender({
//     super.key,
//     required this.isCheatDay,
//     required this.isCalorieTaskCompleted,
//     required this.height,
//     required this.width,
//     required this.backgroundColor,
//     this.child,
//     required this.dayName,
//     this.onTap,
//     this.day,
//     this.month,
//     this.year,
//     this.isToday = false,
//     this.isSelected = false,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return InkWell(
//       onTap: onTap,
//       child: Container(
//         padding: EdgeInsets.symmetric(vertical: 8.h, horizontal: 10.w),
//         decoration: BoxDecoration(
//           color: backgroundColor, // Now using the dynamic background color
//           borderRadius: BorderRadius.only(
//             topLeft: Radius.circular(8.r),
//             topRight: Radius.circular(8.r),
//             bottomLeft: Radius.circular(50.r),
//             bottomRight: Radius.circular(50.r),
//           ),
//         ),
//         child: Column(
//           children: [
//             Text(
//               dayName,
//               style: TextFontStyle.headline16w500cfefefeStylePoppins.copyWith(
//                 color: isToday
//                     ? AppColors.cfefefe
//                     : isToday && isSelected
//                     ? AppColors.cfefefe
//                     : isToday && !isSelected
//                     ? AppColors.c111111
//                     : AppColors.cfefefe,
//               ),
//             ),
//             UIHelper.verticalSpace(10.h),

//             ///Section : ----------///Background Color Handaler///-------------------
//             Container(
//               width: width,
//               height: height,
//               decoration: BoxDecoration(
//                 color: isToday
//                     ? AppColors.cfefefe
//                     : isToday && isSelected
//                     ? AppColors.cfefefe
//                     : isToday && !isSelected
//                     ? AppColors.c262626
//                     : AppColors.c262626,
//                 shape: BoxShape.circle,
//               ),
//               alignment: Alignment.center,
//               child: SvgPicture.asset(Assets.icons.workoutIcon),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

import '../../../../constants/text_font_style.dart';
import '../../../../gen/assets.gen.dart';
import '../../../../gen/colors.gen.dart';
import '../../../../helper/ui_helpers.dart';

class EliteUserWorkoutCalender extends StatelessWidget {
  final bool isCheatDay;
  final String dayName;
  final bool isCalorieTaskCompleted;
  final double height;
  final double width;
  final Color backgroundColor;
  final Widget? child;
  final Function()? onTap;
  final int? day;
  final int? month;
  final int? year;
  final bool isToday;
  final bool isSelected;
  final bool isAnyDateSelected;

  const EliteUserWorkoutCalender({
    super.key,
    required this.isCheatDay,
    required this.isCalorieTaskCompleted,
    required this.height,
    required this.width,
    required this.backgroundColor,
    this.child,
    required this.dayName,
    this.onTap,
    this.day,
    this.month,
    this.year,
    this.isToday = false,
    this.isSelected = false,
    required this.isAnyDateSelected,
  });

  /// Main Container Color Logic
  Color get mainContainerColor {
    return isToday && isSelected
        ? AppColors.cb20000
        : isToday && !isSelected && isAnyDateSelected
        ? AppColors.cd7d7d7
        : isToday && !isSelected && !isAnyDateSelected
        ? AppColors.cb20000
        : !isToday && isSelected
        ? AppColors.cb20000
        : backgroundColor;
  }

  /// Text Color Logic
  Color get textColor {
    return isToday && isSelected
        ? AppColors.cfefefe
        : isToday && !isSelected && isAnyDateSelected
        ? AppColors.c111111
        : isToday && !isSelected && !isAnyDateSelected
        ? AppColors.cfefefe
        : !isToday && isSelected
        ? AppColors.cfefefe
        : AppColors.cfefefe;
  }

  /// Circular Container Color Logic
  Color get circularContainerColor {
    return isToday && isSelected
        ? AppColors.cfefefe
        : isToday && !isSelected && isAnyDateSelected
        ? AppColors.c262626
        : isToday && !isSelected && !isAnyDateSelected
        ? AppColors.cfefefe
        : !isToday && isSelected
        ? AppColors.cfefefe
        : AppColors.c262626;
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 8.h, horizontal: 10.w),
        decoration: BoxDecoration(
          color: mainContainerColor,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(8.r),
            topRight: Radius.circular(8.r),
            bottomLeft: Radius.circular(50.r),
            bottomRight: Radius.circular(50.r),
          ),
        ),
        child: Column(
          children: [
            Text(
              dayName,
              style: TextFontStyle.headline16w500cfefefeStylePoppins.copyWith(
                color: textColor,
              ),
            ),
            UIHelper.verticalSpace(10.h),

            /// Circular Container
            Container(
              width: width,
              height: height,
              decoration: BoxDecoration(
                color: circularContainerColor,
                shape: BoxShape.circle,
              ),
              alignment: Alignment.center,
              child: SvgPicture.asset(Assets.icons.workoutIcon),
            ),
          ],
        ),
      ),
    );
  }
}
