import 'package:bloodfit/features/settings/data/repository/delete_account_repository.dart';
import 'package:bloodfit/routes/routes.dart';
import 'package:get/get.dart';

import '../../../../constants/app_constant_text.dart';
import '../../../../helper/di.dart';
import '../../../../helper/logger_util.dart';

class DeleteAccountController extends GetxController {
  DeleteAccountRepository _deleteAccountRepository;
  DeleteAccountController(this._deleteAccountRepository);

  RxBool isLoading = false.obs;
  RxString errorMessage = ''.obs;

  void clearErrorMessage() {
    errorMessage.value = '';
  }

  Future<void> postDeleteAccountApi() async {
    isLoading.value = true;
    clearErrorMessage();

    final response = await _deleteAccountRepository.deleteAccountRepository();

    if (response.statusCode == 201 && response.isSuccess) {
      try {
        ///------------->>> Pre Removal Data Check
        LoggerUtils.info("📋 Pre-removal data check:");
        LoggerUtils.info(
          "Access Token exists: ${appData.read(kKeyAccessToken) != null}",
        );
        LoggerUtils.info(
          "User Name exists: ${appData.read(kKeyUserName) != null}",
        );
        LoggerUtils.info("Email exists: ${appData.read(kKeyEmail) != null}");
        LoggerUtils.info("User ID exists: ${appData.read(kKeyUserID) != null}");

        ///------------>>> Removing Data
        appData.remove(kKeyAccessToken);
        appData.remove(kKeyUserName);
        appData.remove(kKeyEmail);
        appData.remove(kKeyUserID);

        ///------------->>> Data Check After Removal
        LoggerUtils.info("✅ User data removed successfully");
        LoggerUtils.info("After Removing Data 🤖🤖: ");
        LoggerUtils.info(
          "😶‍🌫️😶‍🌫️Access Token : ${appData.read(kKeyAccessToken)}",
        );
        LoggerUtils.info(
          "😶‍🌫️😶‍🌫️User Name : ${appData.read(kKeyUserName)}",
        );
        LoggerUtils.info("😶‍🌫️😶‍🌫️User Email : ${appData.read(kKeyEmail)}");
        LoggerUtils.info("😶‍🌫️😶‍🌫️User ID : ${appData.read(kKeyUserID)}");

        LoggerUtils.info("🚀 Navigating to sign in screen");
        Get.offAllNamed(Routes.signInScreen);
      } catch (e) {
        errorMessage.value = e.toString();
        LoggerUtils.error("❌ Error during data removal: $e");
      } finally {
        isLoading.value = false;
        LoggerUtils.info("🏁 Delete account process completed");
      }
    } else {
      isLoading.value = false;
      errorMessage.value = response.errorMessage ?? "Failed to delete account";
      LoggerUtils.error(
        "❌ Delete account failed - Status: ${response.statusCode}, Message: ${errorMessage.value}",
      );
    }
  }
}
