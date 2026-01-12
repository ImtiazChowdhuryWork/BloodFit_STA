import 'package:bloodfit/endpoints.dart';
import 'package:bloodfit/networks/network_caller.dart';
import 'package:bloodfit/networks/network_response.dart';

class PrivacyPolicyRepository {
  final NetworkCaller _networkCaller;
  PrivacyPolicyRepository(this._networkCaller);

  Future<NetworkResponse> privacyPolicyRepository() async {
    return _networkCaller.getRequest(Endpoints.privacyPolicy());
  }
}
