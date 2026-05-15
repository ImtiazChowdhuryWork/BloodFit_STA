import 'dart:developer';
import 'dart:io';

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
        /// Camera preview — freezes on the captured image during analysis,
        /// returns to live feed when analysis completes.
        Obx(() {
          final frozen = controller.capturedImagePath.value;
          return SizedBox(
            width: 1.sw,
            height: 0.81.sh,
            child: frozen.isNotEmpty
                ? Image.file(File(frozen), fit: BoxFit.cover)
                : CameraPreview(controller.cameraController),
          );
        }),

        /// Scanning frame with animated scan line
        ScannerOverlayWidget(),

        /// Close button
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

        /// Shutter flash — brief white overlay when photo is taken.
        Obx(() {
          return AnimatedOpacity(
            opacity: controller.isFlashing.value ? 1.0 : 0.0,
            duration: const Duration(milliseconds: 150),
            child: controller.isFlashing.value
                ? Container(
                    width: double.infinity,
                    height: double.infinity,
                    color: Colors.white.withValues(alpha: 0.85),
                  )
                : const SizedBox.shrink(),
          );
        }),


        /// Nutrition result panel
        ScannerNutritionDetailsWidget(),

        /// Capture button
        ScannerCameraCaptureButton(),
      ],
    );
  }
}
