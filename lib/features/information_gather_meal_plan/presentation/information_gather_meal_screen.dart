import 'dart:developer';
import 'package:bloodfit/constants/app_constant_text.dart';
import 'package:bloodfit/custom_widgets/custom_elevated_button.dart';
import 'package:bloodfit/custom_widgets/page_indicator.dart';
import 'package:bloodfit/features/information_gather_meal_plan/data/controller/information_gather_meal_screen_controller.dart';
import 'package:bloodfit/features/information_gather_meal_plan/presentation/widgets/select_age/presentation/select_age_screen_widget.dart';
import 'package:bloodfit/features/information_gather_meal_plan/presentation/widgets/select_blood_group/presentation/select_blood_group_screen.dart';
import 'package:bloodfit/features/information_gather_meal_plan/presentation/widgets/select_country/presentation/select_country_widget.dart';
import 'package:bloodfit/features/information_gather_meal_plan/presentation/widgets/select_diet/presentation/select_diet_widget.dart';
import 'package:bloodfit/features/information_gather_meal_plan/presentation/widgets/select_dislike_foods/presentation/select_dislike_foods_widget.dart';
import 'package:bloodfit/features/information_gather_meal_plan/presentation/widgets/select_food_allergies/presentation/select_foood_allergies_widget.dart';
import 'package:bloodfit/features/information_gather_meal_plan/presentation/widgets/select_gender/presentation/select_gender_widget.dart';
import 'package:bloodfit/features/information_gather_meal_plan/presentation/widgets/select_height/presentation/select_height_screen_widget.dart';
import 'package:bloodfit/features/information_gather_meal_plan/presentation/widgets/select_weight/presentation/select_weight_screen.dart';
import 'package:bloodfit/helper/di.dart';
import 'package:bloodfit/helper/logger_util.dart';
import 'package:bloodfit/helper/ui_helpers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../controllers/information_gather_screen_controller.dart';
import '../../../controllers/select_height_screen_controller.dart';
import '../../../controllers/weight_picker_widget_controller.dart';
import '../../../custom_widgets/go_back_widget.dart';
import '../../../gen/colors.gen.dart';

class InformationGatherMealScreen extends StatelessWidget {
  const InformationGatherMealScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final InformationGatherMealPlanController controller = Get.put(
      InformationGatherMealPlanController(),
    );

    InformationGatherMealScreenController igController =
        Get.find<InformationGatherMealScreenController>();

    return Scaffold(
      backgroundColor: AppColors.scaffoldBackgroundColor,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(UIHelper.kDefaulutPadding()),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /// Top bar (Back button only)
              Obx(() {
                return controller.currentIndex.value <= 0
                    ? const SizedBox.shrink()
                    : CustomBackButton(
                        onTap: () {
                          if (controller.currentIndex.value > 0) {
                            controller.previousPage();
                          } else {
                            Get.back();
                          }
                        },
                      );
              }),
              UIHelper.verticalSpace(26.h),

              /// Page Indicators
              PageIndicator(controller: controller),
              UIHelper.verticalSpace(16.h),

              /// PageView section
              Expanded(
                child: PageView(
                  controller: controller.pageController,
                  onPageChanged: controller.updateCurrentIndex,
                  physics: const NeverScrollableScrollPhysics(),
                  children: [
                    SelectBloodGroupWidget(),
                    SelectGenderWidget(),
                    SelectAgeScreenWidgt(),
                    SelectWeightScreen(),
                    SelectHeightScreenWidget(),
                    SelectCountryWidget(),
                    SelectDietWidget(),
                    SelectFooodAllergiesWidget(),
                    SelectDislikeFoodsWidget(),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),

      bottomNavigationBar: Container(
        width: 1.sw,
        height: 100.h,
        padding: EdgeInsets.only(
          left: UIHelper.kDefaulutPadding(),
          right: UIHelper.kDefaulutPadding(),
          bottom: 40.h,
        ),
        decoration: BoxDecoration(color: AppColors.scaffoldBackgroundColor),
        child: Obx(() {
          ///------->>> Listen to toggle value for page status update
          controller.dataUpdated.value;

          final isLastPage =
              controller.currentIndex.value == controller.totalPages - 1;
          final currentIndex = controller.currentIndex.value;

          // Helper function to check if current page data is valid
          bool isCurrentPageDataValid() {
            LoggerUtils.debug("Validating page $currentIndex");

            switch (currentIndex) {
              case 0:
                final bloodGroup = appData.read(kKeyBloodGroup);
                LoggerUtils.debug("Blood Group validation: $bloodGroup");
                return bloodGroup != null && bloodGroup is String;
              case 1:
                final gender = appData.read(kKeyGender);
                LoggerUtils.debug("Gender validation: $gender");
                return gender != null && gender is String;
              case 2:
                final age = appData.read(kKeyUserAge);
                LoggerUtils.debug("Age validation: $age");
                return age != null && age is int && age > 0;
              case 3:
                final weight = appData.read(kKeyUserWeightWithoutUnit);
                LoggerUtils.debug("Weight validation: $weight");

                // Check if weight exists and is a valid number > 0
                if (weight == null) {
                  LoggerUtils.debug("Weight is null - validation failed");
                  return false;
                }
                if (weight is num) {
                  final isValid = weight > 0;
                  LoggerUtils.debug("Weight is num > 0: $isValid");

                  // Get the weight controller to check if user has interacted
                  try {
                    final weightController = Get.find<WeightController>(
                      tag: 'current_weight',
                    );
                    final hasInteracted =
                        weightController.hasUserInteracted.value;
                    LoggerUtils.debug(
                      "User has interacted with weight picker: $hasInteracted",
                    );

                    // Button enabled only if weight is valid AND user has interacted
                    final finalResult = isValid && hasInteracted;
                    LoggerUtils.debug(
                      "Final weight validation result: $finalResult",
                    );
                    return finalResult;
                  } catch (e) {
                    LoggerUtils.error("Error getting weight controller: $e");
                    return isValid; // Fallback to just checking if weight is valid
                  }
                }
                LoggerUtils.debug("Weight is not a number - validation failed");
                return false;
              case 4:
                final height = appData.read(kKeyUserHeightWithoutUnit);
                LoggerUtils.debug("Height validation: $height");

                // Check if height exists and is a valid number > 0
                if (height == null) {
                  LoggerUtils.debug("Height is null - validation failed");
                  return false;
                }
                if (height is num) {
                  final isValid = height > 0;
                  LoggerUtils.debug("Height is num > 0: $isValid");

                  // Get the height controller to check if user has interacted
                  try {
                    final heightController =
                        Get.find<SelectHeightScreenController>(
                          tag: 'select_height_controller',
                        );
                    final hasInteracted =
                        heightController.hasUserInteracted.value;
                    LoggerUtils.debug(
                      "User has interacted with height picker: $hasInteracted",
                    );

                    // Button enabled only if height is valid AND user has interacted
                    final finalResult = isValid && hasInteracted;
                    LoggerUtils.debug(
                      "Final height validation result: $finalResult",
                    );
                    return finalResult;
                  } catch (e) {
                    LoggerUtils.error("Error getting height controller: $e");
                    return isValid; // Fallback to just checking if height is valid
                  }
                }
                LoggerUtils.debug("Height is not a number - validation failed");
                return false;
              case 5:
                final country = appData.read(kKeyUserCountryName);
                LoggerUtils.debug("Country validation: $country");
                return country != null && country is String;
              case 6:
                final diet = appData.read(kKeyUserDietType);
                LoggerUtils.debug("Diet validation: $diet");
                return diet != null && diet is String;
              case 7:
              case 8:
                // For food allergies and dislikes, they might be optional
                LoggerUtils.debug("Food allergies/dislikes - optional");
                return true;
              default:
                LoggerUtils.debug("Default case - validation false");
                return false;
            }
          }

          final isValid = isCurrentPageDataValid();
          final isLoading = igController.isLoading.value;
          final isButtonEnabled = !isLoading && isValid;

          LoggerUtils.debug(
            "Page $currentIndex - IsValid: $isValid, IsLoading: $isLoading, ButtonEnabled: $isButtonEnabled",
          );

          return CustomElevatedButton(
            onTap: isButtonEnabled
                ? () {
                    LoggerUtils.debug("Button tapped on page $currentIndex");

                    if (isLastPage) {
                      log("Information Gathering Completed!");
                      _logAllStoredData();
                      igController.postInformationGatherMealPlanApi();
                    } else {
                      LoggerUtils.debug("Navigating to next page");
                      controller.nextPage();
                    }
                  }
                : null,
            buttonTitle: isLastPage ? "Finish" : "Continue",
            buttonHeight: 60.h,
            buttonColor: isButtonEnabled ? null : Colors.grey[300],
          );
        }),
      ),
    );
  }

  void _logAllStoredData() {
    LoggerUtils.debug(
      "Blood Group from Storage : ${appData.read(kKeyBloodGroup)}",
    );
    LoggerUtils.debug(
      "Gender Group from Storage : ${appData.read(kKeyGender)}",
    );
    LoggerUtils.debug("User Age from Storage : ${appData.read(kKeyUserAge)}");
    LoggerUtils.debug(
      "User Weight from Storage with Unit: ${appData.read(kKeyUserWeight)}",
    );
    LoggerUtils.debug(
      "User Weight from Storage without Unit: ${appData.read(kKeyUserWeightWithoutUnit)}",
    );
    LoggerUtils.debug(
      "User Height from Storage with Unit: ${appData.read(kKeyUserHeight)}",
    );
    LoggerUtils.debug(
      "User Height from Storage without Unit: ${appData.read(kKeyUserHeightWithoutUnit)}",
    );
    LoggerUtils.debug(
      "User Country Name: ${appData.read(kKeyUserCountryName)}",
    );
    LoggerUtils.debug(
      "User DietType from Storage: ${appData.read(kKeyUserDietType)}",
    );
    LoggerUtils.debug(
      "User Food Allergies List from Storage: ${appData.read(kKeyUserFoodAlergisList)}",
    );
    LoggerUtils.debug(
      "User Food DisLike List from Storage: ${appData.read(kKeyUserDislLikeFoodList)}",
    );
  }
}
