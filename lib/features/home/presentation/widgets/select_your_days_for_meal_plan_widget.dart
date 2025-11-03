import 'package:bloodfit/constants/text_font_style.dart';
import 'package:bloodfit/controllers/home_screen_controller.dart';
import 'package:bloodfit/extensions/week_days_extension.dart';
import 'package:bloodfit/features/home/presentation/widgets/home_screen_selectable_days_showing_widget.dart';
import 'package:bloodfit/features/home/presentation/widgets/week_day_bottom_sheet.dart';
import 'package:bloodfit/gen/colors.gen.dart';
import 'package:bloodfit/helper/ui_helpers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class SelectYourDaysForMealPlanWidget extends StatelessWidget {
  final HomeScreenController homeScreenController =
      Get.find<HomeScreenController>();

  SelectYourDaysForMealPlanWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Meal Plan Calendar",
          style: TextFontStyle.headline20w500cfefefeStylePoppins,
        ),
        UIHelper.verticalSpace(4.h),
        Text(
          "Customize Your Three Days",
          style: TextFontStyle.headline14w400cfefefeStylePoppins,
        ),
        UIHelper.verticalSpace(12.h),

        ///Section : ------///Select Day's///----------------
        Container(
          width: 1.sw,
          height: 100.h,
          padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 18.h),
          decoration: BoxDecoration(
            color: AppColors.c262626,
            borderRadius: BorderRadius.circular(8.r),
          ),
          child: Obx(() {
            // Create a list of widgets inside the Obx so GetX can track observables properly
            List<Widget> dayWidgets = homeScreenController.weekDayList.map((
              day,
            ) {
              bool isSelected = homeScreenController.selectedDaysList.contains(
                day,
              );
              return HomeScreenSelectableDaysShowingWidget(
                onTap: () {
                  showWeekDayBottomSheet();
                },
                isSelected: isSelected,
                title: day.dayNames.substring(0, 3),
              );
            }).toList();

            return ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: dayWidgets.length,
              separatorBuilder: (context, index) =>
                  UIHelper.horizontalSpace(10.w),
              itemBuilder: (context, index) => dayWidgets[index],
            );
          }),
        ),

        ///Section: Show selected days count
        Obx(
          () => Padding(
            padding: EdgeInsets.only(top: 8.h),
            child: Text(
              "Selected: ${homeScreenController.selectedDaysList.length}/${homeScreenController.mealCalanderSelectableDays.value} days",
              style: TextFontStyle.headline14w400c999999StylePoppins,
            ),
          ),
        ),
      ],
    );
  }
}
