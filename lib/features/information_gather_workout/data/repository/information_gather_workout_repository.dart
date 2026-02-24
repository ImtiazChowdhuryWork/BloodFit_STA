import 'package:bloodfit/constants/app_constant_text.dart';
import 'package:bloodfit/endpoints.dart';
import 'package:bloodfit/helper/di.dart';
import 'package:bloodfit/networks/network_caller.dart';
import 'package:bloodfit/networks/network_response.dart';

class InformationGatherWorkoutRepository {
  final NetworkCaller _networkCaller;
  InformationGatherWorkoutRepository(this._networkCaller);



  Future<NetworkResponse> informationGatherWorkoutRepository({
    
    required String bodyShapeData,
    required String activityLevelData,
    required String preferredWorkoutData,
    required List<String> focusAreaListData,
    
    
    })async{

      Map<String,dynamic> data = {
        'bodyShape': bodyShapeData,
        'activityLevel': activityLevelData,
        'prefferedWorkout': preferredWorkoutData,
        'focusArea': focusAreaListData,

      };
    
    String? tokenValue = appData.read(kKeyAccessToken) ?? '';

    return _networkCaller.postRequest(Endpoints.infoGattherWorkOutGoal(),body: data, headers: tokenValue.isNotEmpty ? {'Authorization' : 'Bearer $tokenValue'} : null);
  }
}