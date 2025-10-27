import 'package:bloodfit/features/meal_scanner/presentation/widgets/scanner_camera_initializing_widget.dart';
import 'package:bloodfit/features/meal_scanner/presentation/widgets/scanner_screen_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../controllers/meal_scanner_screen_controller.dart';

class MealScannerScreen extends StatelessWidget {
  final MealScannerScreenController controller = Get.put(
    MealScannerScreenController(),
  );

  MealScannerScreen({super.key});

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
