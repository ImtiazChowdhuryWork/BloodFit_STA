import 'package:bloodfit/constants/app_constant_text.dart';
import 'package:bloodfit/endpoints.dart';
import 'package:bloodfit/helper/di.dart';
import 'package:bloodfit/networks/network_caller.dart';
import 'package:bloodfit/networks/network_response.dart';

class MealDetailsRepository {
  final NetworkCaller _networkCaller;
  MealDetailsRepository(this._networkCaller);


  Future<NetworkResponse> mealDetailsRepository({required String mealID})async{


    String? tokenValue = appData.read(kKeyAccessToken) ?? '';

    return _networkCaller.getRequest(Endpoints.mealDetails(mealID: mealID), headers: tokenValue.isNotEmpty ? {'Authorization' : 'Bearer $tokenValue'} : null);

  }
}