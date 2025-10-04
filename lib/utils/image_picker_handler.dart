import 'package:bloodfit/utils/image_picker_dialog.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

import '../controllers/custom_image_picker_controller.dart';

class ImagePickerHandler {
  final CustomImagePickerController controller;
  ImagePickerHandler(this.controller);

  void pickFromCamera() => controller.pickImage(ImageSource.camera);
  void pickFromGallery() => controller.pickImage(ImageSource.gallery);

  void handlePick(BuildContext context) {
    showImagePickerDialog(
      onCameraTap: () {
        Get.back();
        pickFromCamera();
      },
      onGalleryTap: () {
        Get.back();
        pickFromGallery();
      },
    );
  }
}
