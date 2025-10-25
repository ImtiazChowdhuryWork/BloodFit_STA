// import 'package:camera/camera.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import '../../../controllers/meal_scanner_screen_controller.dart';
// import '../../../gen/colors.gen.dart';

// class MealScannerScreen extends StatelessWidget {
//   final MealScannerScreenController controller = Get.put(
//     MealScannerScreenController(),
//   );

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.black,
//       body: SafeArea(
//         child: Obx(() {
//           if (!controller.cameraInitialized.value) {
//             return _buildLoadingScreen();
//           }
//           return _buildScannerScreen();
//         }),
//       ),
//     );
//   }

//   Widget _buildLoadingScreen() {
//     return Center(
//       child: Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           CircularProgressIndicator(color: Colors.white),
//           SizedBox(height: 20),
//           Text(
//             'Initializing Camera...',
//             style: TextStyle(color: Colors.white, fontSize: 16),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildScannerScreen() {
//     return Stack(
//       children: [
//         // FULL SCREEN Camera Preview
//         SizedBox(
//           width: double.infinity,
//           height: double.infinity,
//           child: CameraPreview(controller.cameraController),
//         ),

//         // Scanner Overlay (Positioned in center)
//         _buildScannerOverlay(),

//         // Close Button
//         Positioned(
//           top: 10,
//           left: 10,
//           child: IconButton(
//             icon: Icon(Icons.close, color: AppColors.cb20000, size: 30),
//             onPressed: () => Get.back(),
//           ),
//         ),

//         // Status & Results
//         _buildStatusUI(),

//         // Nutrition Details (when available)
//         _buildNutritionDetails(),

//         // Capture Button
//         _buildCaptureButton(),
//       ],
//     );
//   }

//   Widget _buildScannerOverlay() {
//     return Center(
//       child: Container(
//         width: 300, // Slightly larger for better scanning
//         height: 300,
//         child: CustomPaint(
//           painter: ScannerOverlayPainter(
//             color: controller.isLoading.value ? Colors.blue : AppColors.cb20000,
//           ),
//         ),
//       ),
//     );
//   }

//   Widget _buildStatusUI() {
//     return Positioned(
//       top: 80, // Moved down to avoid overlap with close button
//       left: 20,
//       right: 20,
//       child: Column(
//         children: [
//           // Status Text
//           Obx(
//             () => Text(
//               controller.scanStatus.value,
//               style: TextStyle(
//                 color: Colors.white,
//                 fontSize: 18,
//                 fontWeight: FontWeight.bold,
//               ),
//               textAlign: TextAlign.center,
//             ),
//           ),
//           SizedBox(height: 10),
//           // Loading Indicator
//           Obx(
//             () => controller.isLoading.value
//                 ? CircularProgressIndicator(color: Colors.white)
//                 : SizedBox(),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildNutritionDetails() {
//     return Obx(
//       () => controller.nutritionData.isNotEmpty
//           ? Positioned(
//               bottom: 120,
//               left: 20,
//               right: 20,
//               child: Container(
//                 padding: EdgeInsets.all(16),
//                 decoration: BoxDecoration(
//                   color: Colors.black.withOpacity(0.8),
//                   borderRadius: BorderRadius.circular(12),
//                   border: Border.all(color: Colors.green, width: 1),
//                 ),
//                 child: Column(
//                   children: [
//                     Text(
//                       '📊 Nutrition Facts',
//                       style: TextStyle(
//                         color: Colors.green,
//                         fontSize: 18,
//                         fontWeight: FontWeight.bold,
//                       ),
//                     ),
//                     SizedBox(height: 10),
//                     Row(
//                       mainAxisAlignment: MainAxisAlignment.spaceAround,
//                       children: [
//                         _buildNutritionItem(
//                           'Calories',
//                           '${controller.nutritionData['calories']}',
//                         ),
//                         _buildNutritionItem(
//                           'Protein',
//                           '${controller.nutritionData['protein']}g',
//                         ),
//                       ],
//                     ),
//                     SizedBox(height: 8),
//                     Row(
//                       mainAxisAlignment: MainAxisAlignment.spaceAround,
//                       children: [
//                         _buildNutritionItem(
//                           'Carbs',
//                           '${controller.nutritionData['carbs']}g',
//                         ),
//                         _buildNutritionItem(
//                           'Fat',
//                           '${controller.nutritionData['fat']}g',
//                         ),
//                       ],
//                     ),
//                   ],
//                 ),
//               ),
//             )
//           : SizedBox(),
//     );
//   }

//   Widget _buildNutritionItem(String label, String value) {
//     return Column(
//       children: [
//         Text(
//           value,
//           style: TextStyle(
//             color: Colors.white,
//             fontSize: 16,
//             fontWeight: FontWeight.bold,
//           ),
//         ),
//         Text(label, style: TextStyle(color: Colors.grey, fontSize: 12)),
//       ],
//     );
//   }

//   Widget _buildCaptureButton() {
//     return Positioned(
//       bottom: 50,
//       left: 0,
//       right: 0,
//       child: Obx(
//         () => FloatingActionButton(
//           onPressed: controller.isLoading.value
//               ? null
//               : controller.captureAndAnalyze,
//           backgroundColor: controller.isLoading.value
//               ? Colors.grey
//               : Colors.green,
//           child: controller.isLoading.value
//               ? CircularProgressIndicator(color: Colors.white)
//               : Icon(Icons.camera_alt, size: 30),
//         ),
//       ),
//     );
//   }
// }

// class ScannerOverlayPainter extends CustomPainter {
//   final Color color;

//   ScannerOverlayPainter({required this.color});

//   @override
//   void paint(Canvas canvas, Size size) {
//     // Create paint for corners only
//     final cornerPaint = Paint()
//       ..color = color
//       ..strokeWidth = 4
//       ..strokeCap = StrokeCap.square
//       ..style = PaintingStyle.stroke;

//     final cornerLength = 25.0;

//     // TOP-LEFT CORNER
//     canvas.drawLine(Offset(0, 0), Offset(cornerLength, 0), cornerPaint);
//     canvas.drawLine(Offset(0, 0), Offset(0, cornerLength), cornerPaint);

//     // TOP-RIGHT CORNER
//     canvas.drawLine(
//       Offset(size.width, 0),
//       Offset(size.width - cornerLength, 0),
//       cornerPaint,
//     );
//     canvas.drawLine(
//       Offset(size.width, 0),
//       Offset(size.width, cornerLength),
//       cornerPaint,
//     );

//     // BOTTOM-LEFT CORNER
//     canvas.drawLine(
//       Offset(0, size.height),
//       Offset(cornerLength, size.height),
//       cornerPaint,
//     );
//     canvas.drawLine(
//       Offset(0, size.height),
//       Offset(0, size.height - cornerLength),
//       cornerPaint,
//     );

//     // BOTTOM-RIGHT CORNER
//     canvas.drawLine(
//       Offset(size.width, size.height),
//       Offset(size.width - cornerLength, size.height),
//       cornerPaint,
//     );
//     canvas.drawLine(
//       Offset(size.width, size.height),
//       Offset(size.width, size.height - cornerLength),
//       cornerPaint,
//     );
//   }

//   @override
//   bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
// }

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../controllers/meal_scanner_screen_controller.dart';
import '../../../gen/colors.gen.dart';

class MealScannerScreen extends StatelessWidget {
  final MealScannerScreenController controller = Get.put(
    MealScannerScreenController(),
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Obx(() {
          if (!controller.cameraInitialized.value) {
            return _buildLoadingScreen();
          }
          return _buildScannerScreen(context);
        }),
      ),
    );
  }

  Widget _buildLoadingScreen() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(color: Colors.white),
          SizedBox(height: 20),
          Text(
            'Initializing Camera...',
            style: TextStyle(color: Colors.white, fontSize: 16),
          ),
        ],
      ),
    );
  }

  Widget _buildScannerScreen(BuildContext context) {
    return Stack(
      children: [
        // FULL SCREEN Camera Preview
        SizedBox(
          width: double.infinity,
          height: double.infinity,
          child: CameraPreview(controller.cameraController),
        ),

        // Scanner Overlay (Positioned in center)
        _buildScannerOverlay(),

        // Close Button - Use Navigator.pop() to go back
        Positioned(
          top: 10,
          left: 10,
          child: IconButton(
            icon: Icon(Icons.close, color: AppColors.cb20000, size: 30),
            onPressed: () =>
                Navigator.pop(context), // Go back to NavigationScreen
          ),
        ),

        // Status & Results
        _buildStatusUI(),

        // Nutrition Details (when available)
        _buildNutritionDetails(),

        // Capture Button
        _buildCaptureButton(),
      ],
    );
  }

  // ... rest of your MealScannerScreen code remains the same
  Widget _buildScannerOverlay() {
    return Center(
      child: Container(
        width: 300,
        height: 300,
        child: CustomPaint(
          painter: ScannerOverlayPainter(
            color: controller.isLoading.value ? Colors.blue : AppColors.cb20000,
          ),
        ),
      ),
    );
  }

  Widget _buildStatusUI() {
    return Positioned(
      top: 80,
      left: 20,
      right: 20,
      child: Column(
        children: [
          Obx(
            () => Text(
              controller.scanStatus.value,
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          SizedBox(height: 10),
          Obx(
            () => controller.isLoading.value
                ? CircularProgressIndicator(color: Colors.white)
                : SizedBox(),
          ),
        ],
      ),
    );
  }

  Widget _buildNutritionDetails() {
    return Obx(
      () => controller.nutritionData.isNotEmpty
          ? Positioned(
              bottom: 120,
              left: 20,
              right: 20,
              child: Container(
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.8),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.green, width: 1),
                ),
                child: Column(
                  children: [
                    Text(
                      '📊 Nutrition Facts',
                      style: TextStyle(
                        color: Colors.green,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        _buildNutritionItem(
                          'Calories',
                          '${controller.nutritionData['calories']}',
                        ),
                        _buildNutritionItem(
                          'Protein',
                          '${controller.nutritionData['protein']}g',
                        ),
                      ],
                    ),
                    SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        _buildNutritionItem(
                          'Carbs',
                          '${controller.nutritionData['carbs']}g',
                        ),
                        _buildNutritionItem(
                          'Fat',
                          '${controller.nutritionData['fat']}g',
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            )
          : SizedBox(),
    );
  }

  Widget _buildNutritionItem(String label, String value) {
    return Column(
      children: [
        Text(
          value,
          style: TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(label, style: TextStyle(color: Colors.grey, fontSize: 12)),
      ],
    );
  }

  Widget _buildCaptureButton() {
    return Positioned(
      bottom: 50,
      left: 0,
      right: 0,
      child: Obx(
        () => FloatingActionButton(
          onPressed: controller.isLoading.value
              ? null
              : controller.captureAndAnalyze,
          backgroundColor: controller.isLoading.value
              ? Colors.grey
              : Colors.green,
          child: controller.isLoading.value
              ? CircularProgressIndicator(color: Colors.white)
              : Icon(Icons.camera_alt, size: 30),
        ),
      ),
    );
  }
}

class ScannerOverlayPainter extends CustomPainter {
  final Color color;

  ScannerOverlayPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final cornerPaint = Paint()
      ..color = color
      ..strokeWidth = 4
      ..strokeCap = StrokeCap.square
      ..style = PaintingStyle.stroke;

    final cornerLength = 25.0;

    // TOP-LEFT CORNER
    canvas.drawLine(Offset(0, 0), Offset(cornerLength, 0), cornerPaint);
    canvas.drawLine(Offset(0, 0), Offset(0, cornerLength), cornerPaint);

    // TOP-RIGHT CORNER
    canvas.drawLine(
      Offset(size.width, 0),
      Offset(size.width - cornerLength, 0),
      cornerPaint,
    );
    canvas.drawLine(
      Offset(size.width, 0),
      Offset(size.width, cornerLength),
      cornerPaint,
    );

    // BOTTOM-LEFT CORNER
    canvas.drawLine(
      Offset(0, size.height),
      Offset(cornerLength, size.height),
      cornerPaint,
    );
    canvas.drawLine(
      Offset(0, size.height),
      Offset(0, size.height - cornerLength),
      cornerPaint,
    );

    // BOTTOM-RIGHT CORNER
    canvas.drawLine(
      Offset(size.width, size.height),
      Offset(size.width - cornerLength, size.height),
      cornerPaint,
    );
    canvas.drawLine(
      Offset(size.width, size.height),
      Offset(size.width, size.height - cornerLength),
      cornerPaint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
