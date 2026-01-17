import 'package:bloodfit/constants/app_constant_text.dart';
import 'package:bloodfit/endpoints.dart';
import 'package:bloodfit/helper/di.dart';
import 'package:bloodfit/networks/network_caller.dart';
import 'package:bloodfit/networks/network_response.dart';

class InformationGatherMealPlanRepository {
  final NetworkCaller _networkCaller;
  InformationGatherMealPlanRepository(this._networkCaller);

  Future<NetworkResponse> informationGatherMealPlanRepository({
    required String bloodGroup,
    required String gender,
    required double age,
    required double weight,
    required double height,
    required String diet,
    required List foodAllergiesList,
    required List foodDislikesList,
    required String country,
  }) async {
    final Map<String, dynamic> data = {
      'bloodGroup': bloodGroup,
      'gender': gender,
      'age': age,
      'weight': weight,
      'height': height,
      'diet': diet,
      'foodAllergies': foodAllergiesList,
      'foodDislikes': foodDislikesList,
      'country': country,
    };

    String tokenValue = appData.read(kKeyAccessToken) ?? '';

    return _networkCaller.postRequest(
      Endpoints.informationGatherMealPlan(),
      body: data,
      headers: tokenValue.isNotEmpty
          ? {'Authorization': 'Bearer $tokenValue'}
          : null,
    );
  }
}
