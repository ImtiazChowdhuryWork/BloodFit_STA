import 'dart:developer';

import 'package:bloodfit/constants/appList.dart';
import 'package:bloodfit/constants/text_font_style.dart';
import 'package:bloodfit/controllers/profile_screen_controller.dart';
import 'package:bloodfit/custom_widgets/go_back_widget.dart';
import 'package:bloodfit/features/my_profile/presentation/widgets/profile_image_showing_widget.dart';
import 'package:bloodfit/features/my_profile/presentation/widgets/show_image_picker_dialog.dart';
import 'package:bloodfit/gen/assets.gen.dart';
import 'package:bloodfit/gen/colors.gen.dart';
import 'package:bloodfit/helper/ui_helpers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

import '../../../custom_widgets/profile_tile_card_widget.dart';

class MyProfileScreen extends StatelessWidget {
  MyProfileScreen({super.key});

  ProfileScreenController controller = Get.put(ProfileScreenController());

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
          "My Profile",
          style: TextFontStyle.headline24w700cFFFFFFStylePoppins,
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(UIHelper.kDefaulutPadding()),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
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
                        controller.imagePicker(
                          imagPickerSource: ImageSource.camera,
                        );
                      },
                      galleryOntap: () {
                        log("Gallery Button Taped!");
                        Get.back();
                        controller.imagePicker(
                          imagPickerSource: ImageSource.gallery,
                        );
                      },
                    );
                  },
                  shapeHeight: 120.h,
                  shapeWidth: 120.w,
                  imagePath: controller.pickedImagePath.value,
                  defualtImagePath:
                      Assets.images.profileAvatarDefaultImage.path,
                  editIconPath: Assets.icons.cameraIcon,
                );
              }),
              UIHelper.verticalSpace(10.h),

              ///Section : ---------------------///Profile Image Picker Widget///-----------
              Text(
                "Tasmia Hassan Shabonty",
                style: TextFontStyle.headline16w500cfefefeStylePoppins,
              ),
              UIHelper.verticalSpace(32.h),

              ///Section : ---------------------///Profile Tile Based on User Subscription Type///-----------
              Obx(() {
                return ListView.separated(
                  itemCount: controller.isFreeUser
                      ? AppList.freeUserProfileTileList.length
                      : AppList.premimumUserProfileTileList.length,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  separatorBuilder: (context, index) =>
                      UIHelper.verticalSpace(16.h),
                  itemBuilder: (context, index) {
                    var data = controller.isFreeUser
                        ? AppList.freeUserProfileTileList[index]
                        : AppList.premimumUserProfileTileList[index];
                    return ProfileTileCardWidget(
                      onTap: () {},
                      imagePath: data.imagePath,
                      title: data.title,
                    );
                  },
                );
              }),
            ],
          ),
        ),
      ),

      ///Section : -----------///Log Out Button///-----------
      bottomNavigationBar: Container(
        height: 150.h,
        color: Colors.transparent,
        padding: EdgeInsets.only(
          bottom: 80.h,
          right: UIHelper.kDefaulutPadding(),
          left: UIHelper.kDefaulutPadding(),
          top: UIHelper.kDefaulutPadding(),
        ),
        child: InkWell(
          onTap: () {
            log("Button -> Logout Button Taped!");
          },
          child: ProfileTileCardWidget(
            imagePath: Assets.icons.logoutIcon,
            cardColor: AppColors.cb20000,
            suffixColor: AppColors.cFFFFFF,
            title: "Logout",
          ),
        ),
      ),
    );
  }
}
