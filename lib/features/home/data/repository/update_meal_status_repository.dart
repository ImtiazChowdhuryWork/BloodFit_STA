import 'package:bloodfit/constants/app_constant_text.dart';
import 'package:bloodfit/endpoints.dart';
import 'package:bloodfit/helper/di.dart';
import 'package:bloodfit/networks/network_caller.dart';
import 'package:bloodfit/networks/network_response.dart';

class MealConsumptionRepository {
  final NetworkCaller _networkCaller;
  MealConsumptionRepository(this._networkCaller);


  Future<NetworkResponse> updateMealConsumptionRepository({required String mealID})async{



    String? tokenValue = appData.read(kKeyAccessToken) ?? '';

    return _networkCaller.patchRequest(Endpoints.updateMealEatenStatus(mealID: mealID), headers: tokenValue.isNotEmpty ? {'Authorization' : 'Bearer $tokenValue'} : null);
  }
}



//updateMealEatenStatus