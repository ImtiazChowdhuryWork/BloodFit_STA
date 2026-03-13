import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../custom_widgets/custom_elevated_button.dart';
import '../../../../gen/colors.gen.dart';
import '../../../../helper/logger_util.dart';
import '../../../../helper/ui_helpers.dart';
import '../../data/controller/weight_progress_showing_controller.dart';

class WeightProgressFailedWidget extends StatelessWidget {
  final ProgressShowingController controller;
  final void Function()? onTap;

  WeightProgressFailedWidget({super.key, required this.controller, this.onTap});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 140.h,
      width: 1.sw,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8.r),
        color: AppColors.ceff1f5.withValues(alpha: 0.4),
      ),
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.error_outline, color: Colors.red, size: 40),
            UIHelper.verticalSpace(8.h),
            controller.weightProgressDataErrorMessage.value.isEmpty
                ? SizedBox.shrink()
                : Text(
                    controller.weightProgressDataErrorMessage.value,
                    style: const TextStyle(color: Colors.white70),
                    textAlign: TextAlign.center,
                  ),
            UIHelper.verticalSpace(8.h),
            CustomElevatedButton(
              onTap: onTap,
              buttonTitle: "Retry",
              buttonWidth: 120.w,
              buttonHeight: 40.h,
            ),
            UIHelper.verticalSpace(8.h),
          ],
        ),
      ),
    );
  }
}
