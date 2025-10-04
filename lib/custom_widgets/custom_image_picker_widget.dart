import 'dart:io';
import 'package:bloodfit/gen/assets.gen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

import '../../../controllers/custom_image_picker_controller.dart';
import '../utils/image_preview.dart';
import '../utils/image_picker_handler.dart';

class CustomImagePickerWidget extends StatelessWidget {
  final CustomImagePickerController controller;
  final ImagePickerHandler handler;
  final String defaultImagePath;
  final String editIconPath;
  final double shapeHeight;
  final double shapeWidth;

  const CustomImagePickerWidget({
    super.key,
    required this.controller,
    required this.handler,
    required this.defaultImagePath,
    required this.editIconPath,
    required this.shapeHeight,
    required this.shapeWidth,
  });

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final imagePath = controller.pickedImagePath.value;

      return Stack(
        alignment: Alignment.bottomRight,
        children: [
          InkWell(
            onTap: () {
              ImagePreview.show(context, imagePath);
            },
            child: Container(
              height: shapeHeight,
              width: shapeWidth,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                image: DecorationImage(
                  fit: BoxFit.cover,
                  image: imagePath.isNotEmpty
                      ? FileImage(File(imagePath))
                      : AssetImage(defaultImagePath) as ImageProvider,
                ),
              ),
            ),
          ),
          Positioned(
            bottom: 4.h,
            right: 4.w,
            child: InkWell(
              onTap: () {
                handler.handlePick(context);
              },
              child: CircleAvatar(
                radius: 16.r,
                backgroundColor: Colors.black54,
                child: SvgPicture.asset(
                  Assets.icons.cameraIcon,
                  width: 18.w,
                  height: 18.h,
                  colorFilter: const ColorFilter.mode(
                    Colors.white,
                    BlendMode.dst,
                  ),
                ),
              ),
            ),
          ),
        ],
      );
    });
  }
}
