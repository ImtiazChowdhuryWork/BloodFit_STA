import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../gen/colors.gen.dart';

class ProgressIndicatorWithMarkers extends StatelessWidget {
  final double progress; // e.g., 0.7
  final double indicatorHeight; // height of the progress bar
  final double markerRadius; // radius of each circular marker

  const ProgressIndicatorWithMarkers({
    Key? key,
    required this.progress,
    this.indicatorHeight = 8.0,
    this.markerRadius = 6.0,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final double totalWidth = constraints.maxWidth;
        final double markerDiameter = markerRadius * 2;
        // Center vertically: (indicatorHeight - markerDiameter)/2
        final double topOffset = (indicatorHeight - markerDiameter) / 2;

        return Stack(
          clipBehavior: Clip.none,
          children: [
            // The progress bar with exact height
            SizedBox(
              height: indicatorHeight,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10.r),
                child: LinearProgressIndicator(
                  value: progress,
                  backgroundColor: AppColors.c999999,
                  color: AppColors.cb20000,
                  semanticsLabel: "Tesdfadsfsadt",
                ),
              ),
            ),
            // Start marker (left)
            Positioned(
              left: 0,
              top: topOffset,
              child: Container(
                width: markerDiameter,
                height: markerDiameter,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.cb20000,
                  border: Border.all(color: AppColors.cb20000, width: 2),
                ),
              ),
            ),
            // Current progress marker
            Positioned(
              left: (totalWidth - markerDiameter) * progress,
              top: topOffset,
              child: Container(
                width: markerDiameter,
                height: markerDiameter,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.cb20000,
                  border: Border.all(color: AppColors.cb20000, width: 2),
                ),
              ),
            ),
            // Goal marker (right)
            Positioned(
              left: totalWidth - markerDiameter,
              top: topOffset,
              child: Container(
                width: markerDiameter,
                height: markerDiameter,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.c999999,
                  border: Border.all(color: AppColors.c999999, width: 2),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}