// import 'package:bloodfit/gen/colors.gen.dart';
// import 'package:flutter/material.dart';
// import 'dart:ui' as ui;

// // ─────────────────────────────────────────────────────────────────────────────
// // Data model
// // ─────────────────────────────────────────────────────────────────────────────

// class WeightEntry {
//   final int day;
//   final double weight;
//   const WeightEntry(this.day, this.weight);
// }

// // ─────────────────────────────────────────────────────────────────────────────
// // Public widget
// // ─────────────────────────────────────────────────────────────────────────────

// class WeightHistoryChart extends StatefulWidget {
//   final String title;
//   final String targetTitle;
//   final List<WeightEntry> entries;
//   final double goalWeight;
//   final double currentWeight;
//   final DateTime? initialMonth;
//   final void Function(DateTime month)? onMonthChanged;

//   const WeightHistoryChart({
//     super.key,
//     this.title = 'Your Weight History',
//     required this.entries,
//     required this.goalWeight,
//     required this.currentWeight,
//     this.initialMonth,
//     this.onMonthChanged,
//     required this.targetTitle,
//   });

//   @override
//   State<WeightHistoryChart> createState() => _WeightHistoryChartState();
// }

// class _WeightHistoryChartState extends State<WeightHistoryChart> {
//   late DateTime _selectedMonth;
//   int? _hoveredIndex;

//   static const List<String> _monthNames = [
//     'Jan',
//     'Feb',
//     'Mar',
//     'Apr',
//     'May',
//     'Jun',
//     'Jul',
//     'Aug',
//     'Sep',
//     'Oct',
//     'Nov',
//     'Dec',
//   ];

//   @override
//   void initState() {
//     super.initState();
//     final DateTime base = widget.initialMonth ?? DateTime.now();
//     _selectedMonth = DateTime(base.year, base.month);
//   }

//   String get _monthLabel =>
//       '${_monthNames[_selectedMonth.month - 1]} ${_selectedMonth.year}';

//   void _openMonthPicker() {
//     showDialog<DateTime>(
//       context: context,
//       barrierColor: Colors.black54,
//       builder: (_) => _MonthYearPickerDialog(current: _selectedMonth),
//     ).then((picked) {
//       if (picked != null) {
//         setState(() {
//           _selectedMonth = picked;
//           _hoveredIndex = null;
//         });
//         widget.onMonthChanged?.call(picked);
//       }
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       mainAxisSize: MainAxisSize.min,
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         // ── Title ──────────────────────────────────────────────────────────
//         Text(
//           widget.title,
//           style: const TextStyle(
//             color: Colors.white,
//             fontSize: 18,
//             fontWeight: FontWeight.w600,
//             letterSpacing: -0.2,
//           ),
//         ),
//         const SizedBox(height: 12),

//         // ── Chart card ────────────────────────────────────────────────────
//         Container(
//           decoration: BoxDecoration(
//             color: const Color(0xFF232323),
//             borderRadius: BorderRadius.circular(14),
//           ),
//           padding: const EdgeInsets.fromLTRB(12, 14, 12, 10),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.stretch,
//             children: [
//               // Header
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: [
//                    Text(
//                     widget.targetTitle,
//                     style: TextStyle(
//                       color: Colors.white,
//                       fontSize: 14,
//                       fontWeight: FontWeight.w500,
//                     ),
//                   ),
//                   GestureDetector(
//                     onTap: _openMonthPicker,
//                     child: Container(
//                       padding: const EdgeInsets.symmetric(
//                         horizontal: 10,
//                         vertical: 5,
//                       ),
//                       decoration: BoxDecoration(
//                         color: const Color(0xFF2E2E2E),
//                         borderRadius: BorderRadius.circular(8),
//                         border: Border.all(
//                           color: const Color(0xFF3A3A3A),
//                           width: 1,
//                         ),
//                       ),
//                       child: Row(
//                         mainAxisSize: MainAxisSize.min,
//                         children: [
//                           Text(
//                             _monthLabel,
//                             style: const TextStyle(
//                               color: Colors.white,
//                               fontSize: 12,
//                             ),
//                           ),
//                           const SizedBox(width: 4),
//                           const Icon(
//                             Icons.keyboard_arrow_down,
//                             color: Colors.white,
//                             size: 16,
//                           ),
//                         ],
//                       ),
//                     ),
//                   ),
//                 ],
//               ),

//               const SizedBox(height: 10),

//               // Chart
//               SizedBox(
//                 height: 220,
//                 child: _ChartArea(
//                   entries: widget.entries,
//                   hoveredIndex: _hoveredIndex,
//                   goalWeight: widget.goalWeight,
//                   currentWeight: widget.currentWeight,
//                   selectedMonth: _selectedMonth,
//                   onHover: (i) => setState(() => _hoveredIndex = i),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ],
//     );
//   }
// }

// // ─────────────────────────────────────────────────────────────────────────────
// // Month / Year Picker Dialog
// // ─────────────────────────────────────────────────────────────────────────────

// class _MonthYearPickerDialog extends StatefulWidget {
//   final DateTime current;
//   const _MonthYearPickerDialog({required this.current});

//   @override
//   State<_MonthYearPickerDialog> createState() => _MonthYearPickerDialogState();
// }

// class _MonthYearPickerDialogState extends State<_MonthYearPickerDialog> {
//   late int _year;
//   late int _month;

//   static const List<String> _months = [
//     'Jan',
//     'Feb',
//     'Mar',
//     'Apr',
//     'May',
//     'Jun',
//     'Jul',
//     'Aug',
//     'Sep',
//     'Oct',
//     'Nov',
//     'Dec',
//   ];

//   @override
//   void initState() {
//     super.initState();
//     _year = widget.current.year;
//     _month = widget.current.month;
//   }

//   @override
//   Widget build(BuildContext context) {
//     final DateTime now = DateTime.now();
//     final bool isCurrentYear = _year == now.year;
//     final bool isFutureYear = _year > now.year;

//     // Forward arrow disabled when already on current year
//     final bool canGoForward = _year < now.year;

//     return Dialog(
//       backgroundColor: const Color(0xFF2A2A2A),
//       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
//       child: Padding(
//         padding: const EdgeInsets.all(20),
//         child: Column(
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             // ── Year selector ──────────────────────────────────────────────
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 // Back arrow — always enabled (no lower bound restriction)
//                 IconButton(
//                   icon: const Icon(Icons.chevron_left, color: Colors.white),
//                   onPressed: () => setState(() => _year--),
//                 ),
//                 Text(
//                   '$_year',
//                   style: const TextStyle(
//                     color: Colors.white,
//                     fontSize: 18,
//                     fontWeight: FontWeight.w600,
//                   ),
//                 ),
//                 // Forward arrow — disabled when on current year
//                 IconButton(
//                   icon: Icon(
//                     Icons.chevron_right,
//                     color: canGoForward
//                         ? Colors.white
//                         : Colors.white.withOpacity(0.25),
//                   ),
//                   onPressed: canGoForward
//                       ? () => setState(() => _year++)
//                       : null,
//                 ),
//               ],
//             ),

//             const SizedBox(height: 12),

//             // ── Month grid ─────────────────────────────────────────────────
//             GridView.builder(
//               shrinkWrap: true,
//               physics: const NeverScrollableScrollPhysics(),
//               gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
//                 crossAxisCount: 4,
//                 mainAxisSpacing: 8,
//                 crossAxisSpacing: 8,
//                 childAspectRatio: 1.8,
//               ),
//               itemCount: 12,
//               itemBuilder: (_, i) {
//                 final int monthNumber = i + 1;
//                 final bool selected = monthNumber == _month;

//                 // A month is in the future if:
//                 //   • the selected year is in the future, OR
//                 //   • it's the current year but the month hasn't arrived yet
//                 final bool isFuture =
//                     isFutureYear || (isCurrentYear && monthNumber > now.month);

//                 return GestureDetector(
//                   // Only allow tap on past/present months
//                   onTap: isFuture
//                       ? null
//                       : () => setState(() => _month = monthNumber),
//                   child: Container(
//                     decoration: BoxDecoration(
//                       color: selected
//                           ? AppColors.cb20000
//                           : const Color(0xFF3A3A3A),
//                       borderRadius: BorderRadius.circular(8),
//                     ),
//                     alignment: Alignment.center,
//                     child: Text(
//                       _months[i],
//                       style: TextStyle(
//                         // Future months are visually dimmed
//                         color: isFuture
//                             ? Colors.white.withOpacity(0.20)
//                             : selected
//                             ? Colors.white
//                             : const Color(0xFFAAAAAA),
//                         fontSize: 13,
//                         fontWeight: selected
//                             ? FontWeight.w600
//                             : FontWeight.w400,
//                       ),
//                     ),
//                   ),
//                 );
//               },
//             ),

//             const SizedBox(height: 16),

//             // ── Confirm button ─────────────────────────────────────────────
//             SizedBox(
//               width: double.infinity,
//               child: ElevatedButton(
//                 style: ElevatedButton.styleFrom(
//                   backgroundColor: AppColors.cb20000,
//                   foregroundColor: Colors.white,
//                   shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(10),
//                   ),
//                   padding: const EdgeInsets.symmetric(vertical: 12),
//                 ),
//                 onPressed: () =>
//                     Navigator.of(context).pop(DateTime(_year, _month)),
//                 child: const Text(
//                   'Confirm',
//                   style: TextStyle(fontWeight: FontWeight.w600),
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

// // ─────────────────────────────────────────────────────────────────────────────
// // Chart area (gesture wrapper + animation controller)
// // ─────────────────────────────────────────────────────────────────────────────

// class _ChartArea extends StatefulWidget {
//   final List<WeightEntry> entries;
//   final int? hoveredIndex;
//   final double goalWeight;
//   final double currentWeight;
//   final DateTime selectedMonth;
//   final ValueChanged<int?> onHover;

//   // Padding shared between gesture handler and painter
//   static const double kLeft = 28.0;
//   static const double kRight = 10.0;
//   static const double kTop = 10.0;
//   static const double kBottom = 22.0;

//   const _ChartArea({
//     required this.entries,
//     required this.hoveredIndex,
//     required this.goalWeight,
//     required this.currentWeight,
//     required this.selectedMonth,
//     required this.onHover,
//   });

//   @override
//   State<_ChartArea> createState() => _ChartAreaState();
// }

// class _ChartAreaState extends State<_ChartArea>
//     with SingleTickerProviderStateMixin {
//   late AnimationController _controller;
//   late Animation<double> _progress;

//   // Last day of the selected month
//   int get _lastDay => DateTime(
//     widget.selectedMonth.year,
//     widget.selectedMonth.month + 1,
//     0,
//   ).day;

//   static const int _xStart = 5;
//   double _toX(double day, double chartW) =>
//       _ChartArea.kLeft + (day - _xStart) / (_lastDay - _xStart) * chartW;

//   @override
//   void initState() {
//     super.initState();
//     _controller = AnimationController(
//       vsync: this,
//       duration: const Duration(milliseconds: 900),
//     );
//     _progress = CurvedAnimation(parent: _controller, curve: Curves.easeInOut);
//     _controller.forward();
//   }

//   @override
//   void didUpdateWidget(_ChartArea old) {
//     super.didUpdateWidget(old);
//     // Re-animate when entries or month changes
//     if (old.entries != widget.entries ||
//         old.selectedMonth != widget.selectedMonth) {
//       _controller.forward(from: 0);
//     }
//   }

//   @override
//   void dispose() {
//     _controller.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return GestureDetector(
//       onTapDown: (d) => _hit(d.localPosition, context, strict: true),
//       onHorizontalDragStart: (d) =>
//           _hit(d.localPosition, context, strict: false),
//       onHorizontalDragUpdate: (d) =>
//           _hit(d.localPosition, context, strict: false),
//       onHorizontalDragEnd: (_) {},
//       child: AnimatedBuilder(
//         animation: _progress,
//         builder: (_, __) => CustomPaint(
//           painter: _ChartPainter(
//             entries: widget.entries,
//             hoveredIndex: widget.hoveredIndex,
//             goalWeight: widget.goalWeight,
//             currentWeight: widget.currentWeight,
//             selectedMonth: widget.selectedMonth,
//             progress: _progress.value,
//           ),
//           child: const SizedBox.expand(),
//         ),
//       ),
//     );
//   }

//   /// [strict] = true  → only select if within 32 px (tap)
//   /// [strict] = false → always snap to nearest entry (drag)
//   void _hit(Offset pos, BuildContext ctx, {required bool strict}) {
//     final double chartW =
//         (ctx.findRenderObject() as RenderBox).size.width -
//         _ChartArea.kLeft -
//         _ChartArea.kRight;
//     if (widget.entries.isEmpty || chartW <= 0) return;

//     int closest = 0;
//     double minDist = double.infinity;
//     for (int i = 0; i < widget.entries.length; i++) {
//       final double dist =
//           (pos.dx - _toX(widget.entries[i].day.toDouble(), chartW)).abs();
//       if (dist < minDist) {
//         minDist = dist;
//         closest = i;
//       }
//     }

//     if (strict && minDist > 32) {
//       widget.onHover(null);
//     } else {
//       widget.onHover(closest);
//     }
//   }
// }

// // ─────────────────────────────────────────────────────────────────────────────
// // Painter
// // ─────────────────────────────────────────────────────────────────────────────

// class _ChartPainter extends CustomPainter {
//   final List<WeightEntry> entries;
//   final int? hoveredIndex;
//   final double goalWeight;
//   final double currentWeight;
//   final DateTime selectedMonth;
//   final double progress; // 0.0 → 1.0 animation progress

//   static const double kLeft = _ChartArea.kLeft;
//   static const double kRight = _ChartArea.kRight;
//   static const double kTop = _ChartArea.kTop;
//   static const double kBottom = _ChartArea.kBottom;

//   static const List<String> _monthNames = [
//     'Jan',
//     'Feb',
//     'Mar',
//     'Apr',
//     'May',
//     'Jun',
//     'Jul',
//     'Aug',
//     'Sep',
//     'Oct',
//     'Nov',
//     'Dec',
//   ];

//   const _ChartPainter({
//     required this.entries,
//     required this.hoveredIndex,
//     required this.goalWeight,
//     required this.currentWeight,
//     required this.selectedMonth,
//     required this.progress,
//   });

//   // Last day of month
//   int get _lastDay =>
//       DateTime(selectedMonth.year, selectedMonth.month + 1, 0).day;

//   // X range: day 5 = left edge, lastDay = right edge
//   static const int _xStart = 5;

//   // ── coordinate helpers ────────────────────────────────────────────────────
//   double _toX(double day, double chartW) =>
//       kLeft + (day - _xStart) / (_lastDay - _xStart) * chartW;

//   double _toY(double weight, double chartH, int yTop, int yBottom) =>
//       kTop + (weight - yTop) / (yBottom - yTop) * chartH;

//   @override
//   void paint(Canvas canvas, Size size) {
//     if (entries.isEmpty) return;

//     final double chartW = size.width - kLeft - kRight;
//     final double chartH = size.height - kTop - kBottom;

//     // ── Y range: snap goal down to nearest 10, current up to nearest 10 ──────
//     final int yTop = ((goalWeight / 10).floor() * 10);
//     final int yBottom = ((currentWeight / 10).ceil() * 10);

//     // Convenience closures
//     double tx(double day) => _toX(day, chartW);
//     double ty(double weight) => _toY(weight, chartH, yTop, yBottom);

//     // Pre-compute canvas points
//     final List<Offset> pts = entries
//         .map((e) => Offset(tx(e.day.toDouble()), ty(e.weight)))
//         .toList();

//     final tp = TextPainter(textDirection: ui.TextDirection.ltr);
//     final gridPaint = Paint()
//       ..color = const Color(0xFF2E2E2E)
//       ..strokeWidth = 1.0;

//     // ── Y-axis: grid lines + labels every 10 kg ─────────────────────────────
//     // Labels are LEFT-ALIGNED at x=0, just like "Weight Loss" and "Kg/Date"
//     for (int w = yTop; w <= yBottom; w += 10) {
//       final double y = ty(w.toDouble());
//       canvas.drawLine(Offset(kLeft, y), Offset(kLeft + chartW, y), gridPaint);

//       tp.text = TextSpan(
//         text: '$w',
//         style: const TextStyle(color: Color(0xFF666666), fontSize: 10),
//       );
//       tp.layout();
//       // Left-align at x=0 — same left edge as "Weight Loss" title
//       tp.paint(canvas, Offset(0, y - tp.height / 2));
//     }

//     // ── X-axis: ticks at 5, 10, 15 … + smart last day ────────────────────────
//     final List<int> xTicks = [];
//     for (int d = 5; d <= _lastDay; d += 5) xTicks.add(d);

//     if (_lastDay % 5 != 0) {
//       if (xTicks.isNotEmpty &&
//           (tx(_lastDay.toDouble()) - tx(xTicks.last.toDouble())).abs() < 20) {
//         xTicks.removeLast();
//       }
//       xTicks.add(_lastDay);
//     }

//     // ── "Kg/Date" bottom-left label ─────────────────────────────────────────
//     // Measure it first so we can position "5" right after it
//     final kgDateTp = TextPainter(textDirection: ui.TextDirection.ltr)
//       ..text = const TextSpan(
//         text: 'Kg/Date',
//         style: TextStyle(color: Color(0xFF555555), fontSize: 9),
//       )
//       ..layout();

//     // Centre Kg/Date under the Y-axis numbers column
//     final yLabelTp = TextPainter(textDirection: ui.TextDirection.ltr)
//       ..text = TextSpan(
//         text: '$yBottom',
//         style: const TextStyle(color: Color(0xFF666666), fontSize: 10),
//       )
//       ..layout();
//     final double yColW = yLabelTp.width;
//     kgDateTp.paint(
//       canvas,
//       Offset((yColW - kgDateTp.width) / 2 + 4, kTop + chartH + 5),
//     );

//     // ── X-axis ticks — always starts from 5 ──────────────────────────────────
//     for (final int d in xTicks) {
//       tp.text = TextSpan(
//         text: '$d',
//         style: const TextStyle(color: Color(0xFF666666), fontSize: 10),
//       );
//       tp.layout();
//       final double x = tx(d.toDouble());
//       // First tick (5): left-align flush at chart start
//       // Last tick:      right-align
//       // Middle ticks:   centre-align
//       final double labelX = (d == xTicks.first)
//           ? x
//           : (d == xTicks.last)
//           ? x - tp.width
//           : x - tp.width / 2;
//       tp.paint(canvas, Offset(labelX, kTop + chartH + 5));
//     }

//     // ── Smooth line path ──────────────────────────────────────────────────────
//     final Path linePath = _smoothPath(pts);

//     // ── Clip canvas to reveal chart left→right based on progress ─────────────
//     final double revealX = kLeft + chartW * progress;
//     canvas.save();
//     canvas.clipRect(Rect.fromLTRB(0, 0, revealX, size.height));

//     // ── Gradient fill under the line ─────────────────────────────────────────
//     final Path fillPath = Path()
//       ..addPath(linePath, Offset.zero)
//       ..lineTo(pts.last.dx, kTop + chartH)
//       ..lineTo(pts.first.dx, kTop + chartH)
//       ..close();

//     canvas.drawPath(
//       fillPath,
//       Paint()
//         ..shader =
//             ui.Gradient.linear(Offset(0, kTop), Offset(0, kTop + chartH), [
//               AppColors.cb20000.withOpacity(0.40),
//               AppColors.cb20000.withOpacity(0.00),
//             ]),
//     );

//     // ── Line stroke ───────────────────────────────────────────────────────────
//     canvas.drawPath(
//       linePath,
//       Paint()
//         ..color = AppColors.cb20000
//         ..strokeWidth = 2.2
//         ..style = PaintingStyle.stroke
//         ..strokeCap = StrokeCap.round
//         ..strokeJoin = StrokeJoin.round,
//     );

//     canvas.restore(); // remove clip so hover dot/tooltip draw freely

//     // ── Hover indicator ───────────────────────────────────────────────────────
//     if (hoveredIndex != null && hoveredIndex! < pts.length) {
//       final Offset pt = pts[hoveredIndex!];
//       final WeightEntry e = entries[hoveredIndex!];

//       // vertical crosshair
//       canvas.drawLine(
//         Offset(pt.dx, kTop),
//         Offset(pt.dx, kTop + chartH),
//         Paint()
//           ..color = Colors.white.withOpacity(0.25)
//           ..strokeWidth = 1,
//       );

//       // dot
//       canvas.drawCircle(pt, 5, Paint()..color = AppColors.cb20000);
//       canvas.drawCircle(pt, 2.5, Paint()..color = Colors.white);

//       _drawTooltip(canvas, size, pt, e, chartW);
//     }
//   }

//   // ── Tooltip ───────────────────────────────────────────────────────────────
//   void _drawTooltip(
//     Canvas canvas,
//     Size size,
//     Offset pt,
//     WeightEntry e,
//     double chartW,
//   ) {
//     const double w = 128.0, h = 44.0, pad = 8.0;

//     double tx = pt.dx + 10;
//     if (tx + w > kLeft + chartW) tx = pt.dx - w - 10;
//     final double ty = (pt.dy - h / 2).clamp(
//       kTop,
//       kTop + (size.height - kTop - kBottom) - h,
//     );

//     final RRect rr = RRect.fromRectAndRadius(
//       Rect.fromLTWH(tx, ty, w, h),
//       const Radius.circular(8),
//     );

//     canvas.drawRRect(
//       rr,
//       Paint()
//         ..color = Colors.black.withOpacity(0.45)
//         ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 6),
//     );
//     canvas.drawRRect(rr, Paint()..color = const Color(0xFF2C2C2C));

//     final tp = TextPainter(textDirection: ui.TextDirection.ltr);

//     final String wStr = '${e.weight % 1 == 0 ? e.weight.toInt() : e.weight}kg';
//     tp.text = TextSpan(
//       text: 'Current: $wStr',
//       style: const TextStyle(
//         color: Colors.white,
//         fontSize: 11,
//         fontWeight: FontWeight.w500,
//       ),
//     );
//     tp.layout(maxWidth: w - pad * 2);
//     tp.paint(canvas, Offset(tx + pad, ty + pad - 1));

//     final String monthStr =
//         '${_monthNames[selectedMonth.month - 1]} ${selectedMonth.year}';
//     tp.text = TextSpan(
//       text: 'Date: ${e.day} $monthStr',
//       style: const TextStyle(color: Color(0xFF999999), fontSize: 10),
//     );
//     tp.layout(maxWidth: w - pad * 2);
//     tp.paint(canvas, Offset(tx + pad, ty + pad + 15));
//   }

//   // ── Catmull-Rom → cubic Bezier ────────────────────────────────────────────
//   Path _smoothPath(List<Offset> pts) {
//     final Path path = Path();
//     if (pts.isEmpty) return path;
//     if (pts.length == 1) {
//       path.moveTo(pts[0].dx, pts[0].dy);
//       return path;
//     }

//     path.moveTo(pts[0].dx, pts[0].dy);
//     for (int i = 0; i < pts.length - 1; i++) {
//       final Offset p0 = i == 0 ? pts[0] : pts[i - 1];
//       final Offset p1 = pts[i];
//       final Offset p2 = pts[i + 1];
//       final Offset p3 = i + 2 < pts.length ? pts[i + 2] : pts[i + 1];
//       path.cubicTo(
//         p1.dx + (p2.dx - p0.dx) / 6,
//         p1.dy + (p2.dy - p0.dy) / 6,
//         p2.dx - (p3.dx - p1.dx) / 6,
//         p2.dy - (p3.dy - p1.dy) / 6,
//         p2.dx,
//         p2.dy,
//       );
//     }
//     return path;
//   }

//   @override
//   bool shouldRepaint(_ChartPainter old) =>
//       old.hoveredIndex != hoveredIndex ||
//       old.entries != entries ||
//       old.goalWeight != goalWeight ||
//       old.currentWeight != currentWeight ||
//       old.selectedMonth != selectedMonth ||
//       old.progress != progress;
// }

import 'package:bloodfit/gen/colors.gen.dart';
import 'package:flutter/material.dart';
import 'dart:ui' as ui;

// ─────────────────────────────────────────────────────────────────────────────
// Data model
// ─────────────────────────────────────────────────────────────────────────────

class WeightEntry {
  final int day;
  final double weight;
  const WeightEntry(this.day, this.weight);
}

// ─────────────────────────────────────────────────────────────────────────────
// Public widget
// ─────────────────────────────────────────────────────────────────────────────

class WeightHistoryChart extends StatefulWidget {
  final String title;
  final String targetTitle;
  final List<WeightEntry> entries;
  final double goalWeight;
  final double currentWeight;
  final DateTime? initialMonth;
  final void Function(DateTime month)? onMonthChanged;

  const WeightHistoryChart({
    super.key,
    this.title = 'Your Weight History',
    required this.entries,
    required this.goalWeight,
    required this.currentWeight,
    this.initialMonth,
    this.onMonthChanged,
    required this.targetTitle,
  });

  @override
  State<WeightHistoryChart> createState() => _WeightHistoryChartState();
}

class _WeightHistoryChartState extends State<WeightHistoryChart> {
  late DateTime _selectedMonth;
  int? _hoveredIndex;

  static const List<String> _monthNames = [
    'Jan',
    'Feb',
    'Mar',
    'Apr',
    'May',
    'Jun',
    'Jul',
    'Aug',
    'Sep',
    'Oct',
    'Nov',
    'Dec',
  ];

  @override
  void initState() {
    super.initState();
    final DateTime base = widget.initialMonth ?? DateTime.now();
    _selectedMonth = DateTime(base.year, base.month);
  }

  String get _monthLabel =>
      '${_monthNames[_selectedMonth.month - 1]} ${_selectedMonth.year}';

  void _openMonthPicker() {
    showDialog<DateTime>(
      context: context,
      barrierColor: Colors.black54,
      builder: (_) => _MonthYearPickerDialog(current: _selectedMonth),
    ).then((picked) {
      if (picked != null) {
        setState(() {
          _selectedMonth = picked;
          _hoveredIndex = null;
        });
        widget.onMonthChanged?.call(picked);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF1A1A1A),
        borderRadius: BorderRadius.circular(20),
      ),
      padding: const EdgeInsets.fromLTRB(16, 18, 16, 16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Title ──────────────────────────────────────────────────────────
          Text(
            widget.title,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.w600,
              letterSpacing: -0.2,
            ),
          ),
          const SizedBox(height: 12),

          // ── Chart card ────────────────────────────────────────────────────
          Container(
            decoration: BoxDecoration(
              color: const Color(0xFF232323),
              borderRadius: BorderRadius.circular(14),
            ),
            padding: const EdgeInsets.fromLTRB(12, 14, 12, 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Header
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      widget.targetTitle,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    GestureDetector(
                      onTap: _openMonthPicker,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 5,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xFF2E2E2E),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                            color: const Color(0xFF3A3A3A),
                            width: 1,
                          ),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              _monthLabel,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                              ),
                            ),
                            const SizedBox(width: 4),
                            const Icon(
                              Icons.keyboard_arrow_down,
                              color: Colors.white,
                              size: 16,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 10),

                // Chart
                SizedBox(
                  height: 220,
                  child: _ChartArea(
                    entries: widget.entries,
                    hoveredIndex: _hoveredIndex,
                    goalWeight: widget.goalWeight,
                    currentWeight: widget.currentWeight,
                    selectedMonth: _selectedMonth,
                    onHover: (i) => setState(() => _hoveredIndex = i),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Month / Year Picker Dialog
// ─────────────────────────────────────────────────────────────────────────────

class _MonthYearPickerDialog extends StatefulWidget {
  final DateTime current;
  const _MonthYearPickerDialog({required this.current});

  @override
  State<_MonthYearPickerDialog> createState() => _MonthYearPickerDialogState();
}

class _MonthYearPickerDialogState extends State<_MonthYearPickerDialog> {
  late int _year;
  late int _month;

  static const List<String> _months = [
    'Jan',
    'Feb',
    'Mar',
    'Apr',
    'May',
    'Jun',
    'Jul',
    'Aug',
    'Sep',
    'Oct',
    'Nov',
    'Dec',
  ];

  @override
  void initState() {
    super.initState();
    _year = widget.current.year;
    _month = widget.current.month;
  }

  @override
  Widget build(BuildContext context) {
    final DateTime now = DateTime.now();
    final bool isCurrentYear = _year == now.year;
    final bool isFutureYear = _year > now.year;

    // Forward arrow disabled when already on current year
    final bool canGoForward = _year < now.year;

    return Dialog(
      backgroundColor: const Color(0xFF2A2A2A),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // ── Year selector ──────────────────────────────────────────────
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Back arrow — always enabled (no lower bound restriction)
                IconButton(
                  icon: const Icon(Icons.chevron_left, color: Colors.white),
                  onPressed: () => setState(() => _year--),
                ),
                Text(
                  '$_year',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                // Forward arrow — disabled when on current year
                IconButton(
                  icon: Icon(
                    Icons.chevron_right,
                    color: canGoForward
                        ? Colors.white
                        : Colors.white.withOpacity(0.25),
                  ),
                  onPressed: canGoForward
                      ? () => setState(() => _year++)
                      : null,
                ),
              ],
            ),

            const SizedBox(height: 12),

            // ── Month grid ─────────────────────────────────────────────────
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 4,
                mainAxisSpacing: 8,
                crossAxisSpacing: 8,
                childAspectRatio: 1.8,
              ),
              itemCount: 12,
              itemBuilder: (_, i) {
                final int monthNumber = i + 1;
                final bool selected = monthNumber == _month;

                // A month is in the future if:
                //   • the selected year is in the future, OR
                //   • it's the current year but the month hasn't arrived yet
                final bool isFuture =
                    isFutureYear || (isCurrentYear && monthNumber > now.month);

                return GestureDetector(
                  // Only allow tap on past/present months
                  onTap: isFuture
                      ? null
                      : () => setState(() => _month = monthNumber),
                  child: Container(
                    decoration: BoxDecoration(
                      color: selected
                          ? AppColors.cb20000
                          : const Color(0xFF3A3A3A),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      _months[i],
                      style: TextStyle(
                        // Future months are visually dimmed
                        color: isFuture
                            ? Colors.white.withOpacity(0.20)
                            : selected
                            ? Colors.white
                            : const Color(0xFFAAAAAA),
                        fontSize: 13,
                        fontWeight: selected
                            ? FontWeight.w600
                            : FontWeight.w400,
                      ),
                    ),
                  ),
                );
              },
            ),

            const SizedBox(height: 16),

            // ── Confirm button ─────────────────────────────────────────────
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.cb20000,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 12),
                ),
                onPressed: () =>
                    Navigator.of(context).pop(DateTime(_year, _month)),
                child: const Text(
                  'Confirm',
                  style: TextStyle(fontWeight: FontWeight.w600),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Chart area (gesture wrapper + animation controller)
// ─────────────────────────────────────────────────────────────────────────────

class _ChartArea extends StatefulWidget {
  final List<WeightEntry> entries;
  final int? hoveredIndex;
  final double goalWeight;
  final double currentWeight;
  final DateTime selectedMonth;
  final ValueChanged<int?> onHover;

  // Padding shared between gesture handler and painter
  static const double kLeft = 28.0;
  static const double kRight = 10.0;
  static const double kTop = 10.0;
  static const double kBottom = 22.0;

  const _ChartArea({
    required this.entries,
    required this.hoveredIndex,
    required this.goalWeight,
    required this.currentWeight,
    required this.selectedMonth,
    required this.onHover,
  });

  @override
  State<_ChartArea> createState() => _ChartAreaState();
}

class _ChartAreaState extends State<_ChartArea>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _progress;

  // Last day of the selected month
  int get _lastDay => DateTime(
    widget.selectedMonth.year,
    widget.selectedMonth.month + 1,
    0,
  ).day;

  static const int _xStart = 5;
  double _toX(double day, double chartW) =>
      _ChartArea.kLeft + (day - _xStart) / (_lastDay - _xStart) * chartW;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    );
    _progress = CurvedAnimation(parent: _controller, curve: Curves.easeInOut);
    _controller.forward();
  }

  @override
  void didUpdateWidget(_ChartArea old) {
    super.didUpdateWidget(old);
    // Re-animate when entries or month changes
    if (old.entries != widget.entries ||
        old.selectedMonth != widget.selectedMonth) {
      _controller.forward(from: 0);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (d) => _hit(d.localPosition, context, strict: true),
      onHorizontalDragStart: (d) =>
          _hit(d.localPosition, context, strict: false),
      onHorizontalDragUpdate: (d) =>
          _hit(d.localPosition, context, strict: false),
      onHorizontalDragEnd: (_) {},
      child: AnimatedBuilder(
        animation: _progress,
        builder: (_, __) => CustomPaint(
          painter: _ChartPainter(
            entries: widget.entries,
            hoveredIndex: widget.hoveredIndex,
            goalWeight: widget.goalWeight,
            currentWeight: widget.currentWeight,
            selectedMonth: widget.selectedMonth,
            progress: _progress.value,
          ),
          child: const SizedBox.expand(),
        ),
      ),
    );
  }

  /// [strict] = true  → only select if within 32 px (tap)
  /// [strict] = false → always snap to nearest entry (drag)
  void _hit(Offset pos, BuildContext ctx, {required bool strict}) {
    final double chartW =
        (ctx.findRenderObject() as RenderBox).size.width -
        _ChartArea.kLeft -
        _ChartArea.kRight;
    if (widget.entries.isEmpty || chartW <= 0) return;

    int closest = 0;
    double minDist = double.infinity;
    for (int i = 0; i < widget.entries.length; i++) {
      final double dist =
          (pos.dx - _toX(widget.entries[i].day.toDouble(), chartW)).abs();
      if (dist < minDist) {
        minDist = dist;
        closest = i;
      }
    }

    if (strict && minDist > 32) {
      widget.onHover(null);
    } else {
      widget.onHover(closest);
    }
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Painter
// ─────────────────────────────────────────────────────────────────────────────

class _ChartPainter extends CustomPainter {
  final List<WeightEntry> entries;
  final int? hoveredIndex;
  final double goalWeight;
  final double currentWeight;
  final DateTime selectedMonth;
  final double progress; // 0.0 → 1.0 animation progress

  static const double kLeft = _ChartArea.kLeft;
  static const double kRight = _ChartArea.kRight;
  static const double kTop = _ChartArea.kTop;
  static const double kBottom = _ChartArea.kBottom;

  static const List<String> _monthNames = [
    'Jan',
    'Feb',
    'Mar',
    'Apr',
    'May',
    'Jun',
    'Jul',
    'Aug',
    'Sep',
    'Oct',
    'Nov',
    'Dec',
  ];

  const _ChartPainter({
    required this.entries,
    required this.hoveredIndex,
    required this.goalWeight,
    required this.currentWeight,
    required this.selectedMonth,
    required this.progress,
  });

  // Last day of month
  int get _lastDay =>
      DateTime(selectedMonth.year, selectedMonth.month + 1, 0).day;

  // X range: day 5 = left edge, lastDay = right edge
  static const int _xStart = 5;

  // ── coordinate helpers ────────────────────────────────────────────────────
  double _toX(double day, double chartW) =>
      kLeft + (day - _xStart) / (_lastDay - _xStart) * chartW;

  double _toY(double weight, double chartH, int yTop, int yBottom) =>
      kTop + (weight - yTop) / (yBottom - yTop) * chartH;

  @override
  void paint(Canvas canvas, Size size) {
    if (entries.isEmpty) return;

    final double chartW = size.width - kLeft - kRight;
    final double chartH = size.height - kTop - kBottom;

    // ── Y range: snap goal down to nearest 10, current up to nearest 10 ──────
    final int yTop = ((goalWeight / 10).floor() * 10);
    final int yBottom = ((currentWeight / 10).ceil() * 10);

    // Convenience closures
    double tx(double day) => _toX(day, chartW);
    double ty(double weight) => _toY(weight, chartH, yTop, yBottom);

    // Pre-compute canvas points
    final List<Offset> pts = entries
        .map((e) => Offset(tx(e.day.toDouble()), ty(e.weight)))
        .toList();

    final tp = TextPainter(textDirection: ui.TextDirection.ltr);
    final gridPaint = Paint()
      ..color = const Color(0xFF2E2E2E)
      ..strokeWidth = 1.0;

    // ── Y-axis: grid lines + labels every 10 kg ─────────────────────────────
    // Labels are LEFT-ALIGNED at x=0, just like "Weight Loss" and "Kg/Date"
    for (int w = yTop; w <= yBottom; w += 10) {
      final double y = ty(w.toDouble());
      canvas.drawLine(Offset(kLeft, y), Offset(kLeft + chartW, y), gridPaint);

      tp.text = TextSpan(
        text: '$w',
        style: const TextStyle(color: Colors.white, fontSize: 10),
      );
      tp.layout();
      // Left-align at x=0 — same left edge as "Weight Loss" title
      tp.paint(canvas, Offset(0, y - tp.height / 2));
    }

    // ── X-axis: ticks at 5, 10, 15 … + smart last day ────────────────────────
    final List<int> xTicks = [];
    for (int d = 5; d <= _lastDay; d += 5) xTicks.add(d);

    if (_lastDay % 5 != 0) {
      if (xTicks.isNotEmpty &&
          (tx(_lastDay.toDouble()) - tx(xTicks.last.toDouble())).abs() < 20) {
        xTicks.removeLast();
      }
      xTicks.add(_lastDay);
    }

    // ── "Kg/Date" bottom-left label ─────────────────────────────────────────
    // Measure it first so we can position "5" right after it
    final kgDateTp = TextPainter(textDirection: ui.TextDirection.ltr)
      ..text = const TextSpan(
        text: 'Kg/Date',
        style: TextStyle(color: Color(0xFF555555), fontSize: 9),
      )
      ..layout();

    // Centre Kg/Date under the Y-axis numbers column
    final yLabelTp = TextPainter(textDirection: ui.TextDirection.ltr)
      ..text = TextSpan(
        text: '$yBottom',
        style: const TextStyle(color: Color(0xFF666666), fontSize: 10),
      )
      ..layout();
    final double yColW = yLabelTp.width;
    kgDateTp.paint(
      canvas,
      Offset((yColW - kgDateTp.width) / 2 + 4, kTop + chartH + 5),
    );

    // ── X-axis ticks — always starts from 5 ──────────────────────────────────
    for (final int d in xTicks) {
      tp.text = TextSpan(
        text: '$d',
        style: const TextStyle(color: Colors.white, fontSize: 10),
      );
      tp.layout();
      final double x = tx(d.toDouble());
      // First tick (5): left-align flush at chart start
      // Last tick:      right-align
      // Middle ticks:   centre-align
      final double labelX = (d == xTicks.first)
          ? x
          : (d == xTicks.last)
          ? x - tp.width
          : x - tp.width / 2;
      tp.paint(canvas, Offset(labelX, kTop + chartH + 5));
    }

    // ── Smooth line path ──────────────────────────────────────────────────────
    final Path linePath = _smoothPath(pts);

    // ── Clip canvas to reveal chart left→right based on progress ─────────────
    final double revealX = kLeft + chartW * progress;
    canvas.save();
    canvas.clipRect(Rect.fromLTRB(0, 0, revealX, size.height));

    // ── Gradient fill under the line ─────────────────────────────────────────
    final Path fillPath = Path()
      ..addPath(linePath, Offset.zero)
      ..lineTo(pts.last.dx, kTop + chartH)
      ..lineTo(pts.first.dx, kTop + chartH)
      ..close();

    canvas.drawPath(
      fillPath,
      Paint()
        ..shader =
            ui.Gradient.linear(Offset(0, kTop), Offset(0, kTop + chartH), [
              AppColors.cb20000.withOpacity(0.40),
              AppColors.cb20000.withOpacity(0.00),
            ]),
    );

    // ── Line stroke ───────────────────────────────────────────────────────────
    canvas.drawPath(
      linePath,
      Paint()
        ..color = AppColors.cb20000
        ..strokeWidth = 2.2
        ..style = PaintingStyle.stroke
        ..strokeCap = StrokeCap.round
        ..strokeJoin = StrokeJoin.round,
    );

    canvas.restore(); // remove clip so hover dot/tooltip draw freely

    // ── Hover indicator ───────────────────────────────────────────────────────
    if (hoveredIndex != null && hoveredIndex! < pts.length) {
      final Offset pt = pts[hoveredIndex!];
      final WeightEntry e = entries[hoveredIndex!];

      // vertical crosshair
      canvas.drawLine(
        Offset(pt.dx, kTop),
        Offset(pt.dx, kTop + chartH),
        Paint()
          ..color = Colors.white.withOpacity(0.25)
          ..strokeWidth = 1,
      );

      // dot
      canvas.drawCircle(pt, 5, Paint()..color = AppColors.cb20000);
      canvas.drawCircle(pt, 2.5, Paint()..color = Colors.white);

      _drawTooltip(canvas, size, pt, e, chartW);
    }
  }

  // ── Tooltip ───────────────────────────────────────────────────────────────
  void _drawTooltip(
    Canvas canvas,
    Size size,
    Offset pt,
    WeightEntry e,
    double chartW,
  ) {
    const double w = 128.0, h = 44.0, pad = 8.0;

    double tx = pt.dx + 10;
    if (tx + w > kLeft + chartW) tx = pt.dx - w - 10;
    final double ty = (pt.dy - h / 2).clamp(
      kTop,
      kTop + (size.height - kTop - kBottom) - h,
    );

    final RRect rr = RRect.fromRectAndRadius(
      Rect.fromLTWH(tx, ty, w, h),
      const Radius.circular(8),
    );

    canvas.drawRRect(
      rr,
      Paint()
        ..color = Colors.black.withOpacity(0.45)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 6),
    );
    canvas.drawRRect(rr, Paint()..color = const Color(0xFF2C2C2C));

    final tp = TextPainter(textDirection: ui.TextDirection.ltr);

    final String wStr = '${e.weight % 1 == 0 ? e.weight.toInt() : e.weight}kg';
    tp.text = TextSpan(
      text: 'Current: $wStr',
      style: const TextStyle(
        color: Colors.white,
        fontSize: 11,
        fontWeight: FontWeight.w500,
      ),
    );
    tp.layout(maxWidth: w - pad * 2);
    tp.paint(canvas, Offset(tx + pad, ty + pad - 1));

    final String monthStr =
        '${_monthNames[selectedMonth.month - 1]} ${selectedMonth.year}';
    tp.text = TextSpan(
      text: 'Date: ${e.day} $monthStr',
      style: const TextStyle(color: Color(0xFF999999), fontSize: 10),
    );
    tp.layout(maxWidth: w - pad * 2);
    tp.paint(canvas, Offset(tx + pad, ty + pad + 15));
  }

  // ── Catmull-Rom → cubic Bezier ────────────────────────────────────────────
  Path _smoothPath(List<Offset> pts) {
    final Path path = Path();
    if (pts.isEmpty) return path;
    if (pts.length == 1) {
      path.moveTo(pts[0].dx, pts[0].dy);
      return path;
    }

    path.moveTo(pts[0].dx, pts[0].dy);
    for (int i = 0; i < pts.length - 1; i++) {
      final Offset p0 = i == 0 ? pts[0] : pts[i - 1];
      final Offset p1 = pts[i];
      final Offset p2 = pts[i + 1];
      final Offset p3 = i + 2 < pts.length ? pts[i + 2] : pts[i + 1];
      path.cubicTo(
        p1.dx + (p2.dx - p0.dx) / 6,
        p1.dy + (p2.dy - p0.dy) / 6,
        p2.dx - (p3.dx - p1.dx) / 6,
        p2.dy - (p3.dy - p1.dy) / 6,
        p2.dx,
        p2.dy,
      );
    }
    return path;
  }

  @override
  bool shouldRepaint(_ChartPainter old) =>
      old.hoveredIndex != hoveredIndex ||
      old.entries != entries ||
      old.goalWeight != goalWeight ||
      old.currentWeight != currentWeight ||
      old.selectedMonth != selectedMonth ||
      old.progress != progress;
}
