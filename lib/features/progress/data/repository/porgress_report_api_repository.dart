import 'package:bloodfit/constants/app_constant_text.dart';
import 'package:bloodfit/endpoints.dart';
import 'package:bloodfit/helper/di.dart';
import 'package:bloodfit/networks/network_caller.dart';
import 'package:bloodfit/networks/network_response.dart';

class PorgressReportApiRepository {
  final NetworkCaller _networkCaller;
  PorgressReportApiRepository(this._networkCaller);

  Future<NetworkResponse> progressReportApiRepository()async{

    String? tokenValue = appData.read(kKeyAccessToken) ?? '';

    return _networkCaller.getRequest(Endpoints.getProgressReportApiUrl(), headers: tokenValue.isNotEmpty ? {'Authorization' : 'Bearer $tokenValue'} : null);
  }


  
}