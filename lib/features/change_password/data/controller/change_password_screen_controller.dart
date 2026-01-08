import 'package:bloodfit/constants/app_constant_text.dart';
import 'package:bloodfit/features/change_password/data/repository/change_password_repository.dart';
import 'package:bloodfit/helper/di.dart';
import 'package:bloodfit/helper/logger_util.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../constants/validator.dart';
import '../model/change_password_model.dart';

class ChangePasswordScreenController extends GetxController {
  ///------------>>> Importing Repository
  ChangePasswordRepository _changePasswordRepository;
  ChangePasswordScreenController(this._changePasswordRepository);
  Rxn<ChangePasswordModel> changePasswordModel = Rxn<ChangePasswordModel>();

  ///---------->>> Global Variables
  RxBool isLoading = false.obs;
  RxString errorMessage = ''.obs;
  void clearErrorMessage() {
    errorMessage.value = '';
  }

  TextEditingController oldPasswordController = TextEditingController();
  TextEditingController newPasswordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();

  ///Section : Old Password Visibility
  RxBool isOldPasswordVisible = false.obs;
  void setOldPasswordVisibility() {
    isOldPasswordVisible.value = !isOldPasswordVisible.value;
  }

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
    ///----> Validator : Password
    final oldPasswordError = passwordValidator(
      oldPasswordController.text.trim(),
    );
    if (oldPasswordError != null) return oldPasswordError;

    ///----> Validator : New Password
    final newPasswordError = newPasswordValidator(
      newPasswordController.text.trim(),
    );
    if (newPasswordError != null) return newPasswordError;

    ///----> Validator : Confirm Password
    final confirmPasswordError = confirmPasswordValidator(
      newPasswordController.text.trim(),
      confirmPasswordController.text.trim(),
    );
    if (confirmPasswordError != null) return confirmPasswordError;

    return null;
  }

  Future<void> postChangePasswordApi() async {
    clearErrorMessage();

    final errorValue = validateForm();
    if (errorValue != null) {
      errorMessage.value = errorValue;
      LoggerUtils.error(
        "Form Validation Err Found 😨😨😨😨😨: ${errorMessage.value}",
      );
    }

    isLoading.value = true;
    final response = await _changePasswordRepository.changePasswordRepository(
      oldPass: oldPasswordController.text,
      newPass: newPasswordController.text.trim(),
    );

    if (response.statusCode == 200 && response.isSuccess) {
      LoggerUtils.info("😁😁😁😁Pasword Changed Successfully!");
      LoggerUtils.info(
        "Current Access Token : ${appData.read(kKeyAccessToken)}",
      );

      isLoading.value = false;
      return;
    } else {
      errorMessage.value = response.errorMessage ?? '';
      LoggerUtils.error("Something Went Wrong!");
      LoggerUtils.info(
        "Current Access Token : ${appData.read(kKeyAccessToken)}",
      );
      isLoading.value = false;
    }
  }

  ///Dispose all controllers when controller is removed from the stack
  @override
  void onClose() {
    oldPasswordController.dispose();
    newPasswordController.dispose();
    confirmPasswordController.dispose();
    super.onClose();
  }
}
