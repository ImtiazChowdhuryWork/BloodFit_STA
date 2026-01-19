// import 'package:bloodfit/constants/app_constant_text.dart';
// import 'package:bloodfit/constants/app_enums.dart';
// import 'package:bloodfit/features/my_profile/data/repository/my_profile_repository.dart';
// import 'package:bloodfit/helper/di.dart';
// import 'package:bloodfit/helper/logger_util.dart';
// import 'package:bloodfit/routes/routes.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:get/get.dart';
// import 'package:image_picker/image_picker.dart';

// import '../model/get_my_profile_data_model.dart';

// class ProfileScreenController extends GetxController {
//   ///---------->>> Importing My Profile Repository
//   final MyProfileRepository _myProfileRepository;
//   ProfileScreenController(this._myProfileRepository);

//   ///--------->>> Importing The My Profile Data Model
//   Rxn<GetMyProfileDataModel> model = Rxn<GetMyProfileDataModel>();

//   ///------>>> Gloabal Variables
//   RxBool isLoading = false.obs;
//   RxString errorMessage = ''.obs;
//   void clearErrorMessage() {
//     errorMessage.value = '';
//   }

//   String userName = appData.read(kKeyUserName) ?? '';

//   ///Section : -------------///Profile Image Picker///--------------
//   final ImagePicker _picker = ImagePicker();
//   RxString pickedImagePath = ''.obs;

//   Future<void> imagePicker({required ImageSource imagPickerSource}) async {
//     try {
//       final XFile? image = await _picker.pickImage(
//         source: imagPickerSource,
//         maxHeight: 1024.h,
//         maxWidth: 1024.w,
//         imageQuality: 85,
//       );

//       image != null
//           ? pickedImagePath.value = image.path
//           : Get.snackbar("Canceled!", "No Image Selected.");
//     } catch (e) {
//       Get.snackbar("Error", "Failed to pick image: $e");
//     }
//   }

//   ///Check If User Is Free User or Premimum User
//   Rx<UserSubscriptionType> subscriptionType =
//       AppConstants.defaultSubscriptionType.obs;
//   bool get isFreeUser => subscriptionType.value == UserSubscriptionType.free;

//   ///-------------------------///Dummy Code///For development Purpose Only
//   ///Set User SubscriptionType as -> FREE
//   void setSubscriptionTypeFree() {
//     subscriptionType.value = UserSubscriptionType.free;
//   }

//   ///Set User SubscriptionType as -> ELITE
//   void setSubscriptionTypeElite() {
//     subscriptionType.value = UserSubscriptionType.elite;
//   }

//   ///Set User SubscriptionType as -> PRO
//   void setSubscriptionTypePro() {
//     subscriptionType.value = UserSubscriptionType.pro;
//   }

//   ///Set User SubscriptionType as -> STARTER
//   void setSubscriptionTypeStarter() {
//     subscriptionType.value = UserSubscriptionType.starter;
//   }

//   ///-------------------////End of Dummy Code///-------------------------------
//   ///
//   ///
//   ///

//   void logOutHelper() {
//     // final token = appData.read(kKeyAccessToken);
//     LoggerUtils.info(
//       "Before Removing Access Token : ${appData.read(kKeyAccessToken)}",
//     );

//     if (appData.read(kKeyAccessToken) != null) {
//       ///------>>> Removing The token
//       appData.remove(kKeyAccessToken);
//       appData.remove(kKeyUserName);
//       appData.remove(kKeyEmail);
//       appData.remove(kKeyUserID);
//       LoggerUtils.info("After Removing Data : ");
//       LoggerUtils.info("Access Token : ${appData.read(kKeyAccessToken)}");
//       LoggerUtils.info("User Name : ${appData.read(kKeyUserName)}");
//       LoggerUtils.info("User Email : ${appData.read(kKeyEmail)}");
//       LoggerUtils.info("User ID : ${appData.read(kKeyUserID)}");

//       Get.offAllNamed(Routes.signInScreen);
//     } else {
//       LoggerUtils.error(
//         "Strange Access Token not found !: ${appData.read(kKeyAccessToken)}",
//       );
//     }
//   }

//   ///----------->>> Get My Profile Api Method Start  Here
//   Future<void> getMyProfileDataApi() async {
//     isLoading.value = true;
//     clearErrorMessage();

//     try {
//       final response = await _myProfileRepository.myProfileRepository();

//       if (response.statusCode == 200 && response.isSuccess) {
//         LoggerUtils.debug("Success : Profile Dta Fetched Successfully!!");
//         model.value = GetMyProfileDataModel.fromJson(response.jsonResponse!);
//       } else {
//         errorMessage.value = response.errorMessage.toString();
//         LoggerUtils.error("Something Went wrong!");
//         LoggerUtils.error("Error Message : ${errorMessage.value}");
//       }
//     } catch (e) {
//       errorMessage.value = e.toString();
//       LoggerUtils.error("Error Message : ${errorMessage.value}");
//     } finally {
//       isLoading.value = false;
//     }
//   }

//   ///----------->>> Get My Profile Api Method Ends Here
//   ///
//   ///
//   ///-------------->>> Getters of My Profile Data Start Here
//   String? get firstName =>
//       model.value?.data?.firstName ?? 'First Name Not Found!';
//   String? get lastName => model.value?.data?.lastName ?? 'Last Name Not Found!';
//   String? get profileImageUrl => model.value?.data?.image;

//   ///------------->>> Getter of My Profile Data Ends Here
// }

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
          LoggerUtils.debug("No image URL found in profile data or URL is empty");
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
