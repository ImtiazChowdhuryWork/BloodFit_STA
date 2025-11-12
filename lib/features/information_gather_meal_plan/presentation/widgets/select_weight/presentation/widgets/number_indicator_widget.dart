import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../../../gen/colors.gen.dart';

class NumberIndicator extends StatelessWidget {
  final int value;
  final bool isCenter;

  const NumberIndicator({
    super.key,
    required this.value,
    required this.isCenter,
  });

  @override
  Widget build(BuildContext context) {
    final targetScale = isCenter ? 1.4 : 1.0;
    final targetOpacity = isCenter ? 1.0 : 0.45;
    final baseFontSize = isCenter ? 36.0 : 34.0;

    return AnimatedOpacity(
      duration: const Duration(milliseconds: 120),
      opacity: targetOpacity,
      curve: Curves.easeOut,
      child: AnimatedDefaultTextStyle(
        duration: const Duration(milliseconds: 120),
        style: TextStyle(
          fontSize: (baseFontSize * targetScale).sp,
          fontWeight: FontWeight.w500,
          color: isCenter ? AppColors.cFFFFFF : AppColors.cd7d7d7,
        ),
        child: value < 0
            ? const SizedBox.shrink()
            : Text(value.toString(), textAlign: TextAlign.center),
      ),
    );
  }
}
