import 'package:bloodfit/features/choose_from_our_suggested_meals/data/controller/choose_from_our_suggested_meal_controller.dart';
import 'package:bloodfit/features/choose_from_our_suggested_meals/data/model/ai_suggested_meals_model.dart';
import 'package:bloodfit/features/choose_from_our_suggested_meals/data/model/recent_chosen_meals_model.dart';
import 'package:bloodfit/features/choose_from_our_suggested_meals/data/repository/create_meal_plan_repository.dart';
import 'package:bloodfit/helper/logger_util.dart';
import 'package:get/get.dart';

import '../../../../endpoints.dart';

class ReviewYourChoosenMealsScreenController extends GetxController {
  /// Repository for creating meal plan
  final CreateMealPlanRepository _createMealPlanRepository;

  /// Reference to the main controller for accessing selected meals data
  ChooseFromOurSuggestedMealController? chooseFromOurSuggestedMealController;

  ReviewYourChoosenMealsScreenController(this._createMealPlanRepository);

  /// Loading state for meal creation
  RxBool isMealCreating = false.obs;
  RxString mealCreatingErrorMessage = ''.obs;

  void clearMealCreatingErrorMessage() {
    mealCreatingErrorMessage.value = '';
  }

  @override
  void onInit() {
    super.onInit();
    // Get reference to the main controller
    chooseFromOurSuggestedMealController = Get.find<ChooseFromOurSuggestedMealController>();
    LoggerUtils.debug("✅ ReviewYourChoosenMealsScreenController initialized");
  }

  ///--------->>>> Section : Build Meal Plan Data for API
  /// This method builds the meal plan data structure from selected meals
  Map<String, dynamic> buildMealPlanData() {
    LoggerUtils.debug("╔═══════════════════════════════════════════════════════════");
    LoggerUtils.debug("📦 [BUILD] Building meal plan data for API...");
    LoggerUtils.debug("╚═══════════════════════════════════════════════════════════");

    Map<String, dynamic> mealPlanData = {
      'date': chooseFromOurSuggestedMealController!.selectedDate.value,
      'meals': {},
      'breakfastImage': '',
      'lunchImage': '',
      'dinnerImage': '',
    };

    // Helper function to build meal data from meal ID
    Map<String, dynamic>? buildMealData(String mealId, String mealType) {
      if (mealId.isEmpty) return null;

      // Check if it's an AI suggested meal (format: "type_category_index")
      if (mealId.contains('_')) {
        final parts = mealId.split('_');
        if (parts.length >= 3) {
          final type = parts[0]; // breakfast, lunch, dinner
          final category = parts[1]; // Protein-Packed, Light-Fresh, Healthy-Comforting
          final index = int.tryParse(parts[2]) ?? -1;

          if (index >= 0) {
            // Get meal from AI suggested meals
            HealthyComforting? meal;
            String baseImageUrl = '';

            if (type == 'breakfast') {
              final categoryList = _getBreakfastCategoryList(category);
              if (index < categoryList.length) {
                meal = categoryList[index];
                baseImageUrl = chooseFromOurSuggestedMealController!.breakFastMealImage;
              }
            } else if (type == 'lunch') {
              final categoryList = _getLunchCategoryList(category);
              if (index < categoryList.length) {
                meal = categoryList[index];
                baseImageUrl = chooseFromOurSuggestedMealController!.lunchMealImage;
              }
            } else if (type == 'dinner') {
              final categoryList = _getDinnerCategoryList(category);
              if (index < categoryList.length) {
                meal = categoryList[index];
                baseImageUrl = chooseFromOurSuggestedMealController!.dinnerMealImage;
              }
            }

            if (meal != null) {
              // Convert image to URL (handles base64, relative paths, etc.)
              final imageUrl = _convertImageToUrl(baseImageUrl);

              LoggerUtils.debug("🖼️ [IMAGE] AI Meal - Type: $type, Category: $category, Index: $index");
              LoggerUtils.debug("🖼️ [IMAGE] AI Meal - Base Image URL: ${baseImageUrl.length > 50 ? '${baseImageUrl.substring(0, 50)}...' : baseImageUrl}");
              LoggerUtils.debug("🖼️ [IMAGE] AI Meal - Final Image URL: $imageUrl");

              final mealMap = <String, dynamic>{
                'mealName': meal.mealName ?? '',
                'description': meal.description ?? '',
                'serving': meal.numberOfServings ?? 1,
                'ingredients': (meal.ingredients ?? []).map((ing) => {
                  'name': ing.name ?? '',
                  'quantity': ing.quantity ?? '',
                  'icon': ing.icon ?? '',
                }).toList(),
                'caloryCount': [
                  {'label': 'Carbs', 'kcal': meal.macronutrients?.carbohydrates ?? 0},
                  {'label': 'Protein', 'kcal': meal.macronutrients?.protein ?? 0},
                  {'label': 'Fat', 'kcal': meal.macronutrients?.fat ?? 0},
                ],
                'image': imageUrl,  // ✅ ALWAYS include image field (backend requires it)
              };

              return mealMap;
            }
          }
        }
      } else {
        // It's a previously selected meal (API ID format)
        // Fetch from recently chosen meals
        Datum? meal;

        if (mealType == 'breakfast') {
          meal = chooseFromOurSuggestedMealController!.breakfastRecentChosenMeals.firstWhere(
            (m) => m.id == mealId,
            orElse: () => Datum(),
          );
        } else if (mealType == 'lunch') {
          meal = chooseFromOurSuggestedMealController!.lunchRecentChosenMeals.firstWhere(
            (m) => m.id == mealId,
            orElse: () => Datum(),
          );
        } else if (mealType == 'dinner') {
          meal = chooseFromOurSuggestedMealController!.dinnerRecentChosenMeals.firstWhere(
            (m) => m.id == mealId,
            orElse: () => Datum(),
          );
        }

        if (meal != null && meal.id != null) {
          // Get the image from the meal object or use default
          String mealImage = meal.image ?? defaultMealImage;
          if (!mealImage.startsWith('http')) {
            mealImage = 'https://faisal5000.merinasib.shop$mealImage';
          }

          LoggerUtils.debug("🖼️ [IMAGE] Previous Meal - Meal ID: ${meal.id}");
          LoggerUtils.debug("🖼️ [IMAGE] Previous Meal - Original Image: ${meal.image}");
          LoggerUtils.debug("🖼️ [IMAGE] Previous Meal - Final Image URL: $mealImage");

          return {
            'mealName': meal.mealName ?? '',
            'description': meal.description ?? '',
            'serving': meal.serving ?? 1,
            'ingredients': (meal.ingredients ?? []).map((ing) => {
              'name': ing.name ?? '',
              'quantity': ing.quantity ?? '',
              'icon': ing.icon ?? '',
            }).toList(),
            'caloryCount': (meal.caloryCount ?? []).map((cal) => {
              'label': cal.label ?? '',
              'kcal': cal.kcal ?? 0,
            }).toList(),
            'image': mealImage,  // ✅ Add image inside each meal object
          };
        }
      }

      return null;
    }

    // Build breakfast meal data
    if (chooseFromOurSuggestedMealController!.selectedBreakfastMealId.value.isNotEmpty) {
      final mealData = buildMealData(
        chooseFromOurSuggestedMealController!.selectedBreakfastMealId.value,
        'breakfast',
      );
      if (mealData != null) {
        mealPlanData['meals']['breakfast'] = [mealData];
        // Convert base64 image to URL if needed
        mealPlanData['breakfastImage'] = _convertImageToUrl(
          chooseFromOurSuggestedMealController!.breakFastMealImage,
        );
        LoggerUtils.debug("✅ [BUILD] Breakfast meal added: ${mealData['mealName']}");
      }
    }

    // Build lunch meal data
    if (chooseFromOurSuggestedMealController!.selectedLunchMealId.value.isNotEmpty) {
      final mealData = buildMealData(
        chooseFromOurSuggestedMealController!.selectedLunchMealId.value,
        'lunch',
      );
      if (mealData != null) {
        mealPlanData['meals']['lunch'] = [mealData];
        // Convert base64 image to URL if needed
        mealPlanData['lunchImage'] = _convertImageToUrl(
          chooseFromOurSuggestedMealController!.lunchMealImage,
        );
        LoggerUtils.debug("✅ [BUILD] Lunch meal added: ${mealData['mealName']}");
      }
    }

    // Build dinner meal data
    if (chooseFromOurSuggestedMealController!.selectedDinnerMealId.value.isNotEmpty) {
      final mealData = buildMealData(
        chooseFromOurSuggestedMealController!.selectedDinnerMealId.value,
        'dinner',
      );
      if (mealData != null) {
        mealPlanData['meals']['dinner'] = [mealData];
        // Convert base64 image to URL if needed
        mealPlanData['dinnerImage'] = _convertImageToUrl(
          chooseFromOurSuggestedMealController!.dinnerMealImage,
        );
        LoggerUtils.debug("✅ [BUILD] Dinner meal added: ${mealData['mealName']}");
      }
    }

    LoggerUtils.debug("📦 [BUILD] Final meal plan data:");
    LoggerUtils.debug("   • Date: ${mealPlanData['date']}");
    LoggerUtils.debug("   • Breakfast: ${mealPlanData['meals']['breakfast'] != null ? '✅' : '❌'}");
    LoggerUtils.debug("   • Lunch: ${mealPlanData['meals']['lunch'] != null ? '✅' : '❌'}");
    LoggerUtils.debug("   • Dinner: ${mealPlanData['meals']['dinner'] != null ? '✅' : '❌'}");

    LoggerUtils.debug("╔═══════════════════════════════════════════════════════════");

    return mealPlanData;
  }

  /// Checks if image data is base64 encoded
  bool _isBase64(String imageData) {
    if (imageData.startsWith('data:image')) return true;
    if (imageData.startsWith('iVBORw0KGgo')) return true;
    if (imageData.startsWith('/9j/')) return true;
    return false;
  }

  // Helper method to convert image data to a URL or pass base64 through as-is
  String _convertImageToUrl(String imageData) {
    LoggerUtils.debug("🔄 [IMAGE_CONVERT] Input: ${imageData.length > 50 ? '${imageData.substring(0, 50)}...' : imageData}");

    if (imageData.isEmpty) {
      LoggerUtils.debug("⚠️ [IMAGE_CONVERT] Empty input, returning empty");
      return '';
    }

    // If it's already a URL (starts with http), return as is
    if (imageData.startsWith('http://') || imageData.startsWith('https://')) {
      LoggerUtils.debug("✅ [IMAGE_CONVERT] Already a URL, returning as-is");
      return imageData;
    }

    // If it's base64 data, pass it through — the repository will handle saving it as a file
    if (_isBase64(imageData)) {
      LoggerUtils.debug("✅ [IMAGE_CONVERT] Base64 detected, passing through for file upload");
      return imageData;
    }

    // If it's a relative path (starts with /), concatenate with base URL
    if (imageData.startsWith('/')) {
      final imageUrl = 'https://faisal5000.merinasib.shop$imageData';
      LoggerUtils.debug("✅ [IMAGE_CONVERT] Relative path converted: $imageUrl");
      return imageUrl;
    }

    // Otherwise, assume it's already a path and concatenate
    final imageUrl = 'https://faisal5000.merinasib.shop/$imageData';
    LoggerUtils.debug("✅ [IMAGE_CONVERT] Path concatenated: $imageUrl");
    return imageUrl;
  }

  // Helper methods to get category lists
  List<HealthyComforting> _getBreakfastCategoryList(String category) {
    LoggerUtils.debug("🔍 [CATEGORY] Looking for breakfast category: $category");
    if (category.contains('Protein')) {
      LoggerUtils.debug("✅ [CATEGORY] Found Protein-Packed");
      return chooseFromOurSuggestedMealController!.breakfastProteinPackedMeals;
    }
    if (category.contains('Light')) {
      LoggerUtils.debug("✅ [CATEGORY] Found Light-Fresh");
      return chooseFromOurSuggestedMealController!.breakfastLightAndFreshMeals;
    }
    if (category.contains('Healthy') || category.contains('Hearty') || category.contains('Comforting')) {
      LoggerUtils.debug("✅ [CATEGORY] Found Healthy-Comforting/Hearty-Comforting");
      return chooseFromOurSuggestedMealController!.breakfastHealthyAndComfortingMeals;
    }
    LoggerUtils.debug("⚠️ [CATEGORY] No matching category found");
    return [];
  }

  List<HealthyComforting> _getLunchCategoryList(String category) {
    LoggerUtils.debug("🔍 [CATEGORY] Looking for lunch category: $category");
    if (category.contains('Protein')) {
      LoggerUtils.debug("✅ [CATEGORY] Found Protein-Packed");
      return chooseFromOurSuggestedMealController!.lunchProteinPackedMeals;
    }
    if (category.contains('Light')) {
      LoggerUtils.debug("✅ [CATEGORY] Found Light-Fresh");
      return chooseFromOurSuggestedMealController!.lunchLightAndFreshMeals;
    }
    if (category.contains('Healthy') || category.contains('Hearty') || category.contains('Comforting')) {
      LoggerUtils.debug("✅ [CATEGORY] Found Healthy-Comforting/Hearty-Comforting");
      return chooseFromOurSuggestedMealController!.lunchHealthyAndComfortingMeals;
    }
    LoggerUtils.debug("⚠️ [CATEGORY] No matching category found");
    return [];
  }

  List<HealthyComforting> _getDinnerCategoryList(String category) {
    LoggerUtils.debug("🔍 [CATEGORY] Looking for dinner category: $category");
    if (category.contains('Protein')) {
      LoggerUtils.debug("✅ [CATEGORY] Found Protein-Packed");
      return chooseFromOurSuggestedMealController!.dinnerProteinPackedMeals;
    }
    if (category.contains('Light')) {
      LoggerUtils.debug("✅ [CATEGORY] Found Light-Fresh");
      return chooseFromOurSuggestedMealController!.dinnerLightAndFreshMeals;
    }
    if (category.contains('Healthy') || category.contains('Hearty') || category.contains('Comforting')) {
      LoggerUtils.debug("✅ [CATEGORY] Found Healthy-Comforting/Hearty-Comforting");
      return chooseFromOurSuggestedMealController!.dinnerHealthyAndComfortingMeals;
    }
    LoggerUtils.debug("⚠️ [CATEGORY] No matching category found");
    return [];
  }

  ///--------->>>> Section : Create Meal Plan API
  Future<void> postCreateMealPlanApi() async {
    LoggerUtils.debug("╔═══════════════════════════════════════════════════════════");
    LoggerUtils.debug("🚀 [API] postCreateMealPlanApi() CALLED");
    LoggerUtils.debug("╚═══════════════════════════════════════════════════════════");

    try {
      isMealCreating.value = true;
      clearMealCreatingErrorMessage();

      // Build meal plan data
      final mealPlanData = buildMealPlanData();

      LoggerUtils.debug("📦 [API] Meal plan data built successfully");
      LoggerUtils.debug("📦 [API] Data: $mealPlanData");

      // Call repository with meal plan data
      final response = await _createMealPlanRepository.createMealPlanRepository(mealPlanData);

      if (response.statusCode == 200 && response.isSuccess) {
        LoggerUtils.debug("✅ [API] Meal plan created successfully!");
        LoggerUtils.debug("🎉 [API] Response: ${response.jsonResponse}");
      } else {
        LoggerUtils.error("❌ [API] Failed to create meal plan");
        LoggerUtils.error("❌ [API] Status Code: ${response.statusCode}");
        LoggerUtils.error("❌ [API] Error: ${response.errorMessage}");
        mealCreatingErrorMessage.value = response.errorMessage.toString();
      }
    } catch (error) {
      LoggerUtils.error("❌ [API] Exception in postCreateMealPlanApi: $error");
      LoggerUtils.error("❌ [API] Error type: ${error.runtimeType}");
      mealCreatingErrorMessage.value = error.toString();
    } finally {
      isMealCreating.value = false;
      LoggerUtils.debug("🏁 [API] postCreateMealPlanApi() completed");
    }
  }

  ///--------->>>> Section : Create Meal Plan Api Ends Here
}
