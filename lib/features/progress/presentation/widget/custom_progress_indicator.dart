



import 'package:bloodfit/gen/colors.gen.dart';
import 'package:flutter/material.dart';


class ProgressIndicatorWithMarkers extends StatelessWidget {
  final double startValue;
  final double currentValue;
  final double goalValue;
  final String unit;
  final double trackHeight;

  const ProgressIndicatorWithMarkers({
    super.key,
    this.startValue = 90,
    this.currentValue = 70,
    this.goalValue = 60,
    this.unit = 'kg',
    this.trackHeight = 3, // ← thinner track (was 6)
  });

  double _fraction(double value) {
    if ((startValue - goalValue).abs() < 0.001) return 0.0;
    return ((startValue - value) / (startValue - goalValue)).clamp(0.0, 1.0);
  }

  String _fmt(double v) => '${v % 1 == 0 ? v.toInt() : v}$unit';

  double _currentCentreX({
    required double totalWidth,
    required double currentX,
  }) {
    const double halfLabelW = 28.0;
    const double minGap = 6.0;

    double cx = currentX.clamp(halfLabelW, totalWidth - halfLabelW);

    final double startRightEdge = halfLabelW * 2;
    if (cx - halfLabelW < startRightEdge + minGap) {
      cx = startRightEdge + minGap + halfLabelW;
    }

    final double goalLeftEdge = totalWidth - halfLabelW * 2;
    if (cx + halfLabelW > goalLeftEdge - minGap) {
      cx = goalLeftEdge - minGap - halfLabelW;
    }

    return cx.clamp(halfLabelW, totalWidth - halfLabelW);
  }

  @override
  Widget build(BuildContext context) {
    final double currentFraction = _fraction(currentValue);

    // ── Marker radius is also slimmed down ──────────────────────────────
    const double markerRadius = 8.0; // ← smaller dots (was 10)

    return Container(
      padding: const EdgeInsets.fromLTRB(14, 14, 14, 12),
      decoration: BoxDecoration(
        color: const Color(0xFF1C1C1E),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // ── Middle container ─────────────────────────────────────────
          Container(
            padding: const EdgeInsets.fromLTRB(14, 10, 14, 10),
            decoration: BoxDecoration(
              color: const Color(0xFF2C2C2E),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Values row
                LayoutBuilder(
                  builder: (context, constraints) {
                    final double totalWidth = constraints.maxWidth;
                    final double startX = markerRadius;
                    final double goalX = totalWidth - markerRadius;
                    final double trackLen = goalX - startX;
                    final double currentX = startX + trackLen * currentFraction;
                    const double halfLabelW = 28.0;

                    final double cx = _currentCentreX(
                      totalWidth: totalWidth,
                      currentX: currentX,
                    );

                    return SizedBox(
                      height: 26,
                      child: Stack(
                        children: [
                          Positioned(
                            left: 0,
                            top: 0,
                            child: Text(
                              _fmt(startValue),
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                                letterSpacing: -0.3,
                              ),
                            ),
                          ),
                          Positioned(
                            right: 0,
                            top: 0,
                            child: Text(
                              _fmt(goalValue),
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                                letterSpacing: -0.3,
                              ),
                            ),
                          ),
                          Positioned(
                            left: cx - halfLabelW,
                            width: halfLabelW * 2,
                            top: 0,
                            child: Text(
                              _fmt(currentValue),
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                color: AppColors.cb20000,
                                fontSize: 20,
                                fontWeight: FontWeight.w700,
                                letterSpacing: -0.3,
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),

                const SizedBox(height: 8),

                // ── Inner container (black + cyan border, track only) ──
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.black,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      width: 1.2,
                    ),
                  ),
                  child: LayoutBuilder(
                    builder: (context, constraints) {
                      final double totalWidth = constraints.maxWidth;
                      final double startX = markerRadius;
                      final double goalX = totalWidth - markerRadius;
                      final double trackLen = goalX - startX;
                      final double currentX =
                          startX + trackLen * currentFraction;

                      return SizedBox(
                        height: markerRadius * 2,
                        child: Stack(
                          clipBehavior: Clip.none,
                          children: [
                            // Grey background track
                            Positioned(
                              left: startX,
                              width: trackLen,
                              top: markerRadius - trackHeight / 2,
                              child: Container(
                                height: trackHeight,
                                decoration: BoxDecoration(
                                  color: const Color(0xFF3A3A3C),
                                  borderRadius:
                                      BorderRadius.circular(trackHeight / 2),
                                ),
                              ),
                            ),
                            // Red filled track
                            Positioned(
                              left: startX,
                              width: (currentX - startX).clamp(0.0, trackLen),
                              top: markerRadius - trackHeight / 2,
                              child: Container(
                                height: trackHeight,
                                decoration: BoxDecoration(
                                  color: AppColors.cb20000,
                                  borderRadius:
                                      BorderRadius.circular(trackHeight / 2),
                                ),
                              ),
                            ),
                            // Start marker
                            Positioned(
                              left: startX - markerRadius,
                              top: 0,
                              child: _markerCircle(
                                radius: markerRadius,
                                color: AppColors.cb20000,
                                borderColor: Colors.black,
                                borderWidth: 2,
                              ),
                            ),
                            // Current marker
                            Positioned(
                              left: currentX - markerRadius,
                              top: 0,
                              child: _markerCircle(
                                radius: markerRadius,
                                color: AppColors.cb20000,
                                borderColor: Colors.black,
                                borderWidth: 2,
                              ),
                            ),
                            // Goal marker
                            Positioned(
                              left: goalX - markerRadius,
                              top: 0,
                              child: _markerCircle(
                                radius: markerRadius,
                                color: const Color(0xFF6E6E73),
                                borderColor: Colors.black,
                                borderWidth: 2,
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 10),

          // ── Labels row — outside middle container ─────────────────────
          LayoutBuilder(
            builder: (context, constraints) {
              final double totalWidth = constraints.maxWidth;
              const double hPad = 14.0;
              const double innerHPad = 10.0;

              final double effectiveStart = hPad + innerHPad + markerRadius;
              final double effectiveEnd =
                  totalWidth - hPad - innerHPad - markerRadius;
              final double effectiveLen = effectiveEnd - effectiveStart;
              final double currentX =
                  effectiveStart + effectiveLen * currentFraction;

              const double halfLabelW = 28.0;
              final double cx = _currentCentreX(
                totalWidth: totalWidth,
                currentX: currentX,
              );

              return SizedBox(
                height: 18,
                child: Stack(
                  children: [
                    const Positioned(
                      left: 0,
                      top: 0,
                      child: Text('Starting', style: _subLabelStyle),
                    ),
                    Positioned(
                      left: cx - halfLabelW,
                      width: halfLabelW * 2,
                      top: 0,
                      child: const Text(
                        'Current',
                        textAlign: TextAlign.center,
                        style: _subLabelStyle,
                      ),
                    ),
                    const Positioned(
                      right: 0,
                      top: 0,
                      child: Text('Goal', style: _subLabelStyle),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  static Widget _markerCircle({
    required double radius,
    required Color color,
    Color? borderColor,
    double borderWidth = 0,
  }) {
    return Container(
      width: radius * 2,
      height: radius * 2,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: color,
        border: borderColor != null
            ? Border.all(color: borderColor, width: borderWidth)
            : null,
      ),
    );
  }

  static const TextStyle _subLabelStyle = TextStyle(
    color: Color(0xFF8E8E93),
    fontSize: 13,
    fontWeight: FontWeight.w400,
    letterSpacing: 0.1,
  );
}