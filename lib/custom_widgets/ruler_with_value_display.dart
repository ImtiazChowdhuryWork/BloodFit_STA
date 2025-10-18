// import 'package:flutter/material.dart';
// import 'fixed_center_ruler_picker.dart';
// import '../controllers/ruler_controller.dart';

// /// A wrapper for FixedCenterRulerPicker that only contains the ruler and pointer
// /// without any value display - for when you need just the interactive ruler component
// class RulerPickerOnly extends StatelessWidget {
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

//   const RulerPickerOnly({
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
//     return FixedCenterRulerPicker(
//       controller: controller,
//       minValue: minValue,
//       maxValue: maxValue,
//       initialValue: initialValue,
//       step: step,
//       scaleItemWidth: scaleItemWidth,
//       scaleLabelSize: scaleLabelSize,
//       longLineHeight: longLineHeight,
//       shortLineHeight: shortLineHeight,
//       lineColor: lineColor,
//       selectedColor: selectedColor,
//       labelColor: labelColor,
//       lineStroke: lineStroke,
//       height: height,
//       axis: axis,
//       unit: unit,
//       selectedValueTextSize: selectedValueTextSize,
//       pointerHeight: pointerHeight,
//       pointerWidth: pointerWidth,
//       onValueChanged: onValueChanged,
//       majorTickInterval: majorTickInterval,
//       minorTickInterval: minorTickInterval,
//     );
//   }
// }
