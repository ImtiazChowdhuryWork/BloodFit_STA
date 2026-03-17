import 'package:bloodfit/features/add_promo_code/data/repository/add_promocode_repository.dart';
import 'package:bloodfit/helper/logger_util.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';

import '../../../../constants/app_enums.dart';
import '../../../../controllers/app_snackbar_controller.dart';

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

        AppSnackBarController.show(
          message: 'Promocode added to this plan!',
          type: AppSnackBarType.success,
          position: AppSnackBarPosition.bottom,
          duration: const Duration(seconds: 4),
        );

        Get.back();
      } else {
        AppSnackBarController.show(
          message: response.errorMessage.toString(),
          type: AppSnackBarType.error,
          position: AppSnackBarPosition.bottom,
          duration: const Duration(seconds: 4),
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
