import 'package:bloodfit/endpoints.dart';
import 'package:bloodfit/helper/api_service.dart';

class ForgotPasswordVerifyOtpRepository {
  final ApiService _apiService = ApiService.instance;

  Future<dynamic> forgotPasswordVerifyOtp(String otp, String email) async {
    try {
      final response = await _apiService.post(Endpoints.resetPasswordOtp(), {
        'otp': otp,
        'email': email,
      });
      return response;
    } catch (e) {
      rethrow;
    }
  }
}
