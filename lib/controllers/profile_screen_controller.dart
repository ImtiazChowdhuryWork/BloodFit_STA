import 'package:bloodfit/constants/app_constant_text.dart';
import 'package:bloodfit/constants/app_enums.dart';
import 'package:bloodfit/helper/di.dart';
import 'package:bloodfit/helper/logger_util.dart';
import 'package:bloodfit/routes/routes.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class ProfileScreenController extends GetxController {
  ///Section : -------------///Profile Image Picker///--------------
  final ImagePicker _picker = ImagePicker();
  RxString pickedImagePath = ''.obs;

  Future<void> imagePicker({required ImageSource imagPickerSource}) async {
    try {
      final XFile? image = await _picker.pickImage(
        source: imagPickerSource,
        maxHeight: 1024.h,
        maxWidth: 1024.w,
        imageQuality: 85,
      );

      image != null
          ? pickedImagePath.value = image.path
          : Get.snackbar("Canceled!", "No Image Selected.");
    } catch (e) {
      Get.snackbar("Error", "Failed to pick image: $e");
    }
  }

  ///Check If User Is Free User or Premimum User
  Rx<UserSubscriptionType> subscriptionType =
      AppConstants.defaultSubscriptionType.obs;
  bool get isFreeUser => subscriptionType.value == UserSubscriptionType.free;

  ///-------------------------///Dummy Code///For development Purpose Only
  ///Set User SubscriptionType as -> FREE
  void setSubscriptionTypeFree() {
    subscriptionType.value = UserSubscriptionType.free;
  }

  ///Set User SubscriptionType as -> ELITE
  void setSubscriptionTypeElite() {
    subscriptionType.value = UserSubscriptionType.elite;
  }

  ///Set User SubscriptionType as -> PRO
  void setSubscriptionTypePro() {
    subscriptionType.value = UserSubscriptionType.pro;
  }

  ///Set User SubscriptionType as -> STARTER
  void setSubscriptionTypeStarter() {
    subscriptionType.value = UserSubscriptionType.starter;
  }

  ///-------------------////End of Dummy Code///-------------------------------
  ///
  ///
  ///

  void logOutHelper() {
    // final token = appData.read(kKeyAccessToken);
    LoggerUtils.info(
      "Before Removing Access Token : ${appData.read(kKeyAccessToken)}",
    );

    if (appData.read(kKeyAccessToken) != null) {
      ///------>>> Removing The token
      appData.remove(kKeyAccessToken);
      LoggerUtils.info(
        "After Removing Access Token : ${appData.read(kKeyAccessToken)}",
      );

      ///------>>> Checking the token if (appData.read(kKeyAccessToken) == null) {
      LoggerUtils.info("Access token Not found!");
      Get.offAllNamed(Routes.signInScreen);
    } else {
      LoggerUtils.error(
        "Strange Access Token not found !: ${appData.read(kKeyAccessToken)}",
      );
    }
  }
}
