import 'package:flutter/material.dart';

/// Painter that draws a diagonal line from top-right → bottom-left
class DiagonalLinePainter extends CustomPainter {
  final Color color;
  final double strokeWidth;

  DiagonalLinePainter({required this.color, this.strokeWidth = 2});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke;

    // Draw from top-right to bottom-left
    canvas.drawLine(
      Offset(size.width, 0), // top-right
      Offset(0, size.height), // bottom-left
      paint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
