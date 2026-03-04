import 'dart:ui' as ui;

import 'package:bloodfit/features/weight_history/presentation/widgets/transformation_timline_widget.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

/// Middle left side design widget (Designs 2, 4)
/// Circle on LEFT side, path flows from RIGHT to LEFT
class WeightMiddleLeftDesign extends StatelessWidget {
  final WeightEntry entry;
  final double yOffset;

  const WeightMiddleLeftDesign({
    Key? key,
    required this.entry,
    this.yOffset = 0,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 84,
      width: double.infinity,
      child: CustomPaint(
        painter: WeightMiddleLeftDesignPainter(
          entry: entry,
          yOffset: yOffset,
        ),
      ),
    );
  }
}

class WeightMiddleLeftDesignPainter extends CustomPainter {
  final WeightEntry entry;
  final double yOffset;

  WeightMiddleLeftDesignPainter({
    required this.entry,
    this.yOffset = 0.0,
  });

  @override
  void paint(ui.Canvas canvas, ui.Size size) {
    final circlePaint = ui.Paint()
      ..color = const Color(0xFFB20000).withOpacity(0.5)
      ..style = ui.PaintingStyle.fill;

    final pathPaint = ui.Paint()
      ..color = const Color(0xFFB20000)
      ..style = ui.PaintingStyle.stroke
      ..strokeWidth = 2.0;

    final smallCirclePaint = ui.Paint()
      ..color = const Color(0xFFB20000)
      ..style = ui.PaintingStyle.fill;

    // Draw path (from right to left)
    final path = ui.Path();
    path.moveTo(133, 42 + yOffset);
    path.lineTo(58, 42 + yOffset);
    path.cubicTo(35.3563, 42 + yOffset, 17, 60.356 + yOffset, 17, 83 + yOffset);
    path.cubicTo(17, 105.644 + yOffset, 35.3563, 124 + yOffset, 58, 124 + yOffset);
    path.lineTo(133, 124 + yOffset);
    canvas.drawPath(path, pathPaint);

    // Draw small circles
    canvas.drawCircle(ui.Offset(133, 42 + yOffset), 6.0, smallCirclePaint);
    canvas.drawCircle(ui.Offset(133, 124 + yOffset), 6.0, smallCirclePaint);

    // Draw large circle (LEFT side)
    canvas.drawCircle(
      ui.Offset(43.5, 47.5 + yOffset),
      38.5,
      circlePaint,
    );

    // Draw text
    _drawText(canvas, entry, 43.5, 47.5 + yOffset, 38.5);
  }

  void _drawText(ui.Canvas canvas, WeightEntry entry, double cx, double cy, double r) {
    final weightText = '${entry.weight.toStringAsFixed(1)}kg';
    final weightTextPainter = TextPainter(
      text: TextSpan(
        text: weightText,
        style: const TextStyle(
          color: const Color(0xFFFFFFFF),
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
          color: const Color(0xFF999999),
          fontSize: 12,
          fontWeight: FontWeight.w400,
          fontFamily: 'Poppins',
        ),
      ),
      textDirection: ui.TextDirection.ltr,
    );
    dateTextPainter.layout();

    // Left side circle - text on right
    weightTextPainter.paint(
      canvas,
      ui.Offset(cx + r + 12, cy - 18),
    );
    dateTextPainter.paint(
      canvas,
      ui.Offset(cx + r + 12, cy + 3),
    );
  }

  String _formatDate(DateTime date) {
    return DateFormat('dd MMM yyyy').format(date);
  }

  @override
  bool shouldRepaint(covariant WeightMiddleLeftDesignPainter oldDelegate) {
    return oldDelegate.entry != entry || oldDelegate.yOffset != yOffset;
  }
}
