import 'dart:developer';

import 'package:bloodfit/helper/advanced_custom_toast_message.dart';
import 'package:bloodfit/helper/loading_helper.dart';
import 'package:bloodfit/networks/exception_handler/data_source.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';

import '../routes/routes.dart';

class ForgotPasswordController extends GetxController {
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
