import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:pinput/pinput.dart';

import '../../../../../constants/text_font_style.dart';
import '../../data/controller/otp_validation_controller.dart';
import '../../../../../gen/colors.gen.dart';
import '../../../../../helper/ui_helpers.dart';

class CustomPinInput extends StatelessWidget {
  CustomPinInput({super.key});

  final OtpValidationScreenController controller =
      Get.find<OtpValidationScreenController>();

  @override
  Widget build(BuildContext context) {
    final defaultPinTheme = PinTheme(
      width: 47.w,
      height: 55.h,
      textStyle: TextFontStyle.headline24w500cfefefeStylePoppins,
      decoration: BoxDecoration(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: AppColors.c363636),
      ),
    );

    final focusedPinTheme = defaultPinTheme.copyDecorationWith(
      border: Border.all(color: AppColors.cb20000),
      borderRadius: BorderRadius.circular(12.r),
    );

    final submittedPinTheme = defaultPinTheme.copyWith(
      decoration: defaultPinTheme.decoration!.copyWith(
        color: Colors.transparent,
      ),
    );

    return Column(
      children: [
        Pinput(
          length: 6,
          defaultPinTheme: defaultPinTheme,
          focusedPinTheme: focusedPinTheme,
          submittedPinTheme: submittedPinTheme,
          validator: controller.validatePin,
          pinputAutovalidateMode: PinputAutovalidateMode.onSubmit,
          showCursor: true,
          cursor: Container(width: 20.w, height: 2.h, color: AppColors.cb20000),
          onCompleted: controller.onCompleted,
        ),

        Obx(() {
          return controller.errorMessage.isNotEmpty
              ? UIHelper.verticalSpace(10.h)
              : SizedBox.shrink();
        }),

        Obx(() {
          return controller.errorMessage.value.isNotEmpty
              ? Text(
                  controller.errorMessage.value,
                  style: TextFontStyle.headline14w400cb20000StylePoppins,
                )
              : SizedBox.shrink();
        }),
        Obx(() {
          return controller.errorMessage.value.isNotEmpty
              ? UIHelper.verticalSpace(22.h)
              : UIHelper.verticalSpace(32.h);
        }),
      ],
    );
  }
}
