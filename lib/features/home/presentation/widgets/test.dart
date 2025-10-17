import 'package:bloodfit/gen/colors.gen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:simple_circular_progress_bar/simple_circular_progress_bar.dart';

class TestCircleProgress extends StatelessWidget {
  const TestCircleProgress({super.key});

  @override
  Widget build(BuildContext context) {
    return SimpleCircularProgressBar(
      mergeMode: true,
      maxValue: 100,
      fullProgressColor: AppColors.cb20000,
      progressStrokeWidth: 14.w,
      progressColors: [AppColors.cb20000],
      backColor: AppColors.c363636,
    );
  }
}
