import 'package:bloodfit/features/meal_details/data/repository/meal_details_repository.dart';
import 'package:bloodfit/helper/logger_util.dart';
import 'package:get/get.dart';

import '../model/meal_details_model.dart';

class MealDetailsScreenController extends GetxController{

  ///-----------<>>> Section : Importing the repositories
  final MealDetailsRepository _mealDetailsRepository;



  MealDetailsScreenController(this._mealDetailsRepository);

  



  ///---------------<>>>>>> Section : Meal Details API Started Here
  Rxn<MealDetailsModel> mealDetailsModel = Rxn<MealDetailsModel>();
  RxBool isMealDetailsLoading = false.obs;


  RxString mealDetailsErrorMessage = ''.obs;
  void clearMealDetailsErrorMessage(){
    mealDetailsErrorMessage.value = '';
  }


  RxString mealID = ''.obs;
  void setMealID({required String mealId}){
    mealID.value = mealId;
    LoggerUtils.debug("From Meal Deatails Screen -> Received MealID : ${mealID.value}");
  }


  Future<void> getMealDetailsApi()async{
    isMealDetailsLoading.value = true;
    clearMealDetailsErrorMessage();


    try{

      final response = await _mealDetailsRepository.mealDetailsRepository(mealID: mealID.value);
      LoggerUtils.debug("🥶🥶🥶Response Status Code : ${response.statusCode}");
      if(response.statusCode == 200 && response.isSuccess){

        LoggerUtils.debug("🎃🎃🎃🎃Fetched meal Details Successfully!");
        mealDetailsModel.value = MealDetailsModel.fromJson(response.jsonResponse!);
        LoggerUtils.debug("Raw JSON: ${response.jsonResponse}");

      }else{
        mealDetailsErrorMessage.value = response.errorMessage.toString();
        LoggerUtils.error("Failed to Get Meal Details : Error Code : ${response.statusCode}");
        LoggerUtils.error("Error Message : ${response.errorMessage}");
      }

    }catch(error){
      mealDetailsErrorMessage.value = error.toString();
      LoggerUtils.error("Error Catched While Getting the Meal Details!");
      LoggerUtils.error("Meals Details Catched Error : ${mealDetailsErrorMessage.value}");

    }finally{
      isMealDetailsLoading.value = false;
      LoggerUtils.debug("🥸🥸🥸🥸🥸🥸🥸Is Meal Details Loading : ${isMealDetailsLoading.value}");
    }
  }


  Data? get data => mealDetailsModel.value?.data;

  String get mealName => data?.mealName ?? 'Geting the meal name...';
  String get mealType => data?.mealType ?? 'Geting the meal type...';
  int get totalKcal => data?.kcal ?? 0;
  String get mealDescription => data?.description ?? 'Getting the meal description';
  List<String> get mealIngredientList => data?.ingredients ?? [];
  List <CaloryCount> get calorieCountList => data?.caloryCount ?? [];
  String get mealImage => data?.image ?? 'Getting your meal image...';






  ///---------------<>>>>>> Section : Meal Details API Ended Here



}