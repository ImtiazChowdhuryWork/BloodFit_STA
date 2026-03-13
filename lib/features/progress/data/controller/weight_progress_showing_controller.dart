import 'package:bloodfit/features/progress/data/model/progress_report_api_model.dart';
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


  ///------------<>>>>>> Section : Progress Report Api Starts Here
  Rxn<ProgressReportApiModel> progressReportApiModel = Rxn<ProgressReportApiModel>();
  RxBool isProgressReportDataLoading = false.obs;
  RxString progressReportDataErrorMessag = ''.obs;
  void clearProgressReportDataErrorMessage(){
    progressReportDataErrorMessag.value = '';
  }


  Future<void> getProgressReportApi()async{
    try{
      isProgressReportDataLoading.value = true;
      clearProgressReportDataErrorMessage();


      final response = await _porgressReportApiRepository.progressReportApiRepository();

      LoggerUtils.info("Progress Report Api Response : $response");

      if(response.statusCode == 200 && response.isSuccess){
        LoggerUtils.debug("😇😇😇😇😇.......Success In Getting the Progress Report Value!");

        progressReportApiModel.value = ProgressReportApiModel.fromJson(response.jsonResponse!);

      }else{


        progressReportDataErrorMessag.value = response.errorMessage ?? 'Failed to fetch progress data';


        LoggerUtils.error("Status Code : ${response.statusCode}");
        LoggerUtils.error("Progress Report Section Error Message : ${progressReportDataErrorMessag.value} ");

      }

    }catch(error){

      progressReportDataErrorMessag.value = error.toString();

      LoggerUtils.error("Something WentWrong ! Failed to Get Progress Report data!");
      LoggerUtils.error("Error Message : ${progressReportDataErrorMessag.value}");


    }finally{
      isProgressReportDataLoading.value = false;
    }
  }


  int get totalProgressValue => progressReportApiModel.value?.data?.completionPercentage ?? 0;
  int get totalMealProgressValue => progressReportApiModel.value?.data?.meal?.mealCompletionPercentage ?? 0;
  int get totalWorkoutProgressValue => progressReportApiModel.value?.data?.workout?.workoutCompletionPercentage ?? 0;




  ///------------<>>>>>> Section : Progress Report Api Ends Here
  


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
        LoggerUtils.error("Weight Progress Section Error Message : ${weightProgressDataErrorMessage.value} ");

      }



    }catch(error){

      weightProgressDataErrorMessage.value = error.toString();
      LoggerUtils.error("Something Went Wrong! While Getting the Weight History Data!");
      LoggerUtils.error("Error Message : ${weightProgressDataErrorMessage.value}");

    }finally{

      isWeightProgressDataLoading.value = false;

    }
  }

  int get initialWeight => weightProgressShowingModel.value?.data?.initialWeight ?? 90;
  int get currentWeight => weightProgressShowingModel.value?.data?.currentWeight ?? 70;
  int get goalWeight => weightProgressShowingModel.value?.data?.desiredWeight ?? 60;



  


  ///------------<>>>>> Section : Weight Progress Showing Api Method Ends Here
  ///
  ///
  ///
}