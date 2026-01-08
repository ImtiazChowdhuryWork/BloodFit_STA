import 'package:bloodfit/constants/app_constant_text.dart';
import 'package:bloodfit/features/auth/forgot_password/data/model/forgot_password_model.dart';
import 'package:bloodfit/features/auth/forgot_password/data/repository/forgot_password_repository.dart';
import 'package:bloodfit/helper/di.dart';
import 'package:bloodfit/helper/logger_util.dart';
import 'package:bloodfit/routes/routes.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';

class ForgotPasswordController extends GetxController {
  ///------->>> Importing The Repository
  final ForgotPasswordRepository _forgotPasswordRepository;

  ForgotPasswordController(this._forgotPasswordRepository);
  final Rxn<ForgotPasswordModel> forgotPasswordModel =
      Rxn<ForgotPasswordModel>();

  TextEditingController accountEmail = TextEditingController();

  // Reactive States
  RxBool isLoading = false.obs;
  var errorMessage = ''.obs;

  // Validation method
  String? validateEmail() {
    if (accountEmail.text.isEmpty) {
      return "Please enter your email";
    }
    if (!GetUtils.isEmail(accountEmail.text)) {
      return "Please enter a valid email";
    }
    return null;
  }

  ///------------->>> Clear Error Message
  void clearErrorMessage() {
    errorMessage.value = '';
  }

  ///--------------->>> Api Method Starts Here

  Future<void> postForgotPasswordApi() async {
    ///----------->>> Clear Initial Error Message
    clearErrorMessage();

    ///----------->>> Giving Email Check
    final errorValue = validateEmail();
    if (errorValue != null) {
      errorMessage.value = errorValue;
    }

    ///----------->>> Calling The Repository
    isLoading.value = true;

    final response = await _forgotPasswordRepository.forgotPasswordRepository(
      email: accountEmail.text.trim(),
    );

    isLoading.value = false;

    ///----------->>> Checking The Response Status
    if (response.statusCode == 200 && response.isSuccess) {
      try {
        forgotPasswordModel.value = ForgotPasswordModel.fromJson(
          response.jsonResponse!,
        );
        final token = forgotPasswordModel.value!.data!.token;
        // Clear any existing sign-up token before setting forgot password token
        appData.remove(kKeySignUpToken);
        appData.write(kKeyForgotPasswordToken, token);
        Get.toNamed(
          Routes.verifyOtpScreen,
          arguments: {'userEmail': accountEmail.text.trim()},
        );
      } catch (e) {
        errorMessage.value = response.errorMessage ?? '';
        LoggerUtils.error(
          "Api Response Error 🤯🤯🤯🤯🤯🤯🤯🤯🤯: ${errorMessage.value}",
        );
        LoggerUtils.error(
          "Forgot Password Api : 🥸🥸🥸🥸🥸Something Went Wrong at the api response!",
        );
      }
    } else {
      errorMessage.value = response.errorMessage ?? '';
      LoggerUtils.error(
        "Api Response Error 🤯🤯🤯🤯🤯🤯🤯🤯🤯: ${errorMessage.value}",
      );
      LoggerUtils.error(
        'Error 🧐🧐🧐🧐 : Forgot Password Api failed to parse!',
      );
    }
  }

  ///------------->>> Api Method Ends Here

  @override
  void onClose() {
    accountEmail.dispose();
    super.onClose();
  }
}
