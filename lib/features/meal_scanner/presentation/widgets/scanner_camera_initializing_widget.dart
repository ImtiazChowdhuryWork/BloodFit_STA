import '../../data/controller/meal_scanner_screen_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ScannerCameraInitializingWidget extends StatelessWidget {
  const ScannerCameraInitializingWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<MealScannerScreenController>();
    return Center(
      child: Obx(() {
        if (controller.cameraInitFailed.value) {
          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.camera_alt_outlined, color: Colors.white54, size: 48),
              const SizedBox(height: 16),
              const Text(
                'Camera failed to start',
                style: TextStyle(color: Colors.white, fontSize: 16),
              ),
              const SizedBox(height: 20),
              TextButton(
                onPressed: controller.retryCamera,
                child: const Text(
                  'Retry',
                  style: TextStyle(color: Colors.red, fontSize: 16),
                ),
              ),
            ],
          );
        }

        return const Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(color: Colors.white),
            SizedBox(height: 20),
            Text(
              'Initializing Camera...',
              style: TextStyle(color: Colors.white, fontSize: 16),
            ),
          ],
        );
      }),
    );
  }
}
