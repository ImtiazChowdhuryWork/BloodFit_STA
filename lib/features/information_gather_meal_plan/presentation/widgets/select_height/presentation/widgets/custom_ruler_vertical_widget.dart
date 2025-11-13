import 'package:bloodfit/constants/text_font_style.dart';
import 'package:bloodfit/gen/assets.gen.dart';
import 'package:bloodfit/gen/colors.gen.dart';
import 'package:bloodfit/helper/ui_helpers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

import '../../../../../../../controllers/select_height_screen_controller.dart';

// Custom Height Ruler Vertical Widget
class CustomHeightRulerVertical extends StatefulWidget {
  final SelectHeightScreenController? controller;
  final int minValue;
  final int maxValue;
  final Color centerIndicatorColor;

  const CustomHeightRulerVertical({
    super.key,
    this.controller,
    this.minValue = 50, // Default min height in cm
    this.maxValue = 250, // Default max height in cm
    this.centerIndicatorColor = Colors.purple,
  });

  @override
  State<CustomHeightRulerVertical> createState() =>
      _CustomHeightRulerVerticalState();
}

class _CustomHeightRulerVerticalState extends State<CustomHeightRulerVertical> {
  late SelectHeightScreenController heightController;

  @override
  void initState() {
    super.initState();
    heightController =
        widget.controller ?? Get.find<SelectHeightScreenController>();

    // Initialize the controller with the passed values
    heightController.initializeRuler(
      minValue: widget.minValue.toDouble(),
      maxValue: widget.maxValue.toDouble(),
      smallDividerValue: 0.5, // 0.5 cm per small divider
      bigDividerInterval: 2, // Every 2 small dividers = 1 cm
    );
  }

  @override
  Widget build(BuildContext context) {
    final double containerHeight = 0.8.sh - 200.h;
    final double centerPadding = (containerHeight / 2) - 12.h;

    return SingleChildScrollView(
      padding: EdgeInsets.all(UIHelper.kDefaulutPadding()),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          // Ruler
          Container(
            height: containerHeight,
            width: 0.3.sw,
            margin: EdgeInsets.symmetric(horizontal: 16.w),
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: AppColors.c363636,
              borderRadius: BorderRadius.circular(8.r),
            ),
            child: Stack(
              clipBehavior: Clip.none,
              alignment: Alignment.centerRight,
              children: [
                // Ruler content - Centered
                Padding(
                  padding: EdgeInsets.all(10.sp),
                  child: ListView.builder(
                    controller: heightController.scrollController,
                    scrollDirection: Axis.vertical,
                    itemCount: heightController.totalItems + 1,
                    physics: const BouncingScrollPhysics(),
                    itemBuilder: (context, index) {
                      if (index == 0) {
                        return SizedBox(height: centerPadding);
                      }
                      final int itemIndex = index - 1;
                      return RulerDividerVertical(
                        itemIndex: itemIndex,
                        controller: heightController,
                      );
                    },
                  ),
                ),

                // Center indicator with glow effect
                Positioned(
                  left: 0,
                  right: 0,
                  top: (containerHeight / 2) - 12.sp,
                  child: Container(
                    height: 3.sp,
                    decoration: BoxDecoration(
                      color: widget.centerIndicatorColor,
                      borderRadius: BorderRadius.circular(2.r),
                      boxShadow: [
                        BoxShadow(
                          color: widget.centerIndicatorColor.withOpacity(0.5),
                          blurRadius: 8.sp,
                          spreadRadius: 2.sp,
                        ),
                      ],
                    ),
                  ),
                ),

                // Arrow pointing towards the ruler
                Positioned(
                  left: -40.w,
                  top: (containerHeight / 2) - 30.sp,
                  child: RotatedBox(
                    quarterTurns: 3,
                    child: SvgPicture.asset(Assets.icons.upperArrowIcon),
                  ),
                ),

                // Selected Value Display
                Obx(
                  () => Positioned(
                    left: -160.w,
                    top: (containerHeight / 2) - 30.sp,
                    child: _buildHeightDisplay(),
                  ),
                ),
              ],
            ),
          ),

          // Number indicators on the left
          Container(
            height: containerHeight,
            padding: EdgeInsets.symmetric(horizontal: 12.w),
            child: Obx(() {
              double currentValue = heightController.centerValue.value;
              return Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  NumberIndicator(value: currentValue + 0.4, isCenter: false),
                  NumberIndicator(value: currentValue + 0.2, isCenter: false),
                  NumberIndicator(value: currentValue, isCenter: true),
                  NumberIndicator(value: currentValue - 0.2, isCenter: false),
                  NumberIndicator(value: currentValue - 0.4, isCenter: false),
                ],
              );
            }),
          ),
        ],
      ),
    );
  }

  // Build the height display based on selected unit
  Widget _buildHeightDisplay() {
    if (heightController.unit.value == "cm") {
      // Format for cm: "170 cm"
      return RichText(
        text: TextSpan(
          children: [
            TextSpan(
              text: heightController.centerValue.value.toStringAsFixed(1),
              style: TextFontStyle.headline22w600cfefefeStylePoppins.copyWith(
                fontWeight: FontWeight.w700,
              ),
            ),
            TextSpan(
              text: " cm",
              style: TextFontStyle.headline22w500cfefefeStylePoppins,
            ),
          ],
        ),
      );
    } else {
      // Format for ft: "6ft 9in"
      final String feetInches = heightController.getFormattedFeetInches();
      return RichText(
        text: TextSpan(
          children: [
            TextSpan(
              text: feetInches,
              style: TextFontStyle.headline22w600cfefefeStylePoppins.copyWith(
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
      );
    }
  }
}

// Ruler Divider Vertical Widget
class RulerDividerVertical extends StatelessWidget {
  final int itemIndex;
  final SelectHeightScreenController controller;

  const RulerDividerVertical({
    super.key,
    required this.itemIndex,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    final bool isBigDivider = controller.isBigDivider(itemIndex);

    return Container(
      width: double.infinity,
      height: 20.h,
      margin: EdgeInsets.symmetric(vertical: 2.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Left spacer
          Expanded(
            child: Container(height: 1.h, color: Colors.transparent),
          ),

          // Main divider line
          Container(
            width: isBigDivider ? 40.w : 25.w,
            height: isBigDivider ? 2.h : 1.h,
            color: Colors.white.withOpacity(isBigDivider ? 1.0 : 0.8),
          ),

          // Right spacer
          Expanded(
            child: Container(height: 1.h, color: Colors.transparent),
          ),
        ],
      ),
    );
  }
}

// Number Indicator Widget
class NumberIndicator extends StatelessWidget {
  final double value;
  final bool isCenter;

  const NumberIndicator({
    super.key,
    required this.value,
    required this.isCenter,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      value.toStringAsFixed(1),
      style: isCenter
          ? TextFontStyle.headline22w500cfefefeStylePoppins
          : TextFontStyle.headline16w500cFFFFFFStylePoppins,
    );
  }
}
