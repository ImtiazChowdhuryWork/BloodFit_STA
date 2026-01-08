import 'package:bloodfit/endpoints.dart';
import 'package:bloodfit/networks/network_caller.dart';
import 'package:bloodfit/networks/network_response.dart';

class ForgotPasswordRepository {
  final NetworkCaller _networkCaller;
  ForgotPasswordRepository(this._networkCaller);

  Future<NetworkResponse> forgotPasswordRepository({
    required String email,
  }) async {
    final Map<String, dynamic> body = {'email': email};

    return _networkCaller.postRequest(Endpoints.forgotPassword(), body: body);
  }
}
