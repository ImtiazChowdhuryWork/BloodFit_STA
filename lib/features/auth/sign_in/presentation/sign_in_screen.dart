import 'dart:developer';

import 'package:bloodfit/constants/text_font_style.dart';
import 'package:bloodfit/constants/validator.dart';
import 'package:bloodfit/controllers/sign_in_screen_controller.dart';
import 'package:bloodfit/custom_widgets/custom_elevated_button.dart';
import 'package:bloodfit/custom_widgets/custom_text_form_field.dart';
import 'package:bloodfit/gen/assets.gen.dart';
import 'package:bloodfit/gen/colors.gen.dart';
import 'package:bloodfit/helper/ui_helpers.dart';
import 'package:bloodfit/routes/routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

import '../../../../custom_widgets/app_logo_widget.dart';
import '../../../../custom_widgets/social_media_button_widget.dart';

class SignInScreen extends StatelessWidget {
  SignInScreen({super.key});

  final SignInScreenController controller = Get.find<SignInScreenController>();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: AppColors.scaffoldBackgroundColor,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(UIHelper.kDefaulutPadding()),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                ///Section : ------------------///AppLogo///---------------------
                AppLogoWidget(),
                UIHelper.verticalSpace(0.12.sh),

                ///Section : --------------///Text -> Welcome!///--------------
                Text(
                  "Welcome!",
                  style: TextFontStyle.headline24w700cfefefeStylePoppins,
                ),
                UIHelper.verticalSpace(10.h),

                ///Section : ---------------///Text-> Fill detail below to login.///---------------
                Text(
                  "Fill detail below to login.",
                  style: TextFontStyle.headline16w500cfefefeStylePoppins,
                ),
                UIHelper.verticalSpace(48.h),

                Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      ///Section : -------------///FormField -> Email///--------------------
                      CustomFormField(
                        controller: controller.emailController,
                        validator: emailValidator,
                        hintText: "Enter Your Email Address",
                      ),
                      UIHelper.verticalSpace(24.h),

                      ///Section : -------------///FormField -> Password///--------------------
                      Obx(() {
                        return CustomFormField(
                          controller: controller.passwordController,
                          validator: passwordValidator,
                          isPass: true,
                          isObsecure: controller.isPasswordVisible.value,
                          suffixIcon: InkWell(
                            onTap: () {
                              controller.setPasswordVisibility();
                              log(
                                "Is Password Visible : ${controller.isPasswordVisible}",
                              );
                            },
                            child: SvgPicture.asset(
                              controller.isPasswordVisible.value
                                  ? Assets.icons.pwdNotObsecured
                                  : Assets.icons.pwdObsecured,
                              color: AppColors.cfefefe,
                            ),
                          ),
                          hintText: "Enter Your Password",
                        );
                      }),
                    ],
                  ),
                ),
                UIHelper.verticalSpace(16.h),

                ///Section : -----------------///Checkbox///----------------
                ///Section : -----------------///Text-> Remember Me///----------------
                ///Section : -----------------///TextButton -> ForgotPassword///----------------
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

                    ///Section : -----------------///Text-> Remember Me///----------------
                    Text(
                      "Remember Me",
                      style: TextFontStyle.headline14w400cd7d7d7StylePoppins,
                    ),
                    Spacer(),

                    ///Section : -----------------///TextButton -> ForgotPassword///----------------
                    InkWell(
                      onTap: () {
                        log("ForgotPassword Button Taped!");
                        Get.toNamed(Routes.forgotPasswordScreen);
                      },
                      child: Text(
                        "Forgot Password?",
                        style: TextFontStyle.headline14w400cfefefeStylePoppins,
                      ),
                    ),
                  ],
                ),
                UIHelper.verticalSpace(48.h),

                ///Section : -----------------///Button -> Login///----------------
                CustomElevatedButton(
                  onTap: () {
                    log("Button Taped -> Login");
                    // Get.toNamed(Routes.enterYourDetailsScreen);
                    controller.signIn();
                  },
                  borderRadius: 24.r,
                  buttonHeight: 52.h,
                  buttonTitle: "Login",
                ),
                UIHelper.verticalSpace(16.h),

                ///Section : -----------------///Text -> New User?///----------------
                ///Section : -----------------///TextButton -> SignUp///----------------
                RichText(
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text: "New User? ",
                        style: TextFontStyle.headline14w400cfefefeStylePoppins,
                      ),
                      WidgetSpan(
                        alignment: PlaceholderAlignment.middle,
                        child: InkWell(
                          onTap: () {
                            log("Button Taped : SignUp!");
                            Get.toNamed(Routes.signUpScreen);
                          },
                          child: Text(
                            "Sign up",
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
                  title: "or Login With Social Media",
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
