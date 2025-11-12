import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../../../controllers/weight_picker_widget_controller.dart';
import '../../../../../../../gen/colors.gen.dart';

class RulerDivider extends StatelessWidget {
  final int itemIndex;
  final WeightController controller;

  const RulerDivider({
    super.key,
    required this.itemIndex,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    final bool isBigDivider = itemIndex % controller.bigDividerInterval == 0;

    return Container(
      margin: EdgeInsets.only(right: controller.computedItemSpacing),
      child: Align(
        alignment: Alignment.center,
        child: Container(
          color: AppColors.c111111,
          width: controller.computedItemWidth,
          height: isBigDivider ? 50.h : 24.h,
        ),
      ),
    );
  }
}
