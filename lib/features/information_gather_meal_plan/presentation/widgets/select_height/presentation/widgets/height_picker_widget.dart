import 'package:bloodfit/features/information_gather_meal_plan/presentation/widgets/select_height/presentation/widgets/ruler_middle_divider_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

import '../../../../../../../constants/text_font_style.dart';
import '../../../../../../../controllers/weight_picker_widget_controller.dart';
import '../../../../../../../gen/assets.gen.dart';
import '../../../../../../../gen/colors.gen.dart';
import '../../../../../../../helper/ui_helpers.dart';
import '../../../select_weight/presentation/widgets/number_indicator_widget.dart';

class CustomHeightRuler extends StatefulWidget {
  final WeightController? controller;
  final int minValue;
  final int maxValue;
  final Color centerIndicatorColor;

  const CustomHeightRuler({
    super.key,
    this.controller,
    this.minValue = 1, // Change default minValue to 1
    this.maxValue = 99,
    this.centerIndicatorColor = Colors.purple,
  });

  @override
  State<CustomHeightRuler> createState() => _CustomWeightRulerState();
}

class _CustomWeightRulerState extends State<CustomHeightRuler> {
  late WeightController weightController;

  @override
  void initState() {
    super.initState();
    // Use provided controller or find the default one
    weightController = widget.controller ?? Get.find<WeightController>();

    // Initialize the controller with the passed values
    weightController.initializeRuler(
      minValue: widget.minValue.toDouble(), // This will be at least 1.0
      maxValue: widget.maxValue.toDouble(),
      smallDividerValue: 0.2, // Each small divider = 0.2
      bigDividerInterval: 5, // Every 5 small dividers = 1 big divider (1.0)
    );
  }

  @override
  Widget build(BuildContext context) {
    final double containerWidth = 1.sw - 20.sp;
    final double centerPadding = (containerWidth / 2) - 12.w;

    return SingleChildScrollView(
      padding: EdgeInsets.all(UIHelper.kDefaulutPadding()),
      child: Column(
        children: [
          // Number indicators
          Container(
            width: 1.sw,
            padding: EdgeInsets.symmetric(vertical: 12.h),
            child: Obx(() {
              double currentValue = weightController.centerValue.value;
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
            decoration: BoxDecoration(color: AppColors.c363636),
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                // Ruler content
                Padding(
                  padding: EdgeInsets.all(10.sp),
                  child: ListView.builder(
                    controller: weightController.scrollController,
                    scrollDirection: Axis.horizontal,
                    itemCount: weightController.totalItems + 1,
                    physics: const BouncingScrollPhysics(),
                    itemBuilder: (context, index) {
                      if (index == 0) {
                        return SizedBox(width: centerPadding);
                      }
                      final int itemIndex = index - 1;
                      return RulerDivider(
                        itemIndex: itemIndex,
                        controller: weightController,
                      );
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
                      color: widget.centerIndicatorColor,
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

                ///Section : Selected Value - Make unit reactive
                Obx(
                  () => Positioned(
                    left: (1.sw / 2) - 50.sp,
                    bottom: -100.h,
                    child: RichText(
                      text: TextSpan(
                        children: [
                          TextSpan(
                            text: weightController.centerValue.value
                                .toStringAsFixed(1),
                            style: TextFontStyle
                                .headline36w500cFFFFFFStylePoppins
                                .copyWith(fontWeight: FontWeight.w700),
                          ),
                          TextSpan(
                            text:
                                " ${weightController.unit}", // Use reactive unit from controller
                            style:
                                TextFontStyle.headline22w500cfefefeStylePoppins,
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
    );
  }
}
