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
          height: 641.h,
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
                  fit: BoxFit.cover,
                  width: 203.w,
                ),
              ),

              ///Section : Arms
              Obx(() {
                return FocusAreaItem(
                  onTap: () {
                    igWorkoutFocusAreaController.setArmsSelection();
                  },
                  title: "Arms",
                  buttonHeight: 50,
                  buttonWidth: 160,
                  buttonTopPosition: 94,
                  buttonLeftPosition: 0,
                  pointerImagPath:
                      igWorkoutFocusAreaController.isArmsSelected.value
                      ? Assets.icons.armsArowSelected
                      : Assets.icons.armsArrowNotSelected,
                  pointerTopPosition:
                      igWorkoutFocusAreaController.isArmsSelected.value
                      ? -6
                      : 22,
                  pointerRightPosition:
                      igWorkoutFocusAreaController.isArmsSelected.value
                      ? -125
                      : -112,
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
                  buttonHeight: 50,
                  buttonWidth: 160,
                  buttonTopPosition: 180,
                  buttonLeftPosition: 0,
                  pointerImagPath:
                      igWorkoutFocusAreaController.isUpperBodySelected.value
                      ? Assets.icons.upperBodyArrowSelected
                      : Assets.icons.upperBodyArrowNotSelected,
                  pointerTopPosition:
                      igWorkoutFocusAreaController.isUpperBodySelected.value
                      ? -90
                      : -80,
                  pointerRightPosition:
                      igWorkoutFocusAreaController.isUpperBodySelected.value
                      ? -255
                      : -255,
                  isSelected:
                      igWorkoutFocusAreaController.isUpperBodySelected.value,
                );
              }),

              ///Section : Abs
              Obx(() {
                return FocusAreaItem(
                  onTap: () {
                    igWorkoutFocusAreaController.setAbsSelection();
                  },
                  title: "Abs",
                  buttonHeight: 50,
                  buttonWidth: 160,
                  buttonTopPosition: 270,
                  buttonLeftPosition: 0,
                  pointerImagPath:
                      igWorkoutFocusAreaController.isAbsSelected.value
                      ? Assets.icons.absArrowSelected
                      : Assets.icons.absArowNotSelected,
                  pointerTopPosition:
                      igWorkoutFocusAreaController.isAbsSelected.value
                      ? -72
                      : -50,
                  pointerRightPosition:
                      igWorkoutFocusAreaController.isAbsSelected.value
                      ? -242
                      : -220,
                  isSelected: igWorkoutFocusAreaController.isAbsSelected.value,
                );
              }),

              ///Section : Butt
              Obx(() {
                return FocusAreaItem(
                  onTap: () {
                    igWorkoutFocusAreaController.setButtSelection();
                  },
                  title: "Butt",
                  buttonHeight: 50,
                  buttonWidth: 160,
                  buttonTopPosition: 350,
                  buttonLeftPosition: 0,
                  pointerImagPath:
                      igWorkoutFocusAreaController.isButtSelected.value
                      ? Assets.icons.buttArrowSelected
                      : Assets.icons.buttArrowNotSelected,
                  pointerTopPosition:
                      igWorkoutFocusAreaController.isButtSelected.value
                      ? -55
                      : -34,
                  pointerRightPosition:
                      igWorkoutFocusAreaController.isButtSelected.value
                      ? -258
                      : -238,
                  isSelected: igWorkoutFocusAreaController.isButtSelected.value,
                );
              }),

              ///Section : Legs
              Obx(() {
                return FocusAreaItem(
                  onTap: () {
                    igWorkoutFocusAreaController.setLegSelection();
                  },
                  title: "Legs",
                  buttonHeight: 50,
                  buttonWidth: 160,
                  buttonTopPosition: 446,
                  buttonLeftPosition: 0,
                  pointerImagPath:
                      igWorkoutFocusAreaController.isLegSelected.value
                      ? Assets.icons.legArrowSelected
                      : Assets.icons.legArrowNotSelected,
                  pointerTopPosition:
                      igWorkoutFocusAreaController.isLegSelected.value
                      ? -92
                      : -67,
                  pointerRightPosition:
                      igWorkoutFocusAreaController.isLegSelected.value
                      ? -180
                      : -157,
                  isSelected: igWorkoutFocusAreaController.isLegSelected.value,
                );
              }),
            ],
          ),
        ),
      ],
    );
  }
}
