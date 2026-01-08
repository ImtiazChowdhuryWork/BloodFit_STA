import 'package:bloodfit/constants/app_constant_text.dart';
import 'package:bloodfit/endpoints.dart';
import 'package:bloodfit/helper/di.dart';
import 'package:bloodfit/helper/logger_util.dart';
import 'package:bloodfit/networks/network_caller.dart';
import 'package:bloodfit/networks/network_response.dart';

class VerifyOtpRepository {
  NetworkCaller _networkCaller;
  VerifyOtpRepository(this._networkCaller);

  Future<NetworkResponse> verifyOtpRepository({required String otp}) async {
    final Map<String, dynamic> body = {'otp': otp};

    String? signUpToken = appData.read(kKeySignUpToken);
    String? forgotPasswordToken = appData.read(kKeyForgotPasswordToken);
    // String tokenValue = token ?? '';
    String tokenValue = signUpToken ?? forgotPasswordToken ?? '';
    LoggerUtils.debug("Token Value Used of Sign-Up : ${signUpToken ?? ''}");
    LoggerUtils.debug(
      "Token Value Used of Forgot Password : ${forgotPasswordToken ?? ''}",
    );
    LoggerUtils.debug("Token Value : $tokenValue");
    return _networkCaller.postRequest(
      Endpoints.verifyOtp(),
      body: body,
      headers: tokenValue.isNotEmpty
          ? {'Authorization': 'Bearer $tokenValue'}
          : null,
    );
  }
}
