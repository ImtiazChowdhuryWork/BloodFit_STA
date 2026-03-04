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

  ///---------------<>>>>>> Section : Direct Meal Data (from AI suggested meals)
  RxMap directMealData = {}.obs;
  RxBool hasDirectMealData = false.obs;
  
  void setDirectMealData(Map<String, dynamic> data) {
    directMealData.value = data;
    hasDirectMealData.value = true;
    LoggerUtils.debug("✅ Received direct meal data: ${data['mealName']}");
  }
  
  void clearDirectMealData() {
    directMealData.value = {};
    hasDirectMealData.value = false;
  }

  Future<void> getMealDetailsApi()async{
    /// If we have direct meal data, use it instead of calling API
    if (hasDirectMealData.value) {
      LoggerUtils.debug("📦 Using direct meal data instead of API call");
      _populateFromDirectMealData();
      isMealDetailsLoading.value = false;
      return;
    }

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




  String get mealName => data?.mealName ?? 'Getting meal name...';
  String get mealType => data?.mealType ?? 'Geting the meal type...';
  int get totalKcal => data?.kcal ?? 0;
  String get mealDescription => data?.description ?? 'Getting the meal description';
  List<Ingredient> get mealIngredientList => data?.ingredients ?? [];
  List <CaloryCount> get calorieCountList => data?.caloryCount ?? [];
  String get mealImage => data?.image ?? 'Getting your meal image...';
  
  /// Check if the current meal image is base64
  bool get isMealImageBase64 {
    if (hasDirectMealData.value) {
      // For direct meal data from AI suggested meals, the image is base64
      return true;
    }
    // For API data (Previously Selected Meals), check the image format
    final image = data?.image ?? '';
    if (image.startsWith('data:image')) return true;
    if (image.startsWith('http://') || image.startsWith('https://')) return false;
    final cleanPath = image.contains(',') ? image.split(',').last : image;
    return RegExp(r'^[A-Za-z0-9+/=]+$').hasMatch(cleanPath);
  }


  ///---------------<>>>>>> Section : Helper method to populate data from direct meal data
  void _populateFromDirectMealData() {
    try {
      LoggerUtils.debug("🔄 Populating meal details from direct data...");
      
      final ingredientsData = directMealData['ingredients'] as List<dynamic>? ?? [];
      final macronutrientsData = directMealData['macronutrients'] as Map<String, dynamic>? ?? {};
      
      /// Create a fake MealDetailsModel from direct data
      final directModel = MealDetailsModel(
        success: true,
        status: 200,
        message: 'Success',
        data: Data(
          id: directMealData['id'] ?? '',
          mealName: directMealData['mealName'] ?? '',
          mealType: directMealData['mealType'] ?? '',
          kcal: directMealData['totalCalories'] ?? 0,
          description: directMealData['description'] ?? '',
          image: directMealData['image'] ?? '',
          serving: directMealData['numberOfServings'] ?? 1,
          ingredients: ingredientsData.map((ing) => Ingredient(
            name: ing['name'] ?? '',
            quantity: ing['quantity'] ?? '',
            icon: ing['icon'] ?? '',
          )).toList(),
          caloryCount: [
            CaloryCount(
              label: 'Carbs',
              kcal: macronutrientsData['carbohydrates'] ?? 0,
            ),
            CaloryCount(
              label: 'Protein',
              kcal: macronutrientsData['protein'] ?? 0,
            ),
            CaloryCount(
              label: 'Fat',
              kcal: macronutrientsData['fat'] ?? 0,
            ),
          ],
        ),
      );
      
      mealDetailsModel.value = directModel;
      LoggerUtils.debug("✅ Meal details populated from direct data successfully");
    } catch (e) {
      LoggerUtils.error("❌ Error populating from direct meal data: $e");
      mealDetailsErrorMessage.value = "Failed to load meal details";
    }
  }

  ///---------------<>>>>>> Section : Meal Details API Ended Here



}