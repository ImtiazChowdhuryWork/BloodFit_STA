import 'package:bloodfit/controllers/ig_workout_focus_area_controller.dart';
import 'package:bloodfit/features/information_gather_workout/presentation/widgets/workout_focus_area/presentation/widgets/focus_area_item.dart';
import 'package:bloodfit/gen/assets.gen.dart';
import 'package:bloodfit/gen/colors.gen.dart';
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

        Container(
          width: 1.sw,
          height: 0.5.sh,
          decoration: BoxDecoration(color: Colors.purple),
          child: Stack(
            children: [
              ///Section : Full  Body Image
              Positioned(
                right: 0.w,
                top: 0.h,
                bottom: 0.h,
                child: Card(
                  child: Image.asset(
                    Assets.images.focusAreaFullBodyImage.path,
                    fit: BoxFit.contain,
                    height: 1.sh,
                    width: 150.w,
                  ),
                ),
              ),

              ///Section : Arms
              FocusAreaItem(
                isSelected: igWorkoutFocusAreaController.isArmsSelected,
                onTap: () {
                  igWorkoutFocusAreaController.setArmsSelection();
                },
                selectedImagePath: Assets.images.armsSelected.path,
                unselectedImagePath: Assets.images.armsNotSelected.path,
                right: 80,
                top: 70,
              ),

              ///Section : UpperBody
              FocusAreaItem(
                isSelected: igWorkoutFocusAreaController.isUpperBodySelected,
                onTap: () {
                  igWorkoutFocusAreaController.setUpperBodySelection();
                },
                selectedImagePath: Assets.images.uppperBodySelectedImage.path,
                unselectedImagePath:
                    Assets.images.upperBodyNotSelectedImage.path,
                right: 40,
                top: 100,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
