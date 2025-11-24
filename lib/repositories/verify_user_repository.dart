import '../endpoints.dart';
import '../helper/api_service.dart';

class VerifyUserRepository {
  final ApiService _apiService = ApiService.instance;

  Future<dynamic> verifyUser(String otp) async {
    try {
      final response = await _apiService.get(Endpoints.verifyUserOtp(otp));
      return response;
    } catch (e) {
      rethrow;
    }
  }
}
