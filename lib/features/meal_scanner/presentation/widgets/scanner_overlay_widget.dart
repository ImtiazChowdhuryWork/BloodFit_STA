import 'package:bloodfit/features/meal_scanner/presentation/widgets/scanner_overlay_painter_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../controllers/meal_scanner_screen_controller.dart';
import '../../../../gen/colors.gen.dart';

class ScannerOverlayWidget extends StatelessWidget {
  final MealScannerScreenController controller = Get.put(
    MealScannerScreenController(),
  );
  ScannerOverlayWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
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
}
