import 'package:bloodfit/gen/colors.gen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../../../../../controllers/onboarding_age_picker_screen_controller.dart';

class AgeSelectorWidget extends StatelessWidget {
  final double itemWidth;
  final int minValue;
  final int maxValue;
  final double height;
  final Color textColor;
  final double baseFontSize;
  final double itemSpacing;
  final double dividerGap;

  const AgeSelectorWidget({
    super.key,
    required this.itemWidth,
    required this.minValue,
    required this.maxValue,
    this.height = 120,
    this.textColor = Colors.black,
    this.baseFontSize = 24,
    this.itemSpacing = 0,
    this.dividerGap = 6,
  });

  String _tag() =>
      'age_picker_${minValue}_${maxValue}_${itemWidth.toInt()}_${itemSpacing.toInt()}_${dividerGap.toInt()}';

  @override
  Widget build(BuildContext context) {
    final tag = _tag();

    final controller = Get.isRegistered<IgAgePickerScreenController>(tag: tag)
        ? Get.find<IgAgePickerScreenController>(tag: tag)
        : Get.put(
            IgAgePickerScreenController(
              itemWidth: itemWidth.w,
              itemSpacing: itemSpacing.w,
              minValue: minValue,
              maxValue: maxValue,
            ),
            tag: tag,
          );

    return LayoutBuilder(
      builder: (context, constraints) {
        final containerWidth = constraints.maxWidth;
        final horizontalPadding =
            (containerWidth - (itemWidth.w + itemSpacing.w)) / 2;

        const double arrowSize = 50; // change freely
        const double numberGap = 4; // gap between number and arrow

        return Stack(
          clipBehavior: Clip.none,
          children: [
            /// Container with numbers only
            Container(
              color: AppColors.c3c3c3c,
              width: double.infinity,
              height: height.h,
              alignment: Alignment.center,
              child: Obx(() {
                final scrollOffset = controller.currentScroll.value;

                return ListView.builder(
                  controller: controller.scrollController,
                  scrollDirection: Axis.horizontal,
                  itemCount: controller.numbers.length,
                  padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
                  physics: const BouncingScrollPhysics(),
                  itemBuilder: (context, index) {
                    final isCentered = controller.isIndexCentered(
                      index,
                      scrollOffset,
                      containerWidth,
                    );

                    final targetScale = isCentered ? 1.4 : 1.0;
                    final targetOpacity = isCentered ? 1.0 : 0.45;
                    final number = controller.numbers[index];

                    return Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: itemSpacing.w / 2,
                      ),
                      child: Center(
                        child: AnimatedOpacity(
                          duration: const Duration(milliseconds: 120),
                          opacity: targetOpacity,
                          curve: Curves.easeOut,
                          child: AnimatedDefaultTextStyle(
                            duration: const Duration(milliseconds: 120),
                            style: TextStyle(
                              fontSize: (baseFontSize * targetScale).sp,
                              fontWeight: FontWeight.bold,
                              color: textColor,
                            ),
                            child: SizedBox(
                              width: itemWidth.w,
                              child: Text(
                                '$number',
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                );
              }),
            ),

            /// Left divider (outside container)
            Positioned(
              top: -(height.h * 0.2), // extend above container
              bottom: -(height.h * 0.2), // extend below container
              left:
                  (containerWidth / 2) - (itemWidth.w / 2) - (dividerGap.w / 2),
              child: Container(width: 2.w, color: AppColors.cfefefe),
            ),

            /// Right divider (outside container)
            Positioned(
              top: -(height.h * 0.2),
              bottom: -(height.h * 0.2),
              right:
                  (containerWidth / 2) - (itemWidth.w / 2) - (dividerGap.w / 2),
              child: Container(width: 2.w, color: AppColors.cfefefe),
            ),

            /// Arrow & selected number (outside container)
            Obx(() {
              final scrollOffset = controller.currentScroll.value;
              final selectedIndex = controller.getCenteredIndex(
                scrollOffset,
                containerWidth,
              );
              final selectedNumber = controller.numbers[selectedIndex];

              final dividerCenterX = containerWidth / 2;

              return Positioned(
                bottom: height.h + 20.h,
                left: dividerCenterX - (arrowSize.w / 2), // dynamically center
                child: Column(
                  children: [
                    Text(
                      '$selectedNumber',
                      style: TextStyle(
                        fontSize: baseFontSize.sp,
                        fontWeight: FontWeight.bold,
                        color: AppColors.cFFFFFF,
                      ),
                    ),
                    SizedBox(height: numberGap.h),
                    Icon(
                      Icons.arrow_drop_up_rounded,
                      color: AppColors.cFFFFFF,
                      size: arrowSize.sp,
                    ),
                  ],
                ),
              );
            }),
          ],
        );
      },
    );
  }
}
