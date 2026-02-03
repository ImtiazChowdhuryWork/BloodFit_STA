import 'dart:developer';

import 'package:bloodfit/constants/validator.dart';
import 'package:bloodfit/gen/colors.gen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

import '../../../constants/text_font_style.dart';
import '../../../custom_widgets/error_message.dart';
import '../data/controller/change_password_screen_controller.dart';
import '../../../custom_widgets/custom_elevated_button.dart';
import '../../../custom_widgets/custom_text_form_field.dart';
import '../../../custom_widgets/go_back_widget.dart';
import '../../../gen/assets.gen.dart';
import '../../../helper/ui_helpers.dart';

class ChangePasswordScreen extends StatelessWidget {
  ChangePasswordScreen({super.key});

  ChangePasswordScreenController controller =
      Get.find<ChangePasswordScreenController>();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: AppColors.scaffoldBackgroundColor,
        centerTitle: true,
        automaticallyImplyLeading: false,
        leading: CustomBackButton(),
        title: Text(
          "Change Password",
          style: TextFontStyle.headline24w700cFFFFFFStylePoppins,
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(UIHelper.kDefaulutPadding()),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                ///Section : Show error message if there is any
                Obx(() {
                  if (controller.errorMessage.value.isNotEmpty) {
                    return Container(
                      width: double.infinity,
                      padding: EdgeInsets.all(12.r),
                      margin: EdgeInsets.only(bottom: 16.h),
                      decoration: BoxDecoration(
                        color: Colors.red.withOpacity(0.1),
                        border: Border.all(color: AppColors.cb20000),
                        borderRadius: BorderRadius.circular(8.r),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            Icons.error,
                            color: AppColors.cb20000,
                            size: 18.sp,
                          ),
                          SizedBox(width: 8.w),
                          Expanded(
                            child: Text(
                              controller.errorMessage.value,
                              style: TextStyle(
                                color: Colors.red,
                                fontSize: 14.sp,
                              ),
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              controller.clearErrorMessage();
                            },

                            child: Icon(
                              Icons.cancel,
                              color: Colors.red,
                              size: 18.sp,
                            ),
                          ),
                        ],
                      ),
                    );
                  }
                  return SizedBox.shrink(); // Return empty widget if no error
                }),

                ///Section : -----------------///Form Field -> OLD Password///-----------------------
                Obx(() {
                  return CustomFormField(
                    controller: controller.oldPasswordController,
                    isPass: true,
                    isObsecure: controller.isOldPasswordVisible.value,
                    suffixIcon: InkWell(
                      onTap: () {
                        controller.setOldPasswordVisibility();
                      },
                      child: SvgPicture.asset(
                        controller.isOldPasswordVisible.value
                            ? Assets.icons.pwdNotObsecured
                            : Assets.icons.pwdObsecured,
                      ),
                    ),
                    hintText: "Enter Your Old Password",
                    validator: passwordValidator,
                  );
                }),
                UIHelper.verticalSpace(24.h),

                ///Section : -----------------///Form Field -> New Password///-----------------------
                Obx(() {
                  return CustomFormField(
                    controller: controller.newPasswordController,
                    isPass: true,
                    isObsecure: controller.isNewPasswordVisible.value,
                    suffixIcon: InkWell(
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
                    validator: newPasswordValidator,
                  );
                }),
                UIHelper.verticalSpace(24.h),

                ///Section : -----------------///Form Field -> Confirm Password///-----------------------
                Obx(() {
                  return CustomFormField(
                    controller: controller.confirmPasswordController,
                    isPass: true,
                    isObsecure: controller.isConfirmNewPasswordVisible.value,
                    suffixIcon: InkWell(
                      onTap: () {
                        controller.setConfirmNewPasswordVisibility();
                      },
                      child: SvgPicture.asset(
                        controller.isConfirmNewPasswordVisible.value
                            ? Assets.icons.pwdNotObsecured
                            : Assets.icons.pwdObsecured,
                      ),
                    ),
                    hintText: "Enter Your Confirm Password",
                    validator: (value) => confirmPasswordValidator(
                      value,
                      controller.newPasswordController.text,
                    ),
                  );
                }),
                UIHelper.verticalSpace(24.h),

                ///Section : Show error message if there is any
                ErrorMessageWidget(
                  errorMessage: controller.errorMessage,
                  onClear: controller.clearErrorMessage,
                ),

                ///Section : -----------///Button -> Weight///--------------
                Spacer(),
                Obx(() {
                  return CustomElevatedButton(
                    onTap: controller.isLoading.value
                        ? null
                        : () async {
                            if (_formKey.currentState!.validate()) {
                              log("Button -> Save Changes Button Taped!");
                              await controller.postChangePasswordApi();
                              _formKey.currentState?.reset();
                            }
                          },
                    isLoading: controller.isLoading.value,
                    buttonHeight: 52.h,
                    borderRadius: 24.r,
                    buttonColor: controller.isLoading.value
                        ? Colors.grey
                        : AppColors.cb20000,
                    buttonTitle: controller.isLoading.value
                        ? "Changing Password..."
                        : "Save Changes",
                  );
                }),
                UIHelper.verticalSpace(UIHelper.kDefaulutPadding()),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
