import 'dart:developer';

import 'package:bloodfit/constants/app_list.dart';
import 'package:bloodfit/features/information_gather_workout/data/controller/information_gather_work_out_controller.dart';
import 'package:bloodfit/features/information_gather_workout/presentation/widgets/current_body_shape/presentation/widget/body_shape_showing_widget.dart';
import 'package:bloodfit/helper/ui_helpers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../../../../constants/app_constant_text.dart';
import '../../../../../../constants/text_font_style.dart';
import '../../../../../../helper/di.dart';
import '../../../../../../helper/logger_util.dart';
import '../data/controller/information_gather_workout_current_body_shape_main_goal_controller.dart';

class CurrentBodyShapeWidget extends StatelessWidget {
  // final IgCurrentBodyTypeController controller =
  //     Get.find<IgCurrentBodyTypeController>();
  
  final InformationGatherWorkoutCurrentBodyShapeMainGoalController controller = Get.find<InformationGatherWorkoutCurrentBodyShapeMainGoalController>();

  CurrentBodyShapeWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ///Section : ------------------///Question///----------
        Text(
          "What's Your Current Body Shape?",
          style: TextFontStyle.headline22w500cfefefeStylePoppins,
        ),
        UIHelper.verticalSpace(16.h),

        ListView.separated(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: AppList.bodyTypeList.length,
          separatorBuilder: (context, index) => UIHelper.verticalSpace(10.h),
          itemBuilder: (context, index) {
            var data = AppList.bodyTypeList[index];
            return Obx(() {
              return BodyShapeShowingWidget(
                onTap: () {
                  int newIndex = index;
                  LoggerUtils.debug("Tapped: On bodyType: ${data.bodyType}");

                  int previousIndex = controller.selectedBodyTypeIndex.value;
                  controller.selectBodyType(index);

                  // Only save and trigger if selection actually changed
                  if (previousIndex != index) {
                    // Save to storage
                    appData.write(
                      kKeyCurrentBodyShape,
                      controller.selectedBodyTypeTobeSaved.value,
                    );

                    ///----------->>> Update the parent controller to enable/disable the continue button
                    Get.find<InformationGatherWorkOutController>()
                        .triggerButtonUpdate();

                    LoggerUtils.debug(
                      "Saved body shape: ${controller.selectedBodyTypeTobeSaved.value}",
                    );
                  } else {
                    LoggerUtils.debug(
                      "Same Type Of Body Shape Selected, clearing selection",
                    );

                    // Clear the saved value when deselecting
                    appData.remove(kKeyCurrentBodyShape);

                    ///----------->>> Update the parent controller to disable the continue button
                    Get.find<InformationGatherWorkOutController>()
                        .triggerButtonUpdate();
                  }
                },
                boydType: data.bodyType,
                bodyImage: data.bodyImage,
                isSelected: controller.isSelected(index),
              );
            });
          },
        ),
      ],
    );
  }
}
