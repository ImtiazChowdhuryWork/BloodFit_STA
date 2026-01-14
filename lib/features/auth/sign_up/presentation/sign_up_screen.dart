import 'dart:developer';

import 'package:bloodfit/constants/validator.dart';
import 'package:bloodfit/features/auth/sign_up/data/controller/sign_up_screen_controller.dart';
import 'package:bloodfit/custom_widgets/app_logo_widget.dart';
import 'package:bloodfit/custom_widgets/custom_text_form_field.dart';
import 'package:bloodfit/gen/colors.gen.dart';
import 'package:bloodfit/helper/ui_helpers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../../constants/text_font_style.dart';
import '../../../../custom_widgets/custom_elevated_button.dart';
import '../../../../custom_widgets/error_message.dart';
import '../../../../custom_widgets/social_media_button_widget.dart';
import '../../../../routes/routes.dart';

class SignUpScreen extends StatelessWidget {
  SignUpScreen({super.key});

  final SignUpScreenController controller = Get.find<SignUpScreenController>();
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
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                ///Section : --------------///AppLogo///--------------
                AppLogoWidget(),
                UIHelper.verticalSpace(18.h),

                ///Section : --------------///Text -> Welcome!///--------------
                Text(
                  "Welcome!",
                  style: TextFontStyle.headline24w700cfefefeStylePoppins,
                ),
                UIHelper.verticalSpace(10.h),

                ///Section : --------------///Text -> Create an account to continue.///---------
                Text(
                  "Create An Account To Continue.",
                  style: TextFontStyle.headline16w500cfefefeStylePoppins,
                ),
                UIHelper.verticalSpace(30.h),

                ///Section : Show error message if there is any
                ErrorMessageWidget(
                  errorMessage: controller.errorMessage,
                  onClear: controller.clearErrorMessage,
                ),

                Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      ///Section : --------------///FormField -> First Name///--------------
                      CustomFormField(
                        controller: controller.firstNameController,
                        hintText: "Enter Your First Name",
                        validator: firstNameValidator,
                      ),
                      UIHelper.verticalSpace(24.h),

                      ///Section : --------------///FormField -> Last Name///--------------
                      CustomFormField(
                        controller: controller.lastNameController,
                        hintText: "Enter Your Last Name",
                        validator: lastNameValidator,
                      ),
                      UIHelper.verticalSpace(24.h),

                      ///Section : --------------///FormField -> Email///--------------
                      CustomFormField(
                        controller: controller.emailController,
                        hintText: "Enter Your Email Address",
                        validator: emailValidator,
                      ),
                      UIHelper.verticalSpace(24.h),

                      ///Section : --------------///FormField -> Contact Number///--------------
                      CustomFormField(
                        controller: controller.contactNumberController,
                        hintText: "Enter Your Contact Number",
                        validator: mobileNumberValidator,
                      ),
                      UIHelper.verticalSpace(24.h),

                      ///Section : --------------///FormField -> Password///--------------
                      CustomFormField(
                        controller: controller.passwordController,
                        hintText: "Enter Your Password",
                        isPass: true,
                        suffixIcon: Icon(
                          Icons.visibility_off,
                          color: AppColors.cfefefe,
                        ),
                        validator: passwordValidator,
                      ),
                      UIHelper.verticalSpace(24.h),

                      ///Section : --------------///FormField -> Confirm Password///--------------
                      CustomFormField(
                        controller: controller.confirmPasswordController,
                        isPass: true,

                        hintText: "Confirm Your Password",
                        suffixIcon: Icon(
                          Icons.visibility_off,
                          color: AppColors.cfefefe,
                        ),
                        validator: (value) => confirmPasswordValidator(
                          value,
                          controller.passwordController.text,
                        ),
                      ),
                    ],
                  ),
                ),
                UIHelper.verticalSpace(24.h),

                ///Section : ---------------///Agree to the Terms & Conditions ///----------------------
                ///Section : -----------------///Checkbox///----------------
                Row(
                  children: [
                    ///Section : -----------------///Checkbox///----------------
                    Obx(() {
                      log("Checked Value : ${controller.isChecked.value}");
                      return Checkbox(
                        value: controller.isChecked.value,
                        onChanged: (value) {
                          controller.setCheckBoxValue(newValue: value!);
                        },
                        activeColor: AppColors.cde0000,
                        checkColor: AppColors.cd7d7d7,
                        side: BorderSide(color: AppColors.cd7d7d7),
                      );
                    }),
                    UIHelper.horizontalSpace(4.w),

                    ///Section : -----------------///Text-> Agree to the Terms & Conditions///----------------
                    Text(
                      "Agree To The Terms & Conditions",
                      style: TextFontStyle.headline14w400cd7d7d7StylePoppins,
                    ),
                  ],
                ),

                Obx(() {
                  return (!controller.isChecked.value &&
                          controller.isButtonPressed.value)
                      ? UIHelper.verticalSpace(5.h)
                      : SizedBox.shrink();
                }),
                Obx(() {
                  return (!controller.isChecked.value &&
                          controller.isButtonPressed.value)
                      ? Text(
                          "Please agree to the Terms & Conditions to continue.",
                          style:
                              TextFontStyle.headline14w400cb20000StylePoppins,
                        )
                      : SizedBox.shrink();
                }),
                UIHelper.verticalSpace(30.h),

                ///Section : -----------------///Button -> Signup///----------------
                Obx(
                  () => CustomElevatedButton(
                    onTap: () {
                      log("Button Taped -> Signup");
                      // Set button pressed to true to show error if checkbox not checked
                      controller.isButtonPressed.value = true;

                      // Validate form and call signup
                      if (_formKey.currentState!.validate() &&
                          controller.isChecked.value == true) {
                        controller.postSignUpApi();
                      }
                    },
                    borderRadius: 24.r,
                    buttonHeight: 52.h,
                    buttonTitle: controller.isLoading.value
                        ? "Creating Account..."
                        : "Signup",
                  ),
                ),
                UIHelper.verticalSpace(16.h),

                ///Section : -----------------///Text -> Already Have An Account? ///----------------
                ///Section : -----------------///TextButton -> SignIn///----------------
                RichText(
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text: "Already Have An Account? ",
                        style: TextFontStyle.headline14w400cfefefeStylePoppins,
                      ),
                      WidgetSpan(
                        alignment: PlaceholderAlignment.middle,
                        child: InkWell(
                          onTap: () {
                            log("Button Taped : Login!");
                            Get.toNamed(Routes.signInScreen);
                          },
                          child: Text(
                            "Login",
                            style:
                                TextFontStyle.headline14w400cb20000StylePoppins,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                UIHelper.verticalSpace(24.h),

                ///Section : -----------------///Button : Social Media -> Facebook///----------------
                ///Section : -----------------///Button : Social Media -> Google///----------------
                SocialMediaButtonWidget(
                  title: "or Signup With Social Media",
                  faceBookOnTap: () {
                    log("Social Button Taped : FaceBook");
                  },
                  googleOnTap: () {
                    log("Social Button Taped : Google");
                  },
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
