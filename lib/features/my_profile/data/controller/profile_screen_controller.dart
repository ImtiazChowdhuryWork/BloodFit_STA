import 'package:bloodfit/constants/app_constant_text.dart';
import 'package:bloodfit/constants/app_enums.dart';
import 'package:bloodfit/features/my_profile/data/repository/my_profile_repository.dart';
import 'package:bloodfit/features/my_profile/data/repository/upload_profile_image_repository.dart';
import 'package:bloodfit/helper/di.dart';
import 'package:bloodfit/helper/logger_util.dart';
import 'package:bloodfit/routes/routes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../controllers/custom_image_picker_controller.dart';
import '../model/get_my_profile_data_model.dart';

class ProfileScreenController extends GetxController {
  ///----------->>> Import MyProfileRepository
  final MyProfileRepository _myProfileRepository;

  ///----------->>> Import -> Upload Profile Image Repository
  final UploadProfileImageRepository _uploadProfileImageRepository;
  ProfileScreenController(
    this._myProfileRepository,
    this._uploadProfileImageRepository,
  );

  @override
  void onInit() {
    super.onInit();
    ever(model, (_) => updateReactiveFullName());
  }

  Rxn<GetMyProfileDataModel> model = Rxn<GetMyProfileDataModel>();
  RxString reactiveFullName = ''.obs;

  RxBool isLoading = false.obs;
  RxString errorMessage = ''.obs;

  void clearErrorMessage() {
    errorMessage.value = '';
  }

  String get userName => appData.read(kKeyUserName) ?? '';

  /// REMOVED: Duplicate image picking logic - use CustomImagePickerController instead

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

  void logOutHelper() {
    // Clear image controller data on logout
    final imageController = Get.find<CustomImagePickerController>();
    imageController.clearImage();

    // Remove user data
    appData.remove(kKeyAccessToken);
    appData.remove(kKeyUserName);
    appData.remove(kKeyEmail);
    appData.remove(kKeyUserID);

    LoggerUtils.info("User logged out successfully");
    Get.offAllNamed(Routes.signInScreen);
  }

  ///----------->>> Api Call : Get Profile Data Method
  Future<void> getMyProfileDataApi() async {
    isLoading.value = true;
    clearErrorMessage();

    try {
      final response = await _myProfileRepository.myProfileRepository();

      if (response.statusCode == 200 && response.isSuccess) {
        model.value = GetMyProfileDataModel.fromJson(response.jsonResponse!);

        // Update image controller with API image
        final imageController = Get.find<CustomImagePickerController>();
        final imageUrl = model.value?.data?.image;
        LoggerUtils.debug("Profile image URL from API: $imageUrl");
        if (imageUrl != null && imageUrl.isNotEmpty) {
          LoggerUtils.debug("Setting API image in controller: $imageUrl");
          imageController.setImageFromApi(imageUrl);
        } else {
          LoggerUtils.debug(
            "No image URL found in profile data or URL is empty",
          );
        }

        // Update reactive full name
        updateReactiveFullName();

        LoggerUtils.debug("Success: Profile Data Fetched Successfully!!");
      } else {
        errorMessage.value = response.errorMessage.toString();
        LoggerUtils.error("Error Message: ${errorMessage.value}");
      }
    } catch (e) {
      errorMessage.value = e.toString();
      LoggerUtils.error("Error Message: ${errorMessage.value}");
    } finally {
      isLoading.value = false;
    }
  }

  /// Getters
  String get firstName => model.value?.data?.firstName ?? '';
  String get lastName => model.value?.data?.lastName ?? '';
  String get profileImageUrl => model.value?.data?.image ?? '';

  // Getter for full name
  String get fullName {
    final name = userName;
    if (name.isNotEmpty) {
      return name;
    }
    return "${firstName} ${lastName}".trim();
  }

  // Update the reactive full name
  void updateReactiveFullName() {
    reactiveFullName.value = fullName;
  }

  ///--------------->>> Api Call : Upload Profile Image
  RxBool isImageBeingUpload = false.obs;
  RxString imageUploadingErrorMessage = ''.obs;
  void clearImageUploadingErrorMessage() {
    imageUploadingErrorMessage.value = '';
  }

  Future<void> postUploadProfileImage() async {
    isImageBeingUpload.value = true;
    clearImageUploadingErrorMessage();

    try {
      // Get the image path from the image picker controller
      final imageController = Get.find<CustomImagePickerController>();
      final imagePath = imageController.pickedImagePath;

      // Check if there's an image to upload
      if (imagePath.isEmpty) {
        imageUploadingErrorMessage.value = "No image selected to upload";
        LoggerUtils.error("Error While Uploading Image: No image selected");
        return;
      }

      final response = await _uploadProfileImageRepository
          .uploadProfileImageRepository(imagePath: imagePath);

      if (response.statusCode == 200 && response.isSuccess) {
        LoggerUtils.debug("Profile image uploaded successfully");

        // Refresh the profile data to get the updated image
        LoggerUtils.debug("Refreshing profile data after upload...");
        await getMyProfileDataApi();

        Get.snackbar(
          "Success",
          "Profile image uploaded successfully!",
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
      } else {
        imageUploadingErrorMessage.value =
            response.errorMessage ?? "Unknown error occurred";
        LoggerUtils.error(
          "Error While Uploading Image: ${imageUploadingErrorMessage.value}",
        );
        Get.snackbar(
          "Error",
          "Failed to upload profile image: ${response.errorMessage}",
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      imageUploadingErrorMessage.value = e.toString();
      LoggerUtils.error(
        "Error While Uploading Image: ${imageUploadingErrorMessage.value}",
      );
      Get.snackbar(
        "Error",
        "Failed to upload profile image: $e",
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isImageBeingUpload.value = false;
    }
  }
}
