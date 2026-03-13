import 'package:bloodfit/features/progress/data/model/weight_progress_showing_model.dart';
import 'package:bloodfit/features/progress/data/repository/weight_progress_showing_repository.dart';
import 'package:bloodfit/helper/logger_util.dart';
import 'package:get/state_manager.dart';
import 'package:logger/web.dart';

import '../repository/porgress_report_api_repository.dart';

class ProgressShowingController extends GetxController {

  ///-----------<>>>>>>> Section : Importing Repositories
  WeightProgressShowingRepository _weightProgressShowingRepository;
  PorgressReportApiRepository _porgressReportApiRepository;

  ProgressShowingController(this._weightProgressShowingRepository, this._porgressReportApiRepository); 
  


  ///------------<>>>>> Section : Weight Progress Showing Api Method Starts Here
  ///
  Rxn<WeightProgressShowingModel> weightProgressShowingModel = Rxn<WeightProgressShowingModel>();
  

  RxBool isWeightProgressDataLoading = false.obs;
  RxString weightProgressDataErrorMessage = ''.obs;
  void clearWeightProgressDataErrorMessage(){
    weightProgressDataErrorMessage.value = '';
  }

  Future<void> getWeightProgressDataApi()async{
    try{
      isWeightProgressDataLoading.value = true;
      clearWeightProgressDataErrorMessage();

      final response = await _weightProgressShowingRepository.weightProgressDataShowingRepository();

      LoggerUtils.debug("Weight History Response : $response");

      if(response.statusCode == 200 && response.isSuccess){

        LoggerUtils.debug("😁😁😁😁Weight Progress Showing api fetched successfully.");
        weightProgressShowingModel.value = WeightProgressShowingModel.fromJson(response.jsonResponse!);

      }else{

        weightProgressDataErrorMessage.value = response.errorMessage ?? 'Failed to fetch weight progress data';


        LoggerUtils.error("Status Code : ${response.statusCode}");
        LoggerUtils.error("Weight Progress Section Error Message : ${response.errorMessage} ");

      }



    }catch(error){

      weightProgressDataErrorMessage.value = error.toString();

    }finally{

      isWeightProgressDataLoading.value = false;

    }
  }

  int get initialWeight => weightProgressShowingModel.value?.data?.initialWeight ?? 90;
  int get currentWeight => weightProgressShowingModel.value?.data?.currentWeight ?? 70;
  int get goalWeight => weightProgressShowingModel.value?.data?.desiredWeight ?? 60;



  


  ///------------<>>>>> Section : Weight Progress Showing Api Method Ends Here
}