import 'dart:developer';

import 'package:bloodfit/constants/app_constant_text.dart';
import 'package:bloodfit/features/auth/verify_otp/data/model/verify_otp_model.dart';
import 'package:bloodfit/features/auth/verify_otp/data/repository/resend_otp_repository.dart';
import 'package:bloodfit/features/auth/verify_otp/data/repository/verify_otp_repository.dart';
import 'package:bloodfit/helper/di.dart';
import 'package:bloodfit/helper/logger_util.dart';
import 'package:bloodfit/routes/routes.dart';
import 'package:get/get.dart';

class OtpValidationScreenController extends GetxController {
  ///---------------->>> Global Variables for Use Start

  RxString errorMessage = ''.obs;
  void clearErrorMessage() {
    errorMessage.value = '';
  }

  ///----------------->>> Gloabal Variables for Use End

  ///---------------->>> Otp Validation Api Start
  VerifyOtpRepository _verifyOtpRepository;
  ResendOtpRepository _resendOtpRepository;
  OtpValidationScreenController(
    this._verifyOtpRepository,
    this._resendOtpRepository,
  );
  Rxn<VerifyOtpModel> otpModel = Rxn<VerifyOtpModel>();

  var pin = ''.obs;
  var isLoading = false.obs;

  Future<void> postOtpValidationApi() async {
    clearErrorMessage();

    final errorValue = validatePin(pin.value);
    if (errorValue != null) {
      errorMessage.value = errorValue;
      LoggerUtils.error(
        "Error Message of Otp Validation 🥶🥶🥶🥶🥶🥶🥶🥶: ${errorMessage.value}",
      );
      return;
    }

    isLoading.value = true;
    final response = await _verifyOtpRepository.verifyOtpRepository(
      otp: pin.value,
    );
    isLoading.value = false;

    if (response.statusCode == 201 && response.isSuccess) {
      otpModel.value = VerifyOtpModel.fromJson(response.jsonResponse!);

      LoggerUtils.info("OTP Response 😬😬😬😬😬😬😬😬😬😬: ${otpModel.value}");
      if (appData.read(kKeySignUpToken) != null) {
        appData.remove(kKeySignUpToken);
        LoggerUtils.debug(
          "Access Token Removed! :😱😱😱😱😱😱😱: ${appData.read(kKeySignUpToken)}",
        );
      }
      Get.toNamed(Routes.signInScreen);
    } else {
      errorMessage.value = response.errorMessage ?? 'Verification failed. Please try again.';
      LoggerUtils.error(
        "Otp Validation Error :🥴🥴🥴🥴🥴🥴🥴🥴🥴: ${errorMessage.value}",
      );
    }
  }

  // Validate OTP format (6 digits)
  String? validatePin(String? value) {
    if (value == null || value.isEmpty) return 'OTP cannot be empty';
    if (value.length != 6) return 'OTP must be 6 digits';
    if (!RegExp(r'^\d+$').hasMatch(value)) {
      return 'OTP must contain only numbers';
    }

    return null;
  }

  // Called when OTP completed
  void onCompleted(String value) {
    pin.value = value;
    LoggerUtils.info('Entered OTP: $value');
    LoggerUtils.info('Pin value : $value');
  }

  ///---------------->>> Otp Validation Api End

  ///---------------->>> Resend Otp Api Start
  RxBool isResendingEmail = false.obs;

  RxString userEamil = ''.obs;
  void setUserEmailValue({required String email}) {
    userEamil.value = email;
    if (userEamil.value.isNotEmpty) {
      LoggerUtils.debug(
        "Received User Eamil for Resend Otp 🫨🫨🫨🫨🫨🫨🫨🫨: $userEamil",
      );
    } else {
      LoggerUtils.error("🙄🙄🙄🙄🙄🙄🙄Email Not found for Resend OTP!");
    }
  }

  Future<void> postResendOtpApi() async {
    clearErrorMessage();
    if (userEamil.value.isEmpty) {
      LoggerUtils.error(
        "🤕🤕🤕🤕🤕🤕🤕🤕User Email not Found for resending the otp!",
      );
      return;
    }

    isResendingEmail.value = true;
    final response = await _resendOtpRepository.resendOtpRepository(
      email: userEamil.value,
    );
    isResendingEmail.value = false;

    if (response.statusCode == 200 && response.isSuccess) {
      LoggerUtils.info(
        "🥱🥱🥱🥱🥱🥱Otp Send to your email again Successfully!",
      );
    } else {
      LoggerUtils.error(
        "🤕🤕🤕🤕🤕🤕🤕🤕Could not send otp! Error : ${response.errorMessage}",
      );
    }
  }
}
