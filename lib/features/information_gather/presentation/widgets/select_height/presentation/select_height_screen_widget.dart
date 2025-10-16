import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../../../../constants/text_font_style.dart';
import '../../../../../../controllers/ruler_controller.dart';
import '../../../../../../controllers/slider_button_controller.dart';
import '../../../../../../custom_widgets/custom_slider_button.dart';
import '../../../../../../custom_widgets/my_simple_ruller.dart';
import '../../../../../../gen/colors.gen.dart';
import '../../../../../../helper/ui_helpers.dart';

class SelectHeightScreenWidget extends StatelessWidget {
  const SelectHeightScreenWidget({super.key});

  @override
  Widget build(BuildContext context) {
    // Existing RulerController
    final rulerController = Get.find<RulerController>();

    // New SliderButtonController
    final heightTypeController = Get.put(SliderButtonController());

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "What’s Your Height?",
          style: TextFontStyle.headline22w500cfefefeStylePoppins,
        ),
        UIHelper.verticalSpace(100.h),

        Align(
          alignment: Alignment.center,
          child: SliderButton(
            controller: heightTypeController,
            items: ["cm", "ft"],
            onValueChanged: (index, value) {
              log("Selected index: $index, value: $value");
            },
          ),
        ),
        UIHelper.verticalSpace(50.h),

        // USAGE EXAMPLE
        Obx(() {
          return SimpleRulerPicker(
            controller: rulerController,
            dataType: heightTypeController.selectedValue.value,
            axis: Axis.vertical,
            selectedValueTextSize: 36.sp,
            minValue: 100,
            maxValue: 500,
            initialValue: 110,
            onValueChanged: (value) {
              log("Selected value: $value");
            },
            numberPadding: 80,
            containerToSelectedValuePadding: 40,
            scaleLabelSize: 20.sp,
            scaleBottomPadding: 200,
            scaleItemWidth: 21,
            longLineHeight: 46,
            shortLineHeight: 24.h,
            lineColor: AppColors.c000000,
            selectedColor: AppColors.cFFFFFF,
            labelColor: AppColors.c000000,
            lineStroke: 3,
            pointerUpwardOffset: 60,
            height: 430.h,
          );
        }),
      ],
    );
  }
}
