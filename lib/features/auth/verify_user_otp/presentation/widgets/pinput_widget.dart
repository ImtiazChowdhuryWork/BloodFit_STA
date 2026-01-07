// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:get/get.dart';
// import 'package:pinput/pinput.dart';

// import '../../../../../constants/text_font_style.dart';

// import '../../../../../controllers/verify_user_otp_screen_controller.dart';
// import '../../../../../gen/colors.gen.dart';
// import '../../../../../helper/ui_helpers.dart';

// class CustomPinInput extends StatelessWidget {
//   CustomPinInput({super.key});

//   final VerifyUserOtpScreenController controller =
//       Get.find<VerifyUserOtpScreenController>();

//   @override
//   Widget build(BuildContext context) {
//     final defaultPinTheme = PinTheme(
//       width: 47.w,
//       height: 55.h,
//       textStyle: TextFontStyle.headline24w500cfefefeStylePoppins,
//       decoration: BoxDecoration(
//         color: Colors.transparent,
//         borderRadius: BorderRadius.circular(12.r),
//         border: Border.all(color: AppColors.c363636),
//       ),
//     );

//     final focusedPinTheme = defaultPinTheme.copyDecorationWith(
//       border: Border.all(color: AppColors.cb20000),
//       borderRadius: BorderRadius.circular(12.r),
//     );

//     final submittedPinTheme = defaultPinTheme.copyWith(
//       decoration: defaultPinTheme.decoration!.copyWith(
//         color: Colors.transparent,
//       ),
//     );

//     return Column(
//       children: [
//         Pinput(
//           length: 6,
//           defaultPinTheme: defaultPinTheme,
//           focusedPinTheme: focusedPinTheme,
//           submittedPinTheme: submittedPinTheme,
//           validator: controller.validatePin,
//           pinputAutovalidateMode: PinputAutovalidateMode.onSubmit,
//           showCursor: true,
//           cursor: Container(width: 20.w, height: 2.h, color: AppColors.cb20000),
//           onCompleted: controller.onCompleted,
//         ),
//         UIHelper.verticalSpace(32.h),
//       ],
//     );
//   }
// }
