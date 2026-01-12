import 'package:bloodfit/constants/app_constant_text.dart';
import 'package:bloodfit/endpoints.dart';
import 'package:bloodfit/helper/di.dart';
import 'package:bloodfit/helper/logger_util.dart';
import 'package:bloodfit/networks/network_caller.dart';
import 'package:bloodfit/networks/network_response.dart';

class ReportAProblemRepository {
  final NetworkCaller _networkCaller;
  ReportAProblemRepository(this._networkCaller);

  Future<NetworkResponse> reportaproblemrepository({
    required String name,
    required String email,
    required String problem,
    required String message,
  }) async {
    final Map<String, dynamic> body = {
      'name': name,
      'email': email,
      'problem': problem,
      'message': message,
    };

    String accessToken = appData.read(kKeyAccessToken);

    LoggerUtils.debug("Access Token : $accessToken");

    return _networkCaller.postRequest(
      Endpoints.reportAProblem(),
      body: body,
      headers: accessToken.isNotEmpty
          ? {'Authorization': 'Bearer $accessToken'}
          : null,
    );
  }
}
