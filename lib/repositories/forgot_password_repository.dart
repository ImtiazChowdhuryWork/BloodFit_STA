import 'package:bloodfit/endpoints.dart';
import 'package:bloodfit/helper/api_service.dart';

class ForgotPasswordRepository {
  final ApiService _apiService = ApiService.instance;

  Future<dynamic> sendOTPAtThisEmail(String mail) async {
    try {
      final response = await _apiService.post(Endpoints.forgotPassword(), {
        'email': mail,
      });
      return response;
    } catch (e) {
      rethrow;
    }
  }
}
