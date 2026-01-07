import 'package:bloodfit/constants/app_constant_text.dart';
import 'package:bloodfit/endpoints.dart';
import 'package:bloodfit/helper/di.dart';
import 'package:bloodfit/networks/network_caller.dart';
import 'package:bloodfit/networks/network_response.dart';

class VerifyOtpRepository {
  NetworkCaller _networkCaller;
  VerifyOtpRepository(this._networkCaller);

  Future<NetworkResponse> verifyOtpRepository({required String otp}) async {
    final Map<String, dynamic> body = {'otp': otp};

    String? token = appData.read(kKeySignUpToken);
    String tokenValue = token ?? '';

    return _networkCaller.postRequest(
      Endpoints.verifyOtp(),
      body: body,
      headers: tokenValue.isNotEmpty
          ? {'Authorization': 'Bearer $tokenValue'}
          : null,
    );
  }
}
