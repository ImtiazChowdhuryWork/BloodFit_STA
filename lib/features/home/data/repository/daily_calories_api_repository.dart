import 'package:bloodfit/constants/app_constant_text.dart';
import 'package:bloodfit/endpoints.dart';
import 'package:bloodfit/helper/di.dart';
import 'package:bloodfit/networks/network_caller.dart';
import 'package:bloodfit/networks/network_response.dart';

class DailyCaloriesApiRepository {
  final NetworkCaller _networkCaller;
  DailyCaloriesApiRepository(this._networkCaller);

  Future<NetworkResponse> dailyCaloriesApiRepository() async {
    String? authToken = appData.read(kKeyAccessToken) ?? '';
    return _networkCaller.getRequest(
      Endpoints.getCalorieRequirements(),
      headers: authToken.isNotEmpty
          ? {'Authorization': 'Bearer $authToken'}
          : null,
    );
  }
}
