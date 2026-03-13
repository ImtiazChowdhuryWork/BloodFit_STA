import 'package:bloodfit/constants/app_constant_text.dart';
import 'package:bloodfit/endpoints.dart';
import 'package:bloodfit/helper/di.dart';
import 'package:bloodfit/networks/network_caller.dart';
import 'package:bloodfit/networks/network_response.dart';

class WeightProgressShowingRepository {
  final NetworkCaller _networkCaller;
  WeightProgressShowingRepository(this._networkCaller);



  Future<NetworkResponse> weightProgressDataShowingRepository()async{

    String? tokenValue = appData.read(kKeyAccessToken) ?? '';

    return _networkCaller.getRequest(Endpoints.getWeightProgressApiUrl(), headers: tokenValue.isNotEmpty ? {'Authorization' : 'Bearer $tokenValue'} : null);
  }
}