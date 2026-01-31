// import 'package:flutter/material.dart';

// class WeightEntry {
//   final double weight;
//   final DateTime date;

//   WeightEntry({required this.weight, required this.date});
// }

// class WeightTimelineWidget extends StatelessWidget {
//   final List<WeightEntry> entries;

//   const WeightTimelineWidget({Key? key, required this.entries})
//     : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return AspectRatio(
//       aspectRatio: 0.6, // Maintain a consistent aspect ratio
//       child: CustomPaint(painter: WeightTimelinePainter(entries: entries)),
//     );
//   }
// }

// class WeightTimelinePainter extends CustomPainter {
//   final List<WeightEntry> entries;

//   // Exact SVG colors
//   static const circleColor = Color(0xFFB20000);
//   static const pathColor = Color(0xFFB20000);
//   static const textColor = Color(0xFFFFFFFF);
//   static const dateColor = Color(0xFF999999);

//   WeightTimelinePainter({required this.entries});

//   @override
//   void paint(Canvas canvas, Size size) {
//     // Define the original SVG size for reference
//     const originalWidth = 290.0;
//     const originalHeight = 520.0;

//     // Calculate scale factors
//     final scaleX = size.width / originalWidth;
//     final scaleY = size.height / originalHeight;
//     final scale = scaleX < scaleY
//         ? scaleX
//         : scaleY; // Use the smaller scale to fit both dimensions

//     // Calculate offset to center the drawing within the available space
//     final offsetX = (size.width - (originalWidth * scale)) / 2;
//     final offsetY = (size.height - (originalHeight * scale)) / 2;

//     // Paint for large circles with 50% opacity
//     final circlePaint = Paint()
//       ..color = circleColor.withOpacity(0.5)
//       ..style = PaintingStyle.fill
//       ..strokeWidth = 2.0 / scale; // Adjust stroke width based on scale

//     // Paint for connecting paths
//     final pathPaint = Paint()
//       ..color = pathColor
//       ..style = PaintingStyle.stroke
//       ..strokeWidth = 2.0 / scale; // Adjust stroke width based on scale

//     // Paint for small circles - ensure they are filled and visible
//     final smallCirclePaint = Paint()
//       ..color = pathColor
//       ..style = PaintingStyle.fill;

//     // Transform matrix for scaling and positioning
//     final transformMatrix = Matrix4.identity()
//       ..scale(scale, scale, 1.0)
//       ..translate(offsetX / scale, offsetY / scale);

//     // Save layer with transformation
//     canvas.save();
//     canvas.transform(transformMatrix.storage);

//     // Original circle positions from SVG (unscaled)
//     final List<Map<String, double>> circleData = [
//       {'cx': 244.5, 'cy': 47.5, 'r': 38.5}, // Right
//       {'cx': 43.5, 'cy': 131.5, 'r': 38.5}, // Left
//       {'cx': 244.5, 'cy': 215.5, 'r': 38.5}, // Right
//       {'cx': 38.5, 'cy': 298.5, 'r': 38.5}, // Left
//       {'cx': 239.5, 'cy': 382.5, 'r': 38.5}, // Right
//       {'cx': 38.5, 'cy': 465.5, 'r': 38.5}, // Left
//     ];

//     // Original small circle positions from SVG (unscaled)
//     final List<Map<String, double>> smallCircles = [
//       {'cx': 157, 'cy': 90, 'r': 6},
//       {'cx': 157, 'cy': 257, 'r': 6},
//       {'cx': 133, 'cy': 174, 'r': 6},
//       {'cx': 128, 'cy': 341, 'r': 6},
//       {'cx': 152, 'cy': 424, 'r': 6},
//       {'cx': 270, 'cy': 508, 'r': 6},
//     ];

//     // Draw connecting paths using exact SVG path data
//     _drawConnectingPaths(canvas, pathPaint);

//     // Draw all large circles
//     for (int i = 0; i < circleData.length && i < entries.length; i++) {
//       final data = circleData[i];
//       canvas.drawCircle(
//         Offset(data['cx']!, data['cy']!),
//         data['r']!,
//         circlePaint,
//       );
//     }

//     // Draw all small circles as filled circles (after paths to ensure visibility)
//     for (var data in smallCircles) {
//       canvas.drawCircle(
//         Offset(data['cx']!, data['cy']!),
//         data['r']!,
//         smallCirclePaint,
//       );
//     }

//     // Draw text labels
//     _drawTextLabels(canvas, entries, scale);

//     // Restore canvas to original state
//     canvas.restore();
//   }

//   void _drawConnectingPaths(Canvas canvas, Paint paint) {
//     // Path 1: Top to first circle (right side)
//     Path path1 = Path();
//     path1.moveTo(15, 0);
//     // Using SVG path: "M15 0C17.9729 0 20.4388 2.16245 20.915 5H232C255.748 5 275 24.2518 275 48..."
//     path1.cubicTo(17.9729, 0, 20.4388, 2.16245, 20.915, 5);
//     path1.lineTo(232, 5);
//     path1.cubicTo(255.748, 5, 275, 24.2518, 275, 48);
//     path1.cubicTo(275, 71.7482, 255.748, 91, 232, 91);
//     path1.lineTo(157, 91);
//     path1.lineTo(157, 89);
//     canvas.drawPath(path1, paint);

//     // Path 2: First to second circle
//     Path path2 = Path();
//     path2.moveTo(133, 84);
//     path2.cubicTo(136.314, 84, 139, 86.6863, 139, 90);
//     path2.cubicTo(139, 93.3137, 136.314, 96, 133, 96);
//     path2.cubicTo(130.027, 96, 127.561, 93.8376, 127.085, 91);
//     path2.lineTo(58, 91);
//     path2.cubicTo(35.3563, 91, 17, 109.356, 17, 132);
//     path2.cubicTo(17, 154.644, 35.3563, 173, 58, 173);
//     path2.lineTo(133, 173);
//     path2.lineTo(133, 175);
//     canvas.drawPath(path2, paint);

//     // Path 3: Second to third circle
//     Path path3 = Path();
//     path3.moveTo(157, 168);
//     path3.cubicTo(159.973, 168, 162.439, 170.162, 162.915, 173);
//     path3.lineTo(232, 173);
//     path3.cubicTo(255.748, 173, 275, 192.252, 275, 216);
//     path3.cubicTo(275, 239.377, 256.345, 258.398, 233.109, 258.986);
//     path3.lineTo(232, 259);
//     path3.lineTo(157, 259);
//     path3.lineTo(157, 257);
//     canvas.drawPath(path3, paint);

//     // Path 4: Third to fourth circle
//     Path path4 = Path();
//     path4.moveTo(128, 251);
//     path4.cubicTo(131.314, 251, 134, 253.686, 134, 257);
//     path4.cubicTo(134, 260.314, 131.314, 263, 128, 263);
//     path4.cubicTo(125.027, 263, 122.561, 260.838, 122.085, 258);
//     path4.lineTo(53, 258);
//     path4.cubicTo(30.3563, 258, 12, 276.356, 12, 299);
//     path4.cubicTo(12, 321.644, 30.3563, 340, 53, 340);
//     path4.lineTo(128, 340);
//     path4.lineTo(128, 342);
//     canvas.drawPath(path4, paint);

//     // Path 5: Fourth to fifth circle
//     Path path5 = Path();
//     path5.moveTo(152, 335);
//     path5.cubicTo(154.973, 335, 157.439, 337.162, 157.915, 340);
//     path5.lineTo(227, 340);
//     path5.cubicTo(250.748, 340, 270, 359.252, 270, 383);
//     path5.cubicTo(270, 406.377, 251.345, 425.398, 228.109, 425.986);
//     path5.lineTo(227, 426);
//     path5.lineTo(152, 426);
//     path5.lineTo(152, 424);
//     canvas.drawPath(path5, paint);

//     // Path 6: Fifth to sixth circle (bottom)
//     Path path6 = Path();
//     path6.moveTo(128, 418);
//     path6.cubicTo(131.314, 418, 134, 420.686, 134, 424);
//     path6.cubicTo(134, 427.314, 131.314, 430, 128, 430);
//     path6.cubicTo(125.388, 430, 123.167, 428.33, 122.343, 426);
//     path6.lineTo(53, 426);
//     path6.cubicTo(30.3563, 426, 12, 444.356, 12, 467);
//     path6.cubicTo(12, 489.29, 29.787, 507.425, 51.9414, 507.986);
//     path6.lineTo(53, 508);
//     path6.lineTo(270, 508);
//     path6.lineTo(270, 510);
//     canvas.drawPath(path6, paint);
//   }

//   void _drawTextLabels(Canvas canvas, List<WeightEntry> entries, double scale) {
//     // Text positions from SVG (approximate positions for weights and dates)
//     final List<Map<String, dynamic>> textData = [
//       {
//         'weight': '62kg',
//         'date': '20 Sept 2025',
//         'wx': 56,
//         'wy': 39,
//         'dx': 20,
//         'dy': 61,
//         'align': TextAlign.left,
//       },
//       {
//         'weight': '62kg',
//         'date': '15 Sept 2025',
//         'wx': 169,
//         'wy': 147,
//         'dx': 169,
//         'dy': 168,
//         'align': TextAlign.left,
//       },
//       {
//         'weight': '65kg',
//         'date': '10 Sept 2025',
//         'wx': 56,
//         'wy': 222,
//         'dx': 20,
//         'dy': 244,
//         'align': TextAlign.left,
//       },
//       {
//         'weight': '68kg',
//         'date': '01 Sept 2025',
//         'wx': 169,
//         'wy': 314,
//         'dx': 169,
//         'dy': 335,
//         'align': TextAlign.left,
//       },
//       {
//         'weight': '70kg',
//         'date': '25 Aug 2025',
//         'wx': 69,
//         'wy': 373,
//         'dx': 36,
//         'dy': 414,
//         'align': TextAlign.left,
//       },
//       {
//         'weight': '75kg',
//         'date': '20 Aug 2025',
//         'wx': 172,
//         'wy': 493,
//         'dx': 172,
//         'dy': 514,
//         'align': TextAlign.left,
//       },
//     ];

//     // Original circle positions from SVG (unscaled)
//     final List<Map<String, double>> circleData = [
//       {'cx': 244.5, 'cy': 47.5, 'r': 38.5}, // Right
//       {'cx': 43.5, 'cy': 131.5, 'r': 38.5}, // Left
//       {'cx': 244.5, 'cy': 215.5, 'r': 38.5}, // Right
//       {'cx': 38.5, 'cy': 298.5, 'r': 38.5}, // Left
//       {'cx': 239.5, 'cy': 382.5, 'r': 38.5}, // Right
//       {'cx': 38.5, 'cy': 465.5, 'r': 38.5}, // Left
//     ];

//     for (int i = 0; i < entries.length && i < textData.length; i++) {
//       final entry = entries[i];
//       final data = textData[i];
//       final circlePos = circleData[i];

//       // Draw weight text
//       final weightTextPainter = TextPainter(
//         text: TextSpan(
//           text: '${entry.weight.toStringAsFixed(0)}kg',
//           style: TextStyle(
//             color: textColor,
//             fontSize: 14 / scale, // Scale font size
//             fontWeight: FontWeight.w600,
//             fontFamily: 'Arial',
//           ),
//         ),
//         textDirection: TextDirection.ltr,
//         textAlign: data['align'],
//       );
//       weightTextPainter.layout();

//       // Draw date text
//       final dateTextPainter = TextPainter(
//         text: TextSpan(
//           text: _formatDate(entry.date),
//           style: TextStyle(
//             color: dateColor,
//             fontSize: 12 / scale, // Scale font size
//             fontWeight: FontWeight.w400,
//             fontFamily: 'Arial',
//           ),
//         ),
//         textDirection: TextDirection.ltr,
//         textAlign: data['align'],
//       );
//       dateTextPainter.layout();

//       // Position text based on circle side
//       final cx = circlePos['cx']!;
//       final cy = circlePos['cy']!;
//       final r = circlePos['r']!;

//       if (cx > 150) {
//         // Right side - text on left
//         weightTextPainter.paint(
//           canvas,
//           Offset(
//             cx - r - (weightTextPainter.width / scale) - (12 / scale),
//             cy - (18 / scale),
//           ),
//         );
//         dateTextPainter.paint(
//           canvas,
//           Offset(
//             cx - r - (dateTextPainter.width / scale) - (12 / scale),
//             cy + (3 / scale),
//           ),
//         );
//       } else {
//         // Left side - text on right
//         weightTextPainter.paint(
//           canvas,
//           Offset(cx + r + (12 / scale), cy - (18 / scale)),
//         );
//         dateTextPainter.paint(
//           canvas,
//           Offset(cx + r + (12 / scale), cy + (3 / scale)),
//         );
//       }
//     }
//   }

//   String _formatDate(DateTime date) {
//     final months = [
//       'Jan',
//       'Feb',
//       'Mar',
//       'Apr',
//       'May',
//       'Jun',
//       'Jul',
//       'Aug',
//       'Sept',
//       'Oct',
//       'Nov',
//       'Dec',
//     ];
//     return '${date.day.toString().padLeft(2, '0')} ${months[date.month - 1]} ${date.year}';
//   }

//   @override
//   bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
// }

// // Example usage
// class WeightTimelineDemo extends StatelessWidget {
//   const WeightTimelineDemo({Key? key}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     final entries = [
//       WeightEntry(weight: 62, date: DateTime(2025, 9, 20)),
//       WeightEntry(weight: 62, date: DateTime(2025, 9, 15)),
//       WeightEntry(weight: 65, date: DateTime(2025, 9, 10)),
//       WeightEntry(weight: 68, date: DateTime(2025, 9, 1)),
//       WeightEntry(weight: 70, date: DateTime(2025, 8, 25)),
//       WeightEntry(weight: 75, date: DateTime(2025, 8, 20)),
//     ];

//     return Scaffold(
//       backgroundColor: const Color(0xFF0D0D0D),
//       body: Center(
//         child: SingleChildScrollView(
//           child: WeightTimelineWidget(entries: entries),
//         ),
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';

class WeightEntry {
  final double weight;
  final DateTime date;

  WeightEntry({required this.weight, required this.date});
}

class WeightTimelineWidget extends StatelessWidget {
  final List<WeightEntry> entries;

  const WeightTimelineWidget({Key? key, required this.entries})
    : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 0.6,
      child: CustomPaint(painter: WeightTimelinePainter(entries: entries)),
    );
  }
}

class WeightTimelinePainter extends CustomPainter {
  final List<WeightEntry> entries;

  // Exact SVG colors
  static const circleColor = Color(0xFFB20000);
  static const pathColor = Color(0xFFB20000);
  static const textColor = Color(0xFFFFFFFF);
  static const dateColor = Color(0xFF999999);

  WeightTimelinePainter({required this.entries});

  @override
  void paint(Canvas canvas, Size size) {
    const originalWidth = 290.0;
    const originalHeight = 520.0;

    final scaleX = size.width / originalWidth;
    final scaleY = size.height / originalHeight;
    final scale = scaleX < scaleY ? scaleX : scaleY;

    final offsetX = (size.width - (originalWidth * scale)) / 2;
    final offsetY = (size.height - (originalHeight * scale)) / 2;

    // Paint for large circles with 50% opacity
    final circlePaint = Paint()
      ..color = circleColor.withOpacity(0.5)
      ..style = PaintingStyle.fill;

    // Paint for connecting paths
    final pathPaint = Paint()
      ..color = pathColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0 / scale;

    // Paint for small circles - SOLID FILLED
    final smallCirclePaint = Paint()
      ..color = pathColor
      ..style = PaintingStyle.fill;

    // Transform matrix
    final transformMatrix = Matrix4.identity()
      ..scale(scale, scale, 1.0)
      ..translate(offsetX / scale, offsetY / scale);

    canvas.save();
    canvas.transform(transformMatrix.storage);

    // Original large circle positions
    final List<Map<String, double>> circleData = [
      {'cx': 244.5, 'cy': 47.5, 'r': 38.5},
      {'cx': 43.5, 'cy': 131.5, 'r': 38.5},
      {'cx': 244.5, 'cy': 215.5, 'r': 38.5},
      {'cx': 38.5, 'cy': 298.5, 'r': 38.5},
      {'cx': 239.5, 'cy': 382.5, 'r': 38.5},
      {'cx': 38.5, 'cy': 465.5, 'r': 38.5},
    ];

    // Draw connecting paths FIRST (under everything)
    _drawConnectingPaths(canvas, pathPaint);

    // Draw all LARGE circles
    for (int i = 0; i < circleData.length && i < entries.length; i++) {
      final data = circleData[i];
      canvas.drawCircle(
        Offset(data['cx']!, data['cy']!),
        data['r']!,
        circlePaint,
      );
    }

    // Define EXACT positions for SMALL circles (connection points)
    // These are the points where the paths have "dots" in the SVG
    final List<Offset> smallCirclePositions = [
      Offset(157, 90), // Top connection
      Offset(133, 90), // First turn
      Offset(133, 173), // Second connection
      Offset(157, 173), // Second turn
      Offset(157, 257), // Third connection
      Offset(128, 257), // Third turn
      Offset(128, 340), // Fourth connection
      Offset(152, 340), // Fourth turn
      Offset(152, 424), // Fifth connection
      Offset(128, 424), // Fifth turn
      Offset(270, 508), // Bottom connection
    ];

    // Draw SMALL circles as COMPLETE filled circles
    for (final position in smallCirclePositions) {
      canvas.drawCircle(
        position,
        6.0, // Radius for small circles
        smallCirclePaint,
      );
    }

    // Draw text labels
    _drawTextLabels(canvas, entries, scale);

    canvas.restore();
  }

  void _drawConnectingPaths(Canvas canvas, Paint paint) {
    // Simplified path drawing - just draw the lines, NOT the circles

    // Path 1: Top to first circle
    Path path1 = Path();
    path1.moveTo(15, 0);
    path1.cubicTo(17.9729, 0, 20.4388, 2.16245, 20.915, 5);
    path1.lineTo(232, 5);
    path1.cubicTo(255.748, 5, 275, 24.2518, 275, 48);
    path1.cubicTo(275, 71.7482, 255.748, 91, 232, 91);
    path1.lineTo(157, 91);
    canvas.drawPath(path1, paint);

    // Path 2: First to second circle
    Path path2 = Path();
    path2.moveTo(133, 91);
    path2.lineTo(58, 91);
    path2.cubicTo(35.3563, 91, 17, 109.356, 17, 132);
    path2.cubicTo(17, 154.644, 35.3563, 173, 58, 173);
    path2.lineTo(133, 173);
    canvas.drawPath(path2, paint);

    // Path 3: Second to third circle
    Path path3 = Path();
    path3.moveTo(157, 173);
    path3.lineTo(232, 173);
    path3.cubicTo(255.748, 173, 275, 192.252, 275, 216);
    path3.cubicTo(275, 239.377, 256.345, 258.398, 233.109, 258.986);
    path3.lineTo(232, 259);
    path3.lineTo(157, 259);
    canvas.drawPath(path3, paint);

    // Path 4: Third to fourth circle
    Path path4 = Path();
    path4.moveTo(128, 259);
    path4.lineTo(53, 259);
    path4.cubicTo(30.3563, 259, 12, 277.356, 12, 300);
    path4.cubicTo(12, 322.644, 30.3563, 341, 53, 341);
    path4.lineTo(128, 341);
    canvas.drawPath(path4, paint);

    // Path 5: Fourth to fifth circle
    Path path5 = Path();
    path5.moveTo(152, 341);
    path5.lineTo(227, 341);
    path5.cubicTo(250.748, 341, 270, 360.252, 270, 384);
    path5.cubicTo(270, 407.377, 251.345, 426.398, 228.109, 426.986);
    path5.lineTo(227, 427);
    path5.lineTo(152, 427);
    canvas.drawPath(path5, paint);

    // Path 6: Fifth to sixth circle
    Path path6 = Path();
    path6.moveTo(128, 427);
    path6.lineTo(53, 427);
    path6.cubicTo(30.3563, 427, 12, 445.356, 12, 468);
    path6.cubicTo(12, 490.29, 29.787, 508.425, 51.9414, 508.986);
    path6.lineTo(53, 509);
    path6.lineTo(270, 509);
    canvas.drawPath(path6, paint);
  }

  void _drawTextLabels(Canvas canvas, List<WeightEntry> entries, double scale) {
    final List<Map<String, dynamic>> textData = [
      {'weight': '62kg', 'date': '20 Sept 2025', 'align': TextAlign.left},
      {'weight': '62kg', 'date': '15 Sept 2025', 'align': TextAlign.left},
      {'weight': '65kg', 'date': '10 Sept 2025', 'align': TextAlign.left},
      {'weight': '68kg', 'date': '01 Sept 2025', 'align': TextAlign.left},
      {'weight': '70kg', 'date': '25 Aug 2025', 'align': TextAlign.left},
      {'weight': '75kg', 'date': '20 Aug 2025', 'align': TextAlign.left},
    ];

    final List<Map<String, double>> circleData = [
      {'cx': 244.5, 'cy': 47.5, 'r': 38.5},
      {'cx': 43.5, 'cy': 131.5, 'r': 38.5},
      {'cx': 244.5, 'cy': 215.5, 'r': 38.5},
      {'cx': 38.5, 'cy': 298.5, 'r': 38.5},
      {'cx': 239.5, 'cy': 382.5, 'r': 38.5},
      {'cx': 38.5, 'cy': 465.5, 'r': 38.5},
    ];

    for (int i = 0; i < entries.length && i < textData.length; i++) {
      final entry = entries[i];
      final data = textData[i];
      final circlePos = circleData[i];

      // Draw weight text
      final weightTextPainter = TextPainter(
        text: TextSpan(
          text: '${entry.weight.toStringAsFixed(0)}kg',
          style: TextStyle(
            color: textColor,
            fontSize: 14 / scale,
            fontWeight: FontWeight.w600,
            fontFamily: 'Arial',
          ),
        ),
        textDirection: TextDirection.ltr,
        textAlign: data['align'],
      );
      weightTextPainter.layout();

      // Draw date text
      final dateTextPainter = TextPainter(
        text: TextSpan(
          text: _formatDate(entry.date),
          style: TextStyle(
            color: dateColor,
            fontSize: 12 / scale,
            fontWeight: FontWeight.w400,
            fontFamily: 'Arial',
          ),
        ),
        textDirection: TextDirection.ltr,
        textAlign: data['align'],
      );
      dateTextPainter.layout();

      // Position text
      final cx = circlePos['cx']!;
      final cy = circlePos['cy']!;
      final r = circlePos['r']!;

      if (cx > 150) {
        // Right side
        weightTextPainter.paint(
          canvas,
          Offset(cx - r - weightTextPainter.width - 12, cy - 18),
        );
        dateTextPainter.paint(
          canvas,
          Offset(cx - r - dateTextPainter.width - 12, cy + 3),
        );
      } else {
        // Left side
        weightTextPainter.paint(canvas, Offset(cx + r + 12, cy - 18));
        dateTextPainter.paint(canvas, Offset(cx + r + 12, cy + 3));
      }
    }
  }

  String _formatDate(DateTime date) {
    final months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sept',
      'Oct',
      'Nov',
      'Dec',
    ];
    return '${date.day.toString().padLeft(2, '0')} ${months[date.month - 1]} ${date.year}';
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
