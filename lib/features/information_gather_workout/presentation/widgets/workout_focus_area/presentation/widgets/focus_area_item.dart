import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class FocusAreaItem extends StatelessWidget {
  final RxBool isSelected;
  final VoidCallback onTap;
  final String selectedImagePath;
  final String unselectedImagePath;
  final double top;
  final double right;
  final double imageWidth;
  final double imageHeight;

  const FocusAreaItem({
    super.key,
    required this.isSelected,
    required this.onTap,
    required this.selectedImagePath,
    required this.unselectedImagePath,
    required this.top,
    required this.right,
    this.imageWidth = 296,
    this.imageHeight = 112,
  });

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final bool selected = isSelected.value;

      return Positioned(
        top: top.h,
        right: right.w,
        child: InkWell(
          onTap: onTap,
          child: Image.asset(
            selected ? selectedImagePath : unselectedImagePath,
            width: imageWidth.w,
            height: imageHeight.h,
            fit: BoxFit.contain,
          ),
        ),
      );
    });
  }
}
