import 'package:bloodfit/constants/app_constant_text.dart';
import 'package:bloodfit/endpoints.dart';
import 'package:bloodfit/helper/di.dart';
import 'package:bloodfit/networks/network_caller.dart';
import 'package:bloodfit/networks/network_response.dart';

class ChangePasswordRepository {
  final NetworkCaller _networkCaller;
  ChangePasswordRepository(this._networkCaller);

  Future<NetworkResponse> changePasswordRepository({
    required String oldPass,
    required String newPass,
  }) async {
    final Map<String, dynamic> body = {
      'oldPassword': oldPass,
      'newPassword': newPass,
    };

    String token = appData.read(kKeyAccessToken);

    return _networkCaller.postRequest(
      Endpoints.changePassword(),
      body: body,
      headers: token.isNotEmpty ? {'Authorization': 'Bearer $token'} : null,
    );
  }
}
