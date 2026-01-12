import 'dart:developer';

import 'package:bloodfit/constants/text_font_style.dart';
import 'package:bloodfit/custom_widgets/app_logo_widget.dart';
import 'package:bloodfit/custom_widgets/custom_text_form_field.dart';
import 'package:bloodfit/features/auth/forgot_password/data/controller/forgot_password_controller.dart';
import 'package:bloodfit/gen/colors.gen.dart';
import 'package:bloodfit/helper/ui_helpers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../../custom_widgets/custom_elevated_button.dart';

class ForgotPasswordScreen extends StatelessWidget {
  ForgotPasswordScreen({super.key});

  final ForgotPasswordController forgotPasswordController =
      Get.find<ForgotPasswordController>();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
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
                ///Section : -----------------///AppLogo///-----------------------
                AppLogoWidget(),
                UIHelper.verticalSpace(0.3.sh),

                ///Section : ----------///Text -> Forgot Your Password?///-------------
                Text(
                  "Forgot Your Password?",
                  style: TextFontStyle.headline24w700cfefefeStylePoppins,
                ),
                UIHelper.verticalSpace(8.h),

                ///Section : ------------------///Text -> Enter the Email or Phone number associated with your account.///---------------
                Text(
                  "Enter The Email Or Phone Number Associated With Your Account.",
                  textAlign: TextAlign.center,
                  style: TextFontStyle.headline16w500cfefefeStylePoppins,
                ),
                UIHelper.verticalSpace(28.h),

                ///Section : ----------///FormField -> Email///-------------
                Form(
                  key: _formKey,
                  child: CustomFormField(
                    controller: forgotPasswordController.accountEmail,
                    hintText: "Enter Your Email Address",
                  ),
                ),

                Obx(() {
                  return forgotPasswordController.errorMessage.value.isNotEmpty
                      ? UIHelper.verticalSpace(10.h)
                      : SizedBox.shrink();
                }),

                Align(
                  alignment: Alignment.centerLeft,
                  child: Obx(() {
                    return forgotPasswordController.errorMessage.isNotEmpty
                        ? Text(
                            forgotPasswordController.errorMessage.value,
                            style:
                                TextFontStyle.headline14w400cb20000StylePoppins,
                          )
                        : SizedBox.shrink();
                  }),
                ),
                UIHelper.verticalSpace(28.h),

                ///Section : -----------------///Button -> Get OTP///----------------
                Obx(() {
                  return CustomElevatedButton(
                    onTap: forgotPasswordController.isLoading.value
                        ? null
                        : () async {
                            log("Button Taped -> Get OTP");
                            // Get.toNamed(Routes.verifyOtpScreen);
                            if (_formKey.currentState!.validate()) {
                              await forgotPasswordController
                                  .postForgotPasswordApi();
                            }
                          },
                    borderRadius: 24.r,
                    buttonHeight: 52.h,
                    buttonTitle: forgotPasswordController.isLoading.value
                        ? "Sending OTP..."
                        : "Get OTP",
                  );
                }),
                UIHelper.verticalSpace(20.h),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
