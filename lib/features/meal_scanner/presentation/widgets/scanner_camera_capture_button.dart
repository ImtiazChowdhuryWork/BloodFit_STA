import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../../constants/text_font_style.dart';
import '../../../../controllers/meal_scanner_screen_controller.dart';
import '../../../../gen/assets.gen.dart';
import '../../../../gen/colors.gen.dart';

class ScannerCameraCaptureButton extends StatelessWidget {
  final MealScannerScreenController controller = Get.put(
    MealScannerScreenController(),
  );
  ScannerCameraCaptureButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: 50,
      left: 0,
      right: 0,
      child: Obx(
        () => Center(
          child: InkWell(
            onTap: controller.isLoading.value
                ? null
                : controller.captureAndAnalyze,
            child: Container(
              height: 90.h,
              width: 90.w,
              padding: EdgeInsets.all(10.sp),
              decoration: BoxDecoration(
                color: AppColors.c111111,
                shape: BoxShape.circle,
              ),
              child: controller.isLoading.value
                  ? Stack(
                      alignment: Alignment.center,
                      children: [
                        // Background circle
                        Container(
                          height: 65.h,
                          width: 65.w,
                          decoration: BoxDecoration(
                            color: AppColors.c111111,
                            shape: BoxShape.circle,
                          ),
                        ),
                        // Circular Progress Border
                        SizedBox(
                          height: 80.h,
                          width: 80.w,
                          child: CircularProgressIndicator(
                            color: AppColors.cb20000,
                            strokeWidth: 2.5,
                            backgroundColor: Colors.purple,
                          ),
                        ),
                        // Loading Text in center
                        Text(
                          "Analyzing",
                          style: TextFontStyle.headline12w400cfefefeStylePoppins
                              .copyWith(fontSize: 10.sp),
                        ),
                      ],
                    )
                  : ClipOval(
                      child: Image.asset(
                        height: 50.h,
                        width: 50.w,
                        Assets.images.scannerButtonImage.path,
                        fit: BoxFit.contain,
                      ),
                    ),
            ),
          ),
        ),
      ),
    );
  }
}
