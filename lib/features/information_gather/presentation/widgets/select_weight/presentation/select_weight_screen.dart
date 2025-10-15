import 'dart:developer';

import 'package:bloodfit/constants/text_font_style.dart';
import 'package:bloodfit/features/information_gather/presentation/widgets/select_weight/presentation/widgets/my_simple_ruller.dart';
import 'package:bloodfit/gen/colors.gen.dart';
import 'package:bloodfit/helper/ui_helpers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../../../../controllers/ruler_controller.dart';
import '../../../../../../controllers/slider_button_controller.dart';
import '../../../../../../custom_widgets/custom_slider_button.dart';

class SelectWeightScreen extends StatelessWidget {
  const SelectWeightScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Existing RulerController
    final rulerController = Get.find<RulerController>();

    // New SliderButtonController
    final sliderController = Get.put(SliderButtonController());
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "What’s Your Weight?",
          style: TextFontStyle.headline22w500cfefefeStylePoppins,
        ),
        UIHelper.verticalSpace(134.h),

        Align(
          alignment: Alignment.center,
          child: SliderButton(
            controller: sliderController,
            items: ["kg", "lb"],
            onValueChanged: (index, value) {
              log("Selected index: $index, value: $value");
            },
          ),
        ),
        UIHelper.verticalSpace(100.h),

        // USAGE EXAMPLE
        SimpleRulerPicker(
          controller: rulerController,
          selectedValueTextSize: 36.sp,
          minValue: 0,
          maxValue: 100,
          initialValue: 10,
          onValueChanged: (value) {
            log("Selected value: $value");
          },
          scaleLabelSize: 20.sp,
          scaleBottomPadding: 20,
          scaleItemWidth: 21,
          longLineHeight: 46,
          shortLineHeight: 24.h,
          lineColor: AppColors.c000000,
          selectedColor: AppColors.cFFFFFF,
          labelColor: AppColors.c000000,
          lineStroke: 3,
          pointerUpwardOffset: 60,
          pointerHeight: 70,
          height: 180.h,
        ),
      ],
    );
  }
}
