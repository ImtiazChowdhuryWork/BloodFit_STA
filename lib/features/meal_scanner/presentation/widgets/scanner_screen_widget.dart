import 'dart:developer';

import 'package:bloodfit/features/meal_scanner/presentation/widgets/scanner_camera_capture_button.dart';
import 'package:bloodfit/features/meal_scanner/presentation/widgets/scanner_nutrition_details_widget.dart';
import 'package:bloodfit/features/meal_scanner/presentation/widgets/scanner_overlay_widget.dart';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../data/controller/meal_scanner_screen_controller.dart';
import '../../../../gen/colors.gen.dart';

class ScannerScreenWidget extends StatelessWidget {
  final MealScannerScreenController controller =
      Get.find<MealScannerScreenController>();
  ScannerScreenWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // FULL SCREEN Camera Preview
        SizedBox(
          width: 1.sw,
          height: 0.81.sh,
          child: CameraPreview(controller.cameraController),
        ),

        // Scanner Overlay (Positioned in center)
        ScannerOverlayWidget(),
        // Close Button - Use Navigator.pop() to go back
        Positioned(
          top: 10.h,
          left: 10.w,
          child: IconButton(
            icon: Icon(Icons.close, color: AppColors.cb20000, size: 30.sp),
            onPressed: () {
              log("Button Taped : Close Button");
              Get.back();
            },
          ),
        ),

        // Nutrition Details (when available)
        ScannerNutritionDetailsWidget(),

        // Capture Button
        ScannerCameraCaptureButton(),
      ],
    );
  }
}
