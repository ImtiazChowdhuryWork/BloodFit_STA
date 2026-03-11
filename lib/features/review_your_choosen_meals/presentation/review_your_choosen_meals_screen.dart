import 'dart:developer';

import 'package:bloodfit/features/choose_from_our_suggested_meals/data/controller/choose_from_our_suggested_meal_controller.dart';
import 'package:bloodfit/features/choose_from_our_suggested_meals/data/model/ai_suggested_meals_model.dart' as ai_model;
import 'package:bloodfit/features/choose_from_our_suggested_meals/data/model/meal_data_model.dart';
import 'package:bloodfit/features/choose_from_our_suggested_meals/data/model/recent_chosen_meals_model.dart' as recent_model;
import 'package:bloodfit/features/review_your_choosen_meals/data/controller/review_your_choosen_meals_screen_controller.dart';
import 'package:bloodfit/gen/colors.gen.dart';
import 'package:bloodfit/helper/logger_util.dart';
import 'package:bloodfit/helper/ui_helpers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

import '../../../constants/text_font_style.dart';
import '../../../custom_widgets/custom_elevated_button.dart';
import '../../../custom_widgets/go_back_widget.dart';
import '../../../endpoints.dart';
import '../../../gen/assets.gen.dart';
import '../../../routes/routes.dart';
import '../../../custom_widgets/meal_plan_item_card.dart';
import '../../meal_plan_feature_options/presentation/widgets/show_meal_plan_build_confirmation_bottom_sheet.dart';
import '../../meal_plan_feature_options/presentation/widgets/swap_meal_bottom_sheet.dart';

class ReviewYourChoosenMealsScreen extends StatelessWidget {
  const ReviewYourChoosenMealsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final chooseController = Get.find<ChooseFromOurSuggestedMealController>();
    final reviewController = Get.find<ReviewYourChoosenMealsScreenController>();

    // Get selected meals data
    final selectedMealsData = chooseController.getSelectedMealsCompleteData();

    return Scaffold(
      backgroundColor: AppColors.scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: AppColors.scaffoldBackgroundColor,
        automaticallyImplyLeading: false,
        leading: CustomBackButton(),
        centerTitle: true,
        title: Text(
          "Meal Plan",
          style: TextFontStyle.headline24w700cFFFFFFStylePoppins,
        ),
        actions: [
          InkWell(
            onTap: () {
              Get.toNamed(Routes.notificationScreen);
            },
            child: SvgPicture.asset(Assets.icons.bellIcon),
          ),
          UIHelper.horizontalSpace(15.w),
          InkWell(
            onTap: () {
              Get.toNamed(Routes.myProfileScreen);
            },
            child: Container(
              width: 48.w,
              height: 48.h,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: AppColors.cFFFFFF),
                image: DecorationImage(
                  fit: BoxFit.cover,
                  image: AssetImage(Assets.images.userImage.path),
                ),
              ),
            ),
          ),
          UIHelper.horizontalSpace(UIHelper.kDefaulutPadding()),
        ],
      ),
      body: SafeArea(
        child: SafeArea(
          child: SingleChildScrollView(
            padding: EdgeInsets.all(UIHelper.kDefaulutPadding()),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Review Your Chosen Meals",
                  style: TextFontStyle.headline20w500cfefefeStylePoppins,
                ),
                UIHelper.verticalSpace(24.h),

                ///Section : ---------///Review Meal Items///------
                ListView.separated(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: selectedMealsData.length,
                  separatorBuilder: (context, index) =>
                      UIHelper.verticalSpace(24.h),
                  itemBuilder: (context, index) {
                    final mealType = selectedMealsData.keys.elementAt(index);
                    final mealData = selectedMealsData[mealType]!;

                    final mealName = mealData['mealName'] as String;
                    final kcal = mealData['kcal'] as int;
                    final imageUrl = mealData['image'] as String;
                    final hasId = mealData['hasId'] as bool;
                    final id = mealData['id'] as String?;

                    // Check if image is base64
                    final isBase64 = imageUrl.startsWith('data:image') ||
                                    imageUrl.startsWith('iVBORw0KGgo') ||
                                    imageUrl.startsWith('/9j/');

                    // Resolve image URL (handle normal URLs and base64)
                    String resolvedImageUrl = isBase64 ? imageUrl : _convertImageToUrl(imageUrl);
                    
                    return MealPlanItemCard(
                      isMealEaten: false,
                      leftButtonTitle: "Details",
                      leftButtonOnTap: () {
                        log("Button Taped : Details");
                        
                        // Create MealDataModel from the selected meal data
                        final mealDataModel = _createMealDataModel(
                          mealData: mealData,
                          mealType: mealType,
                          mealId: id,
                          hasId: hasId,
                        );
                        
                        LoggerUtils.debug("✅ [REVIEW] Created MealDataModel with:");
                        LoggerUtils.debug("   • mealName: ${mealDataModel.mealName}");
                        LoggerUtils.debug("   • mealType: ${mealDataModel.mealType}");
                        LoggerUtils.debug("   • mealId: ${mealDataModel.mealId}");
                        
                        // Pass the model to the details screen with hideSelectButton flag
                        Get.toNamed(
                          Routes.mealDetailscreen,
                          arguments: {
                            'mealData': mealDataModel,
                            'hideSelectButton': true, // Hide select/deselect button when coming from review screen
                          },
                        );
                      },
                      rightButtonOnTap: () {
                        log("Button Taped : Remove");
                        showSwapMealBottomSheet();
                      },
                      kcalValue: kcal,
                      mealType: mealType,
                      mealTitle: mealName,
                      rightButtonTitle: "Remove",
                      rightButtonBorderColor: AppColors.cb20000,
                      isLeftButtonBorderUsed: true,
                      leftButtonBorderWidth: 1.5.sp,
                      leftButtonBorderColor: AppColors.cc6c6c6,
                      leftButtonColor: AppColors.c262626,
                      mealImagePath: resolvedImageUrl,
                      isImageLinkBase64: isBase64,
                    );
                  },
                ),

                UIHelper.verticalSpace(32.h),

                ///Section : -----------///Button -> Confirm Meal Plan///------------
                Obx(() {
                  final isLoading = reviewController.isMealCreating.value;
                  final hasError = reviewController.mealCreatingErrorMessage.value.isNotEmpty;
                  
                  return CustomElevatedButton(
                    onTap: isLoading ? null : () async {
                      log("Button Taped -> Confirm Mealplan");
                      
                      // Show loading indicator
                      Get.dialog(
                        Center(
                          child: Container(
                            width: 100.w,
                            height: 100.h,
                            decoration: BoxDecoration(
                              color: Colors.black87,
                              borderRadius: BorderRadius.circular(12.r),
                            ),
                            child: const Center(
                              child: CircularProgressIndicator(
                                color: Color(0xFFB20000),
                              ),
                            ),
                          ),
                        ),
                        barrierDismissible: false,
                      );

                      // Call the API from review controller
                      await reviewController.postCreateMealPlanApi();

                      // Close loading dialog
                      if (Get.isDialogOpen ?? false) {
                        Get.back();
                      }

                      // Check if API was successful
                      if (reviewController.mealCreatingErrorMessage.value.isEmpty) {
                        LoggerUtils.debug("✅ [REVIEW SCREEN] Meal plan created successfully!");
                        
                        // Show success bottom sheet
                        showMealPlanBuildConfirmationBottomSheet();
                      } else {
                        LoggerUtils.error("❌ [REVIEW SCREEN] Error: ${reviewController.mealCreatingErrorMessage.value}");
                        
                        // Show error snackbar
                        Get.snackbar(
                          'Error',
                          reviewController.mealCreatingErrorMessage.value,
                          snackPosition: SnackPosition.BOTTOM,
                          backgroundColor: Colors.red,
                          colorText: Colors.white,
                        );
                      }
                    },
                    buttonWidth: 1.sw,
                    buttonHeight: 52.h,
                    borderRadius: 24.r,
                    buttonTitle: isLoading ? "Creating..." : "Confirm Mealplan",
                  );
                }),
                UIHelper.verticalSpace(32.h),
              ],
            ),
          ),
        ),
      ),
    );
  }
  
  /// Helper method to convert image to URL (handles base64, relative paths, etc.)
  String _convertImageToUrl(String imageData) {
    if (imageData.isEmpty) {
      return defaultMealImage;
    }
    
    // If it's already a URL (starts with http), return as is
    if (imageData.startsWith('http://') || imageData.startsWith('https://')) {
      return imageData;
    }
    
    // If it's base64 data (starts with "data:image" or looks like base64), return AS-IS
    // Base64 typically starts with iVBORw0KGgo... for PNG or /9j/... for JPEG
    // We need to pass base64 directly to MealDataModel for the details screen to handle
    if (imageData.startsWith('data:image') || 
        imageData.startsWith('iVBORw0KGgo') || 
        imageData.startsWith('/9j/')) {
      return imageData; // Return base64 as-is, don't convert to default image
    }
    
    // If it's a relative path (starts with /), concatenate with base URL
    if (imageData.startsWith('/')) {
      return 'https://faisal5000.merinasib.shop$imageData';
    }
    
    // Otherwise, assume it's already a path and concatenate
    return 'https://faisal5000.merinasib.shop/$imageData';
  }
  
  /// Helper method to create MealDataModel from selected meal data
  MealDataModel _createMealDataModel({
    required Map<String, dynamic> mealData,
    required String mealType,
    required String? mealId,
    required bool hasId,
  }) {
    final mealName = mealData['mealName'] as String;
    final description = mealData['description'] as String;
    final kcal = mealData['kcal'] as int;
    final ingredients = mealData['ingredients'] as List;
    final caloryCount = mealData['caloryCount'] as List;
    final imageUrl = mealData['image'] as String;
    
    LoggerUtils.debug("🖼️ [REVIEW IMAGE] Creating MealDataModel for: $mealName");
    LoggerUtils.debug("🖼️ [REVIEW IMAGE] Original imageUrl: ${imageUrl.length > 50 ? '${imageUrl.substring(0, 50)}...' : imageUrl}");
    LoggerUtils.debug("🖼️ [REVIEW IMAGE] hasId: $hasId, mealType: $mealType");

    // Resolve image URL
    final resolvedImageUrl = _convertImageToUrl(imageUrl);
    
    LoggerUtils.debug("🖼️ [REVIEW IMAGE] Resolved imageUrl: ${resolvedImageUrl.length > 50 ? '${resolvedImageUrl.substring(0, 50)}...' : resolvedImageUrl}");
    
    // Convert ingredients to MealIngredientData list
    List<MealIngredientData> ingredientList = [];
    if (ingredients.isNotEmpty) {
      ingredientList = ingredients.map((ing) {
        if (ing is ai_model.Ingredient) {
          // AI meal ingredient
          return MealIngredientData(
            name: ing.name ?? '',
            quantity: ing.quantity ?? '',
            icon: ing.icon ?? '',
          );
        } else if (ing is recent_model.Ingredient) {
          // Previously selected meal ingredient
          return MealIngredientData(
            name: ing.name ?? '',
            quantity: ing.quantity ?? '',
            icon: ing.icon ?? '',
          );
        } else if (ing is Map) {
          // Fallback: Map data
          return MealIngredientData(
            name: ing['name'] ?? '',
            quantity: ing['quantity'] ?? '',
            icon: ing['icon'] ?? '',
          );
        }
        return MealIngredientData(name: '', quantity: '', icon: '');
      }).toList();
    }
    
    // Convert caloryCount to MealMacronutrientsData
    MealMacronutrientsData macronutrients = MealMacronutrientsData(
      carbohydrates: _getMacroValue(caloryCount, 'Carbs'),
      protein: _getMacroValue(caloryCount, 'Protein'),
      fat: _getMacroValue(caloryCount, 'Fat'),
    );
    
    return MealDataModel(
      mealName: mealName,
      mealType: mealType.toLowerCase(),
      totalCalories: kcal,
      description: description,
      ingredients: ingredientList,
      macronutrients: macronutrients,
      numberOfServings: 1,
      image: resolvedImageUrl,
      mealId: hasId ? mealId : null, // Only set mealId for previously selected meals
    );
  }
  
  int _getMacroValue(List caloryCount, String label) {
    try {
      final macro = caloryCount.firstWhere(
        (item) => item['label'] == label,
        orElse: () => {'kcal': 0},
      );
      return macro['kcal'] ?? 0;
    } catch (e) {
      return 0;
    }
  }
}
