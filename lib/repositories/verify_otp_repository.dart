import 'package:bloodfit/endpoints.dart';
import 'package:bloodfit/helper/api_service.dart';

class VerifyOtpRepository {
  final ApiService _apiService = ApiService.instance;

  Future<dynamic> verifyOtp(String otp) async {
    try {
      final response = await _apiService.get(Endpoints.resetPasswordOtp(otp));
      return response;
    } catch (e) {
      rethrow;
    }
  }
}
