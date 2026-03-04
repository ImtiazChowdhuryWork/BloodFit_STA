import 'dart:ui' as ui;

import 'package:bloodfit/features/weight_history/presentation/widgets/transformation_timline_widget.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

/// Ending design widget (Design 6)
/// Circle on RIGHT side, path flows from RIGHT to LEFT (mirror of Design 1)
class WeightEndDesign extends StatelessWidget {
  final WeightEntry entry;
  final double yOffset;

  const WeightEndDesign({
    Key? key,
    required this.entry,
    this.yOffset = 0,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 130,
      width: double.infinity,
      child: CustomPaint(
        painter: WeightEndDesignPainter(
          entry: entry,
          yOffset: yOffset,
        ),
      ),
    );
  }
}

class WeightEndDesignPainter extends CustomPainter {
  final WeightEntry entry;
  final double yOffset;

  WeightEndDesignPainter({
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

    // Draw path (from right to left, mirror of Design 1)
    final path = ui.Path();
    path.moveTo(152, 42 + yOffset);
    path.lineTo(227, 42 + yOffset);
    path.cubicTo(250.748, 42 + yOffset, 270, 61.252 + yOffset, 270, 85 + yOffset);
    path.cubicTo(270, 108.377 + yOffset, 251.345, 127.398 + yOffset, 228.109, 127.986 + yOffset);
    path.lineTo(227, 128 + yOffset);
    path.lineTo(152, 128 + yOffset);
    // Extended bottom line to left (mirror of Design 1's long top)
    path.lineTo(15, 128 + yOffset);
    canvas.drawPath(path, pathPaint);

    // Draw small circles
    canvas.drawCircle(ui.Offset(152, 42 + yOffset), 6.0, smallCirclePaint);
    canvas.drawCircle(ui.Offset(15, 128 + yOffset), 6.0, smallCirclePaint);

    // Draw large circle (RIGHT side)
    canvas.drawCircle(
      ui.Offset(239.5, 47.5 + yOffset),
      38.5,
      circlePaint,
    );

    // Draw text
    _drawText(canvas, entry, 239.5, 47.5 + yOffset, 38.5);
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

    // Right side circle - text on left
    weightTextPainter.paint(
      canvas,
      ui.Offset(cx - r - weightTextPainter.width - 12, cy - 18),
    );
    dateTextPainter.paint(
      canvas,
      ui.Offset(cx - r - dateTextPainter.width - 12, cy + 3),
    );
  }

  String _formatDate(DateTime date) {
    return DateFormat('dd MMM yyyy').format(date);
  }

  @override
  bool shouldRepaint(covariant WeightEndDesignPainter oldDelegate) {
    return oldDelegate.entry != entry || oldDelegate.yOffset != yOffset;
  }
}
