import 'package:bloodfit/features/meal_scanner/data/controller/meal_scanner_screen_controller.dart';
import 'package:bloodfit/features/meal_scanner/presentation/widgets/scanner_camera_initializing_widget.dart';
import 'package:bloodfit/features/meal_scanner/presentation/widgets/scanner_screen_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MealScannerScreen extends StatelessWidget {
  MealScannerScreen({super.key});

  final MealScannerScreenController controller =
      Get.find<MealScannerScreenController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Obx(() {
          if (!controller.cameraInitialized.value) {
            return ScannerCameraInitializingWidget();
          }
          return ScannerScreenWidget();
        }),
      ),
    );
  }
}
