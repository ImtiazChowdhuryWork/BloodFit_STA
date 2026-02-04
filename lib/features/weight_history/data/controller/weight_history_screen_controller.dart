import 'package:bloodfit/features/weight_history/data/repository/update_current_weight_repository.dart';
import 'package:bloodfit/helper/logger_util.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../presentation/widgets/current_weight_update_success_alertbox.dart';

class WeightHistoryScreenController extends GetxController {
  ///---------->>> Importing the -> Update Current Weight Repository
  final UpdateCurrentWeightRepository _updateCurrentWeightRepository;

  ///-------->>>> Pass Instance through Construtor
  WeightHistoryScreenController(this._updateCurrentWeightRepository);

  ///Section : ---------------------///Update Your Current Weight drop down///-------------------
  var selectedWeightUnit = 'Kg'.obs;
  TextEditingController weightController = TextEditingController();

  ///Feat : -> Set Value of Weight UnitType
  void setSelectedWeightUnit({required String unit}) {
    selectedWeightUnit.value = unit;
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
    // Initialize based on current text field value
    isWeightAvailable.value = weightController.text.trim().isNotEmpty;
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
    isUpdateCurrentWeightLoading.value = true;

    final response = await _updateCurrentWeightRepository
        .updateCurrentWeightRepository(
          updatedWeight: int.parse(weightController.text.trim().toString()),
        );
    try {
      if (response.statusCode == 200 && response.isSuccess) {
        LoggerUtils.debug("Weight Updated Successfully!");

        ///--------->>> Section : Alert Box On Success
        return true;
      } else {
        errorMessage.value = response.errorMessage.toString();
        LoggerUtils.error("Error Found While Submiting Current Weight!");
        LoggerUtils.error("Error Code : ${response.statusCode}");
        LoggerUtils.error("Error Message : ${errorMessage.value}");
        return false;
      }
    } catch (error) {
      errorMessage.value = error.toString();
      LoggerUtils.error("Catched Error : ${errorMessage.value}");
      return false;
    } finally {
      isUpdateCurrentWeightLoading.value = false;
    }
  }

  ///------>>> Update Current Weight Api Method Ends
}
