import 'package:bloodfit/features/choose_from_our_suggested_meals/data/model/meal_data_model.dart';
import 'package:bloodfit/features/meal_details/data/model/generate_meal_image_model.dart';
import 'package:bloodfit/features/meal_details/data/repository/generate_meal_image_repository.dart';
import 'package:bloodfit/features/meal_details/data/repository/meal_details_repository.dart';
import 'package:bloodfit/helper/logger_util.dart';
import 'package:bloodfit/networks/network_response.dart';
import 'package:get/get.dart';

import '../model/has_meal_image_model.dart';
import '../model/meal_details_model.dart';
import '../repository/has_meal_image_api_repository.dart';

class MealDetailsScreenController extends GetxController{

  ///-----------<>>> Section : Importing the repositories
  final MealDetailsRepository _mealDetailsRepository;

  ///-----------<>>>> Section : Importing the Generate Image Repository
  final GenerateMealImageRepository _generateMealImageRepository;


  ///-----------<>>>>> Section : Importing Has Selected Meal Dedicated Image Checking Repository
  final HasMealImageApiRepository _hasMealImageApiRepository;

  MealDetailsScreenController(this._mealDetailsRepository, this._generateMealImageRepository, this._hasMealImageApiRepository);


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
        
        // Log the fetched image URL
        final fetchedImageUrl = mealDetailsModel.value?.data?.image ?? 'NULL';
        LoggerUtils.debug("🖼️ Fetched Meal Image URL: $fetchedImageUrl");
        LoggerUtils.debug("📋 Full Meal Data: ${response.jsonResponse}");
        
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
    // If image has been generated, return the generated image
    if (hasGeneratedImage.value && generatedMealImageLink.value.isNotEmpty) {
      return generatedMealImageLink.value;
    }
    if (hasDirectMealData.value) {
      return directMealDataModel.value?.image ?? '';
    }
    return data?.image ?? '';
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
  ///
  ///
  ///---------------<>>>>>> Section : Generate Meal Image Api Start Here
  ///
  Rxn<GenerateMealImageModel> generateMealImageModel = Rxn<GenerateMealImageModel>();
  RxString generatedMealImageLink = ''.obs;
  RxBool hasGeneratedImage = false.obs;

  RxBool isMealImageGenerating = false.obs;
  RxString generateMealImageErrorMessage = ''.obs;
  void clearGenerateMealImageErrorMessage(){
    generateMealImageErrorMessage.value = '';
  }

  Future<void> postGenerateMealImageApi()async{
    try{
      isMealImageGenerating.value = true;
      clearGenerateMealImageErrorMessage();
      LoggerUtils.debug("Generating Meal Image Started...");

      // Resolve mealId: prefer the explicit mealID (from API-fetched meals),
      // fall back to the mealId embedded in direct meal data (AI suggested meals).
      final effectiveMealId = mealID.value.isNotEmpty
          ? mealID.value
          : directMealDataModel.value?.mealId ?? '';
      LoggerUtils.debug("🎯 [GENERATE IMAGE] Using mealId: '$effectiveMealId'");

      final response = await _generateMealImageRepository.generateMealIamgeRepository(
        title: mealName,
        description: mealDescription,
        ingredientList: mealIngredientList.map((e) => e.name ?? '').toList(),
        mealId: effectiveMealId,
      );

      LoggerUtils.debug("Response Status Code : ${response.statusCode}");

      if(response.statusCode == 200 && response.isSuccess){
        LoggerUtils.debug("Successfully Generated Meal Image!");

        generateMealImageModel.value = GenerateMealImageModel.fromJson(response.jsonResponse!);
        
        // Log the generate image response
        LoggerUtils.debug("📸 Generate Image Response: ${response.jsonResponse}");
        LoggerUtils.debug("📸 Generated Image Base64: ${generateMealImageModel.value?.data?.mealImageBase64 ?? 'NULL'}");

        // Check if API returned the image
        final imageBase64 = generateMealImageModel.value?.data?.mealImageBase64;
        final hasImageData = imageBase64 != null && imageBase64.isNotEmpty;
        
        if (hasImageData) {
          // API returned image data - use it directly
          generatedMealImageLink.value = imageBase64!.startsWith('data:image')
              ? imageBase64
              : 'data:image/png;base64,$imageBase64';
          hasGeneratedImage.value = true;
          LoggerUtils.debug("✅ Generated image displayed from API response");
        } else {
          // No inline image — fetch from has-meal-image endpoint
          LoggerUtils.debug("🔄 No inline image in response, fetching from has-meal-image API...");
          await getHasMealImageApi();
        }

        LoggerUtils.debug("✅ Generated image swapped successfully!");

      }else{
        generateMealImageErrorMessage.value = response.errorMessage.toString();
        LoggerUtils.error("Failed to Generate Meal Image : Error Code : ${response.statusCode}");
        LoggerUtils.error("Error Message : ${response.errorMessage}");
      }

    }catch(error){
      generateMealImageErrorMessage.value = error.toString();
      LoggerUtils.error("Error Caught While Generating Meal Image!");
      LoggerUtils.error("Generate Meal Image Caught Error : $error");
    }finally{
      isMealImageGenerating.value = false;
      LoggerUtils.debug("Is Meal Image Generating : ${isMealImageGenerating.value}");
    }

  }

  ///---------------<>>>>>> Section : Generate Meal Image Api Ends Here
  ///
  ///
  ///---------------<>>>>>> Section : Has Meals Image Checker Api Starts Here

  Rxn<HasMealImageModel> hasMealImageModel = Rxn<HasMealImageModel>();
  RxBool hasMealImageDataLoading = false.obs;
  RxBool hasMealImageApiError = false.obs;
  RxString hasMealIamgeApiErrorMessage = ''.obs;

  void clearHasMealIamgeApiErrorMessage(){
    hasMealIamgeApiErrorMessage.value = '';
  }

  bool get isGeneratedImageBase64 {
    final link = generatedMealImageLink.value;
    if (link.isEmpty) return false;
    return link.startsWith('data:image') ||
        link.startsWith('iVBORw0KGgo') ||
        link.startsWith('/9j/') ||
        link.startsWith('R0lGOD');
  }

  Future<void> getHasMealImageApi() async {
    final effectiveMealId = mealID.value.isNotEmpty
        ? mealID.value
        : directMealDataModel.value?.mealId ?? '';

    if (effectiveMealId.isEmpty) {
      LoggerUtils.debug("⚠️ [HAS MEAL IMAGE] No mealId available — skipping API call");
      return;
    }

    try {
      hasMealImageDataLoading.value = true;
      hasMealImageApiError.value = false;
      clearHasMealIamgeApiErrorMessage();

      final response = await _hasMealImageApiRepository.hasMealImageRepository(
        mealId: effectiveMealId,
      );

      LoggerUtils.debug("Has Meals Image Api Received MealID : $effectiveMealId");
      LoggerUtils.debug("Has Meal Image Api Raw Response : ${response.jsonResponse}");

      if (response.statusCode == 200 && response.isSuccess) {
        LoggerUtils.debug("Has Meal Api Hit Successful!");
        hasMealImageModel.value = HasMealImageModel.fromJson(response.jsonResponse!);
        final imgRef = hasMealImageModel.value?.data?.imgRef;
        if (imgRef != null && imgRef.isNotEmpty) {
          generatedMealImageLink.value = imgRef;
          hasGeneratedImage.value = true;
          LoggerUtils.debug("✅ [HAS MEAL IMAGE] Loaded imgRef: $imgRef");
        } else {
          LoggerUtils.debug("ℹ️ [HAS MEAL IMAGE] No imgRef found — meal has no generated image yet");
        }
      } else {
        hasMealImageApiError.value = true;
        hasMealIamgeApiErrorMessage.value = response.errorMessage.toString();
        LoggerUtils.error("Failed to check meal image: ${response.statusCode} — ${response.errorMessage}");
      }
    } catch (error) {
      hasMealImageApiError.value = true;
      hasMealIamgeApiErrorMessage.value = error.toString();
      LoggerUtils.error("🥴🥴🥴🥴🥴Error Caught While checking meal availability of Meal Image!");
      LoggerUtils.error("🤢🤢🤢🤢🤢🤢Has Meal Image Checking Caught Error : $error");
    } finally {
      hasMealImageDataLoading.value = false;
    }
  }


  ///---------------<>>>>>> Section : Has Meals Image Checker Api Ends Here



}