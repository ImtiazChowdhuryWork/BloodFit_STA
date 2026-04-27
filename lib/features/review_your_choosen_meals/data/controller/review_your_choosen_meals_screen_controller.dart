import 'package:bloodfit/features/choose_from_our_suggested_meals/data/controller/choose_from_our_suggested_meal_controller.dart';
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
  /// Uses the exact same data source as the review screen (getSelectedMealsCompleteData)
  /// so what is displayed and what is sent to the API are always identical.
  Map<String, dynamic> buildMealPlanData() {
    LoggerUtils.debug("╔═══════════════════════════════════════════════════════════");
    LoggerUtils.debug("📦 [BUILD] Building meal plan data for API...");
    LoggerUtils.debug("╚═══════════════════════════════════════════════════════════");

    // Use the exact same data the review screen displays
    final selectedMealsData = chooseFromOurSuggestedMealController!.getSelectedMealsCompleteData();

    Map<String, dynamic> mealPlanData = {
      'date': chooseFromOurSuggestedMealController!.selectedDate.value,
      'meals': {},
      'breakfastImage': '',
      'lunchImage': '',
      'dinnerImage': '',
    };

    void addMealToPayload(String mealType, String imageKey) {
      if (!selectedMealsData.containsKey(mealType)) return;

      final displayData = selectedMealsData[mealType]!;

      final mealName = displayData['mealName'] as String? ?? '';
      final description = displayData['description'] as String? ?? '';
      final kcal = displayData['kcal'] as int? ?? 0;
      final image = displayData['image'] as String? ?? '';
      final ingredients = displayData['ingredients'] as List? ?? [];
      final caloryCount = displayData['caloryCount'] as List? ?? [];

      final ingredientList = ingredients.map((ing) {
        if (ing is Map) {
          return {'name': ing['name'] ?? '', 'quantity': ing['quantity'] ?? '', 'icon': ing['icon'] ?? ''};
        }
        return {'name': ing.name ?? '', 'quantity': ing.quantity ?? '', 'icon': ing.icon ?? ''};
      }).toList();

      final caloryCountList = caloryCount.map((cal) {
        if (cal is Map) {
          return {'label': cal['label'] ?? '', 'kcal': cal['kcal'] ?? 0};
        }
        return {'label': cal.label ?? '', 'kcal': (cal.kcal ?? 0).toInt()};
      }).toList();

      LoggerUtils.debug("✅ [BUILD] $mealType => mealName: $mealName");
      LoggerUtils.debug("🔢 [BUILD] $mealType => kcal: $kcal (exactly what review screen shows)");
      LoggerUtils.debug("🔢 [BUILD] $mealType => caloryCount: ${caloryCountList.map((c) => '${c['label']}:${c['kcal']}').join(', ')}");

      mealPlanData['meals'][mealType] = [{
        'mealName': mealName,
        'description': description,
        'serving': 1,
        'kcal': kcal,
        'ingredients': ingredientList,
        'caloryCount': caloryCountList,
      }];

      mealPlanData[imageKey] = _convertImageToUrl(image);
    }

    addMealToPayload('breakfast', 'breakfastImage');
    addMealToPayload('lunch', 'lunchImage');
    addMealToPayload('dinner', 'dinnerImage');

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
