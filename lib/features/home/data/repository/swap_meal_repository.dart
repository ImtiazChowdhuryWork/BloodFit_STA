import 'package:bloodfit/constants/app_constant_text.dart';
import 'package:bloodfit/endpoints.dart';
import 'package:bloodfit/helper/di.dart';
import 'package:bloodfit/networks/network_caller.dart';
import 'package:bloodfit/networks/network_response.dart';

class SwapMealRepository {
  final NetworkCaller _networkCaller;
  SwapMealRepository(this._networkCaller);


  Future<NetworkResponse> swapMealRepository({
    required String mealID,
    required String description,
    required List<String> ingredientList,
    required String imageUrl,
    required List<Map<String,dynamic>> caloriesCount,
    })async{
    String tokenValue = appData.read(kKeyAccessToken) ?? '';

    Map<String,dynamic> data = {
      'description': description,
      'ingredients': ingredientList,
      'image': imageUrl,
      'caloryCount': caloriesCount,

    };

    return _networkCaller.patchRequest(
      Endpoints.swapMealUrl(mealID: mealID),
      body: data,
      headers: tokenValue.isNotEmpty ? {'Authorization' : 'Bearer $tokenValue'} : null
      );
  }
}