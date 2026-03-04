import 'dart:ui' as ui;

import 'package:bloodfit/features/weight_history/presentation/widgets/transformation_timline_widget.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

/// Starting design widget (Design 1)
/// Circle on RIGHT side, path flows from LEFT to RIGHT
class WeightStartDesign extends StatelessWidget {
  final WeightEntry entry;
  final double yOffset;

  const WeightStartDesign({
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
        painter: WeightStartDesignPainter(
          entry: entry,
          yOffset: yOffset,
        ),
      ),
    );
  }
}

class WeightStartDesignPainter extends CustomPainter {
  final WeightEntry entry;
  final double yOffset;

  WeightStartDesignPainter({
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

    // Draw starting point small circle
    canvas.drawCircle(const ui.Offset(15, 0), 6.0, smallCirclePaint);

    // Draw Path 1
    final path = ui.Path();
    path.moveTo(15, 0);
    path.cubicTo(17.9729, 0, 20.4388, 2.16245, 20.915, 5);
    path.lineTo(232, 5);
    path.cubicTo(255.748, 5, 275, 24.2518, 275, 48);
    path.cubicTo(275, 71.7482, 255.748, 91, 232, 91);
    path.lineTo(157, 91);
    canvas.drawPath(path, pathPaint);

    // Draw small circle at end of path
    canvas.drawCircle(const ui.Offset(157, 91), 6.0, smallCirclePaint);

    // Draw large circle (RIGHT side)
    canvas.drawCircle(
      const ui.Offset(244.5, 47.5),
      38.5,
      circlePaint,
    );

    // Draw text
    _drawText(canvas, entry, 244.5, 47.5, 38.5);
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
  bool shouldRepaint(covariant WeightStartDesignPainter oldDelegate) {
    return oldDelegate.entry != entry || oldDelegate.yOffset != yOffset;
  }
}
