import 'package:bloodfit/constants/app_constant_text.dart';
import 'package:bloodfit/constants/app_enums.dart';
import 'package:bloodfit/features/my_profile/data/repository/my_profile_repository.dart';
import 'package:bloodfit/helper/di.dart';
import 'package:bloodfit/helper/logger_util.dart';
import 'package:bloodfit/routes/routes.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

import '../model/get_my_profile_data_model.dart';

class ProfileScreenController extends GetxController {
  ///---------->>> Importing My Profile Repository
  final MyProfileRepository _myProfileRepository;
  ProfileScreenController(this._myProfileRepository);

  ///--------->>> Importing The My Profile Data Model
  Rxn<GetMyProfileDataModel> model = Rxn<GetMyProfileDataModel>();

  ///------>>> Gloabal Variables
  RxBool isLoading = false.obs;
  RxString errorMessage = ''.obs;
  void clearErrorMessage() {
    errorMessage.value = '';
  }

  String userName = appData.read(kKeyUserName) ?? '';

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
      appData.remove(kKeyUserName);
      appData.remove(kKeyEmail);
      appData.remove(kKeyUserID);
      LoggerUtils.info("After Removing Data : ");
      LoggerUtils.info("Access Token : ${appData.read(kKeyAccessToken)}");
      LoggerUtils.info("User Name : ${appData.read(kKeyUserName)}");
      LoggerUtils.info("User Email : ${appData.read(kKeyEmail)}");
      LoggerUtils.info("User ID : ${appData.read(kKeyUserID)}");

      Get.offAllNamed(Routes.signInScreen);
    } else {
      LoggerUtils.error(
        "Strange Access Token not found !: ${appData.read(kKeyAccessToken)}",
      );
    }
  }

  ///----------->>> Get My Profile Api Method Start  Here
  Future<void> getMyProfileDataApi() async {
    isLoading.value = true;
    clearErrorMessage();

    try {
      final response = await _myProfileRepository.myProfileRepository();

      if (response.statusCode == 200 && response.isSuccess) {
        LoggerUtils.debug("Success : Profile Dta Fetched Successfully!!");
        model.value = GetMyProfileDataModel.fromJson(response.jsonResponse!);
      } else {
        errorMessage.value = response.errorMessage.toString();
        LoggerUtils.error("Something Went wrong!");
        LoggerUtils.error("Error Message : ${errorMessage.value}");
      }
    } catch (e) {
      errorMessage.value = e.toString();
      LoggerUtils.error("Error Message : ${errorMessage.value}");
    } finally {
      isLoading.value = false;
    }
  }

  ///----------->>> Get My Profile Api Method Ends Here
  ///
  ///
  ///-------------->>> Getters of My Profile Data Start Here
  String? get firstName =>
      model.value?.data?.firstName ?? 'First Name Not Found!';
  String? get lastName => model.value?.data?.lastName ?? 'Last Name Not Found!';
  String? get profileImageUrl => model.value?.data?.image;

  ///------------->>> Getter of My Profile Data Ends Here
}
