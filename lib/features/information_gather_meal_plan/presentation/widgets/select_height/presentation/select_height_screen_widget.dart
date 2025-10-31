import 'dart:developer';

import 'package:bloodfit/gen/colors.gen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../../../../constants/text_font_style.dart';
import '../../../../../../controllers/ruler_controller.dart';
import '../../../../../../controllers/slider_button_controller.dart';
import '../../../../../../custom_widgets/custom_slider_button.dart';
import '../../../../../../helper/ui_helpers.dart';

class SelectHeightScreenWidget extends StatelessWidget {
  SelectHeightScreenWidget({super.key});

  // Instantiate your RulerController
  final RulerController rulerController = Get.put(RulerController());

  // New SliderButtonController
  final heightTypeController = Get.put(SliderButtonController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldBackgroundColor,

      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text(
              "What’s Your Height?",
              style: TextFontStyle.headline22w500cfefefeStylePoppins,
            ),
            UIHelper.verticalSpace(50.h),

            Align(
              alignment: Alignment.center,
              child: SliderButton(
                controller: heightTypeController,
                items: ["cm", "ft"],
                onValueChanged: (index, value) {
                  log("Selected index: $index, value: $value");
                  // Update the unit in the ruler picker controller
                  // The ruler picker will automatically reflect the unit change
                },
              ),
            ),
            UIHelper.verticalSpace(50.h),
          ],
        ),
      ),
    );
  }
}
