import 'dart:developer';

import 'package:bloodfit/constants/text_font_style.dart';
import 'package:bloodfit/features/information_gather_workout/presentation/widgets/workout_main_goal/presentation/widget/workout_main_goal_tile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../../../../constants/app_list.dart';
import '../../../../../../controllers/ig_workout_main_goal_controller.dart';
import '../../../../../../helper/ui_helpers.dart';

class WorkoutMainGoalWidget extends StatelessWidget {
  WorkoutMainGoalWidget({super.key});

  final IgWorkoutMainGoalController igWorkoutMainGoalController =
      Get.find<IgWorkoutMainGoalController>();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "What’s Your Main Goal?",
          style: TextFontStyle.headline22w500cfefefeStylePoppins,
        ),

        UIHelper.verticalSpace(16.h),

        ListView.separated(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: AppList.workoutMainGoalList.length,
          separatorBuilder: (context, index) => UIHelper.verticalSpace(10.h),
          itemBuilder: (context, index) {
            var data = AppList.workoutMainGoalList[index];
            return Obx(() {
              return WorkoutMainGoalTile(
                onTap: () {
                  log("Tapped: On bodyType: ${data.title}");
                  igWorkoutMainGoalController.selectBodyType(index);
                },
                boydType: data.title,
                bodyImage: data.imagePath,
                imageWidth: index == 0 ? 200.w : null,
                isSelected: igWorkoutMainGoalController.isSelected(index),
              );
            });
          },
        ),
      ],
    );
  }
}
