import 'package:bloodfit/constants/app_constant_text.dart';
import 'package:bloodfit/endpoints.dart';
import 'package:bloodfit/helper/di.dart';
import 'package:bloodfit/networks/network_caller.dart';
import 'package:bloodfit/networks/network_response.dart';

class FaqRepository {
  final NetworkCaller _networkCaller;
  FaqRepository(this._networkCaller);

  Future<NetworkResponse> faqRepository() async {
    String? authToken = appData.read(kKeyAccessToken) ?? '';

    return _networkCaller.getRequest(
      Endpoints.faq(),
      headers: authToken.isNotEmpty
          ? {'Authorization': 'Bearer $authToken'}
          : null,
    );
  }
}
