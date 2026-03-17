import 'package:bloodfit/features/plan_summery_details/data/repository/summery_details_repository.dart';
import 'package:bloodfit/helper/logger_util.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../model/billing_summery_model.dart';



class PlanSummeryDetailsScreenController extends GetxController{

  ///-----------<>>>>> Section : Importing Repositoryes
  PlanSummeryDetailsRepository _planSummeryDetailsRepository;



  PlanSummeryDetailsScreenController(this._planSummeryDetailsRepository);


  ///------------>>>> Section : Plan Summery Details Api Starts Here
  ///
  Rxn<BillingSummeryModel> planSummeryModel = Rxn<BillingSummeryModel>();
  
  RxBool isSummeryDetailsLoading = false.obs;
  RxString summeryDetailsErrorMessage = ''.obs;
  void clearSummeryDetailsErrorMessage(){
    summeryDetailsErrorMessage.value = '';
  }

  RxString planId = ''.obs;
  void setPlanId({required String value }){
    planId.value = value;
    LoggerUtils.debug("Received Plan Type : ${planId.value}");
  }

  RxString billingType = ''.obs;
  void setBillingType({required String value }){
    billingType.value = value;
    LoggerUtils.debug("Received Billing Type : ${billingType.value}");
  }

  // RxString planName = ''.obs;
  // void setPlanName({required String value}){
  //   planName.value = value;
  // }




  




  Future<void> getPlanSummeryDetailsApi()async{
    try{

      isSummeryDetailsLoading.value = true;
      clearSummeryDetailsErrorMessage();

      LoggerUtils.debug("Calling API with Plan ID: ${planId.value} | Billing Type: ${billingType.value}");

      final response = await _planSummeryDetailsRepository.summeryDetailsRepository(planID: planId.value, billingTYPE: billingType.value,);

      if(response.statusCode == 200 && response.isSuccess){
        LoggerUtils.debug("Successfully Plan Summery Details fetched!");
        LoggerUtils.debug("Response Data: ${response.jsonResponse}");
        planSummeryModel.value = BillingSummeryModel.fromJson(response.jsonResponse!);
      }else{
        LoggerUtils.error("Failed to Get Plan Summery Details!");
        LoggerUtils.error("Error Code : ${response.statusCode} :: -> Error Message : ${response.errorMessage}");
      }

    }catch(error){


      summeryDetailsErrorMessage.value = error.toString();
      LoggerUtils.error("Something went wrong while getting the Plan Summery Data!");
      LoggerUtils.error("Plan Summery Error Message : ${summeryDetailsErrorMessage.value}");

    }finally{
      isSummeryDetailsLoading.value = false;
    }
  }

  String get planName => planSummeryModel.value?.data?.planName ?? 'N/A';
  double get planPrice => planSummeryModel.value?.data?.price ?? 0.0;

String get formattedSubscriptionDate {
  final date = planSummeryModel.value?.data?.date;
  if (date == null) return 'N/A';

  return DateFormat('dd/MM/yyyy').format(date);
}

double get totalAmount => planSummeryModel.value?.data?.totalPrice ?? 0.0;

String get planDurationType => planSummeryModel.value?.data?.billing ?? 'N/A';



  ///------------>>>> Section : Plan Summery Details Api Ends Here

}