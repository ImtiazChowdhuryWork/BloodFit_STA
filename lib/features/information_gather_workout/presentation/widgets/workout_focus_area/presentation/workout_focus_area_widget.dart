import 'package:bloodfit/controllers/ig_workout_focus_area_controller.dart';
import 'package:bloodfit/features/information_gather_workout/presentation/widgets/workout_focus_area/presentation/widgets/focus_area_item.dart';
import 'package:bloodfit/gen/assets.gen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
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

        SizedBox(
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
                  pointerImageHeight: 90,
                  pointerImageWidth: 127,
                  pointerImagPath:
                      igWorkoutFocusAreaController.isArmsSelected.value
                      ? Assets.images.armsArrowSelected.path
                      : Assets.images.armsArrowNotSelected.path,
                  pointerTopPosition:
                      igWorkoutFocusAreaController.isArmsSelected.value
                      ? 16
                      : 22,
                  pointerRightPosition:
                      igWorkoutFocusAreaController.isArmsSelected.value
                      ? -112
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
                  pointerImageHeight: 112,
                  pointerImageWidth: 261,
                  pointerImagPath:
                      igWorkoutFocusAreaController.isUpperBodySelected.value
                      ? Assets.images.upperBodyArrowSelected.path
                      : Assets.images.upperBodyArrowNotSelected.path,
                  pointerTopPosition:
                      igWorkoutFocusAreaController.isUpperBodySelected.value
                      ? -65
                      : -65,
                  pointerRightPosition:
                      igWorkoutFocusAreaController.isUpperBodySelected.value
                      ? -245
                      : -245,
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
                  buttonTopPosition: 260,
                  buttonLeftPosition: 0,
                  pointerImageHeight: 80,
                  pointerImageWidth: 235,
                  pointerImagPath:
                      igWorkoutFocusAreaController.isAbsSelected.value
                      ? Assets.images.absArrowSelected.path
                      : Assets.images.absArrowNotSelected.path,
                  pointerTopPosition:
                      igWorkoutFocusAreaController.isAbsSelected.value
                      ? -38
                      : -42,
                  pointerRightPosition:
                      igWorkoutFocusAreaController.isAbsSelected.value
                      ? -230
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
                  buttonTopPosition: 340,
                  buttonLeftPosition: 0,
                  pointerImageHeight: 60,
                  pointerImageWidth: 246,
                  pointerImagPath:
                      igWorkoutFocusAreaController.isButtSelected.value
                      ? Assets.images.buttArrowSelected.path
                      : Assets.images.buttArrowNotSelected.path,
                  pointerTopPosition:
                      igWorkoutFocusAreaController.isButtSelected.value
                      ? -30
                      : -30,
                  pointerRightPosition:
                      igWorkoutFocusAreaController.isButtSelected.value
                      ? -238
                      : -230,
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
                  buttonTopPosition: 440,
                  buttonLeftPosition: 0,
                  pointerImageHeight: 140,
                  pointerImageWidth: 171,
                  pointerImagPath:
                      igWorkoutFocusAreaController.isLegSelected.value
                      ? Assets.images.legArrowSelected.path
                      : Assets.images.legArrowNotSelected.path,
                  pointerTopPosition:
                      igWorkoutFocusAreaController.isLegSelected.value
                      ? -55
                      : -55,
                  pointerRightPosition:
                      igWorkoutFocusAreaController.isLegSelected.value
                      ? -165
                      : -152,
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
