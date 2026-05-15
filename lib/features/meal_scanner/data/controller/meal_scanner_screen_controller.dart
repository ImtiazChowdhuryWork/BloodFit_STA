import 'package:bloodfit/features/meal_scanner/data/model/meal_scanner_result_model.dart';
import 'package:bloodfit/features/meal_scanner/data/repository/meal_scanner_repository.dart';
import 'package:bloodfit/helper/logger_util.dart';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';

class MealScannerScreenController extends GetxController
    with SingleGetTickerProviderMixin {
  final MealScannerRepository _repository = MealScannerRepository(Get.find());

  var isLoading = false.obs;
  var cameraInitialized = false.obs;
  var cameraInitFailed = false.obs;
  var scanStatus = 'Point camera at food and tap capture'.obs;

  /// Holds the parsed API response after a successful scan.
  Rxn<Data> scanResult = Rxn<Data>();

  late AnimationController animationController;
  late Animation<Offset> slideAnimation;
  late Animation<double> fadeAnimation;

  late CameraController _cameraController;

  @override
  void onInit() {
    super.onInit();
    _initializeCamera();
    _initializeAnimations();
    ever(scanResult, (_) => handleNutritionDataAnimation());
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
        status = await Permission.camera.request();
      }

      if (!status.isGranted) {
        LoggerUtils.error('Camera permission denied');
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
                  Get.close(2);
                  Get.delete<MealScannerScreenController>(force: true);
                },
                child: const Text('Cancel', style: TextStyle(color: Colors.grey)),
              ),
              TextButton(
                onPressed: () async {
                  Get.close(2);
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
      final XFile capturedImage = await _cameraController.takePicture();
      scanStatus.value = 'Analyzing food...';

      LoggerUtils.debug('[SCANNER] Image captured: ${capturedImage.path}');
      LoggerUtils.debug('[SCANNER] Sending to POST /ai-meal/scan-food...');

      final response = await _repository.scanFood(imagePath: capturedImage.path);

      LoggerUtils.debug('[SCANNER] Response status: ${response.statusCode}');
      LoggerUtils.debug('[SCANNER] Response success: ${response.isSuccess}');

      if (response.statusCode == 200 && response.isSuccess && response.jsonResponse != null) {
        final model = MealScannerResultModel.fromJson(response.jsonResponse!);
        LoggerUtils.debug('[SCANNER] Identified ingredients: ${model.data?.identifiedIngredients}');
        LoggerUtils.debug('[SCANNER] Harmful: ${model.data?.harmfulIngredients?.length}');
        LoggerUtils.debug('[SCANNER] Safe: ${model.data?.safeIngredients?.length}');
        LoggerUtils.debug('[SCANNER] Neutral: ${model.data?.neutralIngredients?.length}');

        scanResult.value = model.data;
        scanStatus.value = 'Analysis complete!';
      } else {
        final errorMsg = response.errorMessage ?? 'Could not identify the food. Try again.';
        LoggerUtils.error('[SCANNER] API error: $errorMsg');
        scanStatus.value = 'Analysis failed. Try again.';
        Get.snackbar(
          'Scan Failed',
          errorMsg,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      LoggerUtils.error('[SCANNER] Exception: $e');
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
    scanResult.value = null;
    scanStatus.value = 'Point camera at food and tap capture';
    if (animationController.status == AnimationStatus.completed) {
      animationController.reverse();
    }
  }

  void handleNutritionDataAnimation() {
    if (scanResult.value != null) {
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
    return animationController.value > 0 || scanResult.value != null;
  }

  CameraController get cameraController => _cameraController;

  @override
  void onClose() {
    animationController.dispose();
    if (cameraInitialized.value) _cameraController.dispose();
    super.onClose();
  }
}
