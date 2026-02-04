import 'package:bloodfit/constants/app_constant_text.dart';
import 'package:bloodfit/endpoints.dart';
import 'package:bloodfit/helper/di.dart';
import 'package:bloodfit/helper/logger_util.dart';
import 'package:bloodfit/networks/network_caller.dart';
import 'package:bloodfit/networks/network_response.dart';

class UpdateCurrentWeightRepository {
  final NetworkCaller _networkCaller;
  UpdateCurrentWeightRepository(this._networkCaller);

  Future<NetworkResponse> updateCurrentWeightRepository({
    required int updatedWeight,
  }) async {
    Map<String, dynamic> data = {'weight': updatedWeight};
    String? tokenValue = appData.read(kKeyAccessToken) ?? '';

    LoggerUtils.debug("Access Token for Weight Update : $tokenValue");

    return _networkCaller.patchRequest(
      Endpoints.updateCurrentWeight(),
      body: data,
      headers: tokenValue.isNotEmpty
          ? {'Authorization': 'Bearer $tokenValue'}
          : null,
    );
  }
}
