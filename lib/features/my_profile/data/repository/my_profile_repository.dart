import 'package:bloodfit/constants/app_constant_text.dart';
import 'package:bloodfit/endpoints.dart';
import 'package:bloodfit/helper/di.dart';
import 'package:bloodfit/networks/network_caller.dart';
import 'package:bloodfit/networks/network_response.dart';

class MyProfileRepository {
  final NetworkCaller _networkCaller;
  MyProfileRepository(this._networkCaller);

  Future<NetworkResponse> myProfileRepository() async {
    String? authToken = appData.read(kKeyAccessToken) ?? '';

    return _networkCaller.getRequest(
      Endpoints.myProfile(),
      headers: authToken.isNotEmpty
          ? {'Authorization': 'Bearer $authToken'}
          : null,
    );
  }
}
