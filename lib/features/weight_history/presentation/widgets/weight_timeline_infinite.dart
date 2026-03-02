import 'dart:ui' as ui;

import 'package:bloodfit/constants/text_font_style.dart';
import 'package:bloodfit/features/weight_history/presentation/widgets/transformation_timline_widget.dart';
import 'package:bloodfit/gen/colors.gen.dart';
import 'package:bloodfit/helper/ui_helpers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';

/// Infinite timeline that preserves the EXACT original design
/// and repeats the pattern every 6 entries (one full cycle)
class WeightTimelineInfinite extends StatelessWidget {
  final List<WeightEntry> entries;
  final VoidCallback? onRefresh;

  const WeightTimelineInfinite({
    Key? key,
    required this.entries,
    this.onRefresh,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (entries.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.history, size: 64.h, color: AppColors.c999999),
            UIHelper.verticalSpace(16.h),
            Text('No weight history yet',
                style: TextFontStyle.headline16w500c999999StylePoppins),
            UIHelper.verticalSpace(8.h),
            Text('Start tracking your transformation!',
                style: TextFontStyle.headline14w400c999999StylePoppins),
            if (onRefresh != null) ...[
              UIHelper.verticalSpace(24.h),
              ElevatedButton.icon(
                onPressed: onRefresh,
                icon: const Icon(Icons.refresh),
                label: const Text('Refresh'),
              ),
            ],
          ],
        ),
      );
    }

    // One full cycle = 6 entries = 509px height (where path 6 ends)
    final cycles = (entries.length / 6).ceil();
    final totalHeight = (cycles * 509.0) + 50.0;

    return SizedBox(
      height: totalHeight.h,
      width: double.infinity,
      child: CustomPaint(
        painter: WeightTimelineInfinitePainter(entries: entries),
      ),
    );
  }
}

class WeightTimelineInfinitePainter extends CustomPainter {
  final List<WeightEntry> entries;

  static const circleColor = Color(0xFFB20000);
  static const pathColor = Color(0xFFB20000);
  static const textColor = Color(0xFFFFFFFF);
  static const dateColor = Color(0xFF999999);

  WeightTimelineInfinitePainter({required this.entries});

  @override
  void paint(ui.Canvas canvas, ui.Size size) {
    const originalWidth = 290.0;
    const originalHeight = 520.0;
    
    final scaleX = size.width / originalWidth;
    final scaleY = size.height / originalHeight;
    final scale = scaleX < scaleY ? scaleX : scaleY;

    final offsetX = (size.width - (originalWidth * scale)) / 2;
    final offsetY = (size.height - (originalHeight * scale)) / 2;

    canvas.save();
    
    // Apply scale and offset
    final transformMatrix = Matrix4.identity()
      ..scale(scale, scale, 1.0)
      ..translate(offsetX / scale, offsetY / scale);
    canvas.transform(transformMatrix.storage);

    final circlePaint = ui.Paint()
      ..color = circleColor.withOpacity(0.5)
      ..style = ui.PaintingStyle.fill;

    final pathPaint = ui.Paint()
      ..color = pathColor
      ..style = ui.PaintingStyle.stroke
      ..strokeWidth = 2.0;

    final smallCirclePaint = ui.Paint()
      ..color = pathColor
      ..style = ui.PaintingStyle.fill;

    // Draw repeating pattern - cycle height is 509px (where path 6 ends)
    int entryIndex = 0;
    double yOffset = 0.0;
    final totalCycles = (entries.length / 6).ceil();
    int currentCycle = 0;
    
    // Each cycle is 509px tall - path 6 ends at y=509, next cycle's path 1 starts at y=509
    const cycleHeight = 509.0;
    
    while (entryIndex < entries.length) {
      currentCycle++;
      // Draw one cycle (6 entries) at this yOffset
      final entriesInThisCycle = ((entries.length - entryIndex) > 6) 
          ? 6 
          : (entries.length - entryIndex);
      
      final isFirstCycle = (currentCycle == 1);
      final isLastCycle = (currentCycle == totalCycles);
      
      _drawOneCycle(
        canvas, 
        yOffset, 
        entries.sublist(entryIndex, entryIndex + entriesInThisCycle),
        circlePaint,
        pathPaint,
        smallCirclePaint,
        isFirstCycle,
        isLastCycle,
      );
      
      entryIndex += 6;
      yOffset += cycleHeight;
    }

    canvas.restore();
  }

  void _drawOneCycle(
    ui.Canvas canvas,
    double yOffset,
    List<WeightEntry> cycleEntries,
    ui.Paint circlePaint,
    ui.Paint pathPaint,
    ui.Paint smallCirclePaint,
    bool isFirstCycle,
    bool isLastCycle,
  ) {
    // Circle positions for one cycle (6 entries) - EXACT from original
    final circleData = [
      {'cx': 244.5, 'cy': 47.5 + yOffset, 'r': 38.5},
      {'cx': 43.5, 'cy': 131.5 + yOffset, 'r': 38.5},
      {'cx': 244.5, 'cy': 215.5 + yOffset, 'r': 38.5},
      {'cx': 38.5, 'cy': 298.5 + yOffset, 'r': 38.5},
      {'cx': 239.5, 'cy': 382.5 + yOffset, 'r': 38.5},
      {'cx': 38.5, 'cy': 465.5 + yOffset, 'r': 38.5},
    ];

    // Draw large circles
    for (int i = 0; i < cycleEntries.length && i < 6; i++) {
      final data = circleData[i];
      canvas.drawCircle(
        ui.Offset(data['cx']!, data['cy']!),
        data['r']!,
        circlePaint,
      );
    }

    // Draw paths (only if we have enough entries)
    if (cycleEntries.length > 1) {
      _drawCyclePaths(canvas, yOffset, pathPaint, cycleEntries.length, isFirstCycle, isLastCycle);
    }

    // Draw small circles
    _drawCycleSmallCircles(canvas, yOffset, smallCirclePaint, cycleEntries.length, isFirstCycle, isLastCycle);

    // Draw starting point circle (only for first cycle)
    if (isFirstCycle) {
      canvas.drawCircle(ui.Offset(15, 0 + yOffset), 6.0, smallCirclePaint);
    }

    // Draw text labels
    for (int i = 0; i < cycleEntries.length && i < 6; i++) {
      final entry = cycleEntries[i];
      final data = circleData[i];
      _drawText(canvas, entry, data['cx']!, data['cy']!, data['r']!);
    }
  }

  void _drawCyclePaths(ui.Canvas canvas, double yOffset, ui.Paint paint, int entryCount, bool isFirstCycle, bool isLastCycle) {
    // Draw paths 1-6 (EXACT curves from original)
    if (entryCount >= 2) {
      // Path 1: Top to first circle
      final path1 = ui.Path();
      path1.moveTo(15, 0 + yOffset);
      path1.cubicTo(17.9729, 0 + yOffset, 20.4388, 2.16245 + yOffset, 20.915, 5 + yOffset);
      path1.lineTo(232, 5 + yOffset);
      path1.cubicTo(255.748, 5 + yOffset, 275, 24.2518 + yOffset, 275, 48 + yOffset);
      path1.cubicTo(275, 71.7482 + yOffset, 255.748, 91 + yOffset, 232, 91 + yOffset);
      path1.lineTo(157, 91 + yOffset);
      canvas.drawPath(path1, paint);
    }

    if (entryCount >= 3) {
      // Path 2: First to second circle
      final path2 = ui.Path();
      path2.moveTo(133, 91 + yOffset);
      path2.lineTo(58, 91 + yOffset);
      path2.cubicTo(35.3563, 91 + yOffset, 17, 109.356 + yOffset, 17, 132 + yOffset);
      path2.cubicTo(17, 154.644 + yOffset, 35.3563, 173 + yOffset, 58, 173 + yOffset);
      path2.lineTo(133, 173 + yOffset);
      canvas.drawPath(path2, paint);
    }

    if (entryCount >= 4) {
      // Path 3: Second to third circle
      final path3 = ui.Path();
      path3.moveTo(157, 173 + yOffset);
      path3.lineTo(232, 173 + yOffset);
      path3.cubicTo(255.748, 173 + yOffset, 275, 192.252 + yOffset, 275, 216 + yOffset);
      path3.cubicTo(275, 239.377 + yOffset, 256.345, 258.398 + yOffset, 233.109, 258.986 + yOffset);
      path3.lineTo(232, 259 + yOffset);
      path3.lineTo(157, 259 + yOffset);
      canvas.drawPath(path3, paint);
    }

    if (entryCount >= 5) {
      // Path 4: Third to fourth circle
      final path4 = ui.Path();
      path4.moveTo(128, 259 + yOffset);
      path4.lineTo(53, 259 + yOffset);
      path4.cubicTo(30.3563, 259 + yOffset, 12, 277.356 + yOffset, 12, 300 + yOffset);
      path4.cubicTo(12, 322.644 + yOffset, 30.3563, 341 + yOffset, 53, 341 + yOffset);
      path4.lineTo(128, 341 + yOffset);
      canvas.drawPath(path4, paint);
    }

    if (entryCount >= 6) {
      // Path 5: Fourth to fifth circle
      final path5 = ui.Path();
      path5.moveTo(152, 341 + yOffset);
      path5.lineTo(227, 341 + yOffset);
      path5.cubicTo(250.748, 341 + yOffset, 270, 360.252 + yOffset, 270, 384 + yOffset);
      path5.cubicTo(270, 407.377 + yOffset, 251.345, 426.398 + yOffset, 228.109, 426.986 + yOffset);
      path5.lineTo(227, 427 + yOffset);
      path5.lineTo(152, 427 + yOffset);
      canvas.drawPath(path5, paint);

      // Path 6: Fifth to sixth circle - extend to connect to next cycle at same level
      final path6 = ui.Path();
      path6.moveTo(128, 427 + yOffset);
      path6.lineTo(53, 427 + yOffset);
      path6.cubicTo(30.3563, 427 + yOffset, 12, 445.356 + yOffset, 12, 468 + yOffset);
      path6.cubicTo(12, 490.29 + yOffset, 29.787, 508.425 + yOffset, 51.9414, 508.986 + yOffset);
      path6.lineTo(53, 509 + yOffset);
      
      // If not last cycle, extend to right side so next cycle's path 1 can start at same level
      if (!isLastCycle) {
        path6.lineTo(270, 509 + yOffset);
        // End at right side - next cycle's path 1 will start at left side at same Y level (509 + yOffset)
      }
      
      canvas.drawPath(path6, paint);
    }
  }

  void _drawCycleSmallCircles(ui.Canvas canvas, double yOffset, ui.Paint paint, int entryCount, bool isFirstCycle, bool isLastCycle) {
    // Small circle positions - EXACT from original
    final smallCirclePositions = [
      ui.Offset(157, 90 + yOffset),
      ui.Offset(133, 90 + yOffset),
      ui.Offset(133, 173 + yOffset),
      ui.Offset(157, 173 + yOffset),
      ui.Offset(157, 257 + yOffset),
      ui.Offset(128, 257 + yOffset),
      ui.Offset(128, 340 + yOffset),
      ui.Offset(152, 340 + yOffset),
      ui.Offset(152, 424 + yOffset),
      ui.Offset(128, 424 + yOffset),
      ui.Offset(270, 508 + yOffset),
    ];

    // Draw small circles based on how many entries we have
    final circlesToDraw = switch (entryCount) {
      1 => 0,
      2 => 4,
      3 => 7,
      4 => 10,
      _ => 11,
    };

    for (int i = 0; i < circlesToDraw && i < smallCirclePositions.length; i++) {
      canvas.drawCircle(smallCirclePositions[i], 6.0, paint);
    }
    
    // Add connection point small circle if not last cycle
    if (!isLastCycle && entryCount >= 6) {
      // Small circle at the connection point to next cycle
      canvas.drawCircle(ui.Offset(290, 520 + yOffset), 6.0, paint);
    }
  }

  void _drawText(ui.Canvas canvas, WeightEntry entry, double cx, double cy, double r) {
    final weightText = '${entry.weight.toStringAsFixed(1)}kg';
    final weightTextPainter = TextPainter(
      text: TextSpan(
        text: weightText,
        style: const TextStyle(
          color: textColor,
          fontSize: 14,
          fontWeight: FontWeight.w600,
          fontFamily: 'Poppins',
        ),
      ),
      textDirection: ui.TextDirection.ltr,
    );
    weightTextPainter.layout();

    final dateText = _formatDate(entry.date);
    final dateTextPainter = TextPainter(
      text: TextSpan(
        text: dateText,
        style: const TextStyle(
          color: dateColor,
          fontSize: 12,
          fontWeight: FontWeight.w400,
          fontFamily: 'Poppins',
        ),
      ),
      textDirection: ui.TextDirection.ltr,
    );
    dateTextPainter.layout();

    if (cx > 150) {
      // Right side - text on left
      weightTextPainter.paint(
          canvas, ui.Offset(cx - r - weightTextPainter.width - 12, cy - 18));
      dateTextPainter.paint(
          canvas, ui.Offset(cx - r - dateTextPainter.width - 12, cy + 3));
    } else {
      // Left side - text on right
      weightTextPainter.paint(canvas, ui.Offset(cx + r + 12, cy - 18));
      dateTextPainter.paint(canvas, ui.Offset(cx + r + 12, cy + 3));
    }
  }

  String _formatDate(DateTime date) {
    return DateFormat('dd MMM yyyy').format(date);
  }

  @override
  bool shouldRepaint(covariant WeightTimelineInfinitePainter oldDelegate) {
    return oldDelegate.entries != entries;
  }
}
