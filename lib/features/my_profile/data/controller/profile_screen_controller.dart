import 'package:bloodfit/constants/app_constant_text.dart';
import 'package:bloodfit/constants/app_enums.dart';
import 'package:bloodfit/controllers/app_snackbar_controller.dart';
import 'package:bloodfit/features/my_profile/data/repository/my_profile_repository.dart';
import 'package:bloodfit/features/my_profile/data/repository/upload_profile_image_repository.dart';
import 'package:bloodfit/helper/di.dart';
import 'package:bloodfit/helper/helper_methods.dart';
import 'package:bloodfit/helper/logger_util.dart';
import 'package:bloodfit/routes/routes.dart';
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

    // Pre-load cached image URL from GetStorage so AppBarSectionWidget
    // shows the image instantly before the API call completes.
    final cachedUrl = appData.read(kImageUrl) ?? '';
    reactiveProfileImageUrl.value = cachedUrl;
    LoggerUtils.debug("╔══════════════════════════════════════════════════");
    LoggerUtils.debug("🟢 [PROFILE-CONTROLLER] onInit()");
    LoggerUtils.debug("📦 [PROFILE-CONTROLLER] Cached image URL from storage: ${cachedUrl.isNotEmpty ? cachedUrl : 'EMPTY — no cached URL found'}");
    LoggerUtils.debug("╚══════════════════════════════════════════════════");
  }

  Rxn<GetMyProfileDataModel> model = Rxn<GetMyProfileDataModel>();
  RxString reactiveFullName = ''.obs;

  /// Single source of truth for the profile image URL across all screens.
  /// Watched by AppBarSectionWidget via Obx — updates everywhere automatically.
  RxString reactiveProfileImageUrl = ''.obs;

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
    clearUserSessionData();
    reactiveProfileImageUrl.value = '';
    Get.offAllNamed(Routes.signInScreen);
  }

  ///----------->>> Api Call : Get Profile Data Method
  Future<void> getMyProfileDataApi() async {
    LoggerUtils.debug("╔══════════════════════════════════════════════════");
    LoggerUtils.debug("📡 [PROFILE-API] getMyProfileDataApi() called");
    LoggerUtils.debug("╚══════════════════════════════════════════════════");

    isLoading.value = true;
    clearErrorMessage();

    try {
      final response = await _myProfileRepository.myProfileRepository();

      LoggerUtils.debug("📡 [PROFILE-API] Response received");
      LoggerUtils.debug("📡 [PROFILE-API] Status code : ${response.statusCode}");
      LoggerUtils.debug("📡 [PROFILE-API] isSuccess   : ${response.isSuccess}");

      if (response.statusCode == 200 && response.isSuccess) {
        model.value = GetMyProfileDataModel.fromJson(response.jsonResponse!);

        final imageController = Get.find<CustomImagePickerController>();
        final imageUrl = model.value?.data?.image;

        LoggerUtils.debug("🖼  [PROFILE-API] Image URL from API : ${imageUrl ?? 'NULL'}");

        if (imageUrl != null && imageUrl.isNotEmpty) {
          imageController.setImageFromApi(imageUrl);
          appData.write(kImageUrl, imageUrl);
          reactiveProfileImageUrl.value = imageUrl;
          LoggerUtils.debug("✅ [PROFILE-API] Image URL set in controller, storage, and reactiveProfileImageUrl");
          LoggerUtils.debug("✅ [PROFILE-API] reactiveProfileImageUrl → $imageUrl");
        } else {
          LoggerUtils.debug("⚠️  [PROFILE-API] Image URL is null or empty — default image will show");
        }

        updateReactiveFullName();
        LoggerUtils.debug("✅ [PROFILE-API] Profile data fetched successfully");
      } else {
        errorMessage.value = response.errorMessage.toString();
        LoggerUtils.error("❌ [PROFILE-API] Failed — Status: ${response.statusCode} | Error: ${errorMessage.value}");
      }
    } catch (e) {
      errorMessage.value = e.toString();
      LoggerUtils.error("❌ [PROFILE-API] Exception caught: ${errorMessage.value}");
    } finally {
      isLoading.value = false;
      LoggerUtils.debug("📡 [PROFILE-API] getMyProfileDataApi() finished");
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

        AppSnackBarController.show(
          message: "Profile image uploaded successfully!",
          type: AppSnackBarType.success,
          position: AppSnackBarPosition.bottom,
        );
      } else {
        imageUploadingErrorMessage.value =
            response.errorMessage ?? "Unknown error occurred";
        LoggerUtils.error(
          "Error While Uploading Image: ${imageUploadingErrorMessage.value}",
        );
        AppSnackBarController.show(
          message: "Failed to upload profile image: ${response.errorMessage}",
          type: AppSnackBarType.error,
          position: AppSnackBarPosition.bottom,
        );
      }
    } catch (e) {
      imageUploadingErrorMessage.value = e.toString();
      LoggerUtils.error(
        "Error While Uploading Image: ${imageUploadingErrorMessage.value}",
      );
      AppSnackBarController.show(
        message: "Failed to upload profile image: $e",
        type: AppSnackBarType.error,
        position: AppSnackBarPosition.bottom,
      );
    } finally {
      isImageBeingUpload.value = false;
    }
  }
}
