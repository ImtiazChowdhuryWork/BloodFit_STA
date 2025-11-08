import 'package:bloodfit/constants/text_font_style.dart';
import 'package:bloodfit/gen/colors.gen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../../../../../controllers/slider_button_controller.dart';
import '../../../../../../../controllers/weight_picker_widget_controller.dart';

class WeightPickerWidget extends StatelessWidget {
  final WeightController weightController;
  final SliderButtonController weightTypeController;

  const WeightPickerWidget({
    super.key,
    required this.weightController,
    required this.weightTypeController,
  });

  @override
  Widget build(BuildContext context) {
    // Initialize the slider button controller if not done
    if (weightTypeController.selectedValue.value.isEmpty) {
      weightTypeController.initialize(["kg", "lb"]);
    }

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        /// --- CURRENT WEIGHT DISPLAY ---
        Obx(
          () => Text(
            "${weightController.currentWeight.value.toStringAsFixed(1)} ${weightController.unit}",
            style: TextFontStyle.headline36w500cFFFFFFStylePoppins,
          ),
        ),

        const SizedBox(height: 30),

        /// --- WEIGHT SLIDER ---
      ],
    );
  }
}
