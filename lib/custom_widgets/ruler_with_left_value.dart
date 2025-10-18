// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:get/get.dart';
// import 'fixed_center_ruler_picker.dart';
// import '../controllers/ruler_controller.dart';

// /// A widget that positions the selected value on the left side and the ruler on the right side
// /// as per the requirements:
// /// - Selected value is on the left side of the screen, outside the ruler container
// /// - Ruler container is on the right side of the screen
// /// - Ruler container contains only the ruler and pointer (nothing else)
// class RulerWithLeftValue extends StatelessWidget {
//   final double minValue;
//   final double maxValue;
//   final double initialValue;
//   final double step;
//   final int scaleItemWidth;
//   final double scaleLabelSize;
//   final double longLineHeight;
//   final double shortLineHeight;
//   final Color lineColor;
//   final Color selectedColor;
//   final Color labelColor;
//   final double lineStroke;
//   final double height;
//   final Axis axis;
//   final String unit;
//   final double selectedValueTextSize;
//   final double pointerHeight;
//   final double pointerWidth;
//   final RulerController controller;
//   final Function(double)? onValueChanged;
//   final double majorTickInterval;
//   final double minorTickInterval;

//   const RulerWithLeftValue({
//     Key? key,
//     required this.controller,
//     this.minValue = 0.0,
//     this.maxValue = 200.0,
//     this.initialValue = 100.0,
//     this.step = 1.0,
//     this.scaleItemWidth = 10,
//     this.scaleLabelSize = 14,
//     this.longLineHeight = 24,
//     this.shortLineHeight = 12,
//     this.lineColor = Colors.grey,
//     this.selectedColor = Colors.redAccent,
//     this.labelColor = Colors.grey,
//     this.lineStroke = 2,
//     this.height = 100,
//     this.axis = Axis.horizontal,
//     this.unit = "kg",
//     this.selectedValueTextSize = 24,
//     this.pointerHeight = 30,
//     this.pointerWidth = 2,
//     this.onValueChanged,
//     this.majorTickInterval = 10.0,
//     this.minorTickInterval = 1.0,
//   }) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return Row(
//       children: [
//         // SELECTED VALUE DISPLAY - Positioned on the LEFT side of the screen
//         Expanded(
//           flex: 1,
//           child: Container(
//             alignment: Alignment.center,
//             child: Obx(() {
//               int value = controller.selectedValue.value;
//               // Calculate the actual value with decimals based on step and position
//               // This provides more accurate display than just the integer
//               return Text(
//                 "$value $unit",
//                 style: TextStyle(
//                   fontSize: selectedValueTextSize.sp,
//                   fontWeight: FontWeight.bold,
//                   color: selectedColor,
//                 ),
//               );
//             }),
//           ),
//         ),

//         // RULER AND POINTER CONTAINER - Positioned on the RIGHT side of the screen
//         // This container contains ONLY the ruler and pointer as required
//         Container(
//           width: axis == Axis.horizontal ? 300 : 150, // Appropriate width for each orientation
//           height: height, // Keep the height specified
//           child: FixedCenterRulerPicker(
//             controller: controller,
//             minValue: minValue,
//             maxValue: maxValue,
//             initialValue: initialValue,
//             step: step,
//             scaleItemWidth: scaleItemWidth,
//             scaleLabelSize: scaleLabelSize,
//             longLineHeight: longLineHeight,
//             shortLineHeight: shortLineHeight,
//             lineColor: lineColor,
//             selectedColor: selectedColor,
//             labelColor: labelColor,
//             lineStroke: lineStroke,
//             height: height,
//             axis: axis,
//             unit: unit,
//             selectedValueTextSize: selectedValueTextSize,
//             pointerHeight: pointerHeight,
//             pointerWidth: pointerWidth,
//             onValueChanged: onValueChanged,
//             majorTickInterval: majorTickInterval,
//             minorTickInterval: minorTickInterval,
//           ),
//         ),
//       ],
//     );
//   }

//   int _getDecimalPlaces() {
//     // Determine decimal places based on the step value
//     String stepStr = step.toString();
//     if (stepStr.contains('.')) {
//       return stepStr.split('.').last.length;
//     }
//     return 0;
//   }
// }
