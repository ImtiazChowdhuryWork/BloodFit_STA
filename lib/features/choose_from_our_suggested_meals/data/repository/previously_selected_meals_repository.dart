import 'package:bloodfit/constants/app_constant_text.dart';
import 'package:bloodfit/endpoints.dart';
import 'package:bloodfit/helper/di.dart';
import 'package:bloodfit/networks/network_caller.dart';
import 'package:bloodfit/networks/network_response.dart';

class PreviouslySelectedMealsRepository {
  final NetworkCaller _networkCaller;
  PreviouslySelectedMealsRepository(this._networkCaller);

  Future<NetworkResponse> previouslySelectedMealsRepository({required String mealType}) async {
    String? tokenValue = appData.read(kKeyAccessToken) ?? '';

    return _networkCaller.getRequest(
      Endpoints.getPreviouslySelectedMeals(mealType: mealType),
      headers: tokenValue.isNotEmpty
          ? {'Authorization': 'Bearer $tokenValue'}
          : null,
    );
  }
}
