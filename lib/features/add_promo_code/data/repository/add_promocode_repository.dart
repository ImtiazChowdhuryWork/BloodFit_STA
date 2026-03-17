import 'package:bloodfit/constants/app_constant_text.dart';
import 'package:bloodfit/endpoints.dart';
import 'package:bloodfit/helper/di.dart';
import 'package:bloodfit/networks/network_caller.dart';
import 'package:bloodfit/networks/network_response.dart';

class AddPromocodeRepository {
  final NetworkCaller _networkCaller;

  AddPromocodeRepository(this._networkCaller);

  Future<NetworkResponse> addPromocodeRepository({
    required String planId,
    required String prmCode,
  }) async {
    String? tokenValue = appData.read(kKeyAccessToken) ?? '';

    return _networkCaller.postRequest(
      Endpoints.postAddPromocodeApiUrl(planId: planId, promoCode: prmCode),
      headers: tokenValue.isNotEmpty
          ? {'Authorization': 'Bearer $tokenValue'}
          : null,
    );
  }
}
