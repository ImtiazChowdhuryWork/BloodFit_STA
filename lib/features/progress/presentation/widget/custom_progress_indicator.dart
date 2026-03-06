


// import 'package:flutter/material.dart';

// /// A weight-loss / goal progress indicator showing Starting, Current, and Goal
// /// markers along a horizontal track. The "Current" value label and sub-label
// /// float directly above/below the current marker and move with it.
// class ProgressIndicatorWithMarkers extends StatelessWidget {
//   /// The value at the start of the journey (e.g. 90).
//   final double startValue;

//   /// The current value (e.g. 70).
//   final double currentValue;

//   /// The target / goal value (e.g. 60).
//   final double goalValue;

//   /// Unit label appended to every value (e.g. "kg").
//   final String unit;

//   /// Height of the track bar.
//   final double trackHeight;

//   const ProgressIndicatorWithMarkers({
//     super.key,
//     this.startValue = 90,
//     this.currentValue = 70,
//     this.goalValue = 60,
//     this.unit = 'kg',
//     this.trackHeight = 6,
//   });

//   /// Fraction [0–1] of how far [value] is along [start] → [goal].
//   double _fraction(double value) {
//     if ((startValue - goalValue).abs() < 0.001) return 0.0;
//     return ((startValue - value) / (startValue - goalValue)).clamp(0.0, 1.0);
//   }

//   String _fmt(double v) => '${v % 1 == 0 ? v.toInt() : v}$unit';

//   @override
//   Widget build(BuildContext context) {
//     final double currentFraction = _fraction(currentValue);

//     return Container(
//       padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
//       decoration: BoxDecoration(
//         color: const Color(0xFF1C1C1E),
//         borderRadius: BorderRadius.circular(18),
//       ),
//       child: LayoutBuilder(
//         builder: (context, constraints) {
//           final double totalWidth = constraints.maxWidth;
//           const double markerRadius = 10.0;

//           // ── X positions ──────────────────────────────────────────────────
//           final double startX = markerRadius;
//           final double goalX = totalWidth - markerRadius;
//           final double trackLen = goalX - startX;
//           final double currentX = startX + trackLen * currentFraction;

//           // ── Layout constants ─────────────────────────────────────────────
//           const double topLabelH = 24.0;   // height reserved for value labels
//           const double topGap = 8.0;       // gap between value labels and track
//           const double trackAreaH = markerRadius * 2;
//           const double bottomGap = 10.0;
//           const double bottomLabelH = 18.0;

//           final double totalH =
//               topLabelH + topGap + trackAreaH + bottomGap + bottomLabelH;

//           // ── Vertical offsets ─────────────────────────────────────────────
//           final double trackTop = topLabelH + topGap;
//           final double markerTop = trackTop;
//           final double labelTop = trackTop + trackAreaH + bottomGap;

//           // ── Current label clamping so it never clips the container edges ─
//           const double halfLabelW = 24.0;
//           final double currentLabelCentreX =
//               currentX.clamp(halfLabelW, totalWidth - halfLabelW);

//           return SizedBox(
//             height: totalH,
//             child: Stack(
//               clipBehavior: Clip.none,
//               children: [
//                 // ── Static: Start value label (top-left) ──────────────────
//                 Positioned(
//                   left: 0,
//                   top: 0,
//                   child: Text(
//                     _fmt(startValue),
//                     style: const TextStyle(
//                       color: Colors.white,
//                       fontSize: 16,
//                       fontWeight: FontWeight.w500,
//                       letterSpacing: -0.3,
//                     ),
//                   ),
//                 ),

//                 // ── Static: Goal value label (top-right) ──────────────────
//                 Positioned(
//                   right: 0,
//                   top: 0,
//                   child: Text(
//                     _fmt(goalValue),
//                     style: const TextStyle(
//                       color: Colors.white,
//                       fontSize: 16,
//                       fontWeight: FontWeight.w500,
//                       letterSpacing: -0.3,
//                     ),
//                   ),
//                 ),

//                 // ── Dynamic: Current value label (top, follows marker) ────
//                 Positioned(
//                   top: 0,
//                   left: currentLabelCentreX - halfLabelW,
//                   width: halfLabelW * 2,
//                   child: Text(
//                     _fmt(currentValue),
//                     textAlign: TextAlign.center,
//                     style: const TextStyle(
//                       color: Color(0xFFE53935),
//                       fontSize: 20,
//                       fontWeight: FontWeight.w700,
//                       letterSpacing: -0.3,
//                     ),
//                   ),
//                 ),

//                 // ── Grey background track ─────────────────────────────────
//                 Positioned(
//                   left: startX,
//                   width: trackLen,
//                   top: markerTop + markerRadius - trackHeight / 2,
//                   child: Container(
//                     height: trackHeight,
//                     decoration: BoxDecoration(
//                       color: const Color(0xFF3A3A3C),
//                       borderRadius: BorderRadius.circular(trackHeight / 2),
//                     ),
//                   ),
//                 ),

//                 // ── Red filled track (start → current) ───────────────────
//                 Positioned(
//                   left: startX,
//                   width: (currentX - startX).clamp(0.0, trackLen),
//                   top: markerTop + markerRadius - trackHeight / 2,
//                   child: Container(
//                     height: trackHeight,
//                     decoration: BoxDecoration(
//                       color: const Color(0xFFE53935),
//                       borderRadius: BorderRadius.circular(trackHeight / 2),
//                     ),
//                   ),
//                 ),

//                 // ── Start marker (solid red) ──────────────────────────────
//                 Positioned(
//                   left: startX - markerRadius,
//                   top: markerTop,
//                   child: _markerCircle(
//                     radius: markerRadius,
//                     color: const Color(0xFFE53935),
//                   ),
//                 ),

//                 // ── Current marker (red with dark border) ─────────────────
//                 Positioned(
//                   left: currentX - markerRadius,
//                   top: markerTop,
//                   child: _markerCircle(
//                     radius: markerRadius,
//                     color: const Color(0xFFE53935),
//                     borderColor: const Color(0xFF1C1C1E),
//                     borderWidth: 2.5,
//                   ),
//                 ),

//                 // ── Goal marker (grey) ────────────────────────────────────
//                 Positioned(
//                   left: goalX - markerRadius,
//                   top: markerTop,
//                   child: _markerCircle(
//                     radius: markerRadius,
//                     color: const Color(0xFF6E6E73),
//                     borderColor: const Color(0xFF1C1C1E),
//                     borderWidth: 2.5,
//                   ),
//                 ),

//                 // ── Static: "Starting" sub-label (bottom-left) ───────────
//                 Positioned(
//                   left: 0,
//                   top: labelTop,
//                   child: const Text('Starting', style: _subLabelStyle),
//                 ),

//                 // ── Dynamic: "Current" sub-label (follows marker) ─────────
//                 Positioned(
//                   top: labelTop,
//                   left: currentLabelCentreX - halfLabelW,
//                   width: halfLabelW * 2,
//                   child: const Text(
//                     'Current',
//                     textAlign: TextAlign.center,
//                     style: _subLabelStyle,
//                   ),
//                 ),

//                 // ── Static: "Goal" sub-label (bottom-right) ───────────────
//                 Positioned(
//                   right: 0,
//                   top: labelTop,
//                   child: const Text('Goal', style: _subLabelStyle),
//                 ),
//               ],
//             ),
//           );
//         },
//       ),
//     );
//   }

//   static Widget _markerCircle({
//     required double radius,
//     required Color color,
//     Color? borderColor,
//     double borderWidth = 0,
//   }) {
//     return Container(
//       width: radius * 2,
//       height: radius * 2,
//       decoration: BoxDecoration(
//         shape: BoxShape.circle,
//         color: color,
//         border: borderColor != null
//             ? Border.all(color: borderColor, width: borderWidth)
//             : null,
//       ),
//     );
//   }

//   static const TextStyle _subLabelStyle = TextStyle(
//     color: Color(0xFF8E8E93),
//     fontSize: 13,
//     fontWeight: FontWeight.w400,
//     letterSpacing: 0.1,
//   );
// }



import 'package:flutter/material.dart';

/// A weight-loss / goal progress indicator showing Starting, Current, and Goal
/// markers along a horizontal track. The "Current" value label and sub-label
/// float directly above/below the current marker and move with it.
///
/// Collision avoidance: when the current marker is close to the start or goal
/// markers, the "Current" labels shift away to avoid overlap.
class ProgressIndicatorWithMarkers extends StatelessWidget {
  /// The value at the start of the journey (e.g. 90).
  final double startValue;

  /// The current value (e.g. 70).
  final double currentValue;

  /// The target / goal value (e.g. 60).
  final double goalValue;

  /// Unit label appended to every value (e.g. "kg").
  final String unit;

  /// Height of the track bar.
  final double trackHeight;

  const ProgressIndicatorWithMarkers({
    super.key,
    this.startValue = 90,
    this.currentValue = 70,
    this.goalValue = 60,
    this.unit = 'kg',
    this.trackHeight = 6,
  });

  double _fraction(double value) {
    if ((startValue - goalValue).abs() < 0.001) return 0.0;
    return ((startValue - value) / (startValue - goalValue)).clamp(0.0, 1.0);
  }

  String _fmt(double v) => '${v % 1 == 0 ? v.toInt() : v}$unit';

  @override
  Widget build(BuildContext context) {
    final double currentFraction = _fraction(currentValue);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
      decoration: BoxDecoration(
        color: const Color(0xFF1C1C1E),
        borderRadius: BorderRadius.circular(18),
      ),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final double totalWidth = constraints.maxWidth;
          const double markerRadius = 10.0;

          // ── X positions ──────────────────────────────────────────────────
          final double startX = markerRadius;
          final double goalX = totalWidth - markerRadius;
          final double trackLen = goalX - startX;
          final double currentX = startX + trackLen * currentFraction;

          // ── Layout constants ─────────────────────────────────────────────
          const double topLabelH = 24.0;
          const double topGap = 8.0;
          const double trackAreaH = markerRadius * 2;
          const double bottomGap = 10.0;
          const double bottomLabelH = 18.0;
          final double totalH =
              topLabelH + topGap + trackAreaH + bottomGap + bottomLabelH;

          final double trackTop = topLabelH + topGap;
          final double markerTop = trackTop;
          final double labelTop = trackTop + trackAreaH + bottomGap;

          // ── Label width & collision threshold ────────────────────────────
          // halfLabelW covers the wider value text (e.g. "70kg" at fontSize 20)
          const double halfLabelW = 28.0;
          const double minGap = 6.0; // minimum pixel gap between label edges
          const double collisionDist = halfLabelW * 2 + minGap;

          // Raw centred position, clamped to container bounds
          double currentCentreX =
              currentX.clamp(halfLabelW, totalWidth - halfLabelW);

          // ── Collision with START label ────────────────────────────────────
          // Start label left-edge is at 0, right-edge ~≈ halfLabelW*2 (approx)
          final double startRightEdge = halfLabelW * 2; // conservative estimate
          if (currentCentreX - halfLabelW < startRightEdge + minGap) {
            currentCentreX = startRightEdge + minGap + halfLabelW;
          }

          // ── Collision with GOAL label ─────────────────────────────────────
          // Goal label right-edge is at totalWidth, left-edge ≈ totalWidth - halfLabelW*2
          final double goalLeftEdge = totalWidth - halfLabelW * 2;
          if (currentCentreX + halfLabelW > goalLeftEdge - minGap) {
            currentCentreX = goalLeftEdge - minGap - halfLabelW;
          }

          // Final clamp so we never go out of bounds after adjustments
          currentCentreX =
              currentCentreX.clamp(halfLabelW, totalWidth - halfLabelW);

          return SizedBox(
            height: totalH,
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                // ── Static: Start value label (top-left) ──────────────────
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

                // ── Static: Goal value label (top-right) ──────────────────
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

                // ── Dynamic: Current value label (top, follows marker) ────
                Positioned(
                  top: 0,
                  left: currentCentreX - halfLabelW,
                  width: halfLabelW * 2,
                  child: Text(
                    _fmt(currentValue),
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: Color(0xFFE53935),
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                      letterSpacing: -0.3,
                    ),
                  ),
                ),

                // ── Grey background track ─────────────────────────────────
                Positioned(
                  left: startX,
                  width: trackLen,
                  top: markerTop + markerRadius - trackHeight / 2,
                  child: Container(
                    height: trackHeight,
                    decoration: BoxDecoration(
                      color: const Color(0xFF3A3A3C),
                      borderRadius: BorderRadius.circular(trackHeight / 2),
                    ),
                  ),
                ),

                // ── Red filled track (start → current) ───────────────────
                Positioned(
                  left: startX,
                  width: (currentX - startX).clamp(0.0, trackLen),
                  top: markerTop + markerRadius - trackHeight / 2,
                  child: Container(
                    height: trackHeight,
                    decoration: BoxDecoration(
                      color: const Color(0xFFE53935),
                      borderRadius: BorderRadius.circular(trackHeight / 2),
                    ),
                  ),
                ),

                // ── Start marker (solid red) ──────────────────────────────
                Positioned(
                  left: startX - markerRadius,
                  top: markerTop,
                  child: _markerCircle(
                    radius: markerRadius,
                    color: const Color(0xFFE53935),
                  ),
                ),

                // ── Current marker (red with dark border) ─────────────────
                Positioned(
                  left: currentX - markerRadius,
                  top: markerTop,
                  child: _markerCircle(
                    radius: markerRadius,
                    color: const Color(0xFFE53935),
                    borderColor: const Color(0xFF1C1C1E),
                    borderWidth: 2.5,
                  ),
                ),

                // ── Goal marker (grey) ────────────────────────────────────
                Positioned(
                  left: goalX - markerRadius,
                  top: markerTop,
                  child: _markerCircle(
                    radius: markerRadius,
                    color: const Color(0xFF6E6E73),
                    borderColor: const Color(0xFF1C1C1E),
                    borderWidth: 2.5,
                  ),
                ),

                // ── Static: "Starting" sub-label (bottom-left) ───────────
                Positioned(
                  left: 0,
                  top: labelTop,
                  child: const Text('Starting', style: _subLabelStyle),
                ),

                // ── Dynamic: "Current" sub-label (follows marker, same collision logic) ──
                Positioned(
                  top: labelTop,
                  left: currentCentreX - halfLabelW,
                  width: halfLabelW * 2,
                  child: const Text(
                    'Current',
                    textAlign: TextAlign.center,
                    style: _subLabelStyle,
                  ),
                ),

                // ── Static: "Goal" sub-label (bottom-right) ───────────────
                Positioned(
                  right: 0,
                  top: labelTop,
                  child: const Text('Goal', style: _subLabelStyle),
                ),
              ],
            ),
          );
        },
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

// ─── Quick preview ─────────────────────────────────────────────────────────────

void main() => runApp(const _PreviewApp());

class _PreviewApp extends StatefulWidget {
  const _PreviewApp();

  @override
  State<_PreviewApp> createState() => _PreviewAppState();
}

class _PreviewAppState extends State<_PreviewApp> {
  double _current = 70;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark(),
      home: Scaffold(
        backgroundColor: Colors.black,
        body: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ProgressIndicatorWithMarkers(
                  startValue: 90,
                  currentValue: _current,
                  goalValue: 60,
                  unit: 'kg',
                ),
                const SizedBox(height: 32),
                Slider(
                  value: _current,
                  min: 60,
                  max: 90,
                  divisions: 30,
                  activeColor: const Color(0xFFE53935),
                  onChanged: (v) => setState(() => _current = v),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}