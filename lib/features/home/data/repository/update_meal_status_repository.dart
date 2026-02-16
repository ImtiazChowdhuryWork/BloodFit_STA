import 'package:bloodfit/constants/app_constant_text.dart';
import 'package:bloodfit/endpoints.dart';
import 'package:bloodfit/helper/di.dart';
import 'package:bloodfit/helper/logger_util.dart';
import 'package:bloodfit/networks/network_caller.dart';
import 'package:bloodfit/networks/network_response.dart';

class MealConsumptionRepository {
  final NetworkCaller _networkCaller;
  MealConsumptionRepository(this._networkCaller);


  Future<NetworkResponse> updateMealConsumptionRepository({required String mealID})async{


    String? tokenValue = appData.read(kKeyAccessToken) ?? '';

    LoggerUtils.debug("Access Token Found for Todays Selected Meals : $tokenValue");

    // Send a body with the status update
    Map<String, dynamic> requestBody = {
      'status': 'done'  // Assuming 'done' means the meal has been eaten
    };

    return _networkCaller.patchRequest(
      Endpoints.updateMealEatenStatus(mealID: mealID), 
      body: requestBody,
      headers: tokenValue.isNotEmpty ? {'Authorization' : 'Bearer $tokenValue'} : null
    );
  }
}

