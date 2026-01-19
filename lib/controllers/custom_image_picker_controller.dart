// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:get/get.dart';
// import 'package:image_picker/image_picker.dart';

// class CustomImagePickerController extends GetxController {
//   final ImagePicker _picker = ImagePicker();
//   RxString pickedImagePath = ''.obs;

//   Future<void> pickImage(ImageSource source) async {
//     try {
//       final XFile? image = await _picker.pickImage(
//         source: source,
//         maxWidth: 1024.w,
//         maxHeight: 1024.h,
//         imageQuality: 85,
//       );

//       if (image != null) {
//         pickedImagePath.value = image.path;
//       } else {
//         Get.snackbar("Canceled", "No image selected.");
//       }
//     } catch (e) {
//       Get.snackbar("Error", "Failed to pick image: $e");
//     }
//   }
// }

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class CustomImagePickerController extends GetxController {
  final Rx<XFile?> _pickedImage = Rx<XFile?>(null);
  final RxString _imageFromApi = RxString('');

  XFile? get pickedImage => _pickedImage.value;
  String get pickedImagePath => _pickedImage.value?.path ?? '';
  File? get pickedImageFile =>
      _pickedImage.value != null ? File(_pickedImage.value!.path) : null;

  String get imageFromApi => _imageFromApi.value;

  /// Set image from API (network image)
  void setImageFromApi(String imageUrl) {
    _imageFromApi.value = imageUrl;
  }

  /// Clear both picked image and API image
  void clearImage() {
    _pickedImage.value = null;
    _imageFromApi.value = '';
  }

  /// Pick image from camera or gallery
  Future<void> pickImage(ImageSource source) async {
    try {
      final XFile? image = await ImagePicker().pickImage(
        source: source,
        maxHeight: 1024,
        maxWidth: 1024,
        imageQuality: 85,
      );

      if (image != null) {
        _pickedImage.value = image;
        // Clear API image when picking new image
        _imageFromApi.value = '';
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to pick image: ${e.toString()}',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  /// Check if we should show picked image or API image
  bool get shouldShowPickedImage => pickedImage != null;
  bool get shouldShowApiImage => imageFromApi.isNotEmpty;

  /// Get the image to display (priority: picked image > API image)
  String get imageToDisplay {
    if (shouldShowPickedImage) {
      return pickedImagePath;
    } else if (shouldShowApiImage) {
      return imageFromApi;
    }
    return ''; // Return empty for default image
  }

  /// Get widget for displaying the image
  Widget get imageWidget {
    if (shouldShowPickedImage) {
      return Image.file(
        File(pickedImagePath),
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) => _defaultImage(),
      );
    } else if (shouldShowApiImage) {
      return Image.network(
        imageFromApi,
        fit: BoxFit.cover,
        loadingBuilder: (context, child, loadingProgress) {
          if (loadingProgress == null) return child;
          return Center(child: CircularProgressIndicator());
        },
        errorBuilder: (context, error, stackTrace) => _defaultImage(),
      );
    } else {
      return _defaultImage();
    }
  }

  Widget _defaultImage() {
    return Container(
      color: Colors.grey[300],
      child: Icon(Icons.person, size: 50, color: Colors.grey[600]),
    );
  }
}
