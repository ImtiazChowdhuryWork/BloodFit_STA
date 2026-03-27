import 'package:bloodfit/features/add_promo_code/data/repository/add_promocode_repository.dart';
import 'package:bloodfit/helper/logger_util.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AddPoromocodeScreenController extends GetxController {
  ///-------------<>>>>>> Section : Importing the Repository
  AddPromocodeRepository _addPromocodeRepository;

  AddPoromocodeScreenController(this._addPromocodeRepository);

  ///--------->>> Section : PromoCode Controller
  TextEditingController promocodeController = TextEditingController();

  ///----------->>> Section : Add Promocode Api Starts Here
  RxBool isPromocodeValueLoading = false.obs;
  RxString promocodeErrorMessage = ''.obs;
  void clearPromocodeErrorMessage() {
    promocodeErrorMessage.value = '';
  }

  RxString planId = ''.obs;
  void setPlanId({required String value}) {
    planId.value = value;
  }

  RxBool isPromoCodeActive = false.obs;
  void clearPromoCodeStatus() {
    isPromoCodeActive.value = false;
  }

  Future<void> postAddPromocodeApi() async {
    try {
      isPromocodeValueLoading.value = true;
      clearPromocodeErrorMessage();
      clearPromoCodeStatus();

      final response = await _addPromocodeRepository.addPromocodeRepository(
        planId: planId.value,
        prmCode: promocodeController.text.toString().trim(),
      );

      if (response.statusCode == 200 && response.isSuccess) {
        isPromoCodeActive.value = true;

        // Show success snackbar using rawSnackbar (doesn't need overlay context)
        Get.rawSnackbar(
          title: "Success",
          message: "Promocode added to this plan!",
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green.shade700,
          duration: const Duration(seconds: 3),
          margin: const EdgeInsets.all(16),
          borderRadius: 12,
          icon: const Icon(Icons.check_circle, color: Colors.white, size: 30),
          isDismissible: true,
        );

        // Wait for snackbar to show, then navigate back
        await Future.delayed(const Duration(milliseconds: 300));
        Get.back();
      } else {
        // Show error snackbar
        Get.rawSnackbar(
          title: "Error",
          message: response.errorMessage.toString(),
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red.shade700,
          duration: const Duration(seconds: 4),
          margin: const EdgeInsets.all(16),
          borderRadius: 12,
          icon: const Icon(Icons.error, color: Colors.white, size: 30),
          isDismissible: true,
        );

        LoggerUtils.error("Failed to submit Promocode!");
        LoggerUtils.error(
          "Error Code : ${response.statusCode} :: Error Message :-> ${response.errorMessage.toString()}",
        );
      }
    } catch (error) {
      promocodeErrorMessage.value = error.toString();

      LoggerUtils.debug(
        "Something went wrong! While submitting the Promocode!",
      );
      LoggerUtils.error("Error Message : ${promocodeErrorMessage.value}");
    } finally {
      isPromocodeValueLoading.value = false;
    }
  }

  ///----------->>> Section : Add Promocode Api Ends Here
}
