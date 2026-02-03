import 'package:bloodfit/constants/app_constant_text.dart';
import 'package:bloodfit/helper/di.dart';
import 'package:bloodfit/helper/logger_util.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../../../../constants/app_list.dart';
import '../../../../../../constants/text_font_style.dart';
import '../../../../../../controllers/information_gather_screen_controller.dart';
import '../../../../../../custom_widgets/workout_main_goal_tile.dart';
import '../../../../../../helper/ui_helpers.dart';
import '../data/controller/information_gather_body_shape_main_goal_controller.dart';

class DesiredBodySapeMainGoalScreen extends StatelessWidget {
  const DesiredBodySapeMainGoalScreen({super.key});

  @override
  Widget build(BuildContext context) {
    InformationGatherBodyShapeMainGoalController controller =
        Get.find<InformationGatherBodyShapeMainGoalController>();
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
                  int newIndex = index;
                  LoggerUtils.debug("Tapped: On bodyType: ${data.title}");

                  int previousIndex = controller.selectedBodyTypeIndex.value;
                  controller.selectBodyType(index);

                  // Only save and trigger if selection actually changed
                  if (previousIndex != index) {
                    // Save to storage
                    appData.write(
                      kKeyExpectedBodyShape,
                      controller.selectedBodyTypeTobeSaved.value,
                    );

                    ///----------->>> Update the parent controller to enable/disable the continue button
                    Get.find<InformationGatherMealPlanController>()
                        .triggerButtonUpdate();

                    LoggerUtils.debug(
                      "Saved body shape: ${controller.selectedBodyTypeTobeSaved.value}",
                    );
                  } else {
                    LoggerUtils.debug(
                      "Same Type Of Body Shape Selected, clearing selection",
                    );

                    // Clear the saved value when deselecting
                    appData.remove(kKeyExpectedBodyShape);

                    ///----------->>> Update the parent controller to disable the continue button
                    Get.find<InformationGatherMealPlanController>()
                        .triggerButtonUpdate();
                  }
                },
                boydType: data.title,
                bodyImage: data.imagePath,
                imageWidth: index == 0 ? 200.w : null,
                isSelected: controller.isSelected(index),
              );
            });
          },
        ),
      ],
    );
  }
}
