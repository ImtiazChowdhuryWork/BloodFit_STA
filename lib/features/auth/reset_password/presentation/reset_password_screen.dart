import 'dart:developer';

import 'package:bloodfit/controllers/reset_password_screen_controller.dart';
import 'package:bloodfit/custom_widgets/custom_text_form_field.dart';
import 'package:bloodfit/gen/colors.gen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

import '../../../../constants/text_font_style.dart';
import '../../../../custom_widgets/app_logo_widget.dart';
import '../../../../custom_widgets/custom_elevated_button.dart';
import '../../../../gen/assets.gen.dart';
import '../../../../helper/ui_helpers.dart';
import '../../../../routes/routes.dart';

class ResetPasswordScreen extends StatelessWidget {
  ResetPasswordScreen({super.key});

  final ResetPasswordScreenController controller =
      Get.find<ResetPasswordScreenController>();
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
                  "Reset Password ",
                  style: TextFontStyle.headline24w700cfefefeStylePoppins,
                ),
                UIHelper.verticalSpace(21.h),

                ///Section : ------------------///Text -> Enter the Email or Phone number associated with your account.///---------------
                Text(
                  "Fill Detail Below To Login.",
                  textAlign: TextAlign.center,
                  style: TextFontStyle.headline16w500cfefefeStylePoppins,
                ),
                UIHelper.verticalSpace(21.h),

                ///Section : -----------------///Form Field -> New Password///-----------------------
                Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      Obx(() {
                        return CustomFormField(
                          controller: controller.newPasswordController,
                          isPass: true,
                          isObsecure: controller.isNewPasswordVisible.value,
                          suffixIcon: GestureDetector(
                            onTap: () {
                              controller.setNewPasswordVisibility();
                            },
                            child: SvgPicture.asset(
                              controller.isNewPasswordVisible.value
                                  ? Assets.icons.pwdNotObsecured
                                  : Assets.icons.pwdObsecured,
                            ),
                          ),
                          hintText: "Enter Your New Password",
                          errorText: controller.validateNewPassword(
                            controller.newPasswordController.text,
                          ),
                        );
                      }),
                      UIHelper.verticalSpace(24.h),

                      ///Section : -----------------///Form Field -> Confirm Password///-----------------------
                      Obx(() {
                        return CustomFormField(
                          controller: controller.confirmPasswordController,
                          isPass: true,
                          isObsecure:
                              controller.isConfirmNewPasswordVisible.value,
                          suffixIcon: GestureDetector(
                            onTap: () {
                              controller.setConfirmNewPasswordVisibility();
                            },
                            child: SvgPicture.asset(
                              controller.isConfirmNewPasswordVisible.value
                                  ? Assets.icons.pwdNotObsecured
                                  : Assets.icons.pwdObsecured,
                            ),
                          ),
                          hintText: "Confirm Your New Password",
                          errorText: controller.validateConfirmPassword(
                            controller.confirmPasswordController.text,
                          ),
                        );
                      }),
                    ],
                  ),
                ),
                UIHelper.verticalSpace(24.h),

                ///Section : -----------------///Button ->Verify///----------------
                Obx(() {
                  return CustomElevatedButton(
                    onTap: controller.isLoading.value
                        ? null
                        : controller.resetNewPassword,
                    borderRadius: 24.r,
                    buttonHeight: 52.h,
                    buttonTitle: controller.isLoading.value
                        ? "Reseting New Password..."
                        : "Reset",
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
