import 'package:bloodfit/constants/app_constant_text.dart';
import 'package:bloodfit/endpoints.dart';
import 'package:bloodfit/helper/di.dart';
import 'package:bloodfit/networks/network_caller.dart';
import 'package:bloodfit/networks/network_response.dart';

class YourDailyCaloriesIntakeScreenRepository {
  final NetworkCaller _networkCaller;
  YourDailyCaloriesIntakeScreenRepository(this._networkCaller);

  Future<NetworkResponse> yourDailyCaloriesIntakeRepository() async {
    String? authToken = appData.read(kKeyAccessToken) ?? '';

    return await _networkCaller.getRequest(
      Endpoints.dailyCaloriesIntake(),
      headers: authToken.isNotEmpty
          ? {'Authorization': 'Bearer $authToken'}
          : null,
    );
  }
}
