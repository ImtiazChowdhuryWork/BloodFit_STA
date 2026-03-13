import 'package:get/state_manager.dart';

class WeightProgressShowingController extends GetxController {
  


  ///------------<>>>>> Section : Weight Progress Showing Api Method Starts Here
  

  RxBool isWeightProgressDataLoading = false.obs;
  RxString weightProgressDataErrorMessage = ''.obs;
  void clearWeightProgressDataErrorMessage(){
    weightProgressDataErrorMessage.value = '';
  }

  Future<void> getWeightProgressDataApi()async{}



  


  ///------------<>>>>> Section : Weight Progress Showing Api Method Ends Here
}