// import 'package:bloodfit/gen/colors.gen.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:simple_circular_progress_bar/simple_circular_progress_bar.dart';

// class TestCircleProgress extends StatelessWidget {
//   const TestCircleProgress({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return SimpleCircularProgressBar(
//       mergeMode: true,
//       maxValue: 100,
//       fullProgressColor: AppColors.cb20000,
//       progressStrokeWidth: 14.w,
//       progressColors: [AppColors.cb20000],
//       backColor: AppColors.c363636,
//     );
//   }
// }

import 'package:flutter/material.dart';

class CircularProgressContainer extends StatelessWidget {
  final double size;
  final double progress; // 0.0 to 1.0
  final Color progressColor;
  final Color backgroundColor;
  final Widget? child;

  const CircularProgressContainer({
    super.key,
    required this.size,
    required this.progress,
    this.progressColor = Colors.redAccent,
    this.backgroundColor = Colors.grey,
    this.child,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Circular background
          Container(
            width: size,
            height: size,
            decoration: BoxDecoration(
              color: Colors.white, // inner container color
              shape: BoxShape.circle,
            ),
          ),

          // Circular progress ring
          SizedBox(
            width: size,
            height: size,
            child: CircularProgressIndicator(
              value: progress,
              strokeWidth: 4,
              valueColor: AlwaysStoppedAnimation(progressColor),
              backgroundColor: backgroundColor,
            ),
          ),

          // Optional child widget inside the circle
          if (child != null) child!,
        ],
      ),
    );
  }
}
