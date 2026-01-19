// import 'dart:io';
// import 'package:bloodfit/gen/assets.gen.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:flutter_svg/flutter_svg.dart';
// import 'package:get/get.dart';

// import '../../../controllers/custom_image_picker_controller.dart';
// import '../utils/image_preview.dart';
// import '../utils/image_picker_handler.dart';

// class CustomImagePickerWidget extends StatelessWidget {
//   final CustomImagePickerController controller;
//   final ImagePickerHandler handler;
//   final String defaultImagePath;
//   final String editIconPath;
//   final double shapeHeight;
//   final double shapeWidth;

//   const CustomImagePickerWidget({
//     super.key,
//     required this.controller,
//     required this.handler,
//     required this.defaultImagePath,
//     required this.editIconPath,
//     required this.shapeHeight,
//     required this.shapeWidth,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return Obx(() {
//       final imagePath = controller.pickedImagePath.value;

//       return Stack(
//         alignment: Alignment.bottomRight,
//         children: [
//           InkWell(
//             onTap: () {
//               ImagePreview.show(context, imagePath);
//             },
//             child: Container(
//               height: shapeHeight,
//               width: shapeWidth,
//               decoration: BoxDecoration(
//                 shape: BoxShape.circle,
//                 image: DecorationImage(
//                   fit: BoxFit.cover,
//                   image: imagePath.isNotEmpty
//                       ? FileImage(File(imagePath))
//                       : AssetImage(defaultImagePath) as ImageProvider,
//                 ),
//               ),
//             ),
//           ),
//           Positioned(
//             bottom: 4.h,
//             right: 4.w,
//             child: InkWell(
//               onTap: () {
//                 handler.handlePick(context);
//               },
//               child: CircleAvatar(
//                 radius: 16.r,
//                 backgroundColor: Colors.black54,
//                 child: SvgPicture.asset(
//                   Assets.icons.cameraIcon,
//                   width: 18.w,
//                   height: 18.h,
//                   colorFilter: const ColorFilter.mode(
//                     Colors.white,
//                     BlendMode.dst,
//                   ),
//                 ),
//               ),
//             ),
//           ),
//         ],
//       );
//     });
//   }
// }

import 'dart:io';
import 'package:bloodfit/gen/assets.gen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:cached_network_image/cached_network_image.dart';

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
      final shouldShowPickedImage = controller.shouldShowPickedImage;
      final shouldShowApiImage = controller.shouldShowApiImage;
      final imageToDisplay = controller.imageToDisplay;

      print('CustomImagePickerWidget - shouldShowPickedImage: $shouldShowPickedImage, shouldShowApiImage: $shouldShowApiImage, imageToDisplay: $imageToDisplay');

      return Stack(
        alignment: Alignment.bottomRight,
        children: [
          // Profile Image Container
          InkWell(
            onTap: () {
              if (imageToDisplay.isNotEmpty) {
                // Pass the string path/URL directly
                ImagePreview.show(context, imageToDisplay);
              }
            },
            child: Container(
              height: shapeHeight,
              width: shapeWidth,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: Colors.white, width: 2.w),
              ),
              child: ClipOval(
                child: Obx(() {
                  print('Rebuilding image - picked: ${controller.shouldShowPickedImage}, api: ${controller.shouldShowApiImage}');

                  if (controller.shouldShowPickedImage) {
                    // Show picked image from device
                    final imagePath = controller.pickedImagePath;
                    print('Showing picked image: $imagePath');
                    if (imagePath.isNotEmpty) {
                      return Image.file(
                        File(imagePath),
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          print('Error loading picked image: $error');
                          return _defaultImage();
                        },
                      );
                    }
                    return _defaultImage();
                  } else if (controller.shouldShowApiImage) {
                    // Show image from API (network image)
                    final imageUrl = controller.imageFromApi;
                    print('Showing API image: $imageUrl');
                    if (imageUrl.isNotEmpty) {
                      // Check if the URL is relative and prepend the base URL if needed
                      String fullImageUrl = imageUrl;
                      if (imageUrl.startsWith('/')) {
                        // Use the same base URL as defined in endpoints.dart
                        // The API base URL is https://faisal5000.merinasib.shop/api/v1
                        // So image URLs should be https://faisal5000.merinasib.shop/api/v1/image/...
                        fullImageUrl = 'https://faisal5000.merinasib.shop/api/v1$imageUrl';
                      }

                      return CachedNetworkImage(
                        imageUrl: fullImageUrl,
                        fit: BoxFit.cover,
                        placeholder: (context, url) => Center(
                          child: CircularProgressIndicator(
                            strokeWidth: 2.w,
                            color: Colors.white,
                          ),
                        ),
                        errorWidget: (context, url, error) {
                          print('Error loading API image: $error');
                          return _defaultImage();
                        },
                      );
                    }
                    return _defaultImage();
                  } else {
                    print('Showing default image');
                    // Show default image
                    return _defaultImage();
                  }
                }),
              ),
            ),
          ),

          // Camera Edit Button
          Positioned(
            bottom: 4.h,
            right: 4.w,
            child: InkWell(
              onTap: () => handler.handlePick(context),
              child: CircleAvatar(
                radius: 16.r,
                backgroundColor: Colors.black54,
                child: SvgPicture.asset(
                  editIconPath,
                  width: 18.w,
                  height: 18.h,
                  colorFilter: const ColorFilter.mode(
                    Colors.white,
                    BlendMode.srcIn,
                  ),
                ),
              ),
            ),
          ),
        ],
      );
    });
  }

  Widget _defaultImage() {
    return Image.asset(defaultImagePath, fit: BoxFit.cover);
  }
}
