import 'package:bloodfit/helper/ui_helpers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../../../../../controllers/ruler_controller.dart';
import '../../../../../../../gen/colors.gen.dart';

/// A customizable ruler-style picker widget.
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
  final double selectedValueTextSize;
  final double pointerHeight;
  final double pointerThickness;
  final double pointerUpwardOffset;
  final RulerController controller;
  final Function(int)? onValueChanged;

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
    this.pointerHeight = 60,
    this.pointerThickness = 4,
    this.pointerUpwardOffset = 10,
    this.onValueChanged,
  }) : assert(minValue <= initialValue && initialValue <= maxValue);

  bool get _isHorizontalAxis => axis == Axis.horizontal;

  @override
  Widget build(BuildContext context) {
    final ScrollController scrollController = controller.scrollController;

    // Center offset (so pointer is at center)
    final double centerOffset = _isHorizontalAxis
        ? (MediaQuery.of(context).size.width / 2 - scaleItemWidth.w / 2)
        : (height.h / 2 - scaleItemWidth.h / 2);

    // Initial scroll position
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (scrollController.hasClients) {
        scrollController.jumpTo(
          (initialValue - minValue) * scaleItemWidth.w - centerOffset,
        );
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

    scrollController.addListener(calculateNewValue);

    return SizedBox(
      height: _isHorizontalAxis
          ? height.h
          : pointerHeight.h +
                pointerUpwardOffset.h +
                selectedValueTextSize.sp +
                scaleBottomPadding.h +
                20.h,
      child: Stack(
        alignment: Alignment.center,
        children: [
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
                    width: _isHorizontalAxis ? scaleItemWidth.w : null,
                    height: _isHorizontalAxis ? null : scaleItemWidth.h,
                    child: Obx(
                      () => CustomPaint(
                        painter: _RulerPainter(
                          value: value + 1,
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
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
          Obx(
            () => _isHorizontalAxis
                ? _VerticalPointer(
                    selectedValue: controller.selectedValue.value,
                    selectedColor: selectedColor,
                    longLineHeight: pointerHeight.h,
                    scaleLabelSize: scaleLabelSize.sp,
                    scaleBottomPadding: scaleBottomPadding.h,
                    selectedValueTextSize: selectedValueTextSize.sp,
                    pointerThickness: pointerThickness.w,
                    upwardOffset: pointerUpwardOffset.h,
                  )
                : _HorizontalPointer(
                    selectedValue: controller.selectedValue.value,
                    selectedColor: selectedColor,
                    longLineHeight: pointerHeight.h,
                    scaleLabelWidth: scaleLabelWidth.w,
                    scaleBottomPadding: scaleBottomPadding.h,
                    selectedValueTextSize: selectedValueTextSize.sp,
                    pointerThickness: pointerThickness.w,
                    upwardOffset: pointerUpwardOffset.h,
                  ),
          ),
        ],
      ),
    );
  }
}

// Horizontal Pointer
class _HorizontalPointer extends StatelessWidget {
  const _HorizontalPointer({
    required this.selectedValue,
    required this.selectedColor,
    required this.longLineHeight,
    required this.scaleLabelWidth,
    required this.scaleBottomPadding,
    required this.selectedValueTextSize,
    required this.pointerThickness,
    this.upwardOffset = 10,
  });

  final int selectedValue;
  final Color selectedColor;
  final double longLineHeight;
  final double scaleLabelWidth;
  final double scaleBottomPadding;
  final double selectedValueTextSize;
  final double pointerThickness;
  final double upwardOffset;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerRight,
      child: Transform.translate(
        offset: Offset(0, -upwardOffset),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              "$selectedValue Kg",
              style: TextStyle(
                fontSize: selectedValueTextSize,
                fontWeight: FontWeight.bold,
                color: selectedColor,
              ),
            ),
            Icon(Icons.arrow_right, color: selectedColor, size: 30.w),
            Container(
              height: longLineHeight,
              width: pointerThickness,
              color: selectedColor,
            ),
            SizedBox(width: scaleLabelWidth + scaleBottomPadding),
          ],
        ),
      ),
    );
  }
}

// Vertical Pointer
class _VerticalPointer extends StatelessWidget {
  const _VerticalPointer({
    required this.selectedValue,
    required this.selectedColor,
    required this.longLineHeight,
    required this.scaleLabelSize,
    required this.scaleBottomPadding,
    required this.selectedValueTextSize,
    required this.pointerThickness,
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
              "$selectedValue Kg",
              style: TextStyle(
                fontSize: selectedValueTextSize,
                fontWeight: FontWeight.bold,
                color: selectedColor,
              ),
            ),
            UIHelper.verticalSpace(20.h),
            Icon(Icons.arrow_drop_up, color: selectedColor, size: 40.w),
            Container(
              height: longLineHeight,
              width: pointerThickness,
              color: selectedColor,
            ),
          ],
        ),
      ),
    );
  }
}

// Custom Painter for Ruler
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

  _RulerPainter({
    required this.value,
    required this.selectedValue,
    required this.scaleLabelSize,
    this.maxScaleLabelWidth = 40,
    required this.scaleBottomPadding,
    this.longLineHeight = 24,
    this.shortLineHeight = 12,
    this.lineColor = Colors.grey,
    this.selectedColor = Colors.orange,
    this.labelColor = Colors.grey,
    this.lineStroke = 2,
    this.axis = Axis.horizontal,
  });

  bool get _isHorizontalAxis => axis == Axis.horizontal;

  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()
      ..color = lineColor
      ..strokeWidth = lineStroke;

    final bool isLongLine = value % 5 == 0;
    final double lineHeight = isLongLine ? longLineHeight : shortLineHeight;
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
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
