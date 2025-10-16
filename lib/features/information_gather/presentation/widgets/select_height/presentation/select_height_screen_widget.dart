// import 'dart:developer';

// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:get/get.dart';

// import '../../../../../../constants/text_font_style.dart';
// import '../../../../../../controllers/ruler_controller.dart';
// import '../../../../../../controllers/slider_button_controller.dart';
// import '../../../../../../custom_widgets/custom_slider_button.dart';
// import '../../../../../../custom_widgets/my_simple_ruller.dart';
// import '../../../../../../gen/colors.gen.dart';
// import '../../../../../../helper/ui_helpers.dart';

// class SelectHeightScreenWidget extends StatelessWidget {
//   const SelectHeightScreenWidget({super.key});

//   @override
//   Widget build(BuildContext context) {
//     // Existing RulerController
//     final rulerController = Get.find<RulerController>();

//     // New SliderButtonController
//     final heightTypeController = Get.put(SliderButtonController());

//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Text(
//           "What’s Your Height?",
//           style: TextFontStyle.headline22w500cfefefeStylePoppins,
//         ),
//         UIHelper.verticalSpace(100.h),

//         Align(
//           alignment: Alignment.center,
//           child: SliderButton(
//             controller: heightTypeController,
//             items: ["cm", "ft"],
//             onValueChanged: (index, value) {
//               log("Selected index: $index, value: $value");
//             },
//           ),
//         ),
//         UIHelper.verticalSpace(50.h),

//         // USAGE EXAMPLE
//         Obx(() {
//           return SimpleRulerPicker(
//             controller: rulerController,
//             dataType: heightTypeController.selectedValue.value,
//             axis: Axis.vertical,
//             selectedValueTextSize: 36.sp,
//             minValue: 100,
//             maxValue: 500,
//             initialValue: 110,
//             onValueChanged: (value) {
//               log("Selected value: $value");
//             },
//             numberPadding: 80,
//             containerToSelectedValuePadding: 40,
//             scaleLabelSize: 20.sp,
//             scaleBottomPadding: 200,
//             scaleItemWidth: 21,
//             longLineHeight: 46,
//             shortLineHeight: 24.h,
//             lineColor: AppColors.c000000,
//             selectedColor: AppColors.cFFFFFF,
//             labelColor: AppColors.c000000,
//             lineStroke: 3,
//             pointerUpwardOffset: 60,
//             height: 430.h,
//           );
//         }),
//       ],
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../../../controllers/ruler_controller.dart';
import '../../../../../../custom_widgets/my_simple_ruller.dart';

class SelectHeightScreenWidget extends StatelessWidget {
  SelectHeightScreenWidget({super.key});

  // Instantiate your RulerController
  final RulerController rulerController = Get.put(RulerController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text("Select Your Height"),
        backgroundColor: Colors.black,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // The ruler picker widget
            Expanded(
              child: Center(
                child: SimpleRulerPicker(
                  controller: rulerController,
                  minValue: 50,
                  maxValue: 250,
                  initialValue: 170,
                  axis: Axis.horizontal,
                  dataType: "cm",
                  selectedColor: Colors.orange,
                  lineColor: Colors.grey,
                  labelColor: Colors.white,
                  pointerHeight: 80,
                  pointerThickness: 4,
                  scaleItemWidth: 10,
                  scaleLabelSize: 14,
                  onValueChanged: (value) {
                    // This is optional since RulerController already updates
                    print("Selected value: $value");
                  },
                ),
              ),
            ),

            const SizedBox(height: 24),

            // Only wrap the Text displaying the value with Obx
            Obx(() {
              return Text(
                "${rulerController.selectedValue.value} cm",
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              );
            }),

            const SizedBox(height: 24),

            ElevatedButton(
              onPressed: () {
                // Example: print selected value
                print(
                  "Confirmed height: ${rulerController.selectedValue.value} cm",
                );
              },
              child: const Text("Confirm"),
            ),
          ],
        ),
      ),
    );
  }
}
