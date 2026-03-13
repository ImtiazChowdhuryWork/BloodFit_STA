import 'package:bloodfit/constants/app_constant_text.dart';
import 'package:bloodfit/endpoints.dart';
import 'package:bloodfit/helper/di.dart';
import 'package:bloodfit/networks/network_caller.dart';
import 'package:bloodfit/networks/network_response.dart';

class GenerateMealImageRepository {
  final NetworkCaller _networkCaller;
  GenerateMealImageRepository(this._networkCaller);


  Future<NetworkResponse> generateMealIamgeRepository({
    required String title,
    required String description,
    required List<String> ingredientList,
    })async{

    String? tokenValue = appData.read(kKeyAccessToken) ?? '';

    Map<String,dynamic> data = {
      'meal_name' : title,
      'description' : description,
      'ingredients' : ingredientList,
    };

    return _networkCaller.postRequest(Endpoints.postGenerateMealImageApiUrl(), body: data, headers: tokenValue.isNotEmpty ? {'Authorization' : 'Bearer $tokenValue'} : null);
  }
}