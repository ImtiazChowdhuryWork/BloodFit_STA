import 'dart:developer';

import 'package:bloodfit/constants/app_constant_text.dart';
import 'package:bloodfit/features/auth/reset_password/data/model/reset_password_model.dart';
import 'package:bloodfit/features/auth/reset_password/data/repository/reset_password_repository.dart';
import 'package:bloodfit/helper/di.dart';
import 'package:bloodfit/helper/logger_util.dart';
import 'package:bloodfit/routes/routes.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

import '../../../../../constants/validator.dart';

class ResetPasswordScreenController extends GetxController {
  ///----------->>> Importing Repository and Model
  final ResetPasswordRepository _resetPasswordRepository;
  Rxn<ResetPasswordModel> resetPasswordModel = Rxn<ResetPasswordModel>();
  ResetPasswordScreenController(this._resetPasswordRepository);
  // late String otpToken;

  ///------------->>> Global Variables for Use
  RxBool isLoading = false.obs;
  var errorMessage = ''.obs;
  void clearErrorMessage() {
    errorMessage.value = '';
  }

  TextEditingController newPasswordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();

  ///Section : New Password Visibility
  RxBool isNewPasswordVisible = false.obs;
  void setNewPasswordVisibility() {
    isNewPasswordVisible.value = !isNewPasswordVisible.value;
  }

  ///Section : Confirm New Password Visibility
  RxBool isConfirmNewPasswordVisible = false.obs;
  void setConfirmNewPasswordVisibility() {
    isConfirmNewPasswordVisible.value = !isConfirmNewPasswordVisible.value;
  }

  /// Form validation using external validators
  String? validateForm() {
    ///----> Validator : New Password
    final passwordError = passwordValidator(newPasswordController.text.trim());
    if (passwordError != null) return passwordError;

    ///----> Validator : Confirm Password
    final confirmPassword = confirmPasswordValidator(
      newPasswordController.text.trim(),
      confirmPasswordController.text.trim(),
    );
    if (confirmPassword != null) return confirmPassword;

    return null;
  }

  ///---------------------->>> Reset Password Api Method Starts Here

  Future<void> postResetPasswordApi() async {
    ///----------->>> Clearing Initial Message
    clearErrorMessage();

    ///----------->>> Validating Form
    final validationError = validateForm();
    if (validationError != null) {
      errorMessage.value = validationError;
      LoggerUtils.error("Validation Error : ${errorMessage.value}");
      return;
    }

    ///----------->>> Calling the repository
    isLoading.value = true;
    final response = await _resetPasswordRepository.resetPasswordRepository(
      password: newPasswordController.text.trim(),
    );

    isLoading.value = false;

    ///------------->>> Checking the Response Status
    if (response.statusCode == 200 && response.isSuccess) {
      if (appData.read(kKeyForgotPasswordToken) != null) {
        LoggerUtils.debug(
          "😷😷😷😷😷😷😷😷😷Forgot Password Token Found : ${appData.read(kKeyForgotPasswordToken)}",
        );
        appData.remove(kKeyForgotPasswordToken);
        LoggerUtils.debug("🥺🥺🥺🥺🥺Forgot Password Token Removed!");
        LoggerUtils.debug(
          "Forgot Password Token : ${appData.read(kKeyForgotPasswordToken)}",
        );
        Get.offAllNamed(Routes.signInScreen);
        return;
      }
    } else {
      LoggerUtils.error(
        "😵‍💫😵‍💫😵‍💫😵‍💫😵‍💫Reset Password Error : ${errorMessage.value = response.errorMessage ?? ''}",
      );
      LoggerUtils.error("🤯🤯🤯🤯🤯🤯Failed to change password!");
      LoggerUtils.error(
        "🙄🙄🙄🙄🙄🙄🙄Forgot Password Token : ${appData.read(kKeyForgotPasswordToken)}",
      );
      return;
    }
  }

  ///---------------------->>> Reset Password Api Method Ends Here

  @override
  void onClose() {
    newPasswordController.dispose();
    confirmPasswordController.dispose();
    super.onClose();
  }
}
