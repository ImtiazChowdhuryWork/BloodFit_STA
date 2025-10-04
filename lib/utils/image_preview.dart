import 'dart:io';
import 'package:bloodfit/gen/colors.gen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class ImagePreview {
  static void show(BuildContext context, String imagePath) {
    if (imagePath.isEmpty || !File(imagePath).existsSync()) return;

    showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: '',
      barrierColor: Colors.black54,
      pageBuilder: (_, __, ___) => Center(
        child: Container(
          width: 0.9.sw,
          height: 0.3.sh,
          padding: EdgeInsets.zero,
          decoration: BoxDecoration(
            color: AppColors.c3c3c3c,
            borderRadius: BorderRadius.circular(4.r),
          ),
          child: InteractiveViewer(
            child: Image.file(File(imagePath), fit: BoxFit.contain),
          ),
        ),
      ),
    );
  }
}
