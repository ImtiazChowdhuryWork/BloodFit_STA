import 'package:bloodfit/constants/app_constant_text.dart';
import 'package:bloodfit/features/auth/sign_in/data/model/sign_model.dart';
import 'package:bloodfit/features/auth/sign_in/data/repository/sign_in_repository.dart';
import 'package:bloodfit/helper/di.dart';
import 'package:bloodfit/helper/logger_util.dart';
import 'package:bloodfit/routes/routes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../../../../../constants/validator.dart';

class SignInScreenController extends GetxController {
  final SignInRepository _signInRepository;
  SignInScreenController(this._signInRepository);
  final Rxn<SignInModel> signInmodel = Rxn<SignInModel>();

  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  /// Section: password visibility
  RxBool isPasswordVisible = false.obs;
  void setPasswordVisibility() {
    isPasswordVisible.value = !isPasswordVisible.value;
  }

  /// Section: CheckBox
  RxBool isChecked = false.obs;
  void setCheckBoxValue({required bool newValue}) {
    isChecked.value = newValue;
  }

  var isLoading = false.obs;
  var errorMessage = ''.obs;

  /// Form validation using external validators
  String? validateForm() {
    final emailError = emailValidator(emailController.text);
    if (emailError != null) return emailError;

    final passwordError = passwordValidator(passwordController.text);
    if (passwordError != null) return passwordError;

    return null;
  }

  void clearError() {
    errorMessage.value = '';
  }

  ///--------------->>> Sign In Api Method
  Future<void> postSignInApi() async {
    clearError();

    final validationError = validateForm();
    if (validationError != null) {
      errorMessage.value = validationError;
      LoggerUtils.error("Validation Error : ${errorMessage.value}");
      return;
    }

    isLoading.value = true;

    final response = await _signInRepository.signInRepository(
      email: emailController.text.trim(),
      password: passwordController.text,
    );

    isLoading.value = false;

    if (response.statusCode == 200 && response.isSuccess) {
      try {
        signInmodel.value = SignInModel.fromJson(response.jsonResponse!);

        final token = signInmodel.value!.data!.token;
        if (token!.isEmpty) {
          LoggerUtils.error("Token Not Found : $token");
        } else {
          LoggerUtils.info("Token Found : $token");
          emailController.clear();
          passwordController.clear();
          LoggerUtils.info("Controllers Cleared!");
          appData.write(kKeyAccessToken, token);
          appData.write(kKeyUserName, signInmodel.value?.data?.user?.name);
          appData.write(kKeyEmail, signInmodel.value?.data?.user?.email);
          Get.toNamed(Routes.informationGatherMealScreen);
        }
      } catch (e) {
        LoggerUtils.error("Error : Unexpect Response from Server!");
        LoggerUtils.error("Error : $e");
      }
    } else {
      errorMessage.value = response.errorMessage ?? 'Login Failed. Try Again!';
      LoggerUtils.error("Error : ${errorMessage.value}");
    }
  }

  @override
  void onClose() {
    emailController.clear();
    passwordController.clear();
    super.onClose();
  }
}
