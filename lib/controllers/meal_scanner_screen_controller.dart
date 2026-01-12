// import 'dart:io';
// import 'package:camera/camera.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';

// class MealScannerScreenController extends GetxController {
//   // Reactive variables
//   var isLoading = false.obs;
//   var cameraInitialized = false.obs;
//   var scanStatus = 'Point camera at food and tap capture'.obs;
//   var nutritionData = <String, dynamic>{}.obs;
//   var apiResponse = ''.obs;

//   // Camera
//   late CameraController _cameraController;

//   @override
//   void onInit() {
//     super.onInit();
//     _initializeCamera();
//   }

//   Future<void> _initializeCamera() async {
//     try {
//       final cameras = await availableCameras();
//       _cameraController = CameraController(
//         cameras.first,
//         ResolutionPreset.medium,
//         enableAudio: false,
//       );

//       await _cameraController.initialize();
//       cameraInitialized.value = true;
//     } catch (e) {
//       print('Camera error: $e');
//       scanStatus.value = 'Failed to initialize camera';
//     }
//   }

//   // Main function: Capture image (API simulation)
//   Future<void> captureAndAnalyze() async {
//     if (isLoading.value) return;

//     isLoading.value = true;
//     scanStatus.value = 'Capturing image...';

//     try {
//       // 1. Capture image
//       final image = await _cameraController.takePicture();
//       scanStatus.value = 'Analyzing food...';

//       // 2. Simulate API delay
//       await Future.delayed(Duration(seconds: 2));

//       // 3. Simulate API response (Replace this with real API later)
//       _simulateAPIResponse();
//     } catch (e) {
//       print('Error: $e');
//       Get.snackbar(
//         'Error',
//         'Failed to analyze food: $e',
//         backgroundColor: Colors.red,
//         colorText: Colors.white,
//       );
//       scanStatus.value = 'Analysis failed. Try again.';
//     } finally {
//       isLoading.value = false;
//     }
//   }

//   // Method to clear nutrition data and hide the details widget
//   void clearNutritionData() {
//     nutritionData.clear();
//     scanStatus.value = 'Point camera at food and tap capture';
//   }

//   // Simulated API response - REMOVE THIS WHEN YOU ADD REAL API
//   void _simulateAPIResponse() {
//     // Simulate different food responses randomly
//     final foods = [
//       {
//         'foodName': 'Apple',
//         'calories': 95,
//         'protein': 0.5,
//         'carbs': 25,
//         'fat': 0.3,
//       },
//       {
//         'foodName': 'Banana',
//         'calories': 105,
//         'protein': 1.3,
//         'carbs': 27,
//         'fat': 0.4,
//       },
//       {
//         'foodName': 'Chicken Salad',
//         'calories': 320,
//         'protein': 25,
//         'carbs': 12,
//         'fat': 18,
//       },
//       {
//         'foodName': 'Pizza Slice',
//         'calories': 285,
//         'protein': 12,
//         'carbs': 36,
//         'fat': 10,
//       },
//     ];

//     final randomFood =
//         foods[DateTime.now().millisecondsSinceEpoch % foods.length];

//     // Store the nutrition data
//     nutritionData.value = {
//       'foodName': randomFood['foodName'],
//       'calories': randomFood['calories'],
//       'protein': randomFood['protein'],
//       'carbs': randomFood['carbs'],
//       'fat': randomFood['fat'],
//       'confidence':
//           0.85 + (DateTime.now().millisecond % 15) / 100, // Random confidence
//     };

//     // Update UI
//     scanStatus.value = 'Analysis complete!';
//     apiResponse.value =
//         '${nutritionData['foodName']} - ${nutritionData['calories']} kcal';

//     // Show success
//     // Get.snackbar(
//     //   'Food Analyzed!',
//     //   '${nutritionData['foodName']}: ${nutritionData['calories']} calories',
//     //   backgroundColor: Colors.green,
//     //   colorText: Colors.white,
//     //   duration: Duration(seconds: 3),
//     // );

//     print('Simulated Nutrition Data: $nutritionData');
//   }

//   // Getter for camera controller
//   CameraController get cameraController => _cameraController;

//   @override
//   void onClose() {
//     _cameraController.dispose();
//     super.onClose();
//   }
// }

import 'package:bloodfit/helper/logger_util.dart';
import 'package:camera/camera.dart';
import 'package:flutter/animation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MealScannerScreenController extends GetxController
    with SingleGetTickerProviderMixin {
  // Reactive variables
  var isLoading = false.obs;
  var cameraInitialized = false.obs;
  var scanStatus = 'Point camera at food and tap capture'.obs;
  var nutritionData = <String, dynamic>{}.obs;
  var apiResponse = ''.obs;

  // Animation
  late AnimationController animationController;
  late Animation<Offset> slideAnimation;
  late Animation<double> fadeAnimation;

  // Camera
  late CameraController _cameraController;

  @override
  void onInit() {
    super.onInit();
    _initializeCamera();
    _initializeAnimations();

    // Listen to nutrition data changes to handle animations
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
      final cameras = await availableCameras();
      _cameraController = CameraController(
        cameras.first,
        ResolutionPreset.medium,
        enableAudio: false,
      );

      await _cameraController.initialize();
      cameraInitialized.value = true;
    } catch (e) {
      LoggerUtils.error('Camera error: $e');
      scanStatus.value = 'Failed to initialize camera';
    }
  }

  // Main function: Capture image (API simulation)
  Future<void> captureAndAnalyze() async {
    if (isLoading.value) return;

    isLoading.value = true;
    scanStatus.value = 'Capturing image...';

    try {
      // 1. Capture image
      final image = await _cameraController.takePicture();
      scanStatus.value = 'Analyzing food...';

      // 2. Simulate API delay
      await Future.delayed(Duration(seconds: 2));

      // 3. Simulate API response (Replace this with real API later)
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

  // Method to clear nutrition data and hide the details widget
  void clearNutritionData() {
    nutritionData.clear();
    scanStatus.value = 'Point camera at food and tap capture';
    // Reverse animation when clearing data
    if (animationController.status == AnimationStatus.completed) {
      animationController.reverse();
    }
  }

  // Handle animation when nutrition data becomes available
  void handleNutritionDataAnimation() {
    if (nutritionData.isNotEmpty) {
      // If nutrition data is available and animation is not running, start it
      if (animationController.status == AnimationStatus.dismissed ||
          animationController.status == AnimationStatus.forward) {
        animationController.forward();
      }
    } else {
      // If nutrition data is empty and animation is completed, reverse it
      if (animationController.status == AnimationStatus.completed ||
          animationController.status == AnimationStatus.forward) {
        animationController.reverse();
      }
    }
  }

  // Check if widget should be visible
  bool get shouldShowNutritionDetails {
    return animationController.value > 0 || nutritionData.isNotEmpty;
  }

  // Simulated API response - REMOVE THIS WHEN YOU ADD REAL API
  void _simulateAPIResponse() {
    // Simulate different food responses randomly
    final foods = [
      {
        'foodName': 'Apple',
        'calories': 95,
        'protein': 0.5,
        'carbs': 25,
        'fat': 0.3,
      },
      {
        'foodName': 'Banana',
        'calories': 105,
        'protein': 1.3,
        'carbs': 27,
        'fat': 0.4,
      },
      {
        'foodName': 'Chicken Salad',
        'calories': 320,
        'protein': 25,
        'carbs': 12,
        'fat': 18,
      },
      {
        'foodName': 'Pizza Slice',
        'calories': 285,
        'protein': 12,
        'carbs': 36,
        'fat': 10,
      },
    ];

    final randomFood =
        foods[DateTime.now().millisecondsSinceEpoch % foods.length];

    // Store the nutrition data
    nutritionData.value = {
      'foodName': randomFood['foodName'],
      'calories': randomFood['calories'],
      'protein': randomFood['protein'],
      'carbs': randomFood['carbs'],
      'fat': randomFood['fat'],
      'confidence':
          0.85 + (DateTime.now().millisecond % 15) / 100, // Random confidence
    };

    // Update UI
    scanStatus.value = 'Analysis complete!';
    apiResponse.value =
        '${nutritionData['foodName']} - ${nutritionData['calories']} kcal';

    LoggerUtils.debug('Simulated Nutrition Data: $nutritionData');
  }

  // Getter for camera controller
  CameraController get cameraController => _cameraController;

  @override
  void onClose() {
    animationController.dispose();
    _cameraController.dispose();
    super.onClose();
  }
}
