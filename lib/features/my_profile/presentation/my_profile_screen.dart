import 'dart:developer';

import 'package:bloodfit/constants/app_list.dart';
import 'package:bloodfit/constants/text_font_style.dart';
import 'package:bloodfit/controllers/enums_controller.dart';
import 'package:bloodfit/controllers/profile_screen_controller.dart';
import 'package:bloodfit/custom_widgets/go_back_widget.dart';
import 'package:bloodfit/features/my_profile/presentation/widgets/log_out_button.dart';
import 'package:bloodfit/features/my_profile/presentation/widgets/profile_data_showing_list.dart';
import 'package:bloodfit/features/my_profile/presentation/widgets/profile_tags_showing_widget.dart';
import 'package:bloodfit/features/my_profile/presentation/widgets/show_user_type_buttons.dart';
import 'package:bloodfit/gen/assets.gen.dart';
import 'package:bloodfit/gen/colors.gen.dart';
import 'package:bloodfit/helper/ui_helpers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../controllers/custom_image_picker_controller.dart';
import '../../../custom_widgets/card_tile_option_widget.dart';
import '../../../custom_widgets/custom_image_picker_widget.dart';
import '../../../utils/image_picker_handler.dart';

class MyProfileScreen extends StatelessWidget {
  MyProfileScreen({super.key});

  final CustomImagePickerController imageController = Get.put(
    CustomImagePickerController(),
    tag: 'profileScreen',
  );

  late final ImagePickerHandler pickerHandler = ImagePickerHandler(
    imageController,
  );

  final ProfileScreenController controller =
      Get.find<ProfileScreenController>();

  final EnumsController enumsController = Get.find<EnumsController>();

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
              ///Section : Button -> User Types Buttons
              ShowUserTypeButtons(),
              UIHelper.verticalSpace(10.h),

              ///Section : ---------------------///Profile Image Picker Widget///-----------
              CustomImagePickerWidget(
                controller: imageController,
                handler: pickerHandler,
                defaultImagePath: Assets.images.profileAvatarDefaultImage.path,
                editIconPath: Assets.icons.cameraIcon,
                shapeHeight: 120.h,
                shapeWidth: 120.w,
              ),
              UIHelper.verticalSpace(10.h),

              ///Section : ---------------------///Profile Image Picker Widget///-----------
              Text(
                controller.userName,
                style: TextFontStyle.headline16w500cfefefeStylePoppins,
              ),
              UIHelper.verticalSpace(5.h),

              ///Section : ---------------------///Profile Tags///-----------
              Obx(() {
                return !controller.isFreeUser
                    ? ProfileTagShowingWidget(
                        dietType: "Classic Diet",
                        weightGainOrLooseTarget: "Loose Weight",
                      )
                    : SizedBox.shrink();
              }),

              Obx(() {
                return !controller.isFreeUser
                    ? UIHelper.verticalSpace(24.h)
                    : SizedBox.shrink();
              }),

              ///Section : ---------------------///Profile Data///-----------
              Obx(() {
                return !controller.isFreeUser
                    ? ProfileDataShowingWidget(myList: AppList.personalDataList)
                    : SizedBox.shrink();
              }),

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
                    return CardTileOptionWidget(
                      onTap: () {
                        Get.toNamed(data.route);
                      },
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
      bottomNavigationBar: LogoutButton(
        onTap: () {
          log("Button -> Logout Button Taped!");
          controller.logOutHelper();
        },
        buttonTitle: "Logout",
      ),
    );
  }
}
