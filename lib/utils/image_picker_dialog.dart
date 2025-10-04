import 'package:bloodfit/gen/assets.gen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

void showImagePickerDialog({
  required VoidCallback onCameraTap,
  required VoidCallback onGalleryTap,
}) {
  Get.dialog(
    Center(
      child: Material(
        color: Colors.transparent,
        child: Container(
          width: 0.8.sw,
          padding: EdgeInsets.all(10.sp),
          decoration: BoxDecoration(
            color: const Color(0xFF3C3C3C),
            borderRadius: BorderRadius.circular(12.r),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                onTap: onCameraTap,
                leading: SvgPicture.asset(
                  Assets.icons.cameraIcon,
                  width: 24,
                  height: 24,
                  colorFilter: const ColorFilter.mode(
                    Colors.white,
                    BlendMode.dst,
                  ),
                ),
                title: const Text(
                  "Camera",
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w500,
                    fontSize: 16,
                  ),
                ),
              ),
              ListTile(
                onTap: onGalleryTap,
                leading: const Icon(
                  Icons.collections_rounded,
                  color: Colors.white,
                ),
                title: const Text(
                  "Gallery",
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w500,
                    fontSize: 16,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    ),
  );
}
