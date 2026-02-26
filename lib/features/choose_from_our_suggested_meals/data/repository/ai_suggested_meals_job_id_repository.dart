import 'package:bloodfit/constants/app_constant_text.dart';
import 'package:bloodfit/endpoints.dart';
import 'package:bloodfit/helper/di.dart';
import 'package:bloodfit/networks/network_caller.dart';
import 'package:bloodfit/networks/network_response.dart';



class AiSuggestedMealsJobIdRepository {
  final NetworkCaller _networkCaller;
  AiSuggestedMealsJobIdRepository(this._networkCaller);


  Future<NetworkResponse> aiSuggestedMealsJobIdRepository()async{

    String? tokenValue = appData.read(kKeyAccessToken) ?? '';

    return _networkCaller.getRequest(Endpoints.aiSuggestedMealsJobId(), headers: tokenValue.isNotEmpty ? {'Authorization' : 'Bearer $tokenValue'} : null);
  }
}