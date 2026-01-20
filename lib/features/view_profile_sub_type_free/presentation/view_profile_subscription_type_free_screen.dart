import 'dart:developer';

import 'package:bloodfit/endpoints.dart';
import 'package:bloodfit/gen/colors.gen.dart';
import 'package:bloodfit/helper/logger_util.dart';
import 'package:bloodfit/helper/ui_helpers.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

import '../../../constants/text_font_style.dart';
import '../../../controllers/custom_image_picker_controller.dart';
import '../data/controller/view_profile_subscription_type_free_screen_controller.dart';
import '../../../custom_widgets/custom_elevated_button.dart';
import '../../../custom_widgets/custom_image_picker_widget.dart';
import '../../../custom_widgets/custom_text_form_field.dart';
import '../../../custom_widgets/go_back_widget.dart';
import '../../../gen/assets.gen.dart';
import '../../../utils/image_picker_handler.dart';

class ViewProfileSubscriptionTypeFreeScreen extends StatelessWidget {
  ViewProfileSubscriptionTypeFreeScreen({super.key});

  // final CustomImagePickerController imageController = Get.put(
  //   CustomImagePickerController(),
  //   tag: 'profileScreen',
  // );
  final CustomImagePickerController imageController = Get.put(
    CustomImagePickerController(),
  );

  late final ImagePickerHandler pickerHandler = ImagePickerHandler(
    imageController,
  );

  final ViewProfileSubscriptionTypeFreeScreenController
  viewProfileSubTypeFreeController =
      Get.find<ViewProfileSubscriptionTypeFreeScreenController>();

  @override
  Widget build(BuildContext context) {
    LoggerUtils.debug('Image URl : ${imageController.imageFromApi}');
    return Scaffold(
      backgroundColor: AppColors.scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: AppColors.scaffoldBackgroundColor,
        centerTitle: true,
        automaticallyImplyLeading: false,
        leading: const CustomBackButton(),
        title: Text(
          "View Profile",
          style: TextFontStyle.headline24w700cFFFFFFStylePoppins,
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(UIHelper.kDefaulutPadding()),
          child: Column(
            children: [
              ///Section : ---------------------///Profile Image Picker Widget///-----------
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox.shrink(),

                  ///------------>>> Show the Current Available Profile Picture
                  Obx(() {
                    return viewProfileSubTypeFreeController.isEditModeOn.value
                        ? CustomImagePickerWidget(
                            controller: imageController,
                            handler: pickerHandler,
                            defaultImagePath:
                                Assets.images.profileAvatarDefaultImage.path,
                            editIconPath: Assets.icons.cameraIcon,
                            shapeHeight: 120.h,
                            shapeWidth: 120.w,
                          )
                        : imageController.isImageAvailable.value
                        ? Container(
                            padding: EdgeInsets.all(2.sp),
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: AppColors.cFFFFFF,
                            ),
                            child: ClipOval(
                              child: CachedNetworkImage(
                                height: 120.h,
                                width: 120.w,
                                fit: BoxFit.cover,
                                imageUrl:
                                    '$imageBaseUrl${imageController.imageFromApi}',
                              ),
                            ),
                          )
                        : Container(
                            width: 120.w,
                            height: 120.h,
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: AppColors.cb20000,
                                width: 2.sp,
                              ),
                              shape: BoxShape.circle,
                              image: DecorationImage(
                                fit: BoxFit.cover,
                                image: AssetImage(
                                  Assets.images.profileAvatarDefaultImage.path,
                                ),
                              ),
                            ),
                          );
                  }),

                  ///Section : ---------------------///Button : Edit///-----------
                  Obx(() {
                    return InkWell(
                      onTap: viewProfileSubTypeFreeController.isEditModeOn.value
                          ? null
                          : () {
                              log("Button : Pen Icon Edit Button Taped!");
                              viewProfileSubTypeFreeController.setEditMode();
                            },
                      child: Container(
                        padding: EdgeInsets.all(8.sp),
                        decoration: BoxDecoration(
                          color:
                              viewProfileSubTypeFreeController
                                  .isEditModeOn
                                  .value
                              ? Colors.grey
                              : AppColors.cb20000,
                          borderRadius: BorderRadius.circular(6.r),
                        ),
                        child: SvgPicture.asset(Assets.icons.penIconWhiteBold),
                      ),
                    );
                  }),
                ],
              ),
              UIHelper.verticalSpace(10.h),

              ///Section : ---------------------///Profile Image Picker Widget///-----------
              Text(
                "Tasmia Hassan Shabonty",
                style: TextFontStyle.headline16w500cfefefeStylePoppins,
              ),
              UIHelper.verticalSpace(5.h),

              ///Section : -----------///Form Field -> First Name///--------------
              Obx(() {
                return CustomFormField(
                  controller: viewProfileSubTypeFreeController.firstName,
                  isEnabled:
                      viewProfileSubTypeFreeController.isEditModeOn.value,
                  labelText: "First Name",
                  hintText: "Enter Your First Name",
                );
              }),
              UIHelper.verticalSpace(24.h),

              ///Section : -----------///Form Field -> Last Name///--------------
              Obx(() {
                return CustomFormField(
                  controller: viewProfileSubTypeFreeController.lastName,
                  isEnabled:
                      viewProfileSubTypeFreeController.isEditModeOn.value,
                  labelText: "Last Name",
                  hintText: "Enter Your Last Name",
                );
              }),
              UIHelper.verticalSpace(24.h),

              ///Section : -----------///Form Field -> Email Address///--------------
              Obx(() {
                return CustomFormField(
                  controller: viewProfileSubTypeFreeController.emailAddress,
                  isEnabled:
                      viewProfileSubTypeFreeController.isEditModeOn.value,
                  labelText: "Email Address",
                  hintText: "Enter Your Email",
                );
              }),
              UIHelper.verticalSpace(24.h),

              ///Section : -----------///Form Field -> Contact Number///--------------
              Obx(() {
                return CustomFormField(
                  controller: viewProfileSubTypeFreeController.contactNumber,
                  isEnabled:
                      viewProfileSubTypeFreeController.isEditModeOn.value,
                  labelText: "Contact Number",
                  hintText: "Enter Your Contact Number",
                );
              }),
            ],
          ),
        ),
      ),

      bottomNavigationBar: Obx(() {
        return viewProfileSubTypeFreeController.isEditModeOn.value
            ? Container(
                width: 1.sw,
                padding: EdgeInsets.only(
                  top: UIHelper.kDefaulutPadding(),
                  left: UIHelper.kDefaulutPadding(),
                  right: UIHelper.kDefaulutPadding(),
                  bottom: 70.h,
                ),
                child: CustomElevatedButton(
                  onTap: () {
                    log("Button -> Save Changes Button Taped!");
                    viewProfileSubTypeFreeController.setEditMode();
                    // Get.back();
                  },
                  buttonHeight: 52.h,
                  borderRadius: 24.r,
                  buttonTitle: "Save Changes",
                ),
              )
            : SizedBox.shrink();
      }),
    );
  }
}
