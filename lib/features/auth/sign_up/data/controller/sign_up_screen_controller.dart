import 'dart:developer';

import 'package:bloodfit/constants/validator.dart';
import 'package:bloodfit/features/auth/sign_up/data/model/sign_up_model.dart';
import 'package:bloodfit/features/auth/sign_up/data/repository/sign_up_repository.dart';
import 'package:bloodfit/networks/network_caller.dart';
import 'package:bloodfit/routes/routes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../../helper/logger_util.dart';

class SignUpScreenController extends GetxController {
  SignUpRepository _signUpRepository;
  SignUpScreenController(this._signUpRepository);
  Rxn<SignUpModel> signUpModel = Rxn<SignUpModel>();

  // Text Editing Controllers
  TextEditingController firstNameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController contactNumberController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();

  // Reactive States
  RxBool isChecked = false.obs;
  RxBool isLoading = false.obs;
  RxBool isButtonPressed = false.obs; // Track if sign-up button has been pressed
  var errorMessage = ''.obs;
  void clearErrorMessage() {
    errorMessage.value = '';
  }

  void setCheckBoxValue({required bool newValue}) {
    isChecked.value = newValue;
    // If checkbox is now checked, reset the button pressed state to hide the error message
    if (newValue) {
      isButtonPressed.value = false;
    }
  }

  /// Form validation using external validators
  String? validateForm() {
    ///----> Validator : First Name
    final firstNameError = firstNameValidator(firstNameController.text);
    if (firstNameError != null) return firstNameError;

    ///----> Validator : Last Name
    final lastNameError = lastNameValidator(lastNameController.text);
    if (lastNameError != null) return lastNameError;

    ///----> Validator : Email
    final emailError = emailValidator(emailController.text.trim());
    if (emailError != null) return emailError;

    ///----> Validator : Mobile Number
    final mobileNumberError = mobileNumberValidator(
      contactNumberController.text.trim(),
    );
    if (mobileNumberError != null) return mobileNumberError;

    ///----> Validator : Password
    final passwordError = passwordValidator(passwordController.text.trim());
    if (passwordError != null) return passwordError;

    ///----> Validator : Confirm Password
    final confirmPassword = confirmPasswordValidator(
      passwordController.text.trim(),
      confirmPasswordController.text.trim(),
    );
    if (confirmPassword != null) return confirmPassword;

    if (isChecked.value != true)
      return 'Please agree to the Terms & Conditions to continue.';

    return null;
  }

  Future<void> postSignUpApi() async {
    clearErrorMessage();

    final validationError = validateForm();
    if (validationError != null) {
      errorMessage.value = validationError;
      LoggerUtils.error("Validation Error : ${errorMessage.value}");
      return;
    }

    isLoading.value = true;

    final response = await _signUpRepository.signUpRepository(
      firstName: firstNameController.text,
      lastName: lastNameController.text,
      email: emailController.text.trim(),
      phoneNumber: contactNumberController.text.trim(),
      password: passwordController.text.trim(),
    );

    isLoading.value = false;

    if (response.statusCode == 200 && response.isSuccess) {
      try {
        signUpModel.value = SignUpModel.fromJson(response.jsonResponse!);
        if (signUpModel.value!.success == true &&
            signUpModel.value!.data!.token!.isNotEmpty == true) {
          LoggerUtils.info("Sign Up Successful!");

          ///----------->>> Clear the controllers
          firstNameController.clear();
          lastNameController.clear();
          emailController.clear();
          contactNumberController.clear();
          passwordController.clear();
          confirmPasswordController.clear();
          isButtonPressed.value = false; // Reset button pressed state after successful signup

          Get.toNamed(Routes.signInScreen);
        } else {
          LoggerUtils.error("Failed to Sign-Up!");
        }
      } catch (e) {
        LoggerUtils.error("Error : Unexpect Response from Server!");
        LoggerUtils.error("Error : $e");
      }
    } else {
      errorMessage.value = response.errorMessage ?? 'Signup Failed. Try Again!';
      LoggerUtils.error("Error : ${errorMessage.value}");
    }
  }

  @override
  void onClose() {
    // Clean up controllers
    firstNameController.dispose();
    lastNameController.dispose();
    emailController.dispose();
    contactNumberController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.onClose();
  }
}
