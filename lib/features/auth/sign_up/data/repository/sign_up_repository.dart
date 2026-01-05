// repositories/sign_up_repository.dart
import 'package:bloodfit/endpoints.dart';
import '../../../../../helper/api_service.dart';

class SignUpRepository {
  final ApiService _apiService = ApiService.instance;

  Future<dynamic> signup(
    String firstName,
    String lastName,
    String phone,
    String email,
    String password,
  ) async {
    return await _apiService.post(Endpoints.signUp(), {
      'firstName': firstName,
      'lastName': lastName,
      'phone': phone,
      'email': email,
      'password': password,
    });
  }
}
