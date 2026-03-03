import 'dart:ui' as ui;

import 'package:bloodfit/constants/text_font_style.dart';
import 'package:bloodfit/features/weight_history/presentation/widgets/transformation_timline_widget.dart';
import 'package:bloodfit/gen/colors.gen.dart';
import 'package:bloodfit/helper/ui_helpers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';

/// Continuous timeline that creates a single flowing path
/// First entry = Design 1 (starting point)
/// Last entry = Design 6 (ending point)
/// Middle entries = Designs 2-5 (repeating pattern)
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

    // Calculate total height: each entry adds 84px spacing
    final totalHeight = 47.5 + (entries.length - 1) * 84.0 + 50.0 + 50.0;

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

  static const double entrySpacing = 84.0;
  static const double firstCircleY = 47.5;

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

    if (entries.isEmpty) {
      canvas.restore();
      return;
    }

    final totalEntries = entries.length;

    // Draw starting point
    canvas.drawCircle(const ui.Offset(15, 0), 6.0, smallCirclePaint);
    
    // Draw Path 1 (from start point to Design 1 area) - only if we have entries
    if (totalEntries > 0) {
      final path1 = ui.Path();
      path1.moveTo(15, 0);
      path1.cubicTo(17.9729, 0, 20.4388, 2.16245, 20.915, 5);
      path1.lineTo(232, 5);
      path1.cubicTo(255.748, 5, 275, 24.2518, 275, 48);
      path1.cubicTo(275, 71.7482, 255.748, 91, 232, 91);
      path1.lineTo(157, 91);
      canvas.drawPath(path1, pathPaint);
      
      // Draw small circle at the END of Path 1 (connection to Path 2)
      canvas.drawCircle(const ui.Offset(157, 91), 6.0, smallCirclePaint);
    }

    // Draw all entries using dynamic design widget
    for (int i = 0; i < totalEntries; i++) {
      final entry = entries[i];
      final designType = _getDesignType(i, totalEntries);
      final circleY = firstCircleY + i * entrySpacing;
      
      // Draw the design component at this position
      _drawDesignComponent(
        canvas,
        designType,
        circleY,
        entry,
        circlePaint,
        pathPaint,
        smallCirclePaint,
        i > 0, // hasPrevious (false for first entry)
      );
    }

    canvas.restore();
  }

  /// Returns the design type for an entry index
  DesignType _getDesignType(int entryIndex, int totalEntries) {
    if (entryIndex == 0) return DesignType.start;
    if (entryIndex == totalEntries - 1) return DesignType.end;
    
    // Middle entries cycle through designs 2-5
    final middleIndex = (entryIndex - 1) % 4;
    return DesignType.values[middleIndex + 1]; // +1 because start is index 0
  }

  /// Draw a complete design component (circle + path + small circles + text)
  void _drawDesignComponent(
    ui.Canvas canvas,
    DesignType designType,
    double circleY,
    WeightEntry entry,
    ui.Paint circlePaint,
    ui.Paint pathPaint,
    ui.Paint smallCirclePaint,
    bool hasPrevious,
  ) {
    final circleX = _getCircleX(designType);
    final circleRadius = 38.5;
    
    // Draw large circle
    canvas.drawCircle(ui.Offset(circleX, circleY), circleRadius, circlePaint);
    
    // Draw path from previous entry
    if (hasPrevious) {
      _drawPath(canvas, designType, circleY, pathPaint);
    }
    
    // Draw small circles
    _drawSmallCircles(canvas, designType, circleY, smallCirclePaint, hasPrevious);
    
    // Draw text labels
    _drawText(canvas, entry, circleX, circleY, circleRadius);
  }

  double _getCircleX(DesignType designType) {
    switch (designType) {
      case DesignType.start: return 244.5;   // Right
      case DesignType.middle2: return 43.5;  // Left
      case DesignType.middle3: return 244.5; // Right
      case DesignType.middle4: return 38.5;  // Left
      case DesignType.middle5: return 239.5; // Right
      case DesignType.end: return 38.5;      // Left
    }
  }

  void _drawPath(ui.Canvas canvas, DesignType designType, double circleY, ui.Paint paint) {
    final path = ui.Path();
    
    // Calculate entry index: circleY = firstCircleY + entryIndex * entrySpacing
    final entryIndex = (circleY - firstCircleY) / entrySpacing;
    
    // For each design, the path should connect from the PREVIOUS entry's circle area
    // to THIS entry's circle area
    // Previous circle Y = firstCircleY + (entryIndex - 1) * entrySpacing
    final prevCircleY = firstCircleY + (entryIndex - 1) * entrySpacing;
    
    switch (designType) {
      case DesignType.start:
        // No path for first entry (it's the start)
        break;
        
      case DesignType.middle2:
        // Path 2: From Design 1 (RIGHT, y=47.5) to Design 2 (LEFT, y=131.5)
        // Path flows from right side to left side
        path.moveTo(157, 91);
        path.lineTo(58, 91);
        path.cubicTo(35.3563, 91, 17, 109.356, 17, 132);
        path.cubicTo(17, 154.644, 35.3563, 173, 58, 173);
        path.lineTo(133, 173);
        break;
        
      case DesignType.middle3:
        // Path 3: From Design 2 (LEFT, prevCircleY) to Design 3 (RIGHT, circleY)
        // Path flows from left side to right side
        path.moveTo(157, prevCircleY + 42);
        path.lineTo(232, prevCircleY + 42);
        path.cubicTo(255.748, prevCircleY + 42, 275, prevCircleY + 61.252, 275, prevCircleY + 85);
        path.cubicTo(275, prevCircleY + 108.377, 256.345, prevCircleY + 127.398, 233.109, prevCircleY + 127.986);
        path.lineTo(232, prevCircleY + 128);
        path.lineTo(157, prevCircleY + 128);
        break;
        
      case DesignType.middle4:
        // Path 4: From Design 3 (RIGHT, prevCircleY) to Design 4 (LEFT, circleY)
        // Path flows from right side to left side
        path.moveTo(128, prevCircleY + 42);
        path.lineTo(53, prevCircleY + 42);
        path.cubicTo(30.3563, prevCircleY + 42, 12, prevCircleY + 60.356, 12, prevCircleY + 83);
        path.cubicTo(12, prevCircleY + 105.644, 30.3563, prevCircleY + 124, 53, prevCircleY + 124);
        path.lineTo(128, prevCircleY + 124);
        break;
        
      case DesignType.middle5:
        // Path 5: From Design 4 (LEFT, prevCircleY) to Design 5 (RIGHT, circleY)
        // Path flows from left side to right side
        path.moveTo(152, prevCircleY + 42);
        path.lineTo(227, prevCircleY + 42);
        path.cubicTo(250.748, prevCircleY + 42, 270, prevCircleY + 61.252, 270, prevCircleY + 85);
        path.cubicTo(270, prevCircleY + 108.377, 251.345, prevCircleY + 127.398, 228.109, prevCircleY + 127.986);
        path.lineTo(227, prevCircleY + 128);
        path.lineTo(152, prevCircleY + 128);
        break;
        
      case DesignType.end:
        // Path 6: From Design 5 (RIGHT, prevCircleY) to Design 6 (LEFT, circleY)
        // Path flows from right side to left side (ending)
        path.moveTo(128, prevCircleY + 42);
        path.lineTo(53, prevCircleY + 42);
        path.cubicTo(30.3563, prevCircleY + 42, 12, prevCircleY + 60.356, 12, prevCircleY + 83);
        path.cubicTo(12, prevCircleY + 105.644, 30.3563, prevCircleY + 124, 53, prevCircleY + 124);
        path.lineTo(128, prevCircleY + 124);
        break;
    }
    
    canvas.drawPath(path, paint);
  }

  void _drawSmallCircles(
    ui.Canvas canvas,
    DesignType designType,
    double circleY,
    ui.Paint paint,
    bool hasPrevious,
  ) {
    // Calculate entry index: circleY = firstCircleY + entryIndex * entrySpacing
    final entryIndex = (circleY - firstCircleY) / entrySpacing;
    
    // Previous circle Y for calculating small circle positions
    final prevCircleY = firstCircleY + (entryIndex - 1) * entrySpacing;
    
    switch (designType) {
      case DesignType.start:
        // No small circles for start
        break;
      case DesignType.middle2:
        // Path 2: starts at (157, 91), ends at (133, 173)
        canvas.drawCircle(ui.Offset(157, 91), 6.0, paint);   // Start
        canvas.drawCircle(ui.Offset(133, 173), 6.0, paint);  // End
        break;
      case DesignType.middle3:
        // Path 3: starts at (157, prevCircleY+42), ends at (157, prevCircleY+128)
        canvas.drawCircle(ui.Offset(157, prevCircleY + 42), 6.0, paint);   // Start
        canvas.drawCircle(ui.Offset(157, prevCircleY + 128), 6.0, paint);  // End
        break;
      case DesignType.middle4:
        // Path 4: starts at (128, prevCircleY+42), ends at (128, prevCircleY+124)
        canvas.drawCircle(ui.Offset(128, prevCircleY + 42), 6.0, paint);   // Start
        canvas.drawCircle(ui.Offset(128, prevCircleY + 124), 6.0, paint);  // End
        break;
      case DesignType.middle5:
        // Path 5: starts at (152, prevCircleY+42), ends at (152, prevCircleY+128)
        canvas.drawCircle(ui.Offset(152, prevCircleY + 42), 6.0, paint);   // Start
        canvas.drawCircle(ui.Offset(152, prevCircleY + 128), 6.0, paint);  // End
        break;
      case DesignType.end:
        // Path 6: starts at (128, prevCircleY+42), ends at (128, prevCircleY+124)
        canvas.drawCircle(ui.Offset(128, prevCircleY + 42), 6.0, paint);   // Start
        canvas.drawCircle(ui.Offset(128, prevCircleY + 124), 6.0, paint);  // End
        break;
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

/// Design types for the timeline entries
enum DesignType {
  start,    // Design 1 - Starting point
  middle2,  // Design 2 - Middle (left)
  middle3,  // Design 3 - Middle (right)
  middle4,  // Design 4 - Middle (left)
  middle5,  // Design 5 - Middle (right)
  end,      // Design 6 - Ending point
}
