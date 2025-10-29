import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../../../../constants/text_font_style.dart';
import '../../../../../../controllers/ig_desired_weight_controller.dart';
import '../../../../../../controllers/slider_button_controller.dart';
import '../../../../../../controllers/weight_picker_widget_controller.dart';
import '../../../../../../custom_widgets/custom_slider_button.dart';
import '../../../../../../helper/ui_helpers.dart';
import '../../../../../information_gather_meal_plan/presentation/widgets/select_weight/widgets/weight_picker_widget.dart';

class DesiredWeightWidget extends StatelessWidget {
  DesiredWeightWidget({super.key});

  final IgDesiredWeightController igDesiredWeightController =
      Get.find<IgDesiredWeightController>();

  @override
  Widget build(BuildContext context) {
    /// Controllers
    final weightController = Get.put(WeightController());
    final weightTypeSliderButtonController = Get.put(SliderButtonController());

    // Initialize the slider button controller with items
    weightTypeSliderButtonController.initialize(["kg", "lb"]);

    return Column(
      children: [
        Text(
          "What’s Your Desired Weight?",
          style: TextFontStyle.headline22w500cfefefeStylePoppins,
        ),
        UIHelper.verticalSpace(134.h),

        /// --- UNIT SELECTOR (kg / lb) ---
        Align(
          alignment: Alignment.center,
          child: SliderButton(
            controller: weightTypeSliderButtonController,
            items: const ["kg", "lb"],
            onValueChanged: (index, value) {
              log("Selected index: $index, value: $value");

              /// Update the unit type in WeightController
              if (value == "kg" && weightController.useLb.value) {
                weightController.toggleUnit();
              } else if (value == "lb" && !weightController.useLb.value) {
                weightController.toggleUnit();
              }
            },
          ),
        ),
        UIHelper.verticalSpace(100.h),

        /// --- WEIGHT PICKER SLIDER ---
        WeightPickerWidget(
          weightController: weightController,
          weightTypeController: weightTypeSliderButtonController,
        ),
      ],
    );
  }
}
