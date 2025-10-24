import 'package:bloodfit/constants/app_list.dart';
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
  final bool isSelected;
  final HomeScreenController homeScreenController =
      Get.find<HomeScreenController>();

  SelectYourDaysForMealPlanWidget({super.key, required this.isSelected});

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
        Obx(() {
          // Access reactive variables inside Obx builder
          final selectedDays = homeScreenController.selectedDaysList;
          final maxDays = homeScreenController.mealCalanderSelectableDays.value;

          return Container(
            width: 1.sw,
            height: 120.h,
            padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 18.h),
            decoration: BoxDecoration(
              color: AppColors.c262626,
              borderRadius: BorderRadius.circular(8.r),
            ),
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: homeScreenController.weekDayList.length,
              separatorBuilder: (context, index) =>
                  UIHelper.horizontalSpace(10.w),
              itemBuilder: (context, index) {
                var day = homeScreenController.weekDayList[index];
                return HomeScreenSelectableDaysShowingWidget(
                  onTap: () {
                    showWeekDayBottomSheet();
                  },
                  isSelected: homeScreenController.isDaySelected(day),
                  title: day.dayNames.substring(0, 3),
                );
              },
            ),
          );
        }),

        ///Section: Show selected days count
        Obx(
          () => Padding(
            // Change to Obx
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
