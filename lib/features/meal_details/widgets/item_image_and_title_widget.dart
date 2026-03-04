import 'dart:convert';

import 'package:bloodfit/custom_widgets/meal_network_image_showing_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../constants/text_font_style.dart';
import '../../../custom_widgets/go_back_widget.dart';
import '../../../gen/colors.gen.dart';
import '../../../helper/ui_helpers.dart';

class ItemImageAndTitleWidget extends StatelessWidget {
  final String imagePath;
  final String title;
  final bool isBase64;
  const ItemImageAndTitleWidget({
    super.key,
    required this.imagePath,
    required this.title,
    this.isBase64 = false,
  });

  /// Check if the image path is a base64 string
  bool get _isBase64Image {
    // If explicitly set, use that
    if (isBase64) return true;
    
    // Otherwise, detect based on content
    // Base64 images typically start with "data:image" or contain only base64 characters
    if (imagePath.startsWith('data:image')) return true;
    if (imagePath.startsWith('http://') || imagePath.startsWith('https://')) return false;
    
    // Check if it looks like base64 (contains only valid base64 characters and possibly commas)
    final cleanPath = imagePath.contains(',') ? imagePath.split(',').last : imagePath;
    return RegExp(r'^[A-Za-z0-9+/=]+$').hasMatch(cleanPath);
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        // Display image based on type
        if (_isBase64Image)
          /// Base64 image
          Image.memory(
            base64Decode(imagePath.contains(',') ? imagePath.split(',').last : imagePath),
            width: 1.sw,
            height: 0.4.sh,
            fit: BoxFit.cover,
          )
        else
          /// Network/URL image
          CustomNetworkImageWidget(
            imageUrl: imagePath,
            isClipOval: false,
            width: 1.sw,
            height: 0.4.sh,
            fit: BoxFit.cover,
          ),
        
        // Deep gradient fade for smooth blend
        Positioned(
          bottom: 0,
          left: 0,
          right: 0,
          child: Container(
            height: 120.h, // increase depth of fade
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.transparent,
                  AppColors.scaffoldBackgroundColor.withValues(alpha: 0.3),
                  AppColors.scaffoldBackgroundColor.withValues(alpha: 0.6),
                  AppColors.scaffoldBackgroundColor.withValues(alpha: 0.9),
                  AppColors.scaffoldBackgroundColor,
                ],
                stops: const [0.0, 0.25, 0.5, 0.75, 1.0],
              ),
            ),
          ),
        ),

        // AppBar overlay
        Positioned(
          top: 80.h,
          left: 0.w,
          right: 0.w,
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: UIHelper.kDefaulutPadding(),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                CustomBackButton(),
                Text(
                  "Meal Details",
                  style: TextFontStyle.headline24w700cfefefeStylePoppins,
                ),
                const SizedBox.shrink(),
              ],
            ),
          ),
        ),

        Positioned(
          bottom: 0.h,
          left: 0.w,
          right: 0.w,
          child: Align(
            alignment: Alignment.center,
            child: Text(
              title,
              style: TextFontStyle.headline22w500cfefefeStylePoppins,
            ),
          ),
        ),
      ],
    );
  }
}
