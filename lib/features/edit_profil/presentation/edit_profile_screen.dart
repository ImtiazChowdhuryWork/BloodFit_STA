import 'dart:developer';

import 'package:bloodfit/constants/appList.dart';
import 'package:bloodfit/constants/text_font_style.dart';
import 'package:bloodfit/custom_widgets/custom_elevated_button.dart';
import 'package:bloodfit/custom_widgets/custom_text_form_field.dart';
import 'package:bloodfit/gen/colors.gen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

import '../../../controllers/edit_profile_screen_controller.dart';
import '../../../controllers/profile_screen_controller.dart';
import '../../../custom_widgets/custom_drop_down_field_widget.dart';
import '../../../custom_widgets/go_back_widget.dart';
import '../../../gen/assets.gen.dart';
import '../../../helper/ui_helpers.dart';
import '../../my_profile/presentation/widgets/profile_image_showing_widget.dart';
import '../../my_profile/presentation/widgets/show_image_picker_dialog.dart';

class EditProfileScreen extends StatelessWidget {
  EditProfileScreen({super.key});

  final ProfileScreenController profileScreenController =
      Get.find<ProfileScreenController>();
  final EditProfileScreenController editProfileScreenController =
      Get.find<EditProfileScreenController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: AppColors.scaffoldBackgroundColor,
        centerTitle: true,
        automaticallyImplyLeading: false,
        leading: CustomBackButton(),
        title: Text(
          "Edit Profile",
          style: TextFontStyle.headline24w700cFFFFFFStylePoppins,
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(UIHelper.kDefaulutPadding()),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                ///Section : ---------------------///Profile Image Picker Widget///-----------
                Obx(() {
                  return ProfileImageShowingWidget(
                    onTap: () {
                      log("Camera Icon Button Taped!");
                      showImagPickerDialog(
                        cameraOntap: () {
                          log("Camera Button Tapped!");
                          Get.back();
                          profileScreenController.imagePicker(
                            imagPickerSource: ImageSource.camera,
                          );
                        },
                        galleryOntap: () {
                          log("Gallery Button Taped!");
                          Get.back();
                          profileScreenController.imagePicker(
                            imagPickerSource: ImageSource.gallery,
                          );
                        },
                      );
                    },
                    shapeHeight: 120.h,
                    shapeWidth: 120.w,
                    imagePath: profileScreenController.pickedImagePath.value,
                    defualtImagePath:
                        Assets.images.profileAvatarDefaultImage.path,
                    editIconPath: Assets.icons.cameraIcon,
                  );
                }),
                UIHelper.verticalSpace(30.h),

                ///Section : -----------///Form Field -> First Name///--------------
                CustomFormField(
                  labelText: "First Name",
                  hintText: "Enter Your First Name",
                ),
                UIHelper.verticalSpace(24.h),

                ///Section : -----------///Form Field -> Last Name///--------------
                CustomFormField(
                  labelText: "Last Name",
                  hintText: "Enter Your Last Name",
                ),
                UIHelper.verticalSpace(24.h),

                ///Section : -----------///Form Field -> Email Address///--------------
                CustomFormField(
                  labelText: "Email Address",
                  hintText: "Enter Your Email",
                ),
                UIHelper.verticalSpace(24.h),

                ///Section : -----------///Form Field -> Contact Number///--------------
                CustomFormField(
                  labelText: "Contact Number",
                  hintText: "Enter Your Contact Number",
                ),
                UIHelper.verticalSpace(24.h),

                ///Section : -----------///Form Field -> Age///--------------
                CustomFormField(
                  labelText: "Age",
                  hintText: "Enter Your Age",
                  inputType: TextInputType.numberWithOptions(),
                ),
                UIHelper.verticalSpace(24.h),

                ///Section : -----------///Form Field -> BloodGroup///--------------
                ///Section : -----------///Form Field -> Gender///--------------
                Row(
                  children: [
                    ///Section : -----------///Form Field -> BloodGroup///--------------
                    Obx(
                      () => Expanded(
                        child: CustomDropdownField<String>(
                          labelText: "Blood Type",
                          hintText: "Blood Group",
                          value:
                              editProfileScreenController.selectedBlood.value,
                          onChanged: (val) {
                            editProfileScreenController.setBloodGroup(val);
                          },
                          items: AppList.bloodGroups
                              .map(
                                (bloodGroup) => DropdownMenuItem(
                                  value: bloodGroup,
                                  child: Text(bloodGroup),
                                ),
                              )
                              .toList(),
                        ),
                      ),
                    ),
                    UIHelper.horizontalSpace(24.h),

                    ///Section : -----------///Form Field -> Gender///--------------
                    Obx(
                      () => Expanded(
                        child: CustomDropdownField<String>(
                          labelText: "Gender",
                          hintText: "Select Gender",
                          value:
                              editProfileScreenController.selectdGender.value,
                          onChanged: (val) {
                            editProfileScreenController.setGenderType(val);
                          },
                          items: AppList.genderList
                              .map(
                                (gender) => DropdownMenuItem(
                                  value: gender,
                                  child: Text(gender),
                                ),
                              )
                              .toList(),
                        ),
                      ),
                    ),
                  ],
                ),
                UIHelper.verticalSpace(24.h),

                ///Section : -----------///DropDown -> Height///--------------
                ///Section : -----------///DropDown -> Weight///--------------
                Row(
                  children: [
                    ///Section : -----------///Form Field -> Height///--------------
                    Obx(
                      () => Expanded(
                        child: CustomDropdownField<String>(
                          labelText: "Height",
                          hintText: "Select Height",
                          value:
                              editProfileScreenController.selectedHeight.value,
                          onChanged: (val) {
                            editProfileScreenController.setUserHeight(val);
                          },
                          items: AppList.humanHeightsList
                              .map(
                                (useHeight) => DropdownMenuItem(
                                  value: useHeight,
                                  child: Text(useHeight),
                                ),
                              )
                              .toList(),
                        ),
                      ),
                    ),
                    UIHelper.horizontalSpace(24.h),

                    ///Section : -----------///Form Field -> Weight///--------------
                    Obx(
                      () => Expanded(
                        child: CustomDropdownField<String>(
                          labelText: "Weight",
                          hintText: "Select Weight",
                          value:
                              editProfileScreenController.selectedWeight.value,
                          onChanged: (val) {
                            editProfileScreenController.setUserWeight(val);
                          },
                          items: AppList.humanWeightsList
                              .map(
                                (userWeigth) => DropdownMenuItem(
                                  value: userWeigth,
                                  child: Text(userWeigth),
                                ),
                              )
                              .toList(),
                        ),
                      ),
                    ),
                  ],
                ),
                UIHelper.verticalSpace(70.h),

                ///Section : -----------///Button -> Weight///--------------
                CustomElevatedButton(
                  onTap: () {
                    log("Button -> Save Changes Button Taped!");
                  },
                  buttonHeight: 52.h,
                  borderRadius: 24.r,
                  buttonTitle: "Save Changes",
                ),
                UIHelper.verticalSpace(70.h),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
