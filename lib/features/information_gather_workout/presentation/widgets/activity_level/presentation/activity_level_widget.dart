import 'package:bloodfit/constants/app_constant_text.dart';
import 'package:bloodfit/constants/app_list.dart';
import 'package:bloodfit/constants/text_font_style.dart';
import 'package:bloodfit/controllers/ig_whats_your_activity_level_controller.dart';
import 'package:bloodfit/helper/di.dart';
import 'package:bloodfit/helper/ui_helpers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../widgets/activity_Image_and_desription_showing_widget.dart';
import '../widgets/selectable_bar_widget.dart';

class ActivityLevelWidget extends StatelessWidget {
  ActivityLevelWidget({super.key});

  final IgWhatsYourActivityLevelController activityLevelController =
      Get.find<IgWhatsYourActivityLevelController>();

  @override
  Widget build(BuildContext context) {
    final list = AppList.activityLevelList;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "What’s Your Activity Level?",
          style: TextFontStyle.headline22w500cfefefeStylePoppins,
        ),
        UIHelper.verticalSpace(0.1.sh),

        // --- Image & Description ---
        Obx(() {
          final selectedIndex =
              activityLevelController.selectedActivityLevel.value;
          // If no selection (-1), show first item as placeholder
          final displayIndex = selectedIndex >= 0 ? selectedIndex : 0;
          return ActivityImageAndDescriptionShowingWidget(
            selectedIndex: selectedIndex,
            imagePath: list[displayIndex].imagePath,
            subTitle: list[displayIndex].subTitle,
          );
        }),

        UIHelper.verticalSpace(56.h),

        // --- Selector Bar ---
        Obx(() {
          return SelectableBarWidget(
            onChanged: (index) {
              activityLevelController.setSelectedActivityLevel(newValue: index);
            },
            selectedIndex: activityLevelController.selectedActivityLevel.value,
          );
        }),

        UIHelper.verticalSpace(10.h),

        // --- Labels ---
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 8.w),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                AppList.activityLevelList[0].title,
                style: TextFontStyle.headline14w400cfefefeStylePoppins,
              ),
              Text(
                AppList.activityLevelList[3].title,
                style: TextFontStyle.headline14w400cfefefeStylePoppins,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
