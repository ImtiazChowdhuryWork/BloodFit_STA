import 'package:bloodfit/constants/app_constant_text.dart';
import 'package:bloodfit/endpoints.dart';
import 'package:bloodfit/helper/di.dart';
import 'package:bloodfit/networks/network_caller.dart';
import 'package:bloodfit/networks/network_response.dart';



class AiSuggestedMealsRepository {
  final NetworkCaller _networkCaller;
  AiSuggestedMealsRepository(this._networkCaller);


  Future<NetworkResponse> aiSuggestedMealsRepository()async{

    String? tokenValue = appData.read(kKeyAccessToken) ?? '';

    return _networkCaller.getRequest(Endpoints.aiSuggestedMeals(), headers: tokenValue.isNotEmpty ? {'Authorization' : 'Bearer $tokenValue'} : null);
  }
}