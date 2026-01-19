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
import 'package:bloodfit/helper/logger_util.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class CustomImagePickerController extends GetxController {
  final Rx<XFile?> _pickedImage = Rx<XFile?>(null);
  final RxString _imageFromApi = RxString('');

  // Callback for when an image is picked
  Function()? onImagePicked;

  CustomImagePickerController() {
    // Debug: Log initial state
    LoggerUtils.debug('CustomImagePickerController initialized');
    ever(_pickedImage, (value) {
      LoggerUtils.debug('Picked image changed: ${value?.path ?? "null"}');
    });
    ever(_imageFromApi, (value) {
      LoggerUtils.debug('API image changed: $value');
    });
  }

  XFile? get pickedImage => _pickedImage.value;
  String get pickedImagePath => _pickedImage.value?.path ?? '';
  File? get pickedImageFile =>
      _pickedImage.value != null ? File(_pickedImage.value!.path) : null;

  String get imageFromApi => _imageFromApi.value;

  /// Set image from API (network image)
  void setImageFromApi(String imageUrl) {
    LoggerUtils.debug('Setting API image: $imageUrl');
    _imageFromApi.value = imageUrl;
  }

  /// Clear both picked image and API image
  void clearImage() {
    LoggerUtils.debug('Clearing images - picked: ${_pickedImage.value?.path}, api: ${_imageFromApi.value}');
    _pickedImage.value = null;
    _imageFromApi.value = '';
  }

  /// Pick image from camera or gallery
  Future<void> pickImage(ImageSource source) async {
    try {
      LoggerUtils.debug('Attempting to pick image from: $source');
      final XFile? image = await ImagePicker().pickImage(
        source: source,
        maxHeight: 1024,
        maxWidth: 1024,
        imageQuality: 85,
      );

      if (image != null) {
        LoggerUtils.debug('Image picked successfully: ${image.path}');
        _pickedImage.value = image;
        // Clear API image when picking new image
        _imageFromApi.value = '';

        // Trigger the callback if set
        if (onImagePicked != null) {
          LoggerUtils.debug('Calling onImagePicked callback');
          onImagePicked!();
        }
      } else {
        LoggerUtils.debug('No image picked');
      }
    } catch (e) {
      LoggerUtils.error('Error picking image: $e');
      Get.snackbar(
        'Error',
        'Failed to pick image: ${e.toString()}',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  /// Check if we should show picked image or API image
  bool get shouldShowPickedImage {
    bool result = pickedImage != null;
    LoggerUtils.debug('shouldShowPickedImage: $result (pickedImage: ${pickedImage?.path})');
    return result;
  }

  bool get shouldShowApiImage {
    bool result = imageFromApi.isNotEmpty;
    LoggerUtils.debug('shouldShowApiImage: $result (imageFromApi: $imageFromApi)');
    return result;
  }

  /// Get the image to display (priority: picked image > API image)
  String get imageToDisplay {
    String result;
    if (shouldShowPickedImage) {
      result = pickedImagePath;
      LoggerUtils.debug('imageToDisplay: Returning picked image: $result');
    } else if (shouldShowApiImage) {
      result = imageFromApi;
      LoggerUtils.debug('imageToDisplay: Returning API image: $result');
    } else {
      result = '';
      LoggerUtils.debug('imageToDisplay: Returning empty (default)');
    }
    return result;
  }

  /// Get widget for displaying the image
  Widget get imageWidget {
    LoggerUtils.debug('Building imageWidget - shouldShowPickedImage: $shouldShowPickedImage, shouldShowApiImage: $shouldShowApiImage');

    if (shouldShowPickedImage) {
      LoggerUtils.debug('imageWidget: Building Image.file for picked image: $pickedImagePath');
      return Image.file(
        File(pickedImagePath),
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) {
          LoggerUtils.debug('imageWidget: Error loading picked image: $error');
          return _defaultImage();
        },
      );
    } else if (shouldShowApiImage) {
      LoggerUtils.debug('imageWidget: Building Image.network for API image: $imageFromApi');
      return Image.network(
        imageFromApi,
        fit: BoxFit.cover,
        loadingBuilder: (context, child, loadingProgress) {
          if (loadingProgress == null) {
            LoggerUtils.debug('imageWidget: API image loaded successfully');
            return child;
          }
          LoggerUtils.debug('imageWidget: API image loading...');
          return Center(child: CircularProgressIndicator());
        },
        errorBuilder: (context, error, stackTrace) {
          LoggerUtils.debug('imageWidget: Error loading API image: $error');
          return _defaultImage();
        },
      );
    } else {
      LoggerUtils.debug('imageWidget: Building default image');
      return _defaultImage();
    }
  }

  Widget _defaultImage() {
    LoggerUtils.debug('_defaultImage: Building default image widget');
    return Container(
      color: Colors.grey[300],
      child: Icon(Icons.person, size: 50, color: Colors.grey[600]),
    );
  }
}
