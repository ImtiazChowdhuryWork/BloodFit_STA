import 'package:bloodfit/constants/app_constant_text.dart';
import 'package:bloodfit/endpoints.dart';
import 'package:bloodfit/helper/di.dart';
import 'package:bloodfit/networks/network_caller.dart';
import 'package:bloodfit/networks/network_response.dart';

class PlanSummeryDetailsRepository {
  final NetworkCaller _networkCaller;

  PlanSummeryDetailsRepository(this._networkCaller);

  Future<NetworkResponse> summeryDetailsRepository({
    required String planID,
    required String billingTYPE,
  }) async {
    String? tokenValue = appData.read(kKeyAccessToken) ?? '';

    return _networkCaller.getRequest(
      Endpoints.getBillingSummeryApiUrl(
        planId: planID,
        billingType: billingTYPE,
      ),
      headers: tokenValue.isNotEmpty
          ? {'Authorization': 'Bearer $tokenValue'}
          : null,
    );
  }
}
