// import 'dart:developer';
// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:get/get.dart';

// import '../../../../../../constants/text_font_style.dart';
// import '../../../../../../controllers/weight_picker_widget_controller.dart';
// import '../../../../../../controllers/slider_button_controller.dart';
// import '../../../../../../custom_widgets/custom_slider_button.dart';
// import '../../../../../../helper/ui_helpers.dart';
// import '../../../../../information_gather_meal_plan/presentation/widgets/select_weight/presentation/widgets/weight_picker_widget.dart';

// class DesiredWeightWidget extends StatelessWidget {
//   DesiredWeightWidget({super.key});

//   final weightController = Get.find<WeightController>();
//   final sliderController = Get.find<SliderButtonController>();

//   @override
//   Widget build(BuildContext context) {
//     // Initialize the unit selector
//     sliderController.initialize(["kg", "lb"]);

//     return Column(
//       children: [
//         Text(
//           "What’s Your Desired Weight?",
//           style: TextFontStyle.headline22w500cfefefeStylePoppins,
//         ),
//         UIHelper.verticalSpace(134.h),

//         /// --- UNIT SELECTOR (kg / lb) ---
//         Align(
//           alignment: Alignment.center,
//           child: SliderButton(
//             controller: sliderController,
//             items: const ["kg", "lb"],
//             onValueChanged: (index, value) {
//               log("Selected unit: $value");
//               weightController.isLbSelected.value = (value == "lb");
//             },
//           ),
//         ),
//         UIHelper.verticalSpace(100.h),

//         /// --- WEIGHT PICKER SLIDER ---
//         CustomWeightRuler(
//           title: "Measurement Ruler",
//           unit: "Kg",
//           minValue: 0,
//           maxValue: 99,
//           centerIndicatorColor: Colors.purple,
//         ),
//       ],
//     );
//   }
// }

import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../../../../constants/text_font_style.dart';
import '../../../../../../controllers/weight_picker_widget_controller.dart';
import '../../../../../../controllers/slider_button_controller.dart';
import '../../../../../../custom_widgets/custom_slider_button.dart';
import '../../../../../../helper/ui_helpers.dart';
import '../../../../../information_gather_meal_plan/presentation/widgets/select_weight/presentation/widgets/weight_picker_widget.dart';

class DesiredWeightWidget extends StatelessWidget {
  DesiredWeightWidget({super.key});

  // Use Get.find() with tags for desired weight
  final weightController = Get.find<WeightController>(tag: 'desired_weight');
  final sliderController = Get.find<SliderButtonController>(
    tag: 'desired_weight_unit',
  );

  @override
  Widget build(BuildContext context) {
    // Initialize the unit selector
    sliderController.initialize(["kg", "lb"]);

    return Column(
      children: [
        Text(
          "What's Your Desired Weight?",
          style: TextFontStyle.headline22w500cfefefeStylePoppins,
        ),
        UIHelper.verticalSpace(134.h),

        /// --- UNIT SELECTOR (kg / lb) ---
        Align(
          alignment: Alignment.center,
          child: SliderButton(
            controller: sliderController,
            items: const ["kg", "lb"],
            onValueChanged: (index, value) {
              log("Selected unit: $value");
              weightController.isLbSelected.value = (value == "lb");
            },
          ),
        ),
        UIHelper.verticalSpace(100.h),

        /// --- WEIGHT PICKER SLIDER ---
        CustomWeightRuler(
          controller: weightController,
          minValue: 0,
          maxValue: 99,
          centerIndicatorColor: Colors.green,
        ),
      ],
    );
  }
}
