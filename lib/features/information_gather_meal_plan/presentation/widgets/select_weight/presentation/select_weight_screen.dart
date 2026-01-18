// import 'dart:developer';
// import 'package:bloodfit/constants/text_font_style.dart';
// import 'package:bloodfit/helper/ui_helpers.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:get/get.dart';
// import '../../../../../../controllers/weight_picker_widget_controller.dart';
// import '../../../../../../controllers/slider_button_controller.dart';
// import '../../../../../../custom_widgets/custom_slider_button.dart';
// import 'widgets/weight_picker_widget.dart';

// class SelectWeightScreen extends StatelessWidget {
//   const SelectWeightScreen({super.key});

//   @override
//   Widget build(BuildContext context) {
//     /// Controllers - use Get.find() with tags
//     final weightController = Get.find<WeightController>(tag: 'current_weight');
//     final weightTypeSliderButtonController = Get.find<SliderButtonController>(
//       tag: 'current_weight_unit',
//     );

//     // Initialize the slider button controller with items
//     weightTypeSliderButtonController.initialize(["kg", "lb"]);

//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Text(
//           "What's Your Weight?",
//           style: TextFontStyle.headline22w500cfefefeStylePoppins,
//         ),

//         // Optional: Show selected weight
//         Obx(
//           () => Text(
//             'Selected Weight: ${weightController.centerValue.value.toStringAsFixed(1)} ${weightController.unit}',
//             style: TextFontStyle.headline10w500cfefefeStylePoppins,
//           ),
//         ),

//         UIHelper.verticalSpace(30.h), // Reduced space
//         /// --- UNIT SELECTOR (kg / lb) ---
//         Align(
//           alignment: Alignment.center,
//           child: SliderButton(
//             controller: weightTypeSliderButtonController,
//             items: const ["kg", "lb"],
//             onValueChanged: (index, value) {
//               log("Selected unit: $value");

//               // Use a post-frame callback to avoid updating during build
//               WidgetsBinding.instance.addPostFrameCallback((_) {
//                 weightController.isLbSelected.value = (value == "lb");
//                 weightController.saveWeightAndUnit(); // Save when unit changes
//               });
//             },
//           ),
//         ),
//         UIHelper.verticalSpace(20.h),

//         /// --- WEIGHT PICKER SLIDER ---
//         CustomWeightRuler(
//           controller: weightController,
//           minValue: 1, // Start from 1 instead of 0
//           maxValue: 500,
//           centerIndicatorColor: Colors.blue,
//         ),
//       ],
//     );
//   }
// }

import 'dart:developer';
import 'package:bloodfit/constants/text_font_style.dart';
import 'package:bloodfit/helper/ui_helpers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../../../../controllers/weight_picker_widget_controller.dart';
import '../../../../../../controllers/slider_button_controller.dart';
import '../../../../../../custom_widgets/custom_slider_button.dart';
import 'widgets/weight_picker_widget.dart';

class SelectWeightScreen extends StatelessWidget {
  const SelectWeightScreen({super.key});

  @override
  Widget build(BuildContext context) {
    /// Controllers - use Get.find() with tags
    final weightController = Get.find<WeightController>(tag: 'current_weight');
    final weightTypeSliderButtonController = Get.find<SliderButtonController>(
      tag: 'current_weight_unit',
    );

    // Initialize the slider button controller with items
    weightTypeSliderButtonController.initialize(["kg", "lb"]);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "What's Your Weight?",
          style: TextFontStyle.headline22w500cfefefeStylePoppins,
        ),

        // Optional: Show selected weight
        Obx(
          () => Padding(
            padding: EdgeInsets.only(top: 8.h),
            child: Text(
              'Selected Weight: ${weightController.centerValue.value.toStringAsFixed(1)} ${weightController.unit}',
              style: TextFontStyle.headline14w500cfefefeStylePoppins,
            ),
          ),
        ),

        UIHelper.verticalSpace(30.h), // Reduced space
        /// --- UNIT SELECTOR (kg / lb) ---
        Align(
          alignment: Alignment.center,
          child: SliderButton(
            controller: weightTypeSliderButtonController,
            items: const ["kg", "lb"],
            onValueChanged: (index, value) {
              log("Selected unit: $value");

              // Use a post-frame callback to avoid updating during build
              WidgetsBinding.instance.addPostFrameCallback((_) {
                weightController.isLbSelected.value = (value == "lb");
                weightController.saveWeightAndUnit(); // Save when unit changes
              });
            },
          ),
        ),
        UIHelper.verticalSpace(20.h),

        /// --- WEIGHT PICKER SLIDER ---
        CustomWeightRuler(
          controller: weightController,
          minValue: 1, // Start from 1 instead of 0
          maxValue: 500,
          centerIndicatorColor: Colors.blue,
        ),
      ],
    );
  }
}
