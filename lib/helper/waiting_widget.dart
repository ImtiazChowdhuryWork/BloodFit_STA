import 'package:bloodfit/helper/loading_indicators.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../gen/assets.gen.dart';

class WaitingWidget extends StatelessWidget {
  const WaitingWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: shimmer(name: Assets.lottie.waiting, size: 220.sp),
    );
  }
}
