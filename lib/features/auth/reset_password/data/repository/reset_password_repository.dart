import 'package:bloodfit/constants/app_constant_text.dart';
import 'package:bloodfit/endpoints.dart';
import 'package:bloodfit/helper/di.dart';
import 'package:bloodfit/networks/network_caller.dart';
import 'package:bloodfit/networks/network_response.dart';

class ResetPasswordRepository {
  final NetworkCaller _networkCaller;
  ResetPasswordRepository(this._networkCaller);

  Future<NetworkResponse> resetPasswordRepository({
    required String password,
  }) async {
    final Map<String, dynamic> body = {'password': password};

    String? token = appData.read(kKeyForgotPasswordToken) ?? '';

    return _networkCaller.postRequest(
      Endpoints.resetPassword(),
      body: body,
      headers: token.isNotEmpty ? {'Authorization': 'Bearer $token'} : null,
    );
  }
}
