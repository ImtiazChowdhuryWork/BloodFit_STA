import 'package:bloodfit/constants/app_constant_text.dart';
import 'package:bloodfit/endpoints.dart';
import 'package:bloodfit/features/home/data/model/swap_meal_request_model.dart';
import 'package:bloodfit/helper/di.dart';
import 'package:bloodfit/networks/network_caller.dart';
import 'package:bloodfit/networks/network_response.dart';

class SwapMealRepository {
  final NetworkCaller _networkCaller;
  SwapMealRepository(this._networkCaller);

  Future<NetworkResponse> swapMealRepository({
    required String mealID,
    required SwapMealRequestModel meal,
    required String imageUrl,
  }) async {
    String tokenValue = appData.read(kKeyAccessToken) ?? '';

    Map<String, dynamic> data = {
      'meal': meal.toJson(),
      'image': imageUrl,
    };

    return _networkCaller.patchRequest(
      Endpoints.swapMealUrl(mealID: mealID),
      body: data,
      headers: tokenValue.isNotEmpty ? {'Authorization': 'Bearer $tokenValue'} : null,
    );
  }
}