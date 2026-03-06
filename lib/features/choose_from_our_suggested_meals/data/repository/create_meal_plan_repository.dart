import 'package:bloodfit/constants/app_constant_text.dart';
import 'package:bloodfit/endpoints.dart';
import 'package:bloodfit/helper/di.dart';
import 'package:bloodfit/networks/network_caller.dart';
import 'package:bloodfit/networks/network_response.dart';

class CreateMealPlanRepository {
  final NetworkCaller _networkCaller;
  CreateMealPlanRepository(this._networkCaller);


  Future<NetworkResponse> createMealPlanRepository()async{

    String tokenValue = appData.read(kKeyAccessToken) ?? '';

    Map<String,dynamic> data = {};


    return _networkCaller.postRequest(Endpoints.createMealPlan(), body: data, headers: tokenValue.isNotEmpty ? {'Authorization' : 'Bearer $tokenValue'} : null);
  }
}