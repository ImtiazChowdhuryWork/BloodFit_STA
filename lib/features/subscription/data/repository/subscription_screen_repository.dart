import 'package:bloodfit/constants/app_constant_text.dart';
import 'package:bloodfit/endpoints.dart';
import 'package:bloodfit/helper/di.dart';
import 'package:bloodfit/networks/network_caller.dart';
import 'package:bloodfit/networks/network_response.dart';

class SubscriptionScreenRepository {
  final NetworkCaller _networkCaller;
  SubscriptionScreenRepository(this._networkCaller);

  Future<NetworkResponse> subscriptionScreenRepository() async {
    String? authToken = appData.read(kKeyAccessToken) ?? '';

    return _networkCaller.getRequest(
      Endpoints.getSubscriptionPlans(),
      headers: authToken.isNotEmpty
          ? {'Authorization': 'Bearer $authToken'}
          : null,
    );
  }
}
