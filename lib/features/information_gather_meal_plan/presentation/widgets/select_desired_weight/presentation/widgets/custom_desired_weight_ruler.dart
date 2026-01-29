import 'package:bloodfit/constants/text_font_style.dart';
import 'package:bloodfit/features/information_gather_meal_plan/presentation/widgets/select_desired_weight/presentation/widgets/desired_weight_ruler_divider_widget.dart';
import 'package:bloodfit/features/information_gather_meal_plan/presentation/widgets/select_weight/presentation/widgets/number_indicator_widget.dart';
import 'package:bloodfit/gen/assets.gen.dart';
import 'package:bloodfit/gen/colors.gen.dart';
import 'package:bloodfit/helper/ui_helpers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

import '../../data/controller/ig_select_desired_weight_widget_controller.dart';

class CustomDesiredWeightRuler extends StatefulWidget {
  final IgSelectDesiredWeightWidgetController? controller;
  final int minValue;
  final int maxValue;
  final Color centerIndicatorColor;

  const CustomDesiredWeightRuler({
    super.key,
    this.controller,
    this.minValue = 1, // Change default minValue to 1
    this.maxValue = 99,
    this.centerIndicatorColor = Colors.purple,
  });

  @override
  State<CustomDesiredWeightRuler> createState() =>
      _CustomDesiredWeightRulerState();
}

class _CustomDesiredWeightRulerState extends State<CustomDesiredWeightRuler> {
  late IgSelectDesiredWeightWidgetController desiredWeightController;

  @override
  void initState() {
    super.initState();
    // Use provided controller or find the default one
    desiredWeightController =
        widget.controller ?? Get.find<IgSelectDesiredWeightWidgetController>();

    // Initialize the controller with the passed values
    desiredWeightController.initializeRuler(
      minValue: widget.minValue.toDouble(), // This will be at least 1.0
      maxValue: widget.maxValue.toDouble(),
      smallDividerValue: 0.2, // Each small divider = 0.2
      bigDividerInterval: 5, // Every 5 small dividers = 1 big divider (1.0)
    );
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final double containerWidth = constraints.maxWidth;
        final double centerPadding = (containerWidth / 2) - 12.w;

        // Pass container width to controller
        WidgetsBinding.instance.addPostFrameCallback((_) {
          desiredWeightController.setContainerWidth(containerWidth);
        });

        return SingleChildScrollView(
          padding: EdgeInsets.all(UIHelper.kDefaulutPadding()),
          child: Column(
            children: [
              // Number indicators
              Container(
                width: containerWidth,
                padding: EdgeInsets.symmetric(vertical: 12.h),
                child: Obx(() {
                  double currentValue =
                      desiredWeightController.centerValue.value;
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
                width: containerWidth,
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
                        controller: desiredWeightController.scrollController,
                        scrollDirection: Axis.horizontal,
                        itemCount: desiredWeightController.totalItems + 1,
                        physics: const BouncingScrollPhysics(),
                        itemBuilder: (context, index) {
                          if (index == 0) {
                            return SizedBox(width: centerPadding);
                          }
                          final int itemIndex = index - 1;
                          return DesiredWeightRulerDivider(
                            itemIndex: itemIndex,
                            controller: desiredWeightController,
                          );
                        },
                      ),
                    ),

                    // Center indicator with glow effect
                    Positioned(
                      left: (containerWidth / 2) - 12.sp,
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
                      left: (containerWidth / 2) - 30.sp,
                      bottom: -40.h,
                      child: SvgPicture.asset(Assets.icons.upperArrowIcon),
                    ),

                    ///Section : Selected Value - Make unit reactive
                    Obx(
                      () => Positioned(
                        left: (containerWidth / 2) - 50.sp,
                        bottom: -100.h,
                        child: RichText(
                          text: TextSpan(
                            children: [
                              TextSpan(
                                text: desiredWeightController.centerValue.value
                                    .toStringAsFixed(1),
                                style: TextFontStyle
                                    .headline36w500cFFFFFFStylePoppins
                                    .copyWith(fontWeight: FontWeight.w700),
                              ),
                              TextSpan(
                                text:
                                    " ${desiredWeightController.unit}", // Use reactive unit from controller
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
        );
      },
    );
  }
}
