import 'package:bloodfit/constants/app_constant_text.dart';
import 'package:bloodfit/helper/di.dart';
import 'package:get/get.dart';

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
  RxDouble age = 0.0.obs;
  RxDouble weight = 0.0.obs;
  RxDouble height = 0.0.obs;
  RxString diet = ''.obs;
  RxList foodAlergiesList = [].obs;
  RxList foodDislikeList = [].obs;
  RxString country = ''.obs;

  ///----> Validator : First Name
  // final firstNameError = firstNameValidator(firstNameController.text);
  // if (firstNameError != null) return firstNameError;

  String? bloodGroupValidation() {
    RxString value = appData.read(kKeyAccessToken);
    if (value == null || value.isEmpty) {
      return 'Enter last name';
    }
    return null;
  }

  ///---------->>> Validate Information Gather Meal Plan
  String? validateInformationGatherMealPlan() {
    final bloodGroupError = bloodGroupValidation();
    if (bloodGroupError != null) return bloodGroupError;

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
    Get.toNamed(Routes.dailyCaloriesIntakeScreen);

    // if(){

    // }else{

    // }
  }
}
