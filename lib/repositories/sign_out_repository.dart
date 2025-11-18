// repositories/sign_out_repository.dart
import 'package:bloodfit/endpoints.dart';
import '../helper/api_service.dart';

class SignOutRepository {
  final ApiService _apiService = ApiService.instance;

  Future<dynamic> logout() async {
    return await _apiService.post(Endpoints.signOut());
  }
}
