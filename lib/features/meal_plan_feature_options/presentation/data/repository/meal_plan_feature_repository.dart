import 'package:bloodfit/constants/app_constant_text.dart';
import 'package:bloodfit/endpoints.dart';
import 'package:bloodfit/helper/di.dart';
import 'package:bloodfit/helper/logger_util.dart';
import 'package:bloodfit/networks/network_caller.dart';
import 'package:bloodfit/networks/network_response.dart';

class MealPlanFeatureRepository {
  final NetworkCaller _networkCaller;

  MealPlanFeatureRepository(this._networkCaller);


  Future<NetworkResponse> mealPlanFeatureRepository({required String selectedDate})async{

    String? tokenValue = appData.read(kKeyAccessToken) ?? '';

    Map<String,dynamic> data = {
        "date" : selectedDate,
      };

    LoggerUtils.debug("===== MEAL PLAN FEATURE API REQUEST =====");
    LoggerUtils.debug("URL: ${Endpoints.getMealsByDate()}");
    LoggerUtils.debug("Method: POST");
    LoggerUtils.debug("Request Body: $data");
    LoggerUtils.debug("Token Exists: ${tokenValue.isNotEmpty}");
    LoggerUtils.debug("Headers: ${tokenValue.isNotEmpty ? {'Authorization' : 'Bearer $tokenValue'} : 'No Headers'}");

    final response = await _networkCaller.postRequest(
      Endpoints.getMealsByDate(),
      body: data,
      headers: tokenValue.isNotEmpty ? {'Authorization' : 'Bearer $tokenValue'} : null
    );

    LoggerUtils.debug("===== API RESPONSE =====");
    LoggerUtils.debug("Status Code: ${response.statusCode}");
    LoggerUtils.debug("Is Success: ${response.isSuccess}");
    LoggerUtils.debug("Error Message: ${response.errorMessage}");
    LoggerUtils.debug("Raw Response: ${response.jsonResponse}");
    LoggerUtils.debug("========================");

    return response;
  }
}