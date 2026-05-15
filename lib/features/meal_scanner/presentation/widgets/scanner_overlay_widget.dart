import 'package:bloodfit/features/meal_scanner/presentation/widgets/scanner_overlay_painter_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../data/controller/meal_scanner_screen_controller.dart';
import '../../../../gen/colors.gen.dart';

class ScannerOverlayWidget extends StatefulWidget {
  const ScannerOverlayWidget({super.key});

  @override
  State<ScannerOverlayWidget> createState() => _ScannerOverlayWidgetState();
}

class _ScannerOverlayWidgetState extends State<ScannerOverlayWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _scanLineController;
  late Animation<double> _scanLineAnimation;
  late MealScannerScreenController controller;

  @override
  void initState() {
    super.initState();
    controller = Get.find<MealScannerScreenController>();

    _scanLineController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );

    _scanLineAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _scanLineController, curve: Curves.easeInOut),
    );

    // Start/stop scanning line based on loading state.
    ever(controller.isLoading, (loading) {
      if (loading) {
        _scanLineController.repeat(reverse: true);
      } else {
        _scanLineController.stop();
        _scanLineController.reset();
      }
    });
  }

  @override
  void dispose() {
    _scanLineController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Obx(() {
        final isLoading = controller.isLoading.value;
        return SizedBox(
          width: 300,
          height: 300,
          child: Stack(
            children: [
              // Scanning frame — turns red while loading.
              CustomPaint(
                size: const Size(300, 300),
                painter: ScannerOverlayPainter(
                  color: isLoading ? AppColors.cb20000 : AppColors.cb20000,
                ),
              ),

              // Animated scanning line — only visible while loading.
              if (isLoading)
                AnimatedBuilder(
                  animation: _scanLineAnimation,
                  builder: (context, child) {
                    return Positioned(
                      top: _scanLineAnimation.value * 288,
                      left: 8,
                      right: 8,
                      child: Container(
                        height: 2,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              Colors.transparent,
                              AppColors.cb20000,
                              Colors.transparent,
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
            ],
          ),
        );
      }),
    );
  }
}
