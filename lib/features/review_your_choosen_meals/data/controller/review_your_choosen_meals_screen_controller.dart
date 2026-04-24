import 'package:bloodfit/features/choose_from_our_suggested_meals/data/controller/choose_from_our_suggested_meal_controller.dart';
import 'package:bloodfit/features/choose_from_our_suggested_meals/data/model/ai_suggested_meals_model.dart';
import 'package:bloodfit/features/choose_from_our_suggested_meals/data/model/recent_chosen_meals_model.dart';
import 'package:bloodfit/features/choose_from_our_suggested_meals/data/repository/create_meal_plan_repository.dart';
import 'package:bloodfit/features/home/data/controller/home_screen_controller.dart';
import 'package:bloodfit/helper/logger_util.dart';
import 'package:get/get.dart';


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

    // Helper: search AI meal lists by id for the given meal type
    HealthyComforting? findAiMeal(String mealId, String mealType) {
      List<HealthyComforting> allMeals = [];
      if (mealType == 'breakfast') {
        allMeals = [
          ...chooseFromOurSuggestedMealController!.breakfastProteinPackedMeals,
          ...chooseFromOurSuggestedMealController!.breakfastLightAndFreshMeals,
          ...chooseFromOurSuggestedMealController!.breakfastHealthyAndComfortingMeals,
        ];
      } else if (mealType == 'lunch') {
        allMeals = [
          ...chooseFromOurSuggestedMealController!.lunchProteinPackedMeals,
          ...chooseFromOurSuggestedMealController!.lunchLightAndFreshMeals,
          ...chooseFromOurSuggestedMealController!.lunchHealthyAndComfortingMeals,
        ];
      } else if (mealType == 'dinner') {
        allMeals = [
          ...chooseFromOurSuggestedMealController!.dinnerProteinPackedMeals,
          ...chooseFromOurSuggestedMealController!.dinnerLightAndFreshMeals,
          ...chooseFromOurSuggestedMealController!.dinnerHealthyAndComfortingMeals,
        ];
      }
      try {
        return allMeals.firstWhere((m) => m.id == mealId);
      } catch (_) {
        return null;
      }
    }

    // Helper function to build API-ready meal payload from meal ID
    Map<String, dynamic>? buildMealData(String mealId, String mealType) {
      if (mealId.isEmpty) return null;

      // 1. Try AI suggested meals — search by id across all category lists
      final aiMeal = findAiMeal(mealId, mealType);
      if (aiMeal != null) {
        LoggerUtils.debug("✅ [BUILD] Found AI meal: ${aiMeal.mealName} (type: $mealType)");
        return {
          'mealName': aiMeal.mealName ?? '',
          'description': aiMeal.description ?? '',
          'serving': aiMeal.numberOfServings ?? 1,
          'ingredients': (aiMeal.ingredients ?? []).map((ing) => {
            'name': ing.name ?? '',
            'quantity': ing.quantity ?? '',
            'icon': ing.icon ?? '',
          }).toList(),
          'caloryCount': [
            {'label': 'Carbs', 'kcal': aiMeal.macronutrients?.carbohydrates ?? 0},
            {'label': 'Protein', 'kcal': aiMeal.macronutrients?.protein ?? 0},
            {'label': 'Fat', 'kcal': aiMeal.macronutrients?.fat ?? 0},
          ],
        };
      }

      // 2. Fall back to previously selected meals — search by id
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
        LoggerUtils.debug("✅ [BUILD] Found previously selected meal: ${meal.mealName} (type: $mealType)");
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
            'kcal': (cal.kcal ?? 0).toInt(),
          }).toList(),
        };
      }

      LoggerUtils.error("❌ [BUILD] Could not resolve meal for mealId: $mealId, type: $mealType");
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
        mealPlanData['breakfastImage'] = _resolveImage(
          chooseFromOurSuggestedMealController!.breakFastMealImage,
          chooseFromOurSuggestedMealController!.selectedBreakfastMealId.value,
          chooseFromOurSuggestedMealController!.breakfastRecentChosenMeals,
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
        mealPlanData['lunchImage'] = _resolveImage(
          chooseFromOurSuggestedMealController!.lunchMealImage,
          chooseFromOurSuggestedMealController!.selectedLunchMealId.value,
          chooseFromOurSuggestedMealController!.lunchRecentChosenMeals,
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
        mealPlanData['dinnerImage'] = _resolveImage(
          chooseFromOurSuggestedMealController!.dinnerMealImage,
          chooseFromOurSuggestedMealController!.selectedDinnerMealId.value,
          chooseFromOurSuggestedMealController!.dinnerRecentChosenMeals,
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

  // Returns the best available image URL for a meal slot.
  // Tries AI image first; if empty, falls back to the previously selected Datum's image.
  String _resolveImage(String aiImage, String mealId, List<Datum> recentMeals) {
    final converted = _convertImageToUrl(aiImage);
    if (converted.isNotEmpty) return converted;

    try {
      final meal = recentMeals.firstWhere((m) => m.id == mealId);
      final fallback = _convertImageToUrl(meal.image ?? '');
      LoggerUtils.debug("⚠️ [IMAGE_RESOLVE] AI image empty, using previously selected meal image: $fallback");
      return fallback;
    } catch (_) {
      LoggerUtils.debug("⚠️ [IMAGE_RESOLVE] No fallback image found for mealId: $mealId");
      return '';
    }
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

        // Refresh today's selected meals on the home screen
        try {
          final homeController = Get.find<HomeScreenController>();
          await homeController.getTodaysSelectedMealsApi();
          LoggerUtils.debug("✅ [API] Home screen meals refreshed");
        } catch (_) {
          LoggerUtils.debug("⚠️ [API] HomeScreenController not available — skipping refresh");
        }
      } else {
        LoggerUtils.error("❌ [API] Failed to create meal plan");
        LoggerUtils.error("❌ [API] Status Code: ${response.statusCode}");
        LoggerUtils.error("❌ [API] Error: ${response.errorMessage}");
        
        // Set error message with fallback
        final errorMsg = response.errorMessage?.toString() ?? 'Failed to create meal plan. Please try again.';
        mealCreatingErrorMessage.value = errorMsg.isEmpty 
            ? 'Failed to create meal plan. Please try again.' 
            : errorMsg;
      }
    } catch (error) {
      LoggerUtils.error("❌ [API] Exception in postCreateMealPlanApi: $error");
      LoggerUtils.error("❌ [API] Error type: ${error.runtimeType}");
      mealCreatingErrorMessage.value = error.toString().isEmpty 
          ? 'An unexpected error occurred. Please try again.' 
          : error.toString();
    } finally {
      isMealCreating.value = false;
      LoggerUtils.debug("🏁 [API] postCreateMealPlanApi() completed");
    }
  }

  ///--------->>>> Section : Create Meal Plan Api Ends Here
}
