import 'package:bloodfit/constants/app_constant_text.dart';
import 'package:bloodfit/helper/di.dart';
import 'package:get/get.dart';

import '../../../../controllers/select_height_screen_controller.dart';
import '../../../../controllers/weight_picker_widget_controller.dart';
import '../../../../helper/helper_methods.dart';
import '../../../../helper/logger_util.dart';
import '../../../../routes/routes.dart';
import '../repository/information_gather_meal_repository.dart';

class InformationGatherMealScreenController extends GetxController {
  ///------>>> Section : Import Repository
  final InformationGatherMealPlanRepository
  _informationGatherMealPlanRepository;
  InformationGatherMealScreenController(
    this._informationGatherMealPlanRepository,
  );

  ///---------->>> Global Variables
  RxBool isLoading = false.obs;
  RxString errorMessage = ''.obs;
  void clearErrorMessage() {
    errorMessage.value = '';
  }

  ///---------->>> Receive Value from Saved Storage
  RxString bloodGroup = ''.obs;

  RxString gender = ''.obs;

  // RxDouble age = 0.0.obs;
  RxInt ageAtIntValue = 0.obs;

  RxDouble weightAtDoubleValue = 0.0.obs;
  RxInt weightAtIntValue = 0.obs;

  RxDouble heightAtDoubleValue = 0.0.obs;
  RxInt heightAtIntValue = 0.obs;

  RxString diet = ''.obs;

  RxList foodAlergiesList = [].obs;

  RxList foodDislikeList = [].obs;

  RxString country = ''.obs;

  ///----> Validator : First Name
  // final firstNameError = firstNameValidator(firstNameController.text);
  // if (firstNameError != null) return firstNameError;

  ///-------->>> Check Selected Blood Group
  String? bloodGroupValidation() {
    String value = appData.read(kKeyBloodGroup);
    if (value == null || value.isEmpty) {
      return '🥲🥲🥲Blood Group Not Found!';
    }
    bloodGroup.value = value;
    LoggerUtils.debug("✍️✍️✍️Blood Group : ${bloodGroup.value}");
    return null;
  }

  ///-------->>> Check Selected Gender
  String? userGenderValidation() {
    String value = appData.read(kKeyGender);
    if (value == null || value.isEmpty) {
      return '🥴🥴🥴User Gender Not Found!';
    }
    gender.value = value;
    LoggerUtils.debug("✍️✍️✍️Gender Group : ${gender.value}");
    return null;
  }

  ///-------->>> Check Selected Age
  String? userAgeValidation() {
    int? value = appData.read(kKeyUserAge);
    if (value == null || value <= 0) {
      return '🥴🥴🥴User Age Not Found!';
    }
    ageAtIntValue.value = value;

    LoggerUtils.debug("✍️✍️✍️User Age : ${ageAtIntValue.value}");
    return null;
  }

  ///-------->>> Check Selected Weight
  String? userWeightValidation() {
    double? value = appData.read(kKeyUserWeightWithoutUnit);
    if (value == null || value <= 0) {
      return '🥴🥴🥴User Weight Not Found!';
    }
    weightAtIntValue.value = value.toInt();
    LoggerUtils.debug("✍️✍️✍️User Weight : ${weightAtIntValue.value}");
    return null;
  }

  ///-------->>> Check Selected Height
  String? userHeightValidation() {
    double? value = appData.read(kKeyUserHeightWithoutUnit);
    if (value == null || value <= 0) {
      return '🥴🥴🥴User Height Not Found!';
    }
    heightAtIntValue.value = value.toInt();
    LoggerUtils.debug("✍️✍️✍️User Height : ${heightAtIntValue.value}");
    return null;
  }

  ///-------->>> Check Selected Country
  String? userCountryValidation() {
    String? value = appData.read(kKeyUserCountryName);
    if (value == null || value.isEmpty) {
      return '🥴🥴🥴User Country Name Not Found!';
    }
    country.value = value;
    LoggerUtils.debug("✍️✍️✍️User Height : ${country.value}");
    return null;
  }

  ///-------->>> Check Selected DietType
  String? userDietTypeValidation() {
    String? value = appData.read(kKeyUserDietType);
    if (value == null || value.isEmpty) {
      return '🥴🥴🥴User Diet Type Not Found!';
    }
    diet.value = value.toLowerCase();
    LoggerUtils.debug("✍️✍️✍️User Height : ${diet.value}");
    return null;
  }

  ///-------->>> Check Selected Food Allergies List
  String? userFoodAllergesListValidation() {
    List<dynamic>? value = appData.read(kKeyUserFoodAlergisList);
    if (value == null) {
      value = []; // Initialize as empty list if null
    }

    foodAlergiesList.value = value.cast<String>();
    LoggerUtils.debug(
      "✍️✍️✍️User Food Allergies List : ${foodAlergiesList.value.toString()}",
    );
    return null;
  }

  ///-------->>> Check Selected Food Dislike List
  String? userDisLikeFoodListValidation() {
    List<dynamic>? value = appData.read(kKeyUserDislLikeFoodList);
    if (value == null) {
      value = []; // Initialize as empty list if null
    }

    foodDislikeList.value = value.cast<String>();
    LoggerUtils.debug(
      "✍️✍️✍️User Dis Like List : ${foodDislikeList.value.toString()}",
    );
    return null;
  }

  ///---------->>> Validate Information Gather Meal Plan
  String? validateInformationGatherMealPlan() {
    ///------->>> Blood Group Error Message
    final bloodGroupError = bloodGroupValidation();
    if (bloodGroupError != null) return bloodGroupError;

    ///-------->>> User Gender Error Message
    final userGenderError = userGenderValidation();
    if (userGenderError != null) return userGenderError;

    ///--------->>> User Age Error Message
    final userAgeError = userAgeValidation();
    if (userAgeError != null) return userAgeError;

    ///-------->>> User weight Error Message
    final userWeightError = userWeightValidation();
    if (userWeightError != null) return userWeightError;

    ///------->>> User Height Error Message
    final userHeightError = userHeightValidation();
    if (userHeightError != null) return userHeightError;

    ///-------->>> User Country Name Error Message
    final userCountryNameError = userCountryValidation();
    if (userCountryNameError != null) return userCountryNameError;

    ///---------->>> User Diet Type Error Message
    final userDietTypeError = userDietTypeValidation();
    if (userDietTypeError != null) return userDietTypeError;

    ///----------->>> User Food Allergies List Error Message
    final userFoodAllergiesListError = userFoodAllergesListValidation();
    // Note: Food allergies are optional, so we don't return an error if the list is empty

    ///----------->>> User Food Dislike List Error Message
    final userFoodDislikeListError = userDisLikeFoodListValidation();
    // Note: Food dislikes are optional, so we don't return an error if the list is empty

    return null;
  }

  Future<void> postInformationGatherMealPlanApi() async {
    clearErrorMessage();

    final validationError = validateInformationGatherMealPlan();
    if (validationError != null) {
      errorMessage.value = validationError;

      LoggerUtils.error(
        "🤬🤬Information Gather Meal Plan -> Validation Error : ${errorMessage.value}",
      );
      return;
    }

    isLoading.value = true;

    LoggerUtils.debug("😺😺😺😺😺Information Father Validation Passed !");

    final response = await _informationGatherMealPlanRepository
        .informationGatherMealPlanRepository(
          bloodGroup: bloodGroup.value,
          gender: gender.value,
          age: ageAtIntValue.value,
          weight: weightAtIntValue.value,
          height: heightAtIntValue.value,
          diet: diet.value,
          foodAllergiesList: foodAlergiesList.value,
          foodDislikesList: foodDislikeList.value,
          country: country.value,
        );
    LoggerUtils.debug("Api Response : ${response.jsonResponse}");

    if (response.statusCode == 200 && response.isSuccess) {
      try {
        LoggerUtils.debug("💪💪💪💪Information Sent to server successfully!");

        // API call successful - remove local data
        final isRemoved =
            removeAllSavedDataToLocalStorageForInformationGatherMealPlan();

        ///-------->>> Update the Meal Plan Submission Status
        appData.write(kKeyIsMealPlanSubmitted, true);

        final mealPlanStatus = appData.read(kKeyIsMealPlanSubmitted);

        if (isRemoved == true && mealPlanStatus == true) {
          LoggerUtils.debug(
            "Data posted successfully and local storage cleared",
          );
          // Navigate to next screen
          Get.offAllNamed(Routes.dailyCaloriesIntakeScreen);
        } else {
          LoggerUtils.error("Data posted but local storage not fully cleared");
          // You might want to show an error or try again
        }
      } catch (e) {
        LoggerUtils.error("🪢🪢🪢🪢Some Thing went Wrong");
        errorMessage.value = e.toString();
        LoggerUtils.error(
          "🎍🎍🎍Error Message From Server : ${errorMessage.value}",
        );
      } finally {
        isLoading.value = false;
      }
    } else {
      errorMessage.value = response.errorMessage.toString();
      LoggerUtils.error(
        "Failed to Send information to server : ${errorMessage.value}",
      );
      isLoading.value = false;
    }
  }
}
