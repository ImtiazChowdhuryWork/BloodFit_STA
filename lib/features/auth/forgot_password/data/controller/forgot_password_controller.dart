import 'package:bloodfit/features/auth/forgot_password/data/repository/forgot_password_repository.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';

class ForgotPasswordController extends GetxController {
  ///------->>> Importing The Repository
  final ForgotPasswordRepository _forgotPasswordRepository;
  ForgotPasswordController(this._forgotPasswordRepository);

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

  @override
  void onClose() {
    accountEmail.dispose();
    super.onClose();
  }
}
