import 'package:bloodfit/endpoints.dart';
import 'package:bloodfit/networks/network_caller.dart';
import 'package:bloodfit/networks/network_response.dart';

class SignInRepository {
  final NetworkCaller _networkCaller;
  SignInRepository(this._networkCaller);

  Future<NetworkResponse> signInRepository({
    required String email,
    required String password,
  }) async {
    final Map<String, dynamic> body = {'email': email, 'password': password};

    return _networkCaller.postRequest(
      Endpoints.signIn(),
      body: body,
      isLogin: true,
    );
  }
}
