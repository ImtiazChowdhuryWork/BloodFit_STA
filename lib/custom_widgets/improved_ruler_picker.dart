// import 'dart:math';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart'; // For HapticFeedback
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:get/get.dart';
// import '../controllers/ruler_controller.dart';

// /// An improved ruler picker with fixed center pointer and enhanced features
// class ImprovedRulerPicker extends StatefulWidget {
//   final double minValue;
//   final double maxValue;
//   final double initialValue;
//   final double step; // For decimal precision
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
//   final double pointerThickness;
//   final RulerController controller;
//   final Function(double)? onValueChanged; // Only passes value, unit is constant here
//   final double majorTickInterval; // Interval for major ticks that trigger haptic feedback
//   final double minorTickInterval; // Interval for minor ticks that show labels

//   const ImprovedRulerPicker({
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
//     this.pointerHeight = 80,
//     this.pointerThickness = 2, // Thinner line as specified
//     this.onValueChanged,
//     this.majorTickInterval = 10.0,
//     this.minorTickInterval = 1.0,
//   }) : assert(minValue <= initialValue && initialValue <= maxValue),
//        super(key: key);

//   @override
//   _ImprovedRulerPickerState createState() => _ImprovedRulerPickerState();
// }

// class _ImprovedRulerPickerState extends State<ImprovedRulerPicker> with TickerProviderStateMixin {
//   late final ScrollController _scrollController;
//   double _currentValue = 0.0;
//   late AnimationController _valueAnimationController;
//   late Animation<double> _valueAnimation;
//   double _lastMajorTickValue = 0.0;
//   bool _isScrolling = false;

//   @override
//   void initState() {
//     super.initState();
//     _scrollController = ScrollController();
//     _currentValue = widget.initialValue;
//     widget.controller.selectedValue.value = widget.initialValue.toInt();
    
//     // Animation for value changes
//     _valueAnimationController = AnimationController(
//       duration: const Duration(milliseconds: 150),
//       vsync: this,
//     );
//     _valueAnimation = Tween<double>(begin: widget.initialValue, end: widget.initialValue).animate(
//       CurvedAnimation(parent: _valueAnimationController, curve: Curves.easeOutCubic),
//     );
    
//     WidgetsBinding.instance.addPostFrameCallback((_) {
//       _jumpToInitialValue();
//     });

//     _scrollController.addListener(_onScroll);
//     _lastMajorTickValue = _getNearestMajorTickValue(widget.initialValue);
//   }

//   void _jumpToInitialValue() {
//     final double centerOffset = _centerOffset();
//     final initialIndex = ((widget.initialValue - widget.minValue) / widget.step).round();
//     final initialScrollPosition = initialIndex * widget.scaleItemWidth.w - centerOffset;
//     _scrollController.jumpTo(initialScrollPosition);
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
//     final double calculatedValue = (exactPosition * widget.step + widget.minValue).clamp(widget.minValue, widget.maxValue);
    
//     // Update the current value with animation
//     setState(() {
//       _currentValue = calculatedValue;
//     });
    
//     // Update the controller's selected value
//     widget.controller.selectedValue.value = calculatedValue.toInt();
    
//     // Check for major tick crossing and trigger haptic feedback
//     _checkForMajorTickCrossing(calculatedValue);
    
//     // Notify value change
//     widget.onValueChanged?.call(calculatedValue);
//   }

//   void _checkForMajorTickCrossing(double value) {
//     double nearestMajorTick = _getNearestMajorTickValue(value);
    
//     if ((nearestMajorTick - _lastMajorTickValue).abs() >= widget.majorTickInterval && 
//         _isScrolling) {
//       _lastMajorTickValue = nearestMajorTick;
//       // Trigger haptic feedback
//       HapticFeedback.selectionClick();
//     }
//   }

//   double _getNearestMajorTickValue(double value) {
//     return (value / widget.majorTickInterval).round() * widget.majorTickInterval;
//   }

//   // Implement smooth snapping behavior with elastic motion
//   void _fixScrollPosition() async {
//     if (_isScrolling) return; // Prevent multiple animations
    
//     _isScrolling = true;
    
//     try {
//       final double centerOffset = _centerOffset();
//       final scrollPixels = _scrollController.position.pixels;
//       final exactPosition = (scrollPixels + centerOffset) / widget.scaleItemWidth.w;
//       final int index = exactPosition.round();
//       final double targetValue = (index * widget.step + widget.minValue).clamp(widget.minValue, widget.maxValue);
//       final double targetScrollPosition = index * widget.scaleItemWidth.w - centerOffset;
      
//       // Update the current value and controller before animation
//       setState(() {
//         _currentValue = targetValue;
//       });
//       widget.controller.selectedValue.value = targetValue.toInt();
      
//       // Trigger a value change to update the animation
//       _valueAnimationController
//         ..value = _currentValue
//         ..animateTo(targetValue, duration: const Duration(milliseconds: 150), curve: Curves.easeOutCubic);
      
//       // Calculate the difference to determine the animation curve
//       double positionDiff = (scrollPixels - targetScrollPosition).abs();
      
//       // Use different animation curves based on the distance to snap to
//       Curve animationCurve;
//       if (positionDiff > widget.scaleItemWidth.w * 5) {
//         // For larger distances, use a bouncy curve
//         animationCurve = Curves.elasticOut;
//       } else {
//         // For shorter distances, use a damped curve
//         animationCurve = Curves.decelerate;
//       }
      
//       // Animate to the target position with appropriate curve for elastic feel
//       await _scrollController.animateTo(
//         targetScrollPosition,
//         duration: const Duration(milliseconds: 400),
//         curve: animationCurve,
//       );
      
//       // Notify value change after snapping
//       widget.onValueChanged?.call(targetValue);
//     } finally {
//       _isScrolling = false;
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     final bool isHorizontal = widget.axis == Axis.horizontal;
//     final double totalHeight = widget.height.h;

//     return NotificationListener<ScrollEndNotification>(
//       onNotification: (notification) {
//         // Fix scroll position when scrolling ends with damped elastic motion
//         WidgetsBinding.instance.addPostFrameCallback((_) {
//           _fixScrollPosition();
//         });
//         return true;
//       },
//       child: NotificationListener<OverscrollNotification>(
//         onNotification: (notification) {
//           // Handle overscroll - prevent over-scrolling
//           return false;
//         },
//         child: SizedBox(
//           height: totalHeight,
//           width: isHorizontal 
//               ? double.infinity 
//               : MediaQuery.of(context).size.width,
//           child: Stack(
//             children: [
//               // SCROLLABLE RULER BACKGROUND - This moves behind the fixed pointer
//               Container(
//                 color: const Color(0xFF3C3C3C), // AppColors.c3c3c3c
//                 child: ListView.builder(
//                   controller: _scrollController,
//                   scrollDirection: widget.axis,
//                   itemCount: ((widget.maxValue - widget.minValue) / widget.step).ceil() + 1,
//                   padding: EdgeInsets.zero,
//                   itemBuilder: (context, index) {
//                     final double value = widget.minValue + (index * widget.step);
//                     final bool isMajorTick = (value % widget.majorTickInterval) == 0;
//                     final bool showLabel = (value % widget.minorTickInterval) == 0;
//                     final double lineHeight = isMajorTick ? widget.longLineHeight.h : widget.shortLineHeight.h;

//                     return SizedBox(
//                       width: isHorizontal ? widget.scaleItemWidth.w : null,
//                       height: isHorizontal ? null : widget.scaleItemWidth.h,
//                       child: CustomPaint(
//                         painter: _RulerPainter(
//                           value: value,
//                           isMajorTick: isMajorTick,
//                           showLabel: showLabel,
//                           scaleLabelSize: widget.scaleLabelSize.sp,
//                           lineHeight: lineHeight,
//                           lineColor: widget.lineColor,
//                           selectedColor: widget.selectedColor,
//                           labelColor: widget.labelColor,
//                           lineStroke: widget.lineStroke.w,
//                           axis: widget.axis,
//                         ),
//                       ),
//                     );
//                   },
//                 ),
//               ),

//               // FIXED POINTER + SELECTED VALUE - Positioned in the center
//               if (isHorizontal)
//                 Positioned(
//                   top: 0,
//                   left: MediaQuery.of(context).size.width / 2 - widget.pointerThickness.w / 2,
//                   height: totalHeight,
//                   width: 120.w, // Slightly wider for the value display
//                   child: Column(
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     children: [
//                       // Value display above the pointer with smooth animation
//                       AnimatedContainer(
//                         duration: const Duration(milliseconds: 150),
//                         padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
//                         decoration: BoxDecoration(
//                           color: Colors.black.withOpacity(0.7),
//                           borderRadius: BorderRadius.circular(12.r),
//                         ),
//                         child: AnimatedBuilder(
//                           animation: _valueAnimationController,
//                           builder: (context, child) {
//                             return Text(
//                               "${_currentValue.toStringAsFixed(_getDecimalPlaces())} ${widget.unit}",
//                               style: TextStyle(
//                                 fontSize: widget.selectedValueTextSize.sp,
//                                 fontWeight: FontWeight.bold,
//                                 color: widget.selectedColor,
//                               ),
//                             );
//                           },
//                         ),
//                       ),
//                       SizedBox(height: 8.h),
//                       // Pointer line with enhanced glow effect
//                       Container(
//                         height: widget.pointerHeight.h,
//                         width: widget.pointerThickness.w,
//                         decoration: BoxDecoration(
//                           color: widget.selectedColor,
//                           boxShadow: [
//                             BoxShadow(
//                               color: widget.selectedColor.withOpacity(0.7),
//                               blurRadius: 6,
//                               spreadRadius: 1,
//                             ),
//                           ],
//                         ),
//                       ),
//                       SizedBox(height: 4.h),
//                       // Triangle indicator below the pointer
//                       CustomPaint(
//                         size: Size(16.w, 12.h),
//                         painter: _TrianglePainter(color: widget.selectedColor),
//                       ),
//                     ],
//                   ),
//                 )
//               else
//                 // Vertical mode - fixed pointer on the center right of the ruler
//                 Positioned(
//                   right: 0,
//                   top: 0,
//                   height: widget.height.h,
//                   child: Container(
//                     width: 80.w,
//                     child: Column(
//                       mainAxisAlignment: MainAxisAlignment.center,
//                       children: [
//                         // Horizontal pointer line with enhanced styling
//                         Container(
//                           height: widget.pointerThickness.h,
//                           width: widget.pointerHeight.w,
//                           decoration: BoxDecoration(
//                             color: widget.selectedColor,
//                             boxShadow: [
//                               BoxShadow(
//                                 color: widget.selectedColor.withOpacity(0.7),
//                                 blurRadius: 6,
//                                 spreadRadius: 1,
//                               ),
//                             ],
//                           ),
//                         ),
//                         SizedBox(height: 8.h),
//                         // Value display with smooth animation
//                         AnimatedContainer(
//                           duration: const Duration(milliseconds: 150),
//                           padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
//                           decoration: BoxDecoration(
//                             color: Colors.black.withOpacity(0.7),
//                             borderRadius: BorderRadius.circular(12.r),
//                           ),
//                           child: AnimatedBuilder(
//                             animation: _valueAnimationController,
//                             builder: (context, child) {
//                               return Text(
//                                 "${_currentValue.toStringAsFixed(_getDecimalPlaces())} ${widget.unit}",
//                                 style: TextStyle(
//                                   fontSize: widget.selectedValueTextSize.sp,
//                                   fontWeight: FontWeight.bold,
//                                   color: widget.selectedColor,
//                                 ),
//                               );
//                             },
//                           ),
//                         ),
//                         SizedBox(height: 8.h),
//                         // Triangle indicator to the left of the value
//                         CustomPaint(
//                           size: Size(12.w, 16.h),
//                           painter: _TrianglePainter(color: widget.selectedColor, orientation: _TriangleOrientation.left),
//                         ),
//                       ],
//                     ),
//                   ),
//                 ),
//             ],
//           ),
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
//     _valueAnimationController.dispose();
//     super.dispose();
//   }
// }

// /// Custom painter for the ruler lines
// class _RulerPainter extends CustomPainter {
//   final double value;
//   final bool isMajorTick;
//   final bool showLabel;
//   final double scaleLabelSize;
//   final double lineHeight;
//   final Color lineColor;
//   final Color selectedColor;
//   final Color labelColor;
//   final double lineStroke;
//   final Axis axis;

//   _RulerPainter({
//     required this.value,
//     required this.isMajorTick,
//     required this.showLabel,
//     required this.scaleLabelSize,
//     required this.lineHeight,
//     required this.lineColor,
//     required this.selectedColor,
//     required this.labelColor,
//     required this.lineStroke,
//     required this.axis,
//   });

//   @override
//   void paint(Canvas canvas, Size size) {
//     final paint = Paint()
//       ..color = lineColor
//       ..strokeWidth = lineStroke;

//     if (axis == Axis.horizontal) {
//       final double centerY = size.height / 2;
//       canvas.drawLine(
//         Offset(size.width / 2, centerY - lineHeight / 2),
//         Offset(size.width / 2, centerY + lineHeight / 2),
//         paint,
//       );

//       // Draw label if needed
//       if (showLabel && isMajorTick) {
//         final TextPainter textPainter = TextPainter(
//           text: TextSpan(
//             text: value.toStringAsFixed(0),
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
//           centerY + lineHeight / 2 + 5,
//         );
//         textPainter.paint(canvas, offset);
//       }
//     } else {
//       final double centerX = size.width / 2;
//       canvas.drawLine(
//         Offset(centerX - lineHeight / 2, size.height / 2),
//         Offset(centerX + lineHeight / 2, size.height / 2),
//         paint,
//       );
//     }
//   }

//   @override
//   bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
// }

// /// Custom painter for the triangle pointer indicator
// enum _TriangleOrientation { up, down, left, right }

// class _TrianglePainter extends CustomPainter {
//   final Color color;
//   final _TriangleOrientation orientation;

//   _TrianglePainter({required this.color, this.orientation = _TriangleOrientation.down});

//   @override
//   void paint(Canvas canvas, Size size) {
//     final paint = Paint()
//       ..color = color
//       ..style = PaintingStyle.fill;

//     Path path;
//     switch (orientation) {
//       case _TriangleOrientation.up:
//         path = Path()
//           ..moveTo(size.width / 2, 0)
//           ..lineTo(0, size.height)
//           ..lineTo(size.width, size.height)
//           ..close();
//         break;
//       case _TriangleOrientation.down:
//         path = Path()
//           ..moveTo(0, 0)
//           ..lineTo(size.width, 0)
//           ..lineTo(size.width / 2, size.height)
//           ..close();
//         break;
//       case _TriangleOrientation.left:
//         path = Path()
//           ..moveTo(size.width, 0)
//           ..lineTo(size.width, size.height)
//           ..lineTo(0, size.height / 2)
//           ..close();
//         break;
//       case _TriangleOrientation.right:
//         path = Path()
//           ..moveTo(0, 0)
//           ..lineTo(0, size.height)
//           ..lineTo(size.width, size.height / 2)
//           ..close();
//         break;
//     }

//     canvas.drawPath(path, paint);
//   }

//   @override
//   bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
// }