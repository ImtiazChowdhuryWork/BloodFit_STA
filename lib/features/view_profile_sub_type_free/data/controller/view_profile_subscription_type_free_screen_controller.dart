import 'package:bloodfit/features/my_profile/data/repository/my_profile_repository.dart';
import 'package:bloodfit/helper/logger_util.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';

import '../../../my_profile/data/model/get_my_profile_data_model.dart';

class ViewProfileSubscriptionTypeFreeScreenController extends GetxController {
  /// Importing the My profile repository
  MyProfileRepository _myProfileRepository;
  ViewProfileSubscriptionTypeFreeScreenController(this._myProfileRepository);

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

  Future<void> getViewProfileApi() async {
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
}
