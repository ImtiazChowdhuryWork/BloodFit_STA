import 'package:bloodfit/constants/app_constant_text.dart';
import 'package:bloodfit/endpoints.dart';
import 'package:bloodfit/helper/di.dart';
import 'package:bloodfit/helper/logger_util.dart';
import 'package:bloodfit/networks/network_caller.dart';
import 'package:bloodfit/networks/network_response.dart';

class WeightHistoryRepository {
  final NetworkCaller _networkCaller;
  WeightHistoryRepository(this._networkCaller);

  Future<NetworkResponse> getWeightHistory() async {
    String? tokenValue = appData.read(kKeyAccessToken) ?? '';

    LoggerUtils.debug('🔍 Weight History API - Request Started');
    LoggerUtils.debug('📍 Endpoint: ${Endpoints.getWeightHistory()}');
    LoggerUtils.debug('🔑 Token Available: ${tokenValue.isNotEmpty ? "Yes" : "No"}');
    LoggerUtils.debug('🔑 Token Prefix: ${tokenValue.isNotEmpty ? tokenValue.substring(0, 10) : "N/A"}...');

    final response = await _networkCaller.getRequest(
      Endpoints.getWeightHistory(),
      headers: tokenValue.isNotEmpty ? {'Authorization': 'Bearer $tokenValue'} : null,
    );

    LoggerUtils.debug('📥 Weight History API - Response Received');
    LoggerUtils.debug('📊 Status Code: ${response.statusCode}');
    LoggerUtils.debug('✅ Is Success: ${response.isSuccess}');
    LoggerUtils.debug('📄 Response Data: ${response.jsonResponse}');
    LoggerUtils.debug('⚠️ Error Message: ${response.errorMessage}');

    return response;
  }
}
