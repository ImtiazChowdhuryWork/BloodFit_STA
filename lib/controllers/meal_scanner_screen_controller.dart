import 'package:bloodfit/helper/logger_util.dart';
import 'package:camera/camera.dart';
import 'package:flutter/animation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';

class MealScannerScreenController extends GetxController
    with SingleGetTickerProviderMixin {
  var isLoading = false.obs;
  var cameraInitialized = false.obs;
  var cameraInitFailed = false.obs;
  var scanStatus = 'Point camera at food and tap capture'.obs;
  var nutritionData = <String, dynamic>{}.obs;
  var apiResponse = ''.obs;

  late AnimationController animationController;
  late Animation<Offset> slideAnimation;
  late Animation<double> fadeAnimation;

  late CameraController _cameraController;

  @override
  void onInit() {
    super.onInit();
    _initializeCamera();
    _initializeAnimations();
    ever(nutritionData, (_) => handleNutritionDataAnimation());
  }

  void _initializeAnimations() {
    animationController = AnimationController(
      duration: Duration(milliseconds: 500),
      vsync: this,
    );

    slideAnimation = Tween<Offset>(begin: Offset(0, -0.5), end: Offset(0, 0))
        .animate(
          CurvedAnimation(
            parent: animationController,
            curve: Curves.easeOutCubic,
          ),
        );

    fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: animationController, curve: Curves.easeOut),
    );
  }

  Future<void> _initializeCamera() async {
    try {
      var status = await Permission.camera.status;

      if (status.isGranted) {
        // Already granted — proceed directly
      } else if (status.isDenied) {
        // Not yet asked or denied once — request it
        status = await Permission.camera.request();
      }

      if (!status.isGranted) {
        LoggerUtils.error('Camera permission denied');
        // Permission permanently denied or denied after request — show settings dialog
        await Get.dialog(
          AlertDialog(
            backgroundColor: const Color(0xFF1C1C1C),
            title: const Text(
              'Camera Permission Required',
              style: TextStyle(color: Colors.white),
            ),
            content: const Text(
              'BloodFit needs camera access to scan your meals. Please enable it in Settings.',
              style: TextStyle(color: Colors.white70),
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Get.close(2); // closes dialog + scanner screen
                  Get.delete<MealScannerScreenController>(force: true);
                },
                child: const Text('Cancel', style: TextStyle(color: Colors.grey)),
              ),
              TextButton(
                onPressed: () async {
                  Get.close(2); // closes dialog + scanner screen
                  Get.delete<MealScannerScreenController>(force: true);
                  await openAppSettings();
                },
                child: const Text('Open Settings', style: TextStyle(color: Colors.red)),
              ),
            ],
          ),
          barrierDismissible: false,
        );
        return;
      }

      // On iOS, availableCameras() may return empty immediately after permission
      // is granted — retry a few times with a short delay to allow the camera
      // subsystem to finish initializing.
      List<CameraDescription> cameras = [];
      for (int attempt = 0; attempt < 3; attempt++) {
        cameras = await availableCameras();
        if (cameras.isNotEmpty) break;
        await Future.delayed(const Duration(milliseconds: 500));
        LoggerUtils.debug('Camera list empty, retrying (attempt ${attempt + 1})...');
      }

      if (cameras.isEmpty) {
        scanStatus.value = 'No camera found on this device';
        LoggerUtils.error('No cameras available after retries');
        cameraInitFailed.value = true;
        return;
      }
      _cameraController = CameraController(
        cameras.first,
        ResolutionPreset.medium,
        enableAudio: false,
      );

      await _cameraController.initialize();
      cameraInitialized.value = true;
    } catch (e) {
      LoggerUtils.error('Camera error: $e');
      cameraInitFailed.value = true;
    }
  }

  Future<void> retryCamera() async {
    cameraInitFailed.value = false;
    cameraInitialized.value = false;
    await _initializeCamera();
  }

  Future<void> captureAndAnalyze() async {
    if (isLoading.value) return;

    isLoading.value = true;
    scanStatus.value = 'Capturing image...';

    try {
      await _cameraController.takePicture();
      scanStatus.value = 'Analyzing food...';

      // Simulated delay — replace with real API call when available
      await Future.delayed(Duration(seconds: 2));
      _simulateAPIResponse();
    } catch (e) {
      LoggerUtils.error('Error: $e');
      Get.snackbar(
        'Error',
        'Failed to analyze food: $e',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      scanStatus.value = 'Analysis failed. Try again.';
    } finally {
      isLoading.value = false;
    }
  }

  void clearNutritionData() {
    nutritionData.clear();
    scanStatus.value = 'Point camera at food and tap capture';
    if (animationController.status == AnimationStatus.completed) {
      animationController.reverse();
    }
  }

  void handleNutritionDataAnimation() {
    if (nutritionData.isNotEmpty) {
      if (animationController.status == AnimationStatus.dismissed ||
          animationController.status == AnimationStatus.forward) {
        animationController.forward();
      }
    } else {
      if (animationController.status == AnimationStatus.completed ||
          animationController.status == AnimationStatus.forward) {
        animationController.reverse();
      }
    }
  }

  bool get shouldShowNutritionDetails {
    return animationController.value > 0 || nutritionData.isNotEmpty;
  }

  // Simulated API response — REMOVE THIS WHEN YOU ADD REAL API
  void _simulateAPIResponse() {
    final foods = [
      {'foodName': 'Apple', 'calories': 95, 'protein': 0.5, 'carbs': 25, 'fat': 0.3},
      {'foodName': 'Banana', 'calories': 105, 'protein': 1.3, 'carbs': 27, 'fat': 0.4},
      {'foodName': 'Chicken Salad', 'calories': 320, 'protein': 25, 'carbs': 12, 'fat': 18},
      {'foodName': 'Pizza Slice', 'calories': 285, 'protein': 12, 'carbs': 36, 'fat': 10},
    ];

    final randomFood = foods[DateTime.now().millisecondsSinceEpoch % foods.length];

    nutritionData.value = {
      'foodName': randomFood['foodName'],
      'calories': randomFood['calories'],
      'protein': randomFood['protein'],
      'carbs': randomFood['carbs'],
      'fat': randomFood['fat'],
      'confidence': 0.85 + (DateTime.now().millisecond % 15) / 100,
    };

    scanStatus.value = 'Analysis complete!';
    apiResponse.value = '${nutritionData['foodName']} - ${nutritionData['calories']} kcal';
    LoggerUtils.debug('Simulated Nutrition Data: $nutritionData');
  }

  CameraController get cameraController => _cameraController;

  @override
  void onClose() {
    animationController.dispose();
    if (cameraInitialized.value) _cameraController.dispose();
    super.onClose();
  }
}
