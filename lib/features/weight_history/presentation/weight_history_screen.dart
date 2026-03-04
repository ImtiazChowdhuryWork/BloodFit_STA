

// Section : Weight History with fixed left edge fixed on last design
import 'dart:convert';
import 'dart:ui' as ui;

import 'package:bloodfit/constants/app_constant_text.dart';
import 'package:bloodfit/constants/text_font_style.dart';
import 'package:bloodfit/gen/colors.gen.dart';
import 'package:bloodfit/helper/di.dart';
import 'package:bloodfit/helper/ui_helpers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

import '../../../custom_widgets/current_weight_update_widget.dart';
import '../../home/presentation/widgets/app_bar_section_widget.dart';

// ─────────────────────────────────────────────
// MODEL
// ─────────────────────────────────────────────

class WeightEntry {
  final double weight;
  final DateTime date;

  WeightEntry({required this.weight, required this.date});

  factory WeightEntry.fromJson(Map<String, dynamic> json) {
    return WeightEntry(
      weight: (json['weight'] as num).toDouble(),
      date: DateTime.parse(json['date'] as String),
    );
  }
}

// ─────────────────────────────────────────────
// DESIGN TYPE ENUM
// ─────────────────────────────────────────────

enum DesignType {
  start,   // Design 1 - Starting point (RIGHT side)
  middle2, // Design 2 - Middle (LEFT)
  middle3, // Design 3 - Middle (RIGHT)
  middle4, // Design 4 - Middle (LEFT)
  middle5, // Design 5 - Middle (RIGHT)
  end,     // Design 6 - Ending point (side depends on totalEntries even/odd)
}

// ─────────────────────────────────────────────
// WEIGHT TIMELINE INFINITE WIDGET
// ─────────────────────────────────────────────

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

    final totalHeight = _calculateTotalHeight(entries.length);

    return SizedBox(
      height: totalHeight,
      width: double.infinity,
      child: CustomPaint(
        painter: WeightTimelineInfinitePainter(entries: entries),
      ),
    );
  }

  double _calculateTotalHeight(int entryCount) {
    if (entryCount == 0) return 50.0;
    if (entryCount == 1) return 150.0;
    final lastCircleY = 47.5 + (entryCount - 1) * 84.0;
    return lastCircleY + 38.5 + 300.0;
  }
}

// ─────────────────────────────────────────────
// WEIGHT TIMELINE INFINITE PAINTER
// ─────────────────────────────────────────────

class WeightTimelineInfinitePainter extends CustomPainter {
  final List<WeightEntry> entries;

  static const circleColor = Color(0xFFB20000);
  static const pathColor   = Color(0xFFB20000);
  static const textColor   = Color(0xFFFFFFFF);
  static const dateColor   = Color(0xFF999999);

  static const double entrySpacing = 84.0;
  static const double firstCircleY = 47.5;

  WeightTimelineInfinitePainter({required this.entries});

  /// Returns true when the last entry falls on a LEFT-side position.
  /// Even total count → last index is ODD → LEFT side.
  bool _isEndOnLeft(int totalEntries) => (totalEntries - 1).isOdd;

  @override
  void paint(ui.Canvas canvas, ui.Size size) {
    const originalWidth  = 290.0;
    const originalHeight = 520.0;

    final scaleX = size.width / originalWidth;
    final scaleY = size.height / originalHeight;
    final scale  = scaleX < scaleY ? scaleX : scaleY;

    final offsetX = (size.width  - (originalWidth  * scale)) / 2;
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

    // Starting dot
    canvas.drawCircle(const ui.Offset(15, 0), 6.0, smallCirclePaint);

    // Path 1: start dot → first circle
    if (totalEntries > 0) {
      final path1 = ui.Path();
      path1.moveTo(15, 0);
      path1.cubicTo(17.9729, 0, 20.4388, 2.16245, 20.915, 5);
      path1.lineTo(232, 5);
      path1.cubicTo(255.748, 5, 275, 24.2518, 275, 48);
      path1.cubicTo(275, 71.7482, 255.748, 91, 232, 91);
      path1.lineTo(157, 91);
      canvas.drawPath(path1, pathPaint);
      canvas.drawCircle(const ui.Offset(157, 91), 6.0, smallCirclePaint);
    }

    for (int i = 0; i < totalEntries; i++) {
      final entry      = entries[i];
      final designType = _getDesignType(i, totalEntries);
      final circleY    = firstCircleY + i * entrySpacing;

      _drawDesignComponent(
        canvas, designType, circleY, entry, totalEntries,
        circlePaint, pathPaint, smallCirclePaint, i > 0,
      );
    }

    canvas.restore();
  }

  DesignType _getDesignType(int entryIndex, int totalEntries) {
    if (entryIndex == 0) return DesignType.start;
    if (entryIndex == totalEntries - 1) return DesignType.end;
    final middleIndex = (entryIndex - 1) % 4;
    return DesignType.values[middleIndex + 1];
  }

  void _drawDesignComponent(
    ui.Canvas canvas,
    DesignType designType,
    double circleY,
    WeightEntry entry,
    int totalEntries,
    ui.Paint circlePaint,
    ui.Paint pathPaint,
    ui.Paint smallCirclePaint,
    bool hasPrevious,
  ) {
    final circleX      = _getCircleX(designType, totalEntries);
    const circleRadius = 38.5;

    canvas.drawCircle(ui.Offset(circleX, circleY), circleRadius, circlePaint);

    if (hasPrevious) {
      _drawPath(canvas, designType, circleY, totalEntries, pathPaint);
    }

    _drawSmallCircles(
        canvas, designType, circleY, totalEntries, smallCirclePaint, hasPrevious);
    _drawText(canvas, entry, circleX, circleY, circleRadius);
  }

  // ── Circle X position ──────────────────────────────────────────────────────

  double _getCircleX(DesignType designType, int totalEntries) {
    switch (designType) {
      case DesignType.start:   return 244.5;
      case DesignType.middle2: return 43.5;
      case DesignType.middle3: return 244.5;
      case DesignType.middle4: return 38.5;
      case DesignType.middle5: return 239.5;
      case DesignType.end:
        return _isEndOnLeft(totalEntries) ? 38.5 : 239.5;
    }
  }

  // ── Connecting paths ───────────────────────────────────────────────────────

  void _drawPath(
    ui.Canvas canvas,
    DesignType designType,
    double circleY,
    int totalEntries,
    ui.Paint paint,
  ) {
    final path        = ui.Path();
    final entryIndex  = (circleY - firstCircleY) / entrySpacing;
    final prevCircleY = firstCircleY + (entryIndex - 1) * entrySpacing;

    DesignType prevDesignType;
    if (entryIndex == 1) {
      prevDesignType = DesignType.start;
    } else {
      final prevMiddleIndex = ((entryIndex - 2) % 4).toInt();
      prevDesignType = DesignType.values[prevMiddleIndex + 1];
    }

    switch (designType) {
      case DesignType.start:
        break;

      case DesignType.middle2:
        if (prevDesignType == DesignType.start) {
          path.moveTo(157, 91);
          path.lineTo(58, 91);
          path.cubicTo(35.3563, 91, 17, 109.356, 17, 132);
          path.cubicTo(17, 154.644, 35.3563, 173, 58, 173);
          path.lineTo(133, 173);
        } else {
          final pathBaseY = circleY - 84;
          path.moveTo(128, pathBaseY + 42);
          path.lineTo(53, pathBaseY + 42);
          path.cubicTo(30.3563, pathBaseY + 42, 12, pathBaseY + 60.356, 12, pathBaseY + 83);
          path.cubicTo(12, pathBaseY + 105.644, 30.3563, pathBaseY + 124, 53, pathBaseY + 124);
          path.lineTo(128, pathBaseY + 124);
        }
        break;

      case DesignType.middle3:
        path.moveTo(157, prevCircleY + 42);
        path.lineTo(232, prevCircleY + 42);
        path.cubicTo(255.748, prevCircleY + 42, 275, prevCircleY + 61.252, 275, prevCircleY + 85);
        path.cubicTo(275, prevCircleY + 108.377, 256.345, prevCircleY + 127.398, 233.109, prevCircleY + 127.986);
        path.lineTo(232, prevCircleY + 128);
        path.lineTo(157, prevCircleY + 128);
        break;

      case DesignType.middle4:
        path.moveTo(128, prevCircleY + 42);
        path.lineTo(53, prevCircleY + 42);
        path.cubicTo(30.3563, prevCircleY + 42, 12, prevCircleY + 60.356, 12, prevCircleY + 83);
        path.cubicTo(12, prevCircleY + 105.644, 30.3563, prevCircleY + 124, 53, prevCircleY + 124);
        path.lineTo(128, prevCircleY + 124);
        break;

      case DesignType.middle5:
        path.moveTo(152, prevCircleY + 42);
        path.lineTo(227, prevCircleY + 42);
        path.cubicTo(250.748, prevCircleY + 42, 270, prevCircleY + 61.252, 270, prevCircleY + 85);
        path.cubicTo(270, prevCircleY + 108.377, 251.345, prevCircleY + 127.398, 228.109, prevCircleY + 127.986);
        path.lineTo(227, prevCircleY + 128);
        path.lineTo(152, prevCircleY + 128);
        break;

      case DesignType.end:
        if (_isEndOnLeft(totalEntries)) {
          // ── EVEN total: end circle on LEFT ────────────────────────────────
          // Comes from a RIGHT-side circle. Curves LEFT around it, then the
          // bottom exit flows smoothly rightward to x=270.
          //
          // The second cubic already exits travelling RIGHT (tangent points
          // right), so we simply lineTo(270) — no sharp corner.
          path.moveTo(128, prevCircleY + 42);   // left connector of prev RIGHT circle
          path.lineTo(53, prevCircleY + 42);    // horizontal run to left edge
          path.cubicTo(                         // top-left curve
            30.3563, prevCircleY + 42,
            12,      prevCircleY + 60.356,
            12,      prevCircleY + 83,
          );
          path.cubicTo(                         // bottom-left curve → exits travelling RIGHT
            12,      prevCircleY + 105.644,
            30.3563, prevCircleY + 124,
            53,      prevCircleY + 124,
          );
          // Continue straight right — tangent is already horizontal here,
          // so no kink at the join.
          path.lineTo(270, prevCircleY + 124);  // smooth rightward extension
        } else {
          // ── ODD total: end circle on RIGHT ────────────────────────────────
          // Original behaviour — unchanged.
          path.moveTo(152, prevCircleY + 42);
          path.lineTo(227, prevCircleY + 42);
          path.cubicTo(250.748, prevCircleY + 42, 270, prevCircleY + 61.252, 270, prevCircleY + 85);
          path.cubicTo(270, prevCircleY + 108.377, 251.345, prevCircleY + 127.398, 228.109, prevCircleY + 127.986);
          path.lineTo(227, prevCircleY + 128);
          path.lineTo(152, prevCircleY + 128);
          path.lineTo(15, prevCircleY + 128);
        }
        break;
    }

    canvas.drawPath(path, paint);
  }

  // ── Small connector dots ───────────────────────────────────────────────────

  void _drawSmallCircles(
    ui.Canvas canvas,
    DesignType designType,
    double circleY,
    int totalEntries,
    ui.Paint paint,
    bool hasPrevious,
  ) {
    final entryIndex  = (circleY - firstCircleY) / entrySpacing;
    final prevCircleY = firstCircleY + (entryIndex - 1) * entrySpacing;

    DesignType prevDesignType;
    if (entryIndex == 1) {
      prevDesignType = DesignType.start;
    } else {
      final prevMiddleIndex = ((entryIndex - 2) % 4).toInt();
      prevDesignType = DesignType.values[prevMiddleIndex + 1];
    }

    switch (designType) {
      case DesignType.start:
        break;

      case DesignType.middle2:
        if (prevDesignType == DesignType.start) {
          canvas.drawCircle(const ui.Offset(157, 91),  6.0, paint);
          canvas.drawCircle(const ui.Offset(133, 173), 6.0, paint);
        } else {
          final pathBaseY = circleY - 84;
          canvas.drawCircle(ui.Offset(128, pathBaseY + 42),  6.0, paint);
          canvas.drawCircle(ui.Offset(128, pathBaseY + 124), 6.0, paint);
        }
        break;

      case DesignType.middle3:
        canvas.drawCircle(ui.Offset(157, prevCircleY + 42),  6.0, paint);
        canvas.drawCircle(ui.Offset(157, prevCircleY + 128), 6.0, paint);
        break;

      case DesignType.middle4:
        canvas.drawCircle(ui.Offset(128, prevCircleY + 42),  6.0, paint);
        canvas.drawCircle(ui.Offset(128, prevCircleY + 124), 6.0, paint);
        break;

      case DesignType.middle5:
        canvas.drawCircle(ui.Offset(152, prevCircleY + 42),  6.0, paint);
        canvas.drawCircle(ui.Offset(152, prevCircleY + 128), 6.0, paint);
        break;

      case DesignType.end:
        if (_isEndOnLeft(totalEntries)) {
          // EVEN: start dot at left-connector of prev RIGHT circle,
          // end dot at the right terminus of the smooth bottom line.
          canvas.drawCircle(ui.Offset(128, prevCircleY + 42),  6.0, paint);
          canvas.drawCircle(ui.Offset(270, prevCircleY + 124), 6.0, paint);
        } else {
          // ODD: original
          canvas.drawCircle(ui.Offset(152, prevCircleY + 42),  6.0, paint);
          canvas.drawCircle(ui.Offset(15,  prevCircleY + 128), 6.0, paint);
        }
        break;
    }
  }

  // ── Weight & date labels ───────────────────────────────────────────────────

  void _drawText(
    ui.Canvas canvas,
    WeightEntry entry,
    double cx,
    double cy,
    double r,
  ) {
    final weightTextPainter = TextPainter(
      text: TextSpan(
        text: '${entry.weight.toStringAsFixed(1)}kg',
        style: const TextStyle(
          color: textColor,
          fontSize: 14,
          fontWeight: FontWeight.w600,
          fontFamily: 'Poppins',
        ),
      ),
      textDirection: ui.TextDirection.ltr,
    )..layout();

    final dateTextPainter = TextPainter(
      text: TextSpan(
        text: DateFormat('dd MMM yyyy').format(entry.date),
        style: const TextStyle(
          color: dateColor,
          fontSize: 12,
          fontWeight: FontWeight.w400,
          fontFamily: 'Poppins',
        ),
      ),
      textDirection: ui.TextDirection.ltr,
    )..layout();

    if (cx > 150) {
      weightTextPainter.paint(
          canvas, ui.Offset(cx - r - weightTextPainter.width - 12, cy - 18));
      dateTextPainter.paint(
          canvas, ui.Offset(cx - r - dateTextPainter.width - 12, cy + 3));
    } else {
      weightTextPainter.paint(canvas, ui.Offset(cx + r + 12, cy - 18));
      dateTextPainter.paint(canvas, ui.Offset(cx + r + 12, cy + 3));
    }
  }

  @override
  bool shouldRepaint(covariant WeightTimelineInfinitePainter oldDelegate) =>
      oldDelegate.entries != entries;
}

// ─────────────────────────────────────────────
// API SERVICE
// ─────────────────────────────────────────────

class WeightHistoryApiService {
  static const String _endpoint =
      'https://faisal5000.merinasib.shop/api/v1/health/weight-history';

  static Future<List<WeightEntry>> fetchWeightHistory({
    String? authToken,
  }) async {
    final headers = <String, String>{
      'Content-Type': 'application/json',
      if (authToken != null && authToken.isNotEmpty)
        'Authorization': 'Bearer $authToken',
    };

    final response = await http
        .get(Uri.parse(_endpoint), headers: headers)
        .timeout(const Duration(seconds: 15));

    if (response.statusCode == 200) {
      final Map<String, dynamic> body =
          jsonDecode(response.body) as Map<String, dynamic>;

      if (body['success'] == true) {
        final List<dynamic> data = body['data'] as List<dynamic>;
        return data
            .map((e) => WeightEntry.fromJson(e as Map<String, dynamic>))
            .toList();
      }
      throw Exception(body['message'] ?? 'API returned success: false');
    } else {
      throw Exception('HTTP ${response.statusCode}: Unable to fetch data');
    }
  }
}

// ─────────────────────────────────────────────
// WEIGHT HISTORY SCREEN
// ─────────────────────────────────────────────

class WeightHistoryScreen extends StatefulWidget {
  final String? authToken;

  const WeightHistoryScreen({super.key, this.authToken});

  @override
  State<WeightHistoryScreen> createState() => _WeightHistoryScreenState();
}

class _WeightHistoryScreenState extends State<WeightHistoryScreen> {
  List<WeightEntry> _weightEntries = [];
  bool _isLoading = true;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _loadWeightHistory();
  }

  Future<void> _loadWeightHistory() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final entries = await WeightHistoryApiService.fetchWeightHistory(
        authToken: appData.read(kKeyAccessToken),
      );
      setState(() {
        _weightEntries = entries;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _errorMessage = e.toString();
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldBackgroundColor,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(UIHelper.kDefaulutPadding()),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AppBarSectionWidget(),
              UIHelper.verticalSpace(20.h),
              CurrentWeightUpdateWidget(),
              UIHelper.verticalSpace(24.h),
              Text(
                "Your Transformation Timeline",
                style: TextFontStyle.headline20w500cfefefeStylePoppins,
              ),
              UIHelper.verticalSpace(16.h),
              if (_isLoading)
                const Center(child: CircularProgressIndicator())
              else if (_errorMessage != null)
                _buildErrorState()
              else
                WeightTimelineInfinite(
                  entries: _weightEntries,
                  onRefresh: _loadWeightHistory,
                ),
              // UIHelper.verticalSpace(650.h),
              UIHelper.spacerFromBottomNav,
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildErrorState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.wifi_off_rounded, size: 64.h, color: AppColors.c999999),
          UIHelper.verticalSpace(16.h),
          Text(
            'Failed to load weight history',
            style: TextFontStyle.headline16w500c999999StylePoppins,
          ),
          UIHelper.verticalSpace(8.h),
          Text(
            _errorMessage ?? 'Unknown error',
            style: TextFontStyle.headline14w400c999999StylePoppins,
            textAlign: TextAlign.center,
          ),
          UIHelper.verticalSpace(24.h),
          ElevatedButton.icon(
            onPressed: _loadWeightHistory,
            icon: const Icon(Icons.refresh),
            label: const Text('Try Again'),
          ),
        ],
      ),
    );
  }
}