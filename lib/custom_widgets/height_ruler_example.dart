// import 'dart:developer';

// import 'package:bloodfit/constants/text_font_style.dart';
// import 'package:bloodfit/custom_widgets/my_simple_ruller.dart';
// import 'package:bloodfit/gen/colors.gen.dart';
// import 'package:bloodfit/helper/ui_helpers.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:get/get.dart';

// import '../../controllers/ruler_controller.dart';
// import '../../controllers/slider_button_controller.dart';
// import '../../custom_widgets/custom_slider_button.dart';

// class SelectHeightScreen extends StatelessWidget {
//   const SelectHeightScreen({super.key});

//   @override
//   Widget build(BuildContext context) {
//     // Existing RulerController
//     final rulerController = Get.find<RulerController>();

//     // New SliderButtonController for height units
//     final heightTypeController = Get.put(SliderButtonController());
    
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Text(
//           "What’s Your Height?",
//           style: TextFontStyle.headline22w500cfefefeStylePoppins,
//         ),
//         UIHelper.verticalSpace(50.h),

//         Align(
//           alignment: Alignment.center,
//           child: SliderButton(
//             controller: heightTypeController,
//             items: ["cm", "ft"],
//             onValueChanged: (index, value) {
//               log("Selected height unit: $index, value: $value");
//             },
//           ),
//         ),
//         UIHelper.verticalSpace(50.h),

//         // Vertical ruler for height
//         Expanded(
//           child: Center(
//             child: SizedBox(
//               width: 200.w,
//               child: Obx(() {
//                 return UniversalRulerPicker(
//                   controller: rulerController,
//                   unitOptions: ["cm", "ft"], // Unit options for height
//                   initialUnit: "cm", // Initial unit
//                   selectedValueTextSize: 36.sp,
//                   minValue: 100.0, // Min height 100 cm
//                   maxValue: 250.0, // Max height 250 cm
//                   initialValue: 170.0, // Starting height
//                   step: 0.5, // Allow half-unit increments
//                   onValueChanged: (value, unit) {
//                     log("Selected height: $value $unit");
//                   },
//                   scaleLabelSize: 16.sp,
//                   scaleBottomPadding: 10,
//                   scaleItemWidth: 15,
//                   longLineHeight: 30,
//                   shortLineHeight: 15.h,
//                   lineColor: AppColors.c000000,
//                   selectedColor: AppColors.cFFFFFF,
//                   labelColor: AppColors.c000000,
//                   lineStroke: 2,
//                   pointerUpwardOffset: 10,
//                   pointerHeight: 6,
//                   pointerThickness: 8,
//                   height: 400.h,
//                   axis: Axis.vertical, // Vertical orientation for height
//                 );
//               }),
//             ),
//           ),
//         ),
//       ],
//     );
//   }
// }