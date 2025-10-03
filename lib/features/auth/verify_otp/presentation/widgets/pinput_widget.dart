import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pinput/pinput.dart';
import 'package:get/get.dart';

import '../../../../../constants/text_font_style.dart';
import '../../../../../controllers/otp_validation_controller.dart';
import '../../../../../gen/colors.gen.dart';
import '../../../../../helper/ui_helpers.dart';

class CustomPinInput extends StatelessWidget {
  final VerifyOtpScreenController controller =
      Get.find<VerifyOtpScreenController>();

  CustomPinInput({super.key});

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
        UIHelper.verticalSpace(32.h),

        // Obx(() {

        //   return controller.isOtpExpired.value
        //       ? RichText(
        //           text: TextSpan(
        //             children: [
        //               TextSpan(
        //                 text: "Didn’t receive code? ",
        //                 style: TextFontStyle.headline14w500c606060StyleSatoshi,
        //               ),
        //               WidgetSpan(
        //                 alignment: PlaceholderAlignment.middle,
        //                 child: InkWell(
        //                   onTap: () {
        //                     log("Resend Code Taped!");
        //                   },
        //                   child: Text(
        //                     "Resend Code",
        //                     style: TextFontStyle
        //                         .headline14w500c000000StyleSatoshi
        //                         .copyWith(color: AppColors.cea464a),
        //                   ),
        //                 ),
        //               ),
        //             ],
        //           ),
        //         )
        //       : Row(
        //           mainAxisAlignment: MainAxisAlignment.center,
        //           children: [
        //             Icon(Icons.access_time_rounded),
        //             UIHelper.horizontalSpace(10.w),

        //             ///OTP Expires section
        //             Text(
        //               '00:${seconds.toString().padLeft(2, '0')}',
        //               style: TextFontStyle.headline16w500c000000StyleSatoshi,
        //             ),
        //           ],
        //         );
        // }),
      ],
    );
  }
}
