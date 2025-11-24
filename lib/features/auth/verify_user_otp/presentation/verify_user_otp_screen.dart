import 'dart:developer';

import 'package:bloodfit/features/auth/verify_user_otp/presentation/widgets/pinput_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../../constants/text_font_style.dart';
import '../../../../controllers/verify_user_otp_screen_controller.dart';
import '../../../../custom_widgets/app_logo_widget.dart';
import '../../../../custom_widgets/custom_elevated_button.dart';
import '../../../../gen/colors.gen.dart';
import '../../../../helper/ui_helpers.dart';

class VerifyUserScreen extends StatelessWidget {
  const VerifyUserScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final VerifyUserOtpScreenController controller =
        Get.find<VerifyUserOtpScreenController>();

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
                    onTap: controller.isLoading.value
                        ? null
                        : () {
                            log("Button Tapped -> Verify");
                            controller.verifyOtp();
                          },
                    borderRadius: 24.r,
                    buttonHeight: 52.h,
                    buttonTitle: controller.isLoading.value
                        ? "Verifying..."
                        : "Verify",
                  ),
                ),
                UIHelper.verticalSpace(20.h),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
