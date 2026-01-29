import 'package:bloodfit/features/information_gather_meal_plan/presentation/widgets/select_desired_weight/presentation/widgets/custom_desired_weight_ruler.dart';
import 'package:bloodfit/helper/logger_util.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../../../../constants/text_font_style.dart';
import '../../../../../../controllers/slider_button_controller.dart';
import '../../../../../../custom_widgets/custom_slider_button.dart';
import '../../../../../../helper/ui_helpers.dart';
import '../data/controller/ig_select_desired_weight_widget_controller.dart';

class SelectDesiredWeightWidget extends StatelessWidget {
  const SelectDesiredWeightWidget({super.key});

  @override
  Widget build(BuildContext context) {
    /// Controllers - use Get.find() with tags
    final desiredWeightController =
        Get.find<IgSelectDesiredWeightWidgetController>();
    final desiredWeightTypeSliderButtonController =
        Get.find<SliderButtonController>(tag: 'desired_weight_unit');

    // Initialize the slider button controller with items
    desiredWeightTypeSliderButtonController.initialize(["kg", "lb"]);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "What's Your Desired Weight?",
          style: TextFontStyle.headline22w500cfefefeStylePoppins,
        ),

        // Optional: Show selected weight
        Obx(
          () => Padding(
            padding: EdgeInsets.only(top: 8.h),
            child: Text(
              'Selected Weight: ${desiredWeightController.centerValue.value.toStringAsFixed(1)} ${desiredWeightController.unit}',
              style: TextFontStyle.headline14w500cfefefeStylePoppins,
            ),
          ),
        ),

        UIHelper.verticalSpace(30.h), // Reduced space
        /// --- UNIT SELECTOR (kg / lb) ---
        Align(
          alignment: Alignment.center,
          child: SliderButton(
            controller: desiredWeightTypeSliderButtonController,
            items: const ["kg", "lb"],
            onValueChanged: (index, value) {
              LoggerUtils.debug("Selected unit: $value");

              // Use a post-frame callback to avoid updating during build
              WidgetsBinding.instance.addPostFrameCallback((_) {
                desiredWeightController.isLbSelected.value = (value == "lb");
                desiredWeightController
                    .saveWeightAndUnit(); // Save when unit changes
              });
            },
          ),
        ),
        UIHelper.verticalSpace(20.h),

        /// --- WEIGHT PICKER SLIDER ---
        CustomDesiredWeightRuler(
          controller: desiredWeightController,
          minValue: 1, // Start from 1 instead of 0
          maxValue: 500,
          centerIndicatorColor: Colors.blue,
        ),
      ],
    );
  }
}
