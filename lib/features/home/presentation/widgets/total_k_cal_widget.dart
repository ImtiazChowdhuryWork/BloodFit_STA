import 'dart:math' as math;
import 'package:bloodfit/constants/text_font_style.dart';
import 'package:bloodfit/gen/assets.gen.dart';
import 'package:bloodfit/gen/colors.gen.dart';
import 'package:bloodfit/helper/ui_helpers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

class TotalKCalWidget extends StatelessWidget {
  final double size;
  final double progress; // 0.0 - 1.0
  final double strokeWidth;
  final double capSizeMultiplier;
  final double capPadding; // distance from progress stroke
  final double capRadialOffset; // radial offset along the radius
  final Color capColor;
  final Color progressColor; // main progress color
  final Color progressBoldColor; // start/end bold color
  final String totalCalories;
  final bool isLoading;
  final bool isSuccess;
  final void Function()? onTap;

  const TotalKCalWidget({
    super.key,
    required this.size,
    required this.progress,
    this.strokeWidth = 4.0,
    this.capSizeMultiplier = 1.2,
    this.capPadding = 4.0,
    this.capRadialOffset = 0.0,
    this.capColor = AppColors.cb20000,
    this.progressColor = AppColors.cb20000,
    this.progressBoldColor = AppColors.c7e0101,
    required this.totalCalories,
    required this.isLoading,
    required this.isSuccess,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.0, end: progress),
      duration: const Duration(milliseconds: 800),
      curve: Curves.easeOutCubic,
      builder: (context, animatedValue, child) {
        return Column(
          children: [
            Stack(
              alignment: Alignment.center,
              children: [
                /// Background circle
                Container(
                  width: size - 5,
                  height: size - 5,
                  decoration: BoxDecoration(
                    color: AppColors.c262626,
                    shape: BoxShape.circle,
                    border: Border.all(color: AppColors.cc6c6c6, width: 2.sp),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SvgPicture.asset(Assets.icons.fireIconYellow),

                      UIHelper.verticalSpace(10.h),

                      isSuccess || isLoading
                          ? Text(
                              totalCalories,
                              style: isLoading
                                  ? TextFontStyle
                                        .headline20w500cfefefeStylePoppins
                                        .copyWith(fontSize: 14.sp)
                                  : TextFontStyle
                                        .headline20w500cfefefeStylePoppins,
                            )
                          : GestureDetector(
                              onTap: onTap,
                              child: Icon(
                                Icons.replay_rounded,
                                color: AppColors.cb20000,
                              ),
                            ),
                    ],
                  ),
                ),

                /// Custom progress arc with gradient start/end + moving cap
                SizedBox(
                  width: size,
                  height: size,
                  child: CustomPaint(
                    painter: _RoundedProgressPainter(
                      progress: animatedValue,
                      color: progressColor,
                      startEndBoldColor: progressBoldColor,
                      backgroundColor: Colors.transparent,
                      strokeWidth: strokeWidth.sp,
                      capSizeMultiplier: capSizeMultiplier,
                      capColor: capColor,
                      capPadding: capPadding,
                      capRadialOffset: capRadialOffset,
                    ),
                  ),
                ),
              ],
            ),
            UIHelper.verticalSpace(10.h),

            Text(
              "Kcal Total",
              style: TextFontStyle.headline16w500cc6c6c6StylePoppins,
            ),
          ],
        );
      },
    );
  }
}

class _RoundedProgressPainter extends CustomPainter {
  final double progress;
  final Color color;
  final Color startEndBoldColor;
  final Color backgroundColor;
  final double strokeWidth;
  final double capSizeMultiplier;
  final double capPadding;
  final double capRadialOffset;
  final Color capColor;

  _RoundedProgressPainter({
    required this.progress,
    required this.color,
    required this.startEndBoldColor,
    required this.backgroundColor,
    required this.strokeWidth,
    required this.capSizeMultiplier,
    required this.capPadding,
    required this.capRadialOffset,
    required this.capColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = size.center(Offset.zero);
    final radius = (size.width / 2) - strokeWidth / 2;
    const startAngle = -math.pi / 2;

    // Background circle
    final backgroundPaint = Paint()
      ..color = backgroundColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;
    canvas.drawCircle(center, radius, backgroundPaint);

    // Gradient arc with bold start/end
    final sweepAngle = 2 * math.pi * progress;
    final rect = Rect.fromCircle(center: center, radius: radius);

    // Enhanced gradient with more prominent start and end colors
    final gradient = SweepGradient(
      startAngle: 0,
      endAngle: 2 * math.pi,
      colors: [
        startEndBoldColor,
        startEndBoldColor,
        color,
        color,
        startEndBoldColor,
        startEndBoldColor,
      ],
      stops: const [0.0, 0.08, 0.12, 0.88, 0.92, 1.0],
      transform: GradientRotation(-math.pi / 2),
    );

    final foregroundPaint = Paint()
      ..shader = gradient.createShader(rect)
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;

    canvas.drawArc(rect, startAngle, sweepAngle, false, foregroundPaint);

    // Add start point cap (fixed at beginning)
    if (progress > 0) {
      final knobRadius = strokeWidth * capSizeMultiplier;

      // Start point cap
      final startCapRadius = radius - capPadding + capRadialOffset;
      final startX = center.dx + startCapRadius * math.cos(startAngle);
      final startY = center.dy + startCapRadius * math.sin(startAngle);

      final startKnobPaint = Paint()
        ..color = startEndBoldColor
        ..style = PaintingStyle.fill;
      canvas.drawCircle(Offset(startX, startY), knobRadius, startKnobPaint);
    }

    // Moving endpoint cap
    if (progress > 0) {
      final knobRadius = strokeWidth * capSizeMultiplier;
      final endCapRadius = radius - capPadding + capRadialOffset;
      final endX = center.dx + endCapRadius * math.cos(startAngle + sweepAngle);
      final endY = center.dy + endCapRadius * math.sin(startAngle + sweepAngle);

      final endKnobPaint = Paint()
        ..color = capColor
        ..style = PaintingStyle.fill;
      canvas.drawCircle(Offset(endX, endY), knobRadius, endKnobPaint);
    }
  }

  @override
  bool shouldRepaint(_RoundedProgressPainter oldDelegate) =>
      oldDelegate.progress != progress ||
      oldDelegate.color != color ||
      oldDelegate.capColor != capColor ||
      oldDelegate.startEndBoldColor != startEndBoldColor ||
      oldDelegate.backgroundColor != backgroundColor ||
      oldDelegate.strokeWidth != strokeWidth ||
      oldDelegate.capSizeMultiplier != capSizeMultiplier ||
      oldDelegate.capPadding != capPadding ||
      oldDelegate.capRadialOffset != capRadialOffset;
}
