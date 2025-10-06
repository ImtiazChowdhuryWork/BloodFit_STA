import 'dart:developer';

import 'package:bloodfit/gen/colors.gen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../constants/text_font_style.dart';
import '../../../controllers/change_password_screen_controller.dart';
import '../../../custom_widgets/custom_elevated_button.dart';
import '../../../custom_widgets/custom_text_form_field.dart';
import '../../../custom_widgets/go_back_widget.dart';
import '../../../helper/ui_helpers.dart';

class ChangePasswordScreen extends StatelessWidget {
  ChangePasswordScreen({super.key});

  ChangePasswordScreenController controller =
      Get.find<ChangePasswordScreenController>();

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
          child: Column(
            children: [
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
                    child: Icon(
                      controller.isOldPasswordVisible.value
                          ? Icons.visibility
                          : Icons.visibility_off,
                      color: AppColors.cfefefe,
                    ),
                  ),
                  hintText: "Enter Your Old Password",
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
                    child: Icon(
                      controller.isNewPasswordVisible.value
                          ? Icons.visibility
                          : Icons.visibility_off,
                      color: AppColors.cfefefe,
                    ),
                  ),
                  hintText: "Enter Your New Password",
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
                    child: Icon(
                      controller.isConfirmNewPasswordVisible.value
                          ? Icons.visibility
                          : Icons.visibility_off,
                      color: AppColors.cfefefe,
                    ),
                  ),
                  hintText: "Enter Your New Password",
                );
              }),
              UIHelper.verticalSpace(24.h),

              ///Section : -----------///Button -> Weight///--------------
              Spacer(),
              CustomElevatedButton(
                onTap: () {
                  log("Button -> Save Changes Button Taped!");
                },
                buttonHeight: 52.h,
                borderRadius: 24.r,
                buttonTitle: "Save Changes",
              ),
              UIHelper.verticalSpace(UIHelper.kDefaulutPadding()),
            ],
          ),
        ),
      ),
    );
  }
}
