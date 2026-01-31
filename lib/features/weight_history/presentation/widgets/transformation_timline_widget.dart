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
//       aspectRatio: 0.6,
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
//     const originalWidth = 290.0;
//     const originalHeight = 520.0;

//     final scaleX = size.width / originalWidth;
//     final scaleY = size.height / originalHeight;
//     final scale = scaleX < scaleY ? scaleX : scaleY;

//     final offsetX = (size.width - (originalWidth * scale)) / 2;
//     final offsetY = (size.height - (originalHeight * scale)) / 2;

//     // Paint for large circles with 50% opacity
//     final circlePaint = Paint()
//       ..color = circleColor.withOpacity(0.5)
//       ..style = PaintingStyle.fill;

//     // Paint for connecting paths
//     final pathPaint = Paint()
//       ..color = pathColor
//       ..style = PaintingStyle.stroke
//       ..strokeWidth = 2.0 / scale;

//     // Paint for small circles - SOLID FILLED
//     final smallCirclePaint = Paint()
//       ..color = pathColor
//       ..style = PaintingStyle.fill;

//     // Transform matrix
//     final transformMatrix = Matrix4.identity()
//       ..scale(scale, scale, 1.0)
//       ..translate(offsetX / scale, offsetY / scale);

//     canvas.save();
//     canvas.transform(transformMatrix.storage);

//     // Original large circle positions
//     final List<Map<String, double>> circleData = [
//       {'cx': 244.5, 'cy': 47.5, 'r': 38.5},
//       {'cx': 43.5, 'cy': 131.5, 'r': 38.5},
//       {'cx': 244.5, 'cy': 215.5, 'r': 38.5},
//       {'cx': 38.5, 'cy': 298.5, 'r': 38.5},
//       {'cx': 239.5, 'cy': 382.5, 'r': 38.5},
//       {'cx': 38.5, 'cy': 465.5, 'r': 38.5},
//     ];

//     // Draw connecting paths FIRST (under everything)
//     _drawConnectingPaths(canvas, pathPaint);

//     // Draw all LARGE circles
//     for (int i = 0; i < circleData.length && i < entries.length; i++) {
//       final data = circleData[i];
//       canvas.drawCircle(
//         Offset(data['cx']!, data['cy']!),
//         data['r']!,
//         circlePaint,
//       );
//     }

//     // Define EXACT positions for SMALL circles (connection points)
//     // These are the points where the paths have "dots" in the SVG
//     final List<Offset> smallCirclePositions = [
//       Offset(157, 90), // Top connection
//       Offset(133, 90), // First turn
//       Offset(133, 173), // Second connection
//       Offset(157, 173), // Second turn
//       Offset(157, 257), // Third connection
//       Offset(128, 257), // Third turn
//       Offset(128, 340), // Fourth connection
//       Offset(152, 340), // Fourth turn
//       Offset(152, 424), // Fifth connection
//       Offset(128, 424), // Fifth turn
//       Offset(270, 508), // Bottom connection
//     ];

//     // Draw SMALL circles as COMPLETE filled circles
//     for (final position in smallCirclePositions) {
//       canvas.drawCircle(
//         position,
//         6.0, // Radius for small circles
//         smallCirclePaint,
//       );
//     }

//     // ============ ADD THE VERY FIRST STARTING POINT CIRCLE ============
//     // Draw a complete small circle at the very beginning (15, 0)
//     canvas.drawCircle(Offset(15, 0), 6.0, smallCirclePaint);
//     // ============ END OF ADDITION ============

//     // Draw text labels
//     _drawTextLabels(canvas, entries, scale);

//     canvas.restore();
//   }

//   void _drawConnectingPaths(Canvas canvas, Paint paint) {
//     // Simplified path drawing - just draw the lines, NOT the circles

//     // Path 1: Top to first circle
//     Path path1 = Path();
//     path1.moveTo(15, 0);
//     path1.cubicTo(17.9729, 0, 20.4388, 2.16245, 20.915, 5);
//     path1.lineTo(232, 5);
//     path1.cubicTo(255.748, 5, 275, 24.2518, 275, 48);
//     path1.cubicTo(275, 71.7482, 255.748, 91, 232, 91);
//     path1.lineTo(157, 91);
//     canvas.drawPath(path1, paint);

//     // Path 2: First to second circle
//     Path path2 = Path();
//     path2.moveTo(133, 91);
//     path2.lineTo(58, 91);
//     path2.cubicTo(35.3563, 91, 17, 109.356, 17, 132);
//     path2.cubicTo(17, 154.644, 35.3563, 173, 58, 173);
//     path2.lineTo(133, 173);
//     canvas.drawPath(path2, paint);

//     // Path 3: Second to third circle
//     Path path3 = Path();
//     path3.moveTo(157, 173);
//     path3.lineTo(232, 173);
//     path3.cubicTo(255.748, 173, 275, 192.252, 275, 216);
//     path3.cubicTo(275, 239.377, 256.345, 258.398, 233.109, 258.986);
//     path3.lineTo(232, 259);
//     path3.lineTo(157, 259);
//     canvas.drawPath(path3, paint);

//     // Path 4: Third to fourth circle
//     Path path4 = Path();
//     path4.moveTo(128, 259);
//     path4.lineTo(53, 259);
//     path4.cubicTo(30.3563, 259, 12, 277.356, 12, 300);
//     path4.cubicTo(12, 322.644, 30.3563, 341, 53, 341);
//     path4.lineTo(128, 341);
//     canvas.drawPath(path4, paint);

//     // Path 5: Fourth to fifth circle
//     Path path5 = Path();
//     path5.moveTo(152, 341);
//     path5.lineTo(227, 341);
//     path5.cubicTo(250.748, 341, 270, 360.252, 270, 384);
//     path5.cubicTo(270, 407.377, 251.345, 426.398, 228.109, 426.986);
//     path5.lineTo(227, 427);
//     path5.lineTo(152, 427);
//     canvas.drawPath(path5, paint);

//     // Path 6: Fifth to sixth circle
//     Path path6 = Path();
//     path6.moveTo(128, 427);
//     path6.lineTo(53, 427);
//     path6.cubicTo(30.3563, 427, 12, 445.356, 12, 468);
//     path6.cubicTo(12, 490.29, 29.787, 508.425, 51.9414, 508.986);
//     path6.lineTo(53, 509);
//     path6.lineTo(270, 509);
//     canvas.drawPath(path6, paint);
//   }

//   void _drawTextLabels(Canvas canvas, List<WeightEntry> entries, double scale) {
//     final List<Map<String, dynamic>> textData = [
//       {'weight': '62kg', 'date': '20 Sept 2025', 'align': TextAlign.left},
//       {'weight': '62kg', 'date': '15 Sept 2025', 'align': TextAlign.left},
//       {'weight': '65kg', 'date': '10 Sept 2025', 'align': TextAlign.left},
//       {'weight': '68kg', 'date': '01 Sept 2025', 'align': TextAlign.left},
//       {'weight': '70kg', 'date': '25 Aug 2025', 'align': TextAlign.left},
//       {'weight': '75kg', 'date': '20 Aug 2025', 'align': TextAlign.left},
//     ];

//     final List<Map<String, double>> circleData = [
//       {'cx': 244.5, 'cy': 47.5, 'r': 38.5},
//       {'cx': 43.5, 'cy': 131.5, 'r': 38.5},
//       {'cx': 244.5, 'cy': 215.5, 'r': 38.5},
//       {'cx': 38.5, 'cy': 298.5, 'r': 38.5},
//       {'cx': 239.5, 'cy': 382.5, 'r': 38.5},
//       {'cx': 38.5, 'cy': 465.5, 'r': 38.5},
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
//             fontSize: 14 / scale,
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
//             fontSize: 12 / scale,
//             fontWeight: FontWeight.w400,
//             fontFamily: 'Arial',
//           ),
//         ),
//         textDirection: TextDirection.ltr,
//         textAlign: data['align'],
//       );
//       dateTextPainter.layout();

//       // Position text
//       final cx = circlePos['cx']!;
//       final cy = circlePos['cy']!;
//       final r = circlePos['r']!;

//       if (cx > 150) {
//         // Right side
//         weightTextPainter.paint(
//           canvas,
//           Offset(cx - r - weightTextPainter.width - 12, cy - 18),
//         );
//         dateTextPainter.paint(
//           canvas,
//           Offset(cx - r - dateTextPainter.width - 12, cy + 3),
//         );
//       } else {
//         // Left side
//         weightTextPainter.paint(canvas, Offset(cx + r + 12, cy - 18));
//         dateTextPainter.paint(canvas, Offset(cx + r + 12, cy + 3));
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

    // Define EXACT positions for SMALL circles (connection points)
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

    // ============ CORRECT DRAWING ORDER ============

    // 1. Draw all LARGE circles FIRST (background)
    for (int i = 0; i < circleData.length && i < entries.length; i++) {
      final data = circleData[i];
      canvas.drawCircle(
        Offset(data['cx']!, data['cy']!),
        data['r']!,
        circlePaint,
      );
    }

    // 2. Draw connecting paths SECOND (on top of circles)
    _drawConnectingPaths(canvas, pathPaint);

    // 3. Draw SMALL circles THIRD (on top of paths)
    for (final position in smallCirclePositions) {
      canvas.drawCircle(
        position,
        6.0, // Radius for small circles
        smallCirclePaint,
      );
    }

    // 4. Draw the very first starting point circle
    canvas.drawCircle(Offset(15, 0), 6.0, smallCirclePaint);

    // 5. Draw text labels LAST (on top of everything)
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
