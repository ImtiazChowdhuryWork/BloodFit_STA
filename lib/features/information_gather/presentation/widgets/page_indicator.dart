import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../../controllers/information_gather_screen_controller.dart';
import '../../../../gen/colors.gen.dart';

/// A custom page indicator widget that shows dots and updates with the current page.
class PageIndicator extends StatelessWidget {
  final InformationGatherController controller;
  final double activeWidth;
  final double inactiveWidth;
  final double height;
  final double spacing;

  const PageIndicator({
    super.key,
    required this.controller,
    this.activeWidth = 20,
    this.inactiveWidth = 8,
    this.height = 8,
    this.spacing = 3,
  });

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return Padding(
        padding: EdgeInsets.only(bottom: 40.h),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(controller.totalPages, (index) {
            final isActive = controller.currentIndex.value == index;
            return AnimatedContainer(
              duration: const Duration(milliseconds: 250),
              margin: EdgeInsets.symmetric(horizontal: spacing.w),
              width: isActive ? activeWidth.w : inactiveWidth.w,
              height: height.h,
              decoration: BoxDecoration(
                color: isActive
                    ? AppColors.cb20000
                    : AppColors.cFFFFFF.withOpacity(0.3),
                borderRadius: BorderRadius.circular(height / 2),
              ),
            );
          }),
        ),
      );
    });
  }
}
