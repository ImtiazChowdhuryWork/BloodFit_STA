import 'package:bloodfit/constants/app_constant_text.dart';
import 'package:bloodfit/endpoints.dart';
import 'package:bloodfit/helper/di.dart';
import 'package:bloodfit/networks/network_caller.dart';
import 'package:bloodfit/networks/network_response.dart';

class PreviouslySelectedMealsRepository {
  final NetworkCaller _networkCaller;
  PreviouslySelectedMealsRepository(this._networkCaller);

  Future<NetworkResponse> previouslySelectedMealsRepository() async {
    String? tokenValue = appData.read(kKeyAccessToken) ?? '';

    return _networkCaller.getRequest(
      Endpoints.getPreviouslySelectedMeals(),
      headers: tokenValue.isNotEmpty
          ? {'Authorization': 'Bearer $appData'}
          : null,
    );
  }
}
