import 'package:bloodfit/constants/validator.dart';
import 'package:bloodfit/features/auth/reset_password/data/controller/reset_password_screen_controller.dart';
import 'package:bloodfit/custom_widgets/custom_text_form_field.dart';
import 'package:bloodfit/gen/colors.gen.dart';
import 'package:bloodfit/helper/logger_util.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

import '../../../../constants/text_font_style.dart';
import '../../../../custom_widgets/app_logo_widget.dart';
import '../../../../custom_widgets/custom_elevated_button.dart';
import '../../../../custom_widgets/error_message.dart';
import '../../../../gen/assets.gen.dart';
import '../../../../helper/ui_helpers.dart';

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
                          validator: passwordValidator,
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
                          validator: (value) => confirmPasswordValidator(
                            value,
                            controller.newPasswordController.text,
                          ),
                        );
                      }),
                    ],
                  ),
                ),
                UIHelper.verticalSpace(24.h),

                ///Section : Show error message if there is any
                ErrorMessageWidget(
                  errorMessage: controller.errorMessage,
                  onClear: controller.clearErrorMessage,
                ),

                ///Section : Show error message if token is missing
                Obx(() {
                  if (controller.errorMessage.value.isNotEmpty) {
                    return CustomElevatedButton(
                      onTap: () {
                        // Navigate back to previous screen
                        Get.back();
                      },
                      borderRadius: 24.r,
                      buttonHeight: 52.h,
                      buttonTitle: "Go Back",
                      buttonColor: Colors.grey,
                    );
                  }
                  return CustomElevatedButton(
                    onTap: controller.isLoading.value
                        ? null
                        : () async {
                            if (_formKey.currentState!.validate()) {
                              LoggerUtils.info("Reset Password Button Taped!");
                              await controller.postResetPasswordApi();
                            }
                          },
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
