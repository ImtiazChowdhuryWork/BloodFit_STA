import 'package:bloodfit/constants/text_font_style.dart';
import 'package:bloodfit/gen/assets.gen.dart';
import 'package:bloodfit/gen/colors.gen.dart';
import 'package:bloodfit/helper/ui_helpers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

import '../../controllers/weight_picker_widget_controller.dart';
import '../../features/information_gather_meal_plan/presentation/widgets/select_weight/presentation/widgets/number_indicator_widget.dart';

class CustomVerticalRuler extends StatelessWidget {
  final String title;
  final String unit;
  final int minValue;
  final int maxValue;
  final Color centerIndicatorColor;

  const CustomVerticalRuler({
    super.key,
    this.title = "Measurement Ruler",
    this.unit = "Kg",
    this.minValue = 0,
    this.maxValue = 99,
    this.centerIndicatorColor = Colors.purple,
  });

  @override
  Widget build(BuildContext context) {
    final WeightController controller = Get.put(WeightController());
    final double containerWidth = 1.sw - 20.sp;
    final double centerPadding = (containerWidth / 2) - 12.w;

    return Scaffold(
      backgroundColor: AppColors.scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: AppColors.scaffoldBackgroundColor,
        centerTitle: true,
        title: Text(
          title,
          style: TextFontStyle.headline20w500cfefefeStylePoppins,
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(UIHelper.kDefaulutPadding()),
        child: Column(
          children: [
            // Number indicators
            // Number indicators
            Container(
              width: 1.sw,
              padding: EdgeInsets.symmetric(vertical: 12.h),
              child: Obx(() {
                double currentValue = controller.centerValue.value;
                return Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    NumberIndicator(
                      value: currentValue - 0.4, // Pass double directly
                      isCenter: false,
                    ),
                    NumberIndicator(
                      value: currentValue - 0.2, // Pass double directly
                      isCenter: false,
                    ),
                    NumberIndicator(
                      value: currentValue, // Pass double directly
                      isCenter: true,
                    ),
                    NumberIndicator(
                      value: currentValue + 0.2, // Pass double directly
                      isCenter: false,
                    ),
                    NumberIndicator(
                      value: currentValue + 0.4, // Pass double directly
                      isCenter: false,
                    ),
                  ],
                );
              }),
            ),

            // Ruler
            Container(
              width: 1.sw,
              height: 90.h,
              margin: EdgeInsets.symmetric(vertical: 16.h),
              decoration: BoxDecoration(
                color: AppColors.c363636,
                borderRadius: BorderRadius.circular(12.r),
              ),
              child: Stack(
                clipBehavior: Clip.none,
                children: [
                  // Ruler content
                  Padding(
                    padding: EdgeInsets.all(10.sp),
                    child: ListView.builder(
                      controller: controller.scrollController,
                      scrollDirection: Axis.horizontal,
                      itemCount: controller.totalItems + 1,
                      physics: const BouncingScrollPhysics(),
                      itemBuilder: (context, index) {
                        if (index == 0) {
                          return SizedBox(width: centerPadding);
                        }
                        final int itemIndex = index - 1;
                        return _buildDivider(itemIndex, controller);
                      },
                    ),
                  ),

                  // Center indicator with glow effect
                  Positioned(
                    left: (1.sw / 2) - 12.sp,
                    top: 0,
                    bottom: 0,
                    child: Container(
                      width: 3.sp,
                      decoration: BoxDecoration(
                        color: centerIndicatorColor,
                        borderRadius: BorderRadius.circular(2.r),
                      ),
                    ),
                  ),

                  ///Section : Arrow Up
                  Positioned(
                    left: (1.sw / 2) - 30.sp,
                    bottom: -40.h,
                    child: SvgPicture.asset(Assets.icons.upperArrowIcon),
                  ),

                  ///Section : Selected Value
                  Obx(
                    () => Positioned(
                      left: (1.sw / 2) - 50.sp,
                      bottom: -100.h,
                      child: RichText(
                        text: TextSpan(
                          children: [
                            TextSpan(
                              text: controller.centerValue.value.toString(),
                              style: TextFontStyle
                                  .headline36w500cFFFFFFStylePoppins
                                  .copyWith(fontWeight: FontWeight.w700),
                            ),
                            TextSpan(
                              text: " $unit",
                              style: TextFontStyle
                                  .headline22w500cfefefeStylePoppins,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNumberIndicator(int value, bool isCenter) {
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

  Widget _buildDivider(int itemIndex, WeightController controller) {
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
