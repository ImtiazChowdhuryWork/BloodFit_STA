import 'package:bloodfit/endpoints.dart';

import '../helper/api_service.dart';

class SignInRepository {
  final ApiService _apiService = ApiService.instance;

  Future<dynamic> login(String email, String password) async {
    return await _apiService.post(Endpoints.signIn(), {
      'email': email,
      'password': password,
    });
  }
}
