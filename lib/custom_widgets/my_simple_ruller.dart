// import 'package:bloodfit/gen/colors.gen.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:get/get.dart';
// import '../controllers/ruler_controller.dart';
// import '../helper/ui_helpers.dart';

// class UniversalRulerPicker extends StatefulWidget {
//   final double minValue;
//   final double maxValue;
//   final double initialValue;
//   final double step; // For decimal precision
//   final int scaleItemWidth;
//   final double scaleLabelSize;
//   final double scaleLabelWidth;
//   final double scaleBottomPadding;
//   final double longLineHeight;
//   final double shortLineHeight;
//   final Color lineColor;
//   final Color selectedColor;
//   final Color labelColor;
//   final double lineStroke;
//   final double height;
//   final Axis axis;
//   final List<String> unitOptions; // List of possible units
//   final String initialUnit; // Initial unit value
//   final double selectedValueTextSize;
//   final double pointerHeight;
//   final double pointerThickness;
//   final double pointerUpwardOffset;
//   final RulerController controller;
//   final Function(double, String)? onValueChanged; // Passes value and unit
//   final double numberPadding;
//   final double containerToNumbersPadding;
//   final double containerToSelectedValuePadding;

//   const UniversalRulerPicker({
//     Key? key,
//     required this.controller,
//     required this.unitOptions,
//     this.initialUnit = "",
//     this.minValue = 0.0,
//     this.maxValue = 200.0,
//     this.initialValue = 100.0,
//     this.step = 1.0, // Default to integer steps
//     this.scaleItemWidth = 10,
//     this.scaleLabelSize = 14,
//     this.scaleLabelWidth = 40,
//     this.scaleBottomPadding = 6,
//     this.longLineHeight = 24,
//     this.shortLineHeight = 12,
//     this.lineColor = Colors.grey,
//     this.selectedColor = Colors.orange,
//     this.labelColor = Colors.grey,
//     this.lineStroke = 2,
//     this.height = 100,
//     this.axis = Axis.horizontal,
//     this.selectedValueTextSize = 24,
//     this.pointerHeight = 80,
//     this.pointerThickness = 6,
//     this.pointerUpwardOffset = 10,
//     this.onValueChanged,
//     this.numberPadding = 12.0,
//     this.containerToNumbersPadding = 8.0,
//     this.containerToSelectedValuePadding = 16.0,
//   }) : assert(minValue <= initialValue && initialValue <= maxValue),
//        super(key: key);

//   @override
//   _UniversalRulerPickerState createState() => _UniversalRulerPickerState();
// }

// class _UniversalRulerPickerState extends State<UniversalRulerPicker> {
//   late final ScrollController _scrollController;
//   late final ScrollController _numbersScrollController;
//   String _currentUnit = "";

//   @override
//   void initState() {
//     super.initState();
//     _scrollController = ScrollController();
//     _numbersScrollController = ScrollController();
//     _currentUnit = widget.initialUnit;

//     WidgetsBinding.instance.addPostFrameCallback((_) {
//       _jumpToInitialValue();
//     });

//     _scrollController.addListener(_onScroll);
//   }

//   void _jumpToInitialValue() {
//     final double centerOffset = _centerOffset();
//     final initialIndex = ((widget.initialValue - widget.minValue) / widget.step).round();
//     final initialScrollPosition = initialIndex * widget.scaleItemWidth.w - centerOffset;
//     _scrollController.jumpTo(initialScrollPosition);
//     widget.controller.selectedValue.value = widget.initialValue.toInt();
//     _syncNumberScroll();
//   }

//   double _centerOffset() {
//     return widget.axis == Axis.horizontal
//         ? (MediaQuery.of(context).size.width / 2 - widget.scaleItemWidth.w / 2)
//         : (widget.height.h / 2 - widget.scaleItemWidth.h / 2);
//   }

//   void _onScroll() {
//     final double centerOffset = _centerOffset();
//     final scrollPixels = _scrollController.position.pixels;
//     final exactPosition = (scrollPixels + centerOffset) / widget.scaleItemWidth.w;
//     final int index = exactPosition.round();
//     final double newValue = (index * widget.step + widget.minValue).clamp(widget.minValue, widget.maxValue);

//     if (newValue != widget.controller.selectedValue.value.toDouble()) {
//       widget.controller.selectedValue.value = newValue.toInt();
//       widget.onValueChanged?.call(newValue, _currentUnit);
//     }
//     _syncNumberScroll();
//   }

//   // Implement smooth snapping behavior
//   void _fixScrollPosition() {
//     final double centerOffset = _centerOffset();
//     final scrollPixels = _scrollController.position.pixels;
//     final exactPosition = (scrollPixels + centerOffset) / widget.scaleItemWidth.w;
//     final int index = exactPosition.round();
//     final double targetScrollPosition = index * widget.scaleItemWidth.w - centerOffset;

//     if ((scrollPixels - targetScrollPosition).abs() > 0.5) {
//       _scrollController.jumpTo(targetScrollPosition);
//     }
//   }

//   void _syncNumberScroll() {
//     if (_numbersScrollController.hasClients) {
//       _numbersScrollController.jumpTo(_scrollController.offset);
//     }
//   }

//   void updateUnit(String unit) {
//     setState(() {
//       _currentUnit = unit;
//     });
//     widget.onValueChanged?.call(
//       widget.controller.selectedValue.value.toDouble(),
//       unit
//     ); // Notify of unit change
//   }

//   String getCurrentUnit() {
//     return _currentUnit;
//   }

//   @override
//   Widget build(BuildContext context) {
//     final bool isHorizontal = widget.axis == Axis.horizontal;
//     final double totalHeight = widget.height.h; // For fixed pointer, we just need the ruler height

//     return NotificationListener<ScrollEndNotification>(
//       onNotification: (notification) {
//         WidgetsBinding.instance.addPostFrameCallback((_) {
//           _fixScrollPosition();
//           _syncNumberScroll();
//         });
//         return true;
//       },
//       child: SizedBox(
//         height: totalHeight,
//         width: isHorizontal ? double.infinity : MediaQuery.of(context).size.width,
//         child: Stack(
//           children: [
//             // RULER BACKGROUND - This moves behind the fixed pointer
//             Container(
//               color: AppColors.c3c3c3c,
//               child: ListView.builder(
//                 controller: _scrollController,
//                 scrollDirection: widget.axis,
//                 itemCount: ((widget.maxValue - widget.minValue) / widget.step).ceil() + 1,
//                 padding: EdgeInsets.zero,
//                 itemBuilder: (context, index) {
//                   final double value = widget.minValue + (index * widget.step);
//                   final bool isLongLine = (value % (widget.step * 5)) == 0; // Mark every 5th item as long
//                   final double lineHeight = isLongLine ? widget.longLineHeight.h : widget.shortLineHeight.h;
//                   final bool shouldDisplayLabel = (value % (widget.step * 10)) == 0; // Show label every 10th item

//                   return SizedBox(
//                     width: isHorizontal ? widget.scaleItemWidth.w : null,
//                     height: isHorizontal ? null : widget.scaleItemWidth.h,
//                     child: CustomPaint(
//                       painter: _RulerPainter(
//                         value: value,
//                         displayValue: shouldDisplayLabel ? value : null,
//                         selectedValue: widget.controller.selectedValue.value.toDouble(),
//                         scaleLabelSize: widget.scaleLabelSize.sp,
//                         longLineHeight: lineHeight,
//                         shortLineHeight: widget.shortLineHeight.h,
//                         lineColor: widget.lineColor,
//                         selectedColor: widget.selectedColor,
//                         labelColor: widget.labelColor,
//                         lineStroke: widget.lineStroke.w,
//                         axis: widget.axis,
//                         shouldDisplayLabel: shouldDisplayLabel,
//                       ),
//                     ),
//                   );
//                 },
//               ),
//             ),

//             // FIXED POINTER + SELECTED VALUE - Positioned in the center
//             if (isHorizontal)
//               Positioned(
//                 top: 0,
//                 left: MediaQuery.of(context).size.width / 2 - widget.scaleItemWidth.w / 2,
//                 height: totalHeight,
//                 width: widget.scaleItemWidth.w * 2.5, // Increase width to prevent overflow
//                 child: Column(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   mainAxisSize: MainAxisSize.min,
//                   children: [
//                     // Show the selected value above the pointer only if selectedValueTextSize is greater than 0
//                     if (widget.selectedValueTextSize > 0)
//                       Obx(() {
//                         final selected = widget.controller.selectedValue.value.toDouble();
//                         return Container(
//                           constraints: BoxConstraints(maxWidth: widget.scaleItemWidth.w * 2.5 - 10.w), // Ensure text fits
//                           child: Row(
//                             mainAxisSize: MainAxisSize.min,
//                             children: [
//                               Flexible(
//                                 child: Text(
//                                   selected.toStringAsFixed(_getDecimalPlaces()),
//                                   style: TextStyle(
//                                     fontSize: widget.selectedValueTextSize.sp,
//                                     fontWeight: FontWeight.bold,
//                                     color: widget.selectedColor,
//                                   ),
//                                   textAlign: TextAlign.center,
//                                   overflow: TextOverflow.ellipsis,
//                                 ),
//                               ),
//                               Text(
//                                 " $_currentUnit",
//                                 style: TextStyle(
//                                   fontSize: widget.selectedValueTextSize.sp * 0.7, // Slightly larger unit text but still smaller
//                                   fontWeight: FontWeight.bold,
//                                   color: widget.selectedColor,
//                                 ),
//                               ),
//                             ],
//                           ),
//                         );
//                       }),
//                     if (widget.selectedValueTextSize > 0) UIHelper.verticalSpace(5.h),
//                     // Pointer indicator that stays fixed in the center
//                     Container(
//                       height: widget.pointerHeight.h,
//                       width: widget.pointerThickness.w,
//                       color: widget.selectedColor,
//                     ),
//                     // Small indicator below the pointer
//                     Container(
//                       height: 5.h,
//                       width: widget.pointerThickness.w * 2,
//                       decoration: BoxDecoration(
//                         color: widget.selectedColor,
//                         shape: BoxShape.circle,
//                       ),
//                     ),
//                   ],
//                 ),
//               )
//             else
//               // Vertical mode - fixed pointer on the center right of the ruler
//               Positioned(
//                 right: 0,
//                 top: 0,
//                 height: widget.height.h,
//                 child: Container(
//                   width: 120.w, // Increased width to accommodate content
//                   child: Column(
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     mainAxisSize: MainAxisSize.min,
//                     children: [
//                       if (widget.selectedValueTextSize > 0) // Only show if text size is greater than 0
//                         Row(
//                           mainAxisSize: MainAxisSize.min,
//                           children: [
//                             // Pointer indicator that stays fixed
//                             Container(
//                               width: widget.pointerHeight.w,
//                               height: widget.pointerThickness.h,
//                               color: widget.selectedColor,
//                             ),
//                             UIHelper.horizontalSpace(5.w),
//                             ConstrainedBox(
//                               constraints: BoxConstraints(maxWidth: 80.w), // Limit the width of text content
//                               child: Column(
//                                 mainAxisSize: MainAxisSize.min,
//                                 crossAxisAlignment: CrossAxisAlignment.start,
//                                 children: [
//                                   Obx(() {
//                                     final selected = widget.controller.selectedValue.value.toDouble();
//                                     return Text(
//                                       "${selected.toStringAsFixed(_getDecimalPlaces())}",
//                                       style: TextStyle(
//                                         fontSize: widget.selectedValueTextSize.sp,
//                                         fontWeight: FontWeight.bold,
//                                         color: widget.selectedColor,
//                                       ),
//                                       overflow: TextOverflow.ellipsis,
//                                     );
//                                   }),
//                                   Text(
//                                     _currentUnit,
//                                     style: TextStyle(
//                                       fontSize: 14.sp,
//                                       color: widget.selectedColor,
//                                     ),
//                                   ),
//                                 ],
//                               ),
//                             ),
//                           ],
//                         ),
//                     ],
//                   ),
//                 ),
//               ),
//           ],
//         ),
//       ),
//     );
//   }

//   int _getDecimalPlaces() {
//     // Determine decimal places based on the step value
//     String stepStr = widget.step.toString();
//     if (stepStr.contains('.')) {
//       return stepStr.split('.').last.length;
//     }
//     return 0;
//   }

//   @override
//   void dispose() {
//     _scrollController.dispose();
//     _numbersScrollController.dispose();
//     super.dispose();
//   }
// }

// class _RulerPainter extends CustomPainter {
//   final double value;
//   final double? displayValue;
//   final double selectedValue;
//   final double scaleLabelSize;
//   final double longLineHeight;
//   final double shortLineHeight;
//   final Color lineColor;
//   final Color selectedColor;
//   final Color labelColor;
//   final double lineStroke;
//   final Axis axis;
//   final bool shouldDisplayLabel;

//   _RulerPainter({
//     required this.value,
//     this.displayValue,
//     required this.selectedValue,
//     required this.scaleLabelSize,
//     required this.longLineHeight,
//     required this.shortLineHeight,
//     required this.lineColor,
//     required this.selectedColor,
//     required this.labelColor,
//     required this.lineStroke,
//     required this.axis,
//     required this.shouldDisplayLabel,
//   });

//   @override
//   void paint(Canvas canvas, Size size) {
//     // Since the selected value is displayed in a fixed position over the ruler,
//     // we don't need to compare against selectedValue here
//     // Instead, we just draw the lines normally
//     final paint = Paint()
//       ..color = lineColor
//       ..strokeWidth = lineStroke;

//     final bool isLongLine = shouldDisplayLabel;
//     final double lineLen = isLongLine ? longLineHeight : shortLineHeight;

//     if (axis == Axis.horizontal) {
//       final double centerY = size.height / 2;
//       canvas.drawLine(
//         Offset(size.width / 2, centerY - lineLen / 2),
//         Offset(size.width / 2, centerY + lineLen / 2),
//         paint,
//       );

//       // Draw label if needed
//       if (shouldDisplayLabel) {
//         final TextPainter textPainter = TextPainter(
//           text: TextSpan(
//             text: displayValue?.toStringAsFixed(0),
//             style: TextStyle(
//               color: labelColor,
//               fontSize: scaleLabelSize,
//             ),
//           ),
//           textDirection: TextDirection.ltr,
//         );
//         textPainter.layout();
//         final offset = Offset(
//           size.width / 2 - textPainter.width / 2,
//           centerY + lineLen / 2 + 5,
//         );
//         textPainter.paint(canvas, offset);
//       }
//     } else {
//       final double centerX = size.width / 2;
//       canvas.drawLine(
//         Offset(centerX - lineLen / 2, size.height / 2),
//         Offset(centerX + lineLen / 2, size.height / 2),
//         paint,
//       );
//     }
//   }

//   @override
//   bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
// }
