import 'package:bloodfit/constants/app_constant_text.dart';
import 'package:bloodfit/endpoints.dart';
import 'package:bloodfit/helper/di.dart';
import 'package:bloodfit/networks/network_caller.dart';
import 'package:bloodfit/networks/network_response.dart';

class HasMealImageApiRepository {
  final NetworkCaller _networkCaller;


  HasMealImageApiRepository(this._networkCaller);

  Future<NetworkResponse> hasMealImageRepository({required String mealId}) async {
    String? tokenValue = appData.read(kKeyAccessToken) ?? '';


    return _networkCaller.getRequest(Endpoints.getHasMealImageApiUrl(mealId: mealId), headers: tokenValue.isNotEmpty ? {'Authorization' : 'Bearer $tokenValue'} : null);
  }
}