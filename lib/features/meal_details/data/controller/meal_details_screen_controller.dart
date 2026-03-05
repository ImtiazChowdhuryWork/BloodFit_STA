import 'package:bloodfit/features/choose_from_our_suggested_meals/data/model/meal_data_model.dart';
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
  Rxn<MealDataModel> directMealDataModel = Rxn<MealDataModel>();
  RxBool hasDirectMealData = false.obs;
  
  void setDirectMealData(MealDataModel data) {
    directMealDataModel.value = data;
    hasDirectMealData.value = true;
    LoggerUtils.debug("✅ Received direct meal data: ${data.mealName}");
  }
  
  void clearDirectMealData() {
    directMealDataModel.value = null;
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




  String get mealName {
    if (hasDirectMealData.value) {
      return directMealDataModel.value?.mealName ?? 'Getting meal name...';
    }
    return data?.mealName ?? 'Getting meal name...';
  }
  
  String get mealType {
    if (hasDirectMealData.value) {
      return directMealDataModel.value?.mealType ?? 'Getting the meal type...';
    }
    return data?.mealType ?? 'Geting the meal type...';
  }
  
  int get totalKcal {
    if (hasDirectMealData.value) {
      return directMealDataModel.value?.totalCalories ?? 0;
    }
    return data?.kcal ?? 0;
  }
  
  String get mealDescription {
    if (hasDirectMealData.value) {
      return directMealDataModel.value?.description ?? 'Getting the meal description';
    }
    return data?.description ?? 'Getting the meal description';
  }
  
  List<Ingredient> get mealIngredientList {
    if (hasDirectMealData.value) {
      final ingredients = directMealDataModel.value?.ingredients ?? [];
      return ingredients.map((ing) => Ingredient(
        name: ing.name,
        quantity: ing.quantity,
        icon: ing.icon,
      )).toList();
    }
    return data?.ingredients ?? [];
  }
  
  List<CaloryCount> get calorieCountList {
    if (hasDirectMealData.value) {
      final macros = directMealDataModel.value?.macronutrients;
      return [
        CaloryCount(label: 'Carbs', kcal: macros?.carbohydrates ?? 0),
        CaloryCount(label: 'Protein', kcal: macros?.protein ?? 0),
        CaloryCount(label: 'Fat', kcal: macros?.fat ?? 0),
      ];
    }
    return data?.caloryCount ?? [];
  }
  
  String get mealImage {
    if (hasDirectMealData.value) {
      return directMealDataModel.value?.image ?? 'Getting your meal image...';
    }
    return data?.image ?? 'Getting your meal image...';
  }
  
  /// Check if the current meal image is base64
  bool get isMealImageBase64 {
    if (hasDirectMealData.value) {
      // For direct meal data from AI suggested meals, the image is base64
      final image = directMealDataModel.value?.image ?? '';
      if (image.isEmpty) return false;
      if (image.startsWith('data:image')) return true;
      if (image.startsWith('http://') || image.startsWith('https://')) return false;
      final cleanPath = image.contains(',') ? image.split(',').last : image;
      return RegExp(r'^[A-Za-z0-9+/=]+$').hasMatch(cleanPath);
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
      
      final mealData = directMealDataModel.value;
      if (mealData == null) {
        LoggerUtils.error("❌ Direct meal data is null");
        mealDetailsErrorMessage.value = "No meal data available";
        return;
      }
      
      /// Create a MealDetailsModel from MealDataModel
      final directModel = MealDetailsModel(
        success: true,
        status: 200,
        message: 'Success',
        data: Data(
          mealName: mealData.mealName,
          mealType: mealData.mealType,
          kcal: mealData.totalCalories,
          description: mealData.description,
          image: mealData.image,
          serving: mealData.numberOfServings,
          ingredients: mealData.ingredients.map((ing) => Ingredient(
            name: ing.name,
            quantity: ing.quantity,
            icon: ing.icon,
          )).toList(),
          caloryCount: [
            CaloryCount(
              label: 'Carbs',
              kcal: mealData.macronutrients.carbohydrates,
            ),
            CaloryCount(
              label: 'Protein',
              kcal: mealData.macronutrients.protein,
            ),
            CaloryCount(
              label: 'Fat',
              kcal: mealData.macronutrients.fat,
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