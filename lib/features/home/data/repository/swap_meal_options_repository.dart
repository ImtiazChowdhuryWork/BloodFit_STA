import 'package:bloodfit/constants/app_constant_text.dart';
import 'package:bloodfit/endpoints.dart';
import 'package:bloodfit/helper/di.dart';
import 'package:bloodfit/networks/network_caller.dart';
import 'package:bloodfit/networks/network_response.dart';

class SwapMealOptionsRepository {
  final NetworkCaller _networkCaller;

  SwapMealOptionsRepository(this._networkCaller);

  Future<NetworkResponse> swapMealOptionsRepository({required String category, required String subCategory, required  int currentCallories})async{


    String? tokenValue = appData.read(kKeyAccessToken) ?? '';

    

    return _networkCaller.getRequest(Endpoints.swapMealOptions(category: category, subCategory: subCategory, currentCalories: currentCallories), headers: tokenValue.isNotEmpty ? {'Authorization' : 'Bearer $tokenValue'} : null);
  }
}