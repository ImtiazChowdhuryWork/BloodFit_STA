import 'package:bloodfit/gen/assets.gen.dart';
import 'package:bloodfit/helper/ui_helpers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import '../controllers/ruler_controller.dart';
import '../gen/colors.gen.dart';

class SimpleRulerPicker extends StatelessWidget {
  final int minValue;
  final int maxValue;
  final int initialValue;
  final int scaleItemWidth;
  final double scaleLabelSize;
  final double scaleLabelWidth;
  final double scaleBottomPadding;
  final double longLineHeight;
  final double shortLineHeight;
  final Color lineColor;
  final Color selectedColor;
  final Color labelColor;
  final double lineStroke;
  final double height;
  final Axis axis;
  final String dataType;
  final double selectedValueTextSize;
  final double pointerHeight;
  final double pointerThickness;
  final double pointerUpwardOffset;
  final RulerController controller;
  final Function(int)? onValueChanged;
  final double numberPadding; // Padding between lines and numbers
  final double
  containerToNumbersPadding; // Padding between container and numbers
  final double
  containerToSelectedValuePadding; // Padding between container and selected value + SVG

  const SimpleRulerPicker({
    super.key,
    required this.controller,
    this.minValue = 0,
    this.maxValue = 200,
    this.initialValue = 100,
    this.scaleItemWidth = 10,
    this.scaleLabelSize = 14,
    this.scaleLabelWidth = 40,
    this.scaleBottomPadding = 6,
    this.longLineHeight = 24,
    this.shortLineHeight = 12,
    this.lineColor = Colors.grey,
    this.selectedColor = Colors.orange,
    this.labelColor = Colors.grey,
    this.lineStroke = 2,
    this.height = 100,
    this.axis = Axis.horizontal,
    this.selectedValueTextSize = 24,
    this.pointerHeight = 80, // INCREASED: from 60 to 80
    this.pointerThickness = 6, // INCREASED: from 4 to 6
    this.pointerUpwardOffset = 10,
    this.onValueChanged,
    required this.dataType,
    this.numberPadding = 12.0,
    this.containerToNumbersPadding = 8.0,
    this.containerToSelectedValuePadding = 16.0,
  }) : assert(minValue <= initialValue && initialValue <= maxValue);

  bool get _isHorizontalAxis => axis == Axis.horizontal;

  @override
  Widget build(BuildContext context) {
    final ScrollController scrollController = controller.scrollController;
    final ScrollController numbersScrollController = ScrollController();

    final double centerOffset = _isHorizontalAxis
        ? (MediaQuery.of(context).size.width / 2 - scaleItemWidth.w / 2)
        : (height.h / 2 - scaleItemWidth.h / 2);

    void syncScrollControllers() {
      if (scrollController.hasClients && numbersScrollController.hasClients) {
        numbersScrollController.jumpTo(scrollController.offset);
      }
    }

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (scrollController.hasClients) {
        scrollController.jumpTo(
          (initialValue - minValue) * scaleItemWidth.w - centerOffset,
        );
        WidgetsBinding.instance.addPostFrameCallback((_) {
          syncScrollControllers();
        });
      }
    });

    void calculateNewValue() {
      if (!scrollController.hasClients) return;
      final scrollPixels = scrollController.position.pixels;
      final jumpIndex = ((scrollPixels + centerOffset) / scaleItemWidth.w)
          .round();
      final newValue = (jumpIndex + minValue).clamp(minValue, maxValue);
      if (newValue != controller.selectedValue.value) {
        controller.selectedValue.value = newValue;
        onValueChanged?.call(newValue);
      }
    }

    scrollController.addListener(() {
      calculateNewValue();
      syncScrollControllers();
    });

    return SizedBox(
      height: _isHorizontalAxis
          ? height.h
          : pointerHeight.h +
                pointerUpwardOffset.h +
                selectedValueTextSize.sp +
                scaleBottomPadding.h +
                20.h,
      width: _isHorizontalAxis ? null : MediaQuery.of(context).size.width,
      child: Stack(
        children: [
          // VERTICAL MODE
          if (!_isHorizontalAxis)
            Stack(
              children: [
                // Ruler container with lines
                Positioned(
                  right: scaleLabelWidth.w + containerToNumbersPadding.w,
                  top: 0,
                  bottom: 0,
                  child: Container(
                    width: longLineHeight.w + 20.w,
                    color: AppColors.c3c3c3c,
                    padding: EdgeInsets.symmetric(horizontal: 8.w),
                    child: Stack(
                      children: [
                        // Ruler lines
                        NotificationListener<ScrollEndNotification>(
                          onNotification: (notification) {
                            controller.fixScrollPosition();
                            return true;
                          },
                          child: ListView.builder(
                            controller: scrollController,
                            scrollDirection: axis,
                            itemCount: (maxValue - minValue) + 1,
                            padding: EdgeInsets.zero,
                            itemBuilder: (context, index) {
                              final int value = minValue + index;
                              return SizedBox(
                                height: scaleItemWidth.h,
                                child: CustomPaint(
                                  painter: _RulerPainter(
                                    value: value,
                                    selectedValue:
                                        controller.selectedValue.value,
                                    scaleLabelSize: scaleLabelSize.sp,
                                    scaleBottomPadding: scaleBottomPadding.h,
                                    longLineHeight: longLineHeight.h,
                                    shortLineHeight: shortLineHeight.h,
                                    lineColor: lineColor,
                                    selectedColor: selectedColor,
                                    labelColor: labelColor,
                                    lineStroke: lineStroke.w,
                                    axis: axis,
                                    maxScaleLabelWidth: scaleLabelWidth.w,
                                    isRightAligned: !_isHorizontalAxis,
                                    horizontalPadding: 8.w,
                                    numberPadding: numberPadding,
                                  ),
                                ),
                              );
                            },
                          ),
                        ),

                        // Pointer line - INCREASED SIZE
                        Positioned(
                          left: 0,
                          right: 0,
                          top: 0,
                          bottom: 0,
                          child: Center(
                            child: Container(
                              height: pointerThickness.w, // Now 6 (increased)
                              width:
                                  (longLineHeight.h *
                                  2.0), // INCREASED: from 1.5 to 2.0
                              color: selectedColor,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                // Numbers on the RIGHT side
                Positioned(
                  right: 0,
                  top: 0,
                  bottom: 0,
                  child: Container(
                    width: scaleLabelWidth.w,
                    child: ListView.builder(
                      controller: numbersScrollController,
                      scrollDirection: axis,
                      itemCount: (maxValue - minValue) + 1,
                      padding: EdgeInsets.zero,
                      physics: const NeverScrollableScrollPhysics(),
                      itemBuilder: (context, index) {
                        final int value = minValue + index;
                        final bool isLongLine = value % 5 == 0;
                        final bool shouldShowLabel =
                            isLongLine && value % 10 == 0;

                        return SizedBox(
                          height: scaleItemWidth.h,
                          child: shouldShowLabel
                              ? Align(
                                  alignment: Alignment.centerLeft,
                                  child: Padding(
                                    padding: EdgeInsets.only(left: 2.w),
                                    child: Text(
                                      '$value',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: scaleLabelSize.sp,
                                        fontWeight:
                                            value ==
                                                controller.selectedValue.value
                                            ? FontWeight.bold
                                            : FontWeight.normal,
                                      ),
                                    ),
                                  ),
                                )
                              : const SizedBox.shrink(),
                        );
                      },
                    ),
                  ),
                ),
              ],
            ),

          // Selected value display for vertical mode
          if (!_isHorizontalAxis)
            Obx(
              () => Positioned(
                right:
                    scaleLabelWidth.w +
                    longLineHeight.w +
                    containerToNumbersPadding.w +
                    containerToSelectedValuePadding.w,
                top: 0,
                bottom: 0,
                child: Center(
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        "${controller.selectedValue.value} $dataType",
                        style: TextStyle(
                          fontSize: selectedValueTextSize.sp,
                          fontWeight: FontWeight.bold,
                          color: selectedColor,
                        ),
                      ),
                      SizedBox(width: 4.w),
                      SvgPicture.asset(
                        Assets.icons.arrowLeft,
                        color: selectedColor,
                      ),
                    ],
                  ),
                ),
              ),
            ),

          // HORIZONTAL MODE
          if (_isHorizontalAxis)
            NotificationListener<ScrollEndNotification>(
              onNotification: (notification) {
                controller.fixScrollPosition();
                return true;
              },
              child: Container(
                color: AppColors.c3c3c3c,
                child: ListView.builder(
                  controller: scrollController,
                  scrollDirection: axis,
                  itemCount: (maxValue - minValue) + 1,
                  padding: EdgeInsets.zero,
                  itemBuilder: (context, index) {
                    final int value = minValue + index;
                    return SizedBox(
                      width: scaleItemWidth.w,
                      child: CustomPaint(
                        painter: _RulerPainter(
                          value: value,
                          selectedValue: controller.selectedValue.value,
                          scaleLabelSize: scaleLabelSize.sp,
                          scaleBottomPadding: scaleBottomPadding.h,
                          longLineHeight: longLineHeight.h,
                          shortLineHeight: shortLineHeight.h,
                          lineColor: lineColor,
                          selectedColor: selectedColor,
                          labelColor: labelColor,
                          lineStroke: lineStroke.w,
                          axis: axis,
                          maxScaleLabelWidth: scaleLabelWidth.w,
                          isRightAligned: !_isHorizontalAxis,
                          horizontalPadding: 0,
                          numberPadding: numberPadding,
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),

          // Horizontal pointer - NOW WITH INCREASED SIZE
          if (_isHorizontalAxis)
            Obx(
              () => _HorizontalPointer(
                selectedValue: controller.selectedValue.value,
                selectedColor: selectedColor,
                longLineHeight: pointerHeight.h, // Now 80 (increased)
                scaleLabelSize: scaleLabelSize.sp,
                scaleBottomPadding: scaleBottomPadding.h,
                selectedValueTextSize: selectedValueTextSize.sp,
                pointerThickness: pointerThickness.w, // Now 6 (increased)
                upwardOffset: pointerUpwardOffset.h,
                dataType: dataType,
              ),
            ),
        ],
      ),
    );
  }
}

// _HorizontalPointer and _RulerPainter remain the same but will use the increased values
class _HorizontalPointer extends StatelessWidget {
  const _HorizontalPointer({
    required this.selectedValue,
    required this.selectedColor,
    required this.longLineHeight,
    required this.scaleLabelSize,
    required this.scaleBottomPadding,
    required this.selectedValueTextSize,
    required this.pointerThickness,
    required this.dataType,
    this.upwardOffset = 10,
  });

  final int selectedValue;
  final Color selectedColor;
  final double longLineHeight;
  final double scaleLabelSize;
  final double scaleBottomPadding;
  final double selectedValueTextSize;
  final double pointerThickness;
  final double upwardOffset;
  final String dataType;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.center,
      child: Transform.translate(
        offset: Offset(0, -upwardOffset),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              "$selectedValue $dataType",
              style: TextStyle(
                fontSize: selectedValueTextSize,
                fontWeight: FontWeight.bold,
                color: selectedColor,
              ),
            ),
            UIHelper.verticalSpace(20.h),
            Icon(Icons.arrow_drop_up, color: selectedColor, size: 40.w),
            Container(
              height: longLineHeight, // Now taller (80)
              width: pointerThickness, // Now thicker (6)
              color: selectedColor,
            ),
          ],
        ),
      ),
    );
  }
}

class _RulerPainter extends CustomPainter {
  final int value;
  final int selectedValue;
  final double scaleLabelSize;
  final double maxScaleLabelWidth;
  final double scaleBottomPadding;
  final double longLineHeight;
  final double shortLineHeight;
  final Color lineColor;
  final Color selectedColor;
  final Color labelColor;
  final double lineStroke;
  final Axis axis;
  final bool isRightAligned;
  final double horizontalPadding;
  final double numberPadding;

  _RulerPainter({
    required this.value,
    required this.selectedValue,
    required this.scaleLabelSize,
    this.maxScaleLabelWidth = 40,
    this.scaleBottomPadding = 6,
    this.longLineHeight = 24,
    this.shortLineHeight = 12,
    this.lineColor = Colors.grey,
    this.selectedColor = Colors.orange,
    this.labelColor = Colors.grey,
    this.lineStroke = 2,
    this.axis = Axis.horizontal,
    this.isRightAligned = false,
    this.horizontalPadding = 0,
    this.numberPadding = 12.0,
  });

  bool get _isHorizontalAxis => axis == Axis.horizontal;

  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()
      ..color = lineColor
      ..strokeWidth = lineStroke;

    final bool isLongLine = value % 5 == 0;
    final double lineHeight = isLongLine ? longLineHeight : shortLineHeight;

    if (_isHorizontalAxis) {
      final double centerY = size.height / 2;
      final p1 = Offset(size.width / 2, centerY - lineHeight / 2);
      final p2 = Offset(size.width / 2, centerY + lineHeight / 2);
      canvas.drawLine(p1, p2, paint);

      if (isLongLine && value % 10 == 0) {
        final TextPainter textPainter = TextPainter(
          text: TextSpan(
            text: '$value',
            style: TextStyle(
              color: value == selectedValue ? selectedColor : labelColor,
              fontSize: scaleLabelSize,
            ),
          ),
          textDirection: TextDirection.ltr,
        );
        textPainter.layout();
        final offset = Offset(
          size.width / 2 - textPainter.width / 2,
          centerY + lineHeight / 2 + scaleBottomPadding,
        );
        textPainter.paint(canvas, offset);
      }
    } else {
      final double availableWidth = size.width - (horizontalPadding * 2);
      final double lineCenterX = horizontalPadding + (availableWidth / 2);
      final double lineStartX = lineCenterX - (lineHeight / 2);
      final double lineEndX = lineCenterX + (lineHeight / 2);

      final p1 = Offset(lineStartX, size.height / 2);
      final p2 = Offset(lineEndX, size.height / 2);
      canvas.drawLine(p1, p2, paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
