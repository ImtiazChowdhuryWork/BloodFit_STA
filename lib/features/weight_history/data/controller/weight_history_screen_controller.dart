import 'package:bloodfit/features/weight_history/data/repository/update_current_weight_repository.dart';
import 'package:bloodfit/helper/logger_util.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class WeightHistoryScreenController extends GetxController {
  ///---------->>> Importing the -> Update Current Weight Repository
  final UpdateCurrentWeightRepository _updateCurrentWeightRepository;

  ///-------->>>> Pass Instance through Constructor
  WeightHistoryScreenController(this._updateCurrentWeightRepository);

  ///Section : ---------------------///Update Your Current Weight drop down///-------------------
  final List<String> weightUnits = ['kg', 'lb'];
  var selectedWeightUnit = 'kg'.obs; // Changed to lowercase for consistency
  TextEditingController weightController = TextEditingController();

  /// Section : Input Validation
  // Update Current Weight Validator (allows decimal input)
  String? updateCurrentWeightValidator(String? value) {
    if (value == null || value.isEmpty) {
      return 'Weight cannot be empty!';
    }

    final trimmedValue = value.trim();

    // Allow decimal numbers (e.g., 65.5)
    final parsedValue = double.tryParse(trimmedValue);
    if (parsedValue == null) {
      return 'Please enter a valid number';
    }

    // Range validation
    if (parsedValue <= 0) {
      return 'Weight must be greater than 0';
    }

    // Different max values for different units
    final maxWeight = selectedWeightUnit.value == 'lb' ? 2200.0 : 1000.0;

    if (parsedValue > maxWeight) {
      return 'Weight must be less than $maxWeight ${selectedWeightUnit.value}';
    }

    return null;
  }

  ///Section : Weight Conversion Methods
  // Convert pounds to kilograms (returns int)
  static int convertLbToKgInt(double pounds) {
    return (pounds * 0.45359237).round();
  }

  // Convert pounds to kilograms (returns double for display)
  static double convertLbToKgDouble(double pounds) {
    return pounds * 0.45359237;
  }

  ///Feat : -> Set Value of Weight UnitType
  void setSelectedWeightUnit({required String unit}) {
    selectedWeightUnit.value = unit.toLowerCase(); // Ensure lowercase
  }

  ///Section : Selected Weight Unit Checker (returns int for API)
  int selectedWeightUnitChecker() {
    final weightText = weightController.text.trim();

    // This should only be called after validation, so parsing should succeed
    final parsedWeight = double.parse(weightText);

    if (selectedWeightUnit.value == 'kg') {
      // Convert kg (double) to int (rounded)
      return parsedWeight.round();
    } else {
      // Convert lb to kg and round to int
      return convertLbToKgInt(parsedWeight);
    }
  }

  /// Section : Get Display Summary (for user feedback)
  String getWeightSummary() {
    final weightText = weightController.text.trim();
    if (weightText.isEmpty) return '';

    final parsedValue = double.tryParse(weightText);
    if (parsedValue == null) return '';

    if (selectedWeightUnit.value == 'kg') {
      final kgInt = parsedValue.round();
      return 'Entered: $weightText kg → Will send: $kgInt kg';
    } else {
      final kgDouble = convertLbToKgDouble(parsedValue);
      final kgInt = kgDouble.round();
      return 'Entered: $weightText lb (${kgDouble.toStringAsFixed(1)} kg) → Will send: $kgInt kg';
    }
  }

  ///Feat : -> Close the weight controller
  @override
  void onClose() {
    weightController.dispose();
    super.onClose();
  }

  ///Feat : -> Show and Hide Submit Button
  RxBool isWeightAvailable = false.obs;

  @override
  void onInit() {
    super.onInit();
    // Listen to text changes to update button visibility
    weightController.addListener(updateWeightAvailability);
    updateWeightAvailability();
  }

  void updateWeightAvailability() {
    isWeightAvailable.value = weightController.text.trim().isNotEmpty;
  }

  void setIsWeightAvailableValue({required bool newValue}) {
    isWeightAvailable.value = newValue;
  }

  ///------>>> Update Current Weight Api Method Starts
  RxBool isUpdateCurrentWeightLoading = false.obs;
  RxString errorMessage = ''.obs;

  void clearErrorMessage() {
    errorMessage.value = '';
  }

  Future<bool> postUpdateCurrentWeightApi() async {
    clearErrorMessage();

    // First validate the input
    if (weightController.text.trim().isEmpty) {
      errorMessage.value = 'Please enter a weight';
      return false;
    }

    final parsedValue = double.tryParse(weightController.text.trim());
    if (parsedValue == null) {
      errorMessage.value = 'Invalid weight value';
      return false;
    }

    isUpdateCurrentWeightLoading.value = true;

    try {
      // Get weight as int for API
      final weightForApi = selectedWeightUnitChecker();

      LoggerUtils.debug(
        "API Request: ${weightController.text.trim()} ${selectedWeightUnit.value} → $weightForApi kg",
      );

      final response = await _updateCurrentWeightRepository
          .updateCurrentWeightRepository(
            updatedWeight: weightForApi, // This is int
          );

      if (response.statusCode == 200 && response.isSuccess) {
        LoggerUtils.debug("Weight Updated Successfully!");
        LoggerUtils.debug("Sent to API: $weightForApi kg");

        ///------>>> Section : Clear the controller
        weightController.clear();
        updateWeightAvailability();
        return true;
      } else {
        errorMessage.value =
            response.errorMessage?.toString() ?? 'Unknown error';
        LoggerUtils.error("Error Submitting Current Weight!");
        LoggerUtils.error("Status Code: ${response.statusCode}");
        LoggerUtils.error("Error Message: ${errorMessage.value}");
        return false;
      }
    } catch (error) {
      errorMessage.value = error.toString();
      LoggerUtils.error("Caught Error: ${errorMessage.value}");
      return false;
    } finally {
      isUpdateCurrentWeightLoading.value = false;
    }
  }

  ///------>>> Update Current Weight Api Method Ends
}
