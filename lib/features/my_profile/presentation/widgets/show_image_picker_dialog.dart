import 'package:bloodfit/constants/text_font_style.dart';
import 'package:bloodfit/gen/assets.gen.dart';
import 'package:bloodfit/gen/colors.gen.dart';
import 'package:bloodfit/helper/ui_helpers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

void showImagPickerDialog({
  required final void Function()? cameraOntap,
  required final void Function()? galleryOntap,
}) {
  Get.dialog(
    Center(
      child: Material(
        color: AppColors.c3c3c3c,
        child: Container(
          width: 0.8.sw,
          padding: EdgeInsets.all(10.sp),
          decoration: BoxDecoration(
            color: AppColors.c3c3c3c,
            borderRadius: BorderRadius.circular(12.r),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ///Section : Camera
              ListTile(
                onTap: cameraOntap,
                leading: SvgPicture.asset(
                  Assets.icons.cameraIconWithoutBg,
                  colorFilter: ColorFilter.mode(
                    AppColors.cFFFFFF,
                    BlendMode.color,
                  ),
                ),
                title: Text(
                  "Camera",
                  style: TextFontStyle.headline16w500cFFFFFFStylePoppins,
                ),
                trailing: Icon(
                  Icons.arrow_forward_ios_rounded,
                  color: AppColors.c999999,
                ),
              ),
              UIHelper.verticalSpace(10.h),

              ///Section : Camera
              ListTile(
                onTap: galleryOntap,
                leading: Icon(
                  Icons.collections_rounded,
                  color: AppColors.cFFFFFF,
                ),
                title: Text(
                  "Gellary",
                  style: TextFontStyle.headline16w500cFFFFFFStylePoppins,
                ),
                trailing: Icon(
                  Icons.arrow_forward_ios_rounded,
                  color: AppColors.c999999,
                ),
              ),
            ],
          ),
        ),
      ),
    ),
  );
}
