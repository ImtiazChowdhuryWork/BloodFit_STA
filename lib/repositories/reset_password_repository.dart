import 'package:bloodfit/endpoints.dart';
import 'package:bloodfit/helper/api_service.dart';

class ResetPasswordRepository {
  final ApiService _apiService = ApiService.instance;

  Future<dynamic> resetPassword(String token, String password) async {
    try {
      final response = await _apiService.post(Endpoints.resetPassword(), {
        'token': token,
        'password': password,
      });
      return response;
    } catch (e) {
      rethrow;
    }
  }
}
