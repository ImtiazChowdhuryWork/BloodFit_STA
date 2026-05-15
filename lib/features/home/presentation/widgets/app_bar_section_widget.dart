import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

import '../../../../controllers/custom_image_picker_controller.dart';
import '../../../../custom_widgets/app_logo_widget.dart';
import '../../../../features/my_profile/data/controller/profile_screen_controller.dart';
import '../../../../gen/assets.gen.dart';
import '../../../../gen/colors.gen.dart';
import '../../../../helper/ui_helpers.dart';
import '../../../../routes/routes.dart';

/// App bar shown at the top of every main screen (Home, Meal, Workout, Progress).
///
/// Profile image priority:
///   1. Locally picked image (shows immediately after user picks, before upload).
///   2. API image URL from [ProfileScreenController.reactiveProfileImageUrl]
///      which is pre-loaded from GetStorage in [onInit] and updated after
///      every successful API fetch — survives hot reload and app restart.
///   3. Default asset fallback.
class AppBarSectionWidget extends StatelessWidget {
  const AppBarSectionWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final profileController = Get.find<ProfileScreenController>();
    final imagePickerController = Get.find<CustomImagePickerController>();

    return Row(
      children: [
        AppLogoWidget(),
        Spacer(),

        InkWell(
          onTap: () => Get.toNamed(Routes.notificationScreen),
          child: SvgPicture.asset(Assets.icons.bellIcon),
        ),
        UIHelper.horizontalSpace(15.w),

        InkWell(
          onTap: () => Get.toNamed(Routes.myProfileScreen),
          child: Obx(() {
            // Priority 1: locally picked image (before upload completes).
            if (imagePickerController.shouldShowPickedImage) {
              return _profileCircle(
                Image.file(
                  File(imagePickerController.pickedImagePath),
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) => _defaultImage(),
                ),
              );
            }

            // Priority 2: reactive URL from ProfileScreenController.
            // Pre-populated from GetStorage on init — no flash on hot reload.
            final imageUrl = profileController.reactiveProfileImageUrl.value;
            if (imageUrl.isNotEmpty) {
              return _profileCircle(
                CachedNetworkImage(
                  imageUrl: imageUrl,
                  fit: BoxFit.cover,
                  errorWidget: (context, url, error) => _defaultImage(),
                ),
              );
            }

            // Priority 3: default fallback.
            return _profileCircle(_defaultImage());
          }),
        ),
      ],
    );
  }

  Widget _profileCircle(Widget child) {
    return Container(
      width: 48.w,
      height: 48.h,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: AppColors.cFFFFFF),
      ),
      child: ClipOval(child: child),
    );
  }

  Widget _defaultImage() {
    return Image.asset(Assets.images.userImage.path, fit: BoxFit.cover);
  }
}
