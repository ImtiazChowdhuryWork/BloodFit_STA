import 'dart:developer';

import 'package:bloodfit/features/information_gather_meal_plan/presentation/widgets/select_height/presentation/widgets/custom_ruler_vertical_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../../../../constants/text_font_style.dart';
import '../../../../../../controllers/select_height_screen_controller.dart';
import '../../../../../../controllers/slider_button_controller.dart';
import '../../../../../../custom_widgets/custom_slider_button.dart';
import '../../../../../../gen/colors.gen.dart';
import '../../../../../../helper/ui_helpers.dart';

class SelectHeightScreenWidget extends StatelessWidget {
  const SelectHeightScreenWidget({super.key});

  @override
  Widget build(BuildContext context) {
    /// Controllers - use DIFFERENT tags for height screen
    final heightController = Get.find<SelectHeightScreenController>();
    final heightTypeSliderButtonController = Get.find<SliderButtonController>(
      tag: 'current_height_unit',
    );

    // Initialize the slider button controller with items
    heightTypeSliderButtonController.initialize(["cm", "ft"]);

    return Scaffold(
      backgroundColor: AppColors.scaffoldBackgroundColor,
      body: SafeArea(
        child: Column(
          children: [
            Text(
              "What's Your Height?",
              style: TextFontStyle.headline22w500cfefefeStylePoppins,
            ),
            UIHelper.verticalSpace(50.h),

            /// --- UNIT SELECTOR (cm / ft) ---
            Align(
              alignment: Alignment.center,
              child: SliderButton(
                controller: heightTypeSliderButtonController,
                items: const ["cm", "ft"],
                onValueChanged: (index, value) {
                  log("Selected unit: $value");
                  heightController.isLbSelected.value = (value == "ft");
                  heightController.changeUnit(
                    value,
                  ); // Also update the unit in height controller
                },
              ),
            ),
            UIHelper.verticalSpace(20.h),

            /// --- HEIGHT PICKER SLIDER ---
            CustomHeightRulerVertical(
              controller: heightController,
              minValue: 50, // Adjusted for height range
              maxValue: 250,
              centerIndicatorColor: Colors.blue,
            ),
          ],
        ),
      ),
    );
  }
}
