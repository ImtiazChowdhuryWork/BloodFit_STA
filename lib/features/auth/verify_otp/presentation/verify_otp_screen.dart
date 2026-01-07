import 'dart:developer';

import 'package:bloodfit/features/auth/verify_otp/presentation/widgets/pinput_widget.dart';
import 'package:bloodfit/gen/colors.gen.dart';
import 'package:bloodfit/helper/logger_util.dart';
import 'package:bloodfit/helper/ui_helpers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../../constants/text_font_style.dart';
import '../data/controller/otp_validation_controller.dart';
import '../../../../custom_widgets/app_logo_widget.dart';
import '../../../../custom_widgets/custom_elevated_button.dart';

class VerifyOtpScreen extends StatelessWidget {
  const VerifyOtpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final OtpValidationScreenController controller =
        Get.find<OtpValidationScreenController>();

    final arguments = Get.arguments as Map<String, dynamic>?;
    final email = arguments?['userEmail'] ?? '';

    LoggerUtils.debug("😒😒😒😒😒😒Email Value : $email");

    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.setUserEmailValue(email: email);
    });

    return Scaffold(
      backgroundColor: AppColors.scaffoldBackgroundColor,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: UIHelper.kDefaulutPadding(),
            ),
            child: Column(
              children: [
                /// App Logo
                AppLogoWidget(),
                UIHelper.verticalSpace(0.3.sh),

                /// Title
                Text(
                  "Verify Your Email Address",
                  style: TextFontStyle.headline24w700cfefefeStylePoppins,
                ),
                UIHelper.verticalSpace(8.h),

                /// Description
                Text(
                  "Please Enter Your Verification Code Below To Verify Your Email Address",
                  textAlign: TextAlign.center,
                  style: TextFontStyle.headline16w500cfefefeStylePoppins,
                ),
                UIHelper.verticalSpace(28.h),

                /// OTP Field
                CustomPinInput(),
                UIHelper.verticalSpace(32.h),

                /// Verify Button
                Obx(
                  () => CustomElevatedButton(
                    onTap: () async {
                      log("Button Tapped -> Verify");
                      await controller.postOtpValidationApi();
                    },
                    borderRadius: 24.r,
                    buttonHeight: 52.h,
                    buttonTitle: controller.isLoading.value
                        ? "Verifying..."
                        : "Verify",
                  ),
                ),
                UIHelper.verticalSpace(20.h),

                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Didn't receive code?",
                      style: TextFontStyle.headline14w500cFFFFFFStylePoppins,
                    ),
                    UIHelper.horizontalSpace(5.w),
                    GestureDetector(
                      onTap: () async {
                        await controller.postResendOtpApi();
                      },
                      child: Text(
                        "Resend Code",
                        style: TextFontStyle.headline16w500cb20000StylePoppins,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
