// import 'dart:ui' as ui;

// import 'package:bloodfit/constants/text_font_style.dart';
// import 'package:bloodfit/features/weight_history/presentation/widgets/transformation_timline_widget.dart';
// import 'package:bloodfit/features/weight_history/presentation/widgets/weight_start_design.dart';
// import 'package:bloodfit/features/weight_history/presentation/widgets/weight_middle_left_design.dart';
// import 'package:bloodfit/features/weight_history/presentation/widgets/weight_middle_right_design.dart';
// import 'package:bloodfit/features/weight_history/presentation/widgets/weight_end_design.dart';
// import 'package:bloodfit/gen/colors.gen.dart';
// import 'package:bloodfit/helper/ui_helpers.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';

// /// Continuous timeline that creates a single flowing path
// /// First entry = Design 1 (starting point)
// /// Last entry = Design 6 (ending point)
// /// Middle entries = Designs 2-5 (repeating pattern: left, right, left, right)
// class WeightTimelineInfinite extends StatelessWidget {
//   final List<WeightEntry> entries;
//   final VoidCallback? onRefresh;

//   const WeightTimelineInfinite({
//     Key? key,
//     required this.entries,
//     this.onRefresh,
//   }) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     if (entries.isEmpty) {
//       return Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Icon(Icons.history, size: 64.h, color: AppColors.c999999),
//             UIHelper.verticalSpace(16.h),
//             Text('No weight history yet',
//                 style: TextFontStyle.headline16w500c999999StylePoppins),
//             UIHelper.verticalSpace(8.h),
//             Text('Start tracking your transformation!',
//                 style: TextFontStyle.headline14w400c999999StylePoppins),
//             if (onRefresh != null) ...[
//               UIHelper.verticalSpace(24.h),
//               ElevatedButton.icon(
//                 onPressed: onRefresh,
//                 icon: const Icon(Icons.refresh),
//                 label: const Text('Refresh'),
//               ),
//             ],
//           ],
//         ),
//       );
//     }

//     // Calculate total height
//     final totalHeight = _calculateTotalHeight(entries.length);

//     return SizedBox(
//       height: totalHeight,
//       width: double.infinity,
//       child: CustomPaint(
//         painter: WeightTimelineInfinitePainter(entries: entries),
//       ),
//     );
//   }

//   double _calculateTotalHeight(int entryCount) {
//     if (entryCount == 0) return 50.0;
//     if (entryCount == 1) return 150.0;
    
//     // Last circle Y position
//     final lastCircleY = 47.5 + (entryCount - 1) * 84.0;
    
//     // Add circle radius + generous bottom padding for path and spacing
//     return lastCircleY + 38.5 + 300.0;
//   }
// }

// class WeightTimelineInfinitePainter extends CustomPainter {
//   final List<WeightEntry> entries;

//   WeightTimelineInfinitePainter({required this.entries});

//   @override
//   void paint(ui.Canvas canvas, ui.Size size) {
//     if (entries.isEmpty) return;

//     final totalEntries = entries.length;

//     // Draw each entry using the appropriate design widget painter
//     for (int i = 0; i < totalEntries; i++) {
//       final entry = entries[i];
//       final designType = _getDesignType(i, totalEntries);
//       final yOffset = i * 84.0;

//       switch (designType) {
//         case DesignType.start:
//           WeightStartDesignPainter(entry: entry, yOffset: yOffset).paint(canvas, size);
//           break;
//         case DesignType.middleLeft:
//           WeightMiddleLeftDesignPainter(entry: entry, yOffset: yOffset).paint(canvas, size);
//           break;
//         case DesignType.middleRight:
//           WeightMiddleRightDesignPainter(entry: entry, yOffset: yOffset).paint(canvas, size);
//           break;
//         case DesignType.end:
//           WeightEndDesignPainter(entry: entry, yOffset: yOffset).paint(canvas, size);
//           break;
//       }
//     }
//   }

//   DesignType _getDesignType(int entryIndex, int totalEntries) {
//     if (entryIndex == 0) return DesignType.start;
//     if (entryIndex == totalEntries - 1) return DesignType.end;
    
//     // Middle entries cycle: left, right, left, right...
//     final middleIndex = (entryIndex - 1) % 4;
//     if (middleIndex == 0 || middleIndex == 2) {
//       return DesignType.middleLeft; // Designs 2, 4
//     } else {
//       return DesignType.middleRight; // Designs 3, 5
//     }
//   }

//   @override
//   bool shouldRepaint(covariant WeightTimelineInfinitePainter oldDelegate) {
//     return oldDelegate.entries != entries;
//   }
// }

// enum DesignType {
//   start,       // Design 1 - Starting point (RIGHT circle)
//   middleLeft,  // Designs 2, 4 - Middle left (LEFT circle)
//   middleRight, // Designs 3, 5 - Middle right (RIGHT circle)
//   end,         // Design 6 - Ending point (RIGHT circle, mirror of start)
// }


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

    // Calculate total height based on entries
    // First circle at Y=47.5, each entry adds 84px
    // Last entry's path extends ~124px below previous circle
    final totalHeight = _calculateTotalHeight(entries.length);

    return SizedBox(
      height: totalHeight, // Don't scale with .h - use calculated height directly
      width: double.infinity,
      child: CustomPaint(
        painter: WeightTimelineInfinitePainter(entries: entries),
      ),
    );
  }

  double _calculateTotalHeight(int entryCount) {
    if (entryCount == 0) return 50.0;
    if (entryCount == 1) return 150.0;
    
    // Last circle Y position
    final lastCircleY = 47.5 + (entryCount - 1) * 84.0;
    
    // Add circle radius + generous bottom padding for path and spacing
    return lastCircleY + 38.5 + 300.0;
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
      case DesignType.end: return 239.5;     // Right (mirror of Design 1)
    }
  }

  void _drawPath(ui.Canvas canvas, DesignType designType, double circleY, ui.Paint paint) {
    final path = ui.Path();
    
    // Calculate entry index: circleY = firstCircleY + entryIndex * entrySpacing
    final entryIndex = (circleY - firstCircleY) / entrySpacing;
    
    // Previous circle Y
    final prevCircleY = firstCircleY + (entryIndex - 1) * entrySpacing;
    
    // Get previous design type to know where the path should start from
    // This is calculated the same way as in the loop
    DesignType prevDesignType;
    if (entryIndex == 1) {
      prevDesignType = DesignType.start;
    } else {
      // For entryIndex > 1, calculate what design the previous entry was
      // We need totalEntries to determine if previous was 'end', but since we're
      // drawing sequentially, previous entry was never 'end' (only the current can be 'end')
      final prevMiddleIndex = ((entryIndex - 2) % 4).toInt();
      prevDesignType = DesignType.values[prevMiddleIndex + 1]; // middle2, middle3, middle4, or middle5
    }
    
    switch (designType) {
      case DesignType.start:
        // No path for first entry (it's the start)
        break;
        
      case DesignType.middle2:
        // Path to Design 2 (LEFT) - can come from Design 1 (start) or Design 5 (cycle transition)
        if (prevDesignType == DesignType.start) {
          // From Design 1 (RIGHT) to Design 2 (LEFT) - original Path 1 + Path 2
          path.moveTo(157, 91);
          path.lineTo(58, 91);
          path.cubicTo(35.3563, 91, 17, 109.356, 17, 132);
          path.cubicTo(17, 154.644, 35.3563, 173, 58, 173);
          path.lineTo(133, 173);
        } else {
          // From Design 5 (RIGHT) to Design 2 (LEFT) - cycle transition
          // DON'T draw Path 5 again - it was already drawn by previous entry!
          // Only draw Path 6 (LEFT side curve) to connect to Design 2
          // Position relative to circleY so it ends at the current circle
          final pathBaseY = circleY - 84; // Position path to connect to current circle
          path.moveTo(128, pathBaseY + 42);
          path.lineTo(53, pathBaseY + 42);
          path.cubicTo(30.3563, pathBaseY + 42, 12, pathBaseY + 60.356, 12, pathBaseY + 83);
          path.cubicTo(12, pathBaseY + 105.644, 30.3563, pathBaseY + 124, 53, pathBaseY + 124);
          path.lineTo(128, pathBaseY + 124);
        }
        break;
        
      case DesignType.middle3:
        // Path 3: From Design 2 (LEFT) to Design 3 (RIGHT)
        path.moveTo(157, prevCircleY + 42);
        path.lineTo(232, prevCircleY + 42);
        path.cubicTo(255.748, prevCircleY + 42, 275, prevCircleY + 61.252, 275, prevCircleY + 85);
        path.cubicTo(275, prevCircleY + 108.377, 256.345, prevCircleY + 127.398, 233.109, prevCircleY + 127.986);
        path.lineTo(232, prevCircleY + 128);
        path.lineTo(157, prevCircleY + 128);
        break;
        
      case DesignType.middle4:
        // Path 4: From Design 3 (RIGHT) to Design 4 (LEFT)
        path.moveTo(128, prevCircleY + 42);
        path.lineTo(53, prevCircleY + 42);
        path.cubicTo(30.3563, prevCircleY + 42, 12, prevCircleY + 60.356, 12, prevCircleY + 83);
        path.cubicTo(12, prevCircleY + 105.644, 30.3563, prevCircleY + 124, 53, prevCircleY + 124);
        path.lineTo(128, prevCircleY + 124);
        break;
        
      case DesignType.middle5:
        // Path 5: From Design 4 (LEFT) to Design 5 (RIGHT)
        path.moveTo(152, prevCircleY + 42);
        path.lineTo(227, prevCircleY + 42);
        path.cubicTo(250.748, prevCircleY + 42, 270, prevCircleY + 61.252, 270, prevCircleY + 85);
        path.cubicTo(270, prevCircleY + 108.377, 251.345, prevCircleY + 127.398, 228.109, prevCircleY + 127.986);
        path.lineTo(227, prevCircleY + 128);
        path.lineTo(152, prevCircleY + 128);
        break;
        
      case DesignType.end:
        // Path 6 (END): ONE continuous path like Design 1 (mirrored)
        // Design 1: Long top line from LEFT (x=15) → curve → short bottom
        // Design 6: Short top → curve → long bottom line to LEFT (x=15)
        path.moveTo(152, prevCircleY + 42);
        path.lineTo(227, prevCircleY + 42);
        path.cubicTo(250.748, prevCircleY + 42, 270, prevCircleY + 61.252, 270, prevCircleY + 85);
        path.cubicTo(270, prevCircleY + 108.377, 251.345, prevCircleY + 127.398, 228.109, prevCircleY + 127.986);
        path.lineTo(227, prevCircleY + 128);
        path.lineTo(152, prevCircleY + 128);
        // Extend bottom line to the LEFT (mirror of Design 1's long top from left)
        path.lineTo(15, prevCircleY + 128);
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
    
    // Get previous design type
    DesignType prevDesignType;
    if (entryIndex == 1) {
      prevDesignType = DesignType.start;
    } else {
      final prevMiddleIndex = ((entryIndex - 2) % 4).toInt();
      prevDesignType = DesignType.values[prevMiddleIndex + 1];
    }
    
    switch (designType) {
      case DesignType.start:
        // No small circles for start
        break;
      case DesignType.middle2:
        if (prevDesignType == DesignType.start) {
          // From Design 1: small circles at (157, 91) and (133, 173)
          canvas.drawCircle(ui.Offset(157, 91), 6.0, paint);   // Start
          canvas.drawCircle(ui.Offset(133, 173), 6.0, paint);  // End
        } else {
          // From Design 5 (cycle transition): Only Path 6 small circles
          // Path 5 was already drawn by previous entry
          final pathBaseY = circleY - 84;
          canvas.drawCircle(ui.Offset(128, pathBaseY + 42), 6.0, paint);   // Start of Path 6
          canvas.drawCircle(ui.Offset(128, pathBaseY + 124), 6.0, paint);  // End of Path 6
        }
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
        // Path 6 (END): ONE continuous path - small circles at start and end
        canvas.drawCircle(ui.Offset(152, prevCircleY + 42), 6.0, paint);   // Start of curve
        canvas.drawCircle(ui.Offset(15, prevCircleY + 128), 6.0, paint);   // End of extended line (left side)
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