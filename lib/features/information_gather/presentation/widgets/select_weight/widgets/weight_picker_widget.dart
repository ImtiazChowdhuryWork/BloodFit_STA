import 'dart:developer';
import 'package:bloodfit/constants/text_font_style.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:syncfusion_flutter_sliders/sliders.dart';
import 'package:syncfusion_flutter_core/theme.dart';
import '../../../../../../controllers/weight_picker_widget_controller.dart';
import '../../../../../../controllers/slider_button_controller.dart';
import '../../../../../../gen/colors.gen.dart';
import '../../../../../../helper/ui_helpers.dart';

class WeightPickerWidget extends StatelessWidget {
  final WeightController weightController;
  final SliderButtonController weightTypeController;

  const WeightPickerWidget({
    super.key,
    required this.weightController,
    required this.weightTypeController,
  });

  /// Returns the interval between major ticks depending on the selected unit
  double _getMajorInterval() {
    return weightTypeController.getValue() == "kg" ? 60 : 20;
  }

  /// Returns number of minor ticks per major interval depending on unit
  int _getMinorTicksPerInterval() {
    return weightTypeController.getValue() == "kg" ? 1 : 1;
  }

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
        Obx(
          () => SfSliderTheme(
            data: const SfSliderThemeData(
              activeTrackHeight: 6,
              inactiveTrackHeight: 6,
              activeTrackColor: AppColors.cb20000,
              inactiveTrackColor: AppColors.cc6c6c6,
              thumbRadius: 12,
              thumbColor: AppColors.cb20000,
            ),
            child: SfSlider(
              min: weightController.minWeight,
              max: weightController.maxWeight,
              value: weightController.currentWeight.value,
              interval: _getMajorInterval(),
              showTicks: true,
              showLabels: true,
              enableTooltip: true,
              stepSize: weightController.stepSize,
              minorTicksPerInterval: _getMinorTicksPerInterval(),
              onChanged: (value) =>
                  weightController.updateWeight(value as double),
            ),
          ),
        ),
      ],
    );
  }
}
