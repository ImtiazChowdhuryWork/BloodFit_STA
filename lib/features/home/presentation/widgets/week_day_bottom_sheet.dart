import 'dart:developer';

import 'package:bloodfit/constants/text_font_style.dart';
import 'package:bloodfit/extensions/week_days_extension.dart';
import 'package:bloodfit/features/home/presentation/widgets/bottom_sheet_screen_selectable_days_showing_widget.dart';
import 'package:bloodfit/gen/colors.gen.dart';
import 'package:bloodfit/helper/ui_helpers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../data/controller/home_screen_controller.dart';
import '../../../../custom_widgets/custom_elevated_button.dart';

void showWeekDayBottomSheet() {
  final HomeScreenController homeScreenController =
      Get.find<HomeScreenController>();

  Get.bottomSheet(
    backgroundColor: AppColors.c111111,
    isScrollControlled: true,
    Container(
      width: 1.sw,
      constraints: BoxConstraints(
        maxHeight: 0.6.sh, // Reduced height to make it more compact
      ),
      padding: EdgeInsets.only(
        top: 20.h,
        left: 20.w,
        right: 20.w,
        bottom: 20.h, // Reduced bottom padding
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.min, // Important for compact layout
        children: [
          ///Section : -----------------///Top Divider///--------------
          Container(
            width: 76.w,
            height: 3.h,
            decoration: BoxDecoration(
              color: AppColors.c999999,
              borderRadius: BorderRadius.circular(8.r),
            ),
          ),
          UIHelper.verticalSpace(16.h), // Reduced space
          ///Section : ------------------///Text-> Customize Your Meal Days///-------------
          Text(
            "Customize Your Meal Days",
            style: TextFontStyle.headline18w500cfefefeStylePoppins,
          ),
          UIHelper.verticalSpace(12.h), // Reduced space
          ///Section: --------///Selection Counter///-----------------
          // Obx(
          //   () => Text(
          //     "Selected: ${homeScreenController.selectedDaysList.length}/${homeScreenController.mealCalanderSelectableDays.value} days",
          //     style: TextFontStyle.headline14w400c999999StylePoppins,
          //   ),
          // ),

          // UIHelper.verticalSpace(16.h),

          ///Section: --------///Show The Selected days///-----------------
          Obx(
            () => Wrap(
              spacing: 8.w, // Reduced spacing
              runSpacing: 8.h, // Reduced run spacing
              alignment: WrapAlignment.center,
              children: homeScreenController.weekDayList
                  .map(
                    (day) => BottomSheetScreenSelectableDaysShowingWidget(
                      isSelected: homeScreenController.isDaySelected(day),
                      title: day.dayNames,
                      onTap: () => homeScreenController.toggleDaySelection(day),
                    ),
                  )
                  .toList(),
            ),
          ),

          ///Section: --------///Close Button///-----------------
          UIHelper.verticalSpace(16.h), // Reduced space
          CustomElevatedButton(
            onTap: () {
              log("Confirm button tapped - closing bottom sheet");
              Get.back();
            },
            buttonColor: AppColors.c363636,
            borderRadius: 24.r,
            buttonHeight: 52.h,
            buttonTitle: "Confirm",
          ),
        ],
      ),
    ),
  );
}
