import 'package:bloodfit/endpoints.dart';
import 'package:bloodfit/networks/network_caller.dart';
import 'package:bloodfit/networks/network_response.dart';

class SignUpRepository {
  final NetworkCaller _networkCaller;
  SignUpRepository(this._networkCaller);

  Future<NetworkResponse> signUpRepository({
    required String firstName,
    required String lastName,
    required String email,
    required String phoneNumber,
    required String password,
  }) async {
    final Map<String, dynamic> body = {
      'firstName': firstName,
      'lastName': firstName,
      'email': firstName,
      'contactNumber': firstName,
      'password': firstName,
    };

    return _networkCaller.postRequest(Endpoints.signUp(), body: body);
  }
}
