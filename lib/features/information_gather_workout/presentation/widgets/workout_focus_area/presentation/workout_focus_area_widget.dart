import 'package:bloodfit/controllers/ig_workout_focus_area_controller.dart';
import 'package:bloodfit/features/information_gather_workout/presentation/widgets/workout_focus_area/presentation/widgets/focus_area_item.dart';
import 'package:bloodfit/gen/assets.gen.dart';
import 'package:bloodfit/gen/colors.gen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

import '../../../../../../constants/text_font_style.dart';
import '../../../../../../helper/ui_helpers.dart';

class WorkoutFocusAreaWidget extends StatelessWidget {
  WorkoutFocusAreaWidget({super.key});

  final IgWorkoutFocusAreaController igWorkoutFocusAreaController =
      Get.find<IgWorkoutFocusAreaController>();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "What’s Your Focus Area?",
          style: TextFontStyle.headline22w500cfefefeStylePoppins,
        ),
        UIHelper.verticalSpace(16.h),

        Container(
          width: 1.sw,
          height: 0.5.sh,
          // decoration: BoxDecoration(color: Colors.purple),
          child: Stack(
            children: [
              ///Section : Full  Body Image
              Positioned(
                right: 0.w,
                top: 0.h,
                bottom: 0.h,
                child: Image.asset(
                  Assets.images.focusAreaFullBodyImage.path,
                  fit: BoxFit.contain,
                  height: 1.sh,
                  width: 150.w,
                ),
              ),

              ///Section : Arms
              Obx(() {
                return FocusAreaItem(
                  onTap: () {
                    igWorkoutFocusAreaController.setArmsSelection();
                  },
                  title: "Arms",
                  buttonWidth: 180,
                  buttonTopPosition: 70,
                  buttonLeftPosition: 0,
                  pointerImagPath:
                      igWorkoutFocusAreaController.isArmsSelected.value
                      ? Assets.icons.armsArowSelected
                      : Assets.icons.armsArrowNotSelected,
                  pointerTopPosition:
                      igWorkoutFocusAreaController.isArmsSelected.value
                      ? -5
                      : 20,
                  pointerRightPosition:
                      igWorkoutFocusAreaController.isArmsSelected.value
                      ? -142
                      : -130,
                  isSelected: igWorkoutFocusAreaController.isArmsSelected.value,
                );
              }),

              ///Section : UpperBody
              Obx(() {
                return FocusAreaItem(
                  onTap: () {
                    igWorkoutFocusAreaController.setUpperBodySelection();
                  },
                  title: "Upper Body",
                  buttonWidth: 150,
                  buttonTopPosition: 140,
                  buttonLeftPosition: 0,
                  pointerImagPath:
                      igWorkoutFocusAreaController.isUpperBodySelected.value
                      ? Assets.icons.upperBodyArrowSelected
                      : Assets.icons.upperBodyArrowNotSelected,
                  pointerTopPosition:
                      igWorkoutFocusAreaController.isUpperBodySelected.value
                      ? -70
                      : -70,
                  pointerRightPosition:
                      igWorkoutFocusAreaController.isUpperBodySelected.value
                      ? -275
                      : -270,
                  isSelected:
                      igWorkoutFocusAreaController.isUpperBodySelected.value,
                );
              }),
            ],
          ),
        ),
      ],
    );
  }
}
