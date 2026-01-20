import 'package:bloodfit/features/my_profile/data/repository/my_profile_repository.dart';
import 'package:bloodfit/helper/logger_util.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';

import '../../../my_profile/data/model/get_my_profile_data_model.dart';
import '../repository/update_profile_data_repository.dart';

class ViewProfileSubscriptionTypeFreeScreenController extends GetxController {
  /// Importing the My profile repository
  MyProfileRepository _myProfileRepository;

  ///-------->>> Importing Update Profile Data Repository
  UpdateProfileDataRepository _updateProfileDataRepository;
  ViewProfileSubscriptionTypeFreeScreenController(
    this._myProfileRepository,
    this._updateProfileDataRepository,
  );

  ///Importing My Profile Model
  Rxn<GetMyProfileDataModel> model = Rxn<GetMyProfileDataModel>();

  TextEditingController firstName = TextEditingController();
  TextEditingController lastName = TextEditingController();
  TextEditingController emailAddress = TextEditingController();
  TextEditingController contactNumber = TextEditingController();

  RxBool isEditModeOn = false.obs;
  void setEditMode() {
    isEditModeOn.value = !isEditModeOn.value;
  }

  ///View Profile api repo starts from here
  RxBool isViewProfileDataLoading = false.obs;
  RxString viewProfileErrorMessage = ''.obs;
  void clearViewProfileErrorMessage() {
    viewProfileErrorMessage.value = '';
  }

  Future<void> getViewProfileDataApi() async {
    try {
      isViewProfileDataLoading.value = true;
      clearViewProfileErrorMessage();

      final response = await _myProfileRepository.myProfileRepository();

      if (response.statusCode == 200 && response.isSuccess) {
        model.value = GetMyProfileDataModel.fromJson(response.jsonResponse!);
      } else {
        viewProfileErrorMessage.value = response.errorMessage.toString();
        LoggerUtils.error("Something Went Wrong!");
        LoggerUtils.error("Error Code : ${response.statusCode}");
        LoggerUtils.error("Error Message : ${viewProfileErrorMessage.value}");
      }
    } catch (e) {
      viewProfileErrorMessage.value = e.toString();
      LoggerUtils.error("Catched Error : ${viewProfileErrorMessage.value}");
    } finally {
      isViewProfileDataLoading.value = false;
    }
  }

  String? get userFirstName =>
      model.value?.data?.firstName.toString() ?? 'First Name Not Found!';
  String? get userLastName =>
      model.value?.data?.lastName.toString() ?? 'Last Name Not Found!';
  String? get userEmail =>
      model.value?.data?.email.toString() ?? 'Email Not Found!';
  String? get userMobileNumber =>
      model.value?.data?.contactNumber.toString() ??
      'Contact Number Not Found!';

  ///------------>>> Get My Data Api Method Ends Here

  ///------------>>> Upload My Profile Api Method Start Here
  RxBool isProfileDataBeingUpload = false.obs;
  RxString profileDataUpdateErrorMessage = ''.obs;
  void clearProfileDataUpdateErroMessage() {
    profileDataUpdateErrorMessage.value = '';
  }

  Future<void> patchProfileDataUpdateApi() async {
    try {
      isProfileDataBeingUpload.value = true;
      clearProfileDataUpdateErroMessage();

      final response = await _updateProfileDataRepository
          .updateProfileDataRepository(
            firstName: firstName.text.trim(),
            lastName: lastName.text.trim(),
            contactNumber: contactNumber.text.trim(),
          );

      if (response.statusCode == 200 && response.isSuccess) {
        LoggerUtils.debug("Success : Updating profile data Success");
      } else {
        LoggerUtils.error("Error : Something Went Wrong");
        LoggerUtils.error("Error Status Code : ${response.statusCode}");
        LoggerUtils.error("Error Message : ${response.errorMessage}");
      }
    } catch (e) {
      profileDataUpdateErrorMessage.value = e.toString();
      LoggerUtils.error(
        "Error Catched : ${profileDataUpdateErrorMessage.value}",
      );
    } finally {
      isProfileDataBeingUpload.value = false;
    }
  }

  ///------------>>> Upload My Profile Api Method Excluding Email Start Here
  Future<void> patchProfileDataUpdateApiExcludingEmail() async {
    try {
      isProfileDataBeingUpload.value = true;
      clearProfileDataUpdateErroMessage();

      final response = await _updateProfileDataRepository
          .updateProfileDataRepository(
            firstName: firstName.text.trim(),
            lastName: lastName.text.trim(),
            // Email is excluded from update
            contactNumber: contactNumber.text.trim(),
          );

      if (response.statusCode == 200 && response.isSuccess) {
        LoggerUtils.debug(
          "Success : Updating profile data (excluding email) Success",
        );
      } else {
        LoggerUtils.error("Error : Something Went Wrong");
        LoggerUtils.error("Error Status Code : ${response.statusCode}");
        LoggerUtils.error("Error Message : ${response.errorMessage}");
      }
    } catch (e) {
      profileDataUpdateErrorMessage.value = e.toString();
      LoggerUtils.error(
        "Error Catched : ${profileDataUpdateErrorMessage.value}",
      );
    } finally {
      isProfileDataBeingUpload.value = false;
    }
  }
}
