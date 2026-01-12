import 'package:bloodfit/endpoints.dart';
import 'package:bloodfit/networks/network_caller.dart';
import 'package:bloodfit/networks/network_response.dart';

class TermsAndConditionsRepository {
  final NetworkCaller _networkCaller;
  TermsAndConditionsRepository(this._networkCaller);

  Future<NetworkResponse> termsAndConditionsRepository() async {
    return _networkCaller.getRequest(Endpoints.termsAndConditions());
  }
}
