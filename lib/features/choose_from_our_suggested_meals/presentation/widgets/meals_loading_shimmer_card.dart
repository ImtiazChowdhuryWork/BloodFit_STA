import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../../custom_widgets/custom_shimmer_effect.dart';
import '../../../../gen/colors.gen.dart';
import '../../../../helper/ui_helpers.dart';
import '../../../home/data/controller/home_screen_controller.dart';
import '../../data/controller/choose_from_our_suggested_meal_controller.dart';

class MealsLoadingShimmerCard extends StatelessWidget {
  const MealsLoadingShimmerCard({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 120.h,
      child: ListView.separated(
        itemCount: 3,
        shrinkWrap: true,
        scrollDirection: Axis.horizontal,
        separatorBuilder: (context, index) => UIHelper.horizontalSpace(8.w),
        itemBuilder: (context, index) {
          return CustomShimmerEffect(
            height: 120.h,
            width: 0.4.sw,
            child: Padding(
              padding: const EdgeInsets.all(8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CustomShimmerEffect(
                    height: 50.h,
                    width: 50.w,
                    isShapUsed: true,
                    shapType: BoxShape.circle,
                  ),
                  UIHelper.verticalSpace(10.h),
                  CustomShimmerEffect(height: 10.h, width: 0.3.sw),
                  UIHelper.verticalSpace(10.h),
                  Row(
                    children: [
                      CustomShimmerEffect(height: 10.h, width: 0.10.sw),
                      UIHelper.horizontalSpace(10.w),
                      CustomShimmerEffect(height: 10.h, width: 0.10.sw),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Inline progress card shown while AI meals are being generated.
// Sits in the scroll column BELOW previously selected meals — no overlay,
// so the user can still see and interact with their existing meal choices above.
// ─────────────────────────────────────────────────────────────────────────────
class AiMealsProgressCard extends StatelessWidget {
  const AiMealsProgressCard({super.key});

  @override
  Widget build(BuildContext context) {
    final ctrl = Get.find<ChooseFromOurSuggestedMealController>();

    return Obx(() {
      final progress = ctrl.aiMealsLoadingProgress.value;
      final message = ctrl.aiMealsLoadingMessage.value;

      return Container(
        width: double.infinity,
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFF1E1E1E), Color(0xFF141414)],
          ),
          borderRadius: BorderRadius.circular(20.r),
          border: Border.all(
            color: AppColors.cb20000.withValues(alpha: 0.3),
            width: 1.5,
          ),
          boxShadow: [
            BoxShadow(
              color: AppColors.cb20000.withValues(alpha: 0.10),
              blurRadius: 32,
              spreadRadius: 4,
            ),
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.4),
              blurRadius: 16,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 28.h),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ///Section : Icon badge
            Container(
              width: 48.w,
              height: 48.w,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.cb20000.withValues(alpha: 0.12),
                border: Border.all(
                  color: AppColors.cb20000.withValues(alpha: 0.3),
                  width: 1,
                ),
              ),
              child: Icon(
                Icons.restaurant_menu_rounded,
                color: AppColors.cb20000,
                size: 22.sp,
              ),
            ),
            SizedBox(height: 20.h),

            ///Section : Progress ring + percentage (ring is clean, number sits below)
            Stack(
              alignment: Alignment.center,
              children: [
                // Soft red glow behind ring
                Container(
                  width: 110.w,
                  height: 110.w,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.cb20000.withValues(alpha: 0.15),
                        blurRadius: 24,
                        spreadRadius: 4,
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  width: 110.w,
                  height: 110.w,
                  child: CircularProgressIndicator(
                    value: progress / 100.0,
                    strokeWidth: 6,
                    backgroundColor: const Color(0xFF2A2A2A),
                    color: AppColors.cb20000,
                    strokeCap: StrokeCap.round,
                  ),
                ),
                // Percentage sits inside the open inner space of the ring
                RichText(
                  textAlign: TextAlign.center,
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text: '$progress',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 26.sp,
                          fontWeight: FontWeight.w700,
                          fontFamily: 'Poppins',
                          height: 1.0,
                        ),
                      ),
                      TextSpan(
                        text: '%',
                        style: TextStyle(
                          color: AppColors.cb20000,
                          fontSize: 13.sp,
                          fontWeight: FontWeight.w600,
                          fontFamily: 'Poppins',
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(height: 20.h),

            ///Section : Title
            Text(
              'Generating Your Meal Plan',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white,
                fontSize: 15.sp,
                fontWeight: FontWeight.w600,
                fontFamily: 'Poppins',
              ),
            ),
            SizedBox(height: 6.h),

            ///Section : Dynamic message (fades between updates)
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 400),
              child: Text(
                message,
                key: ValueKey(message),
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: const Color(0xFF888888),
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w400,
                  fontFamily: 'Poppins',
                ),
              ),
            ),
            SizedBox(height: 20.h),

            ///Section : Thin progress bar
            ClipRRect(
              borderRadius: BorderRadius.circular(4.r),
              child: LinearProgressIndicator(
                value: progress / 100.0,
                backgroundColor: const Color(0xFF2A2A2A),
                color: AppColors.cb20000,
                minHeight: 4.h,
              ),
            ),
          ],
        ),
      );
    });
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Progress card for the Swap Meal bottom sheet while AI alternatives are
// being generated. Reads progress state from HomeScreenController.
// ─────────────────────────────────────────────────────────────────────────────
class SwapMealProgressCard extends StatelessWidget {
  const SwapMealProgressCard({super.key});

  @override
  Widget build(BuildContext context) {
    final ctrl = Get.find<HomeScreenController>();

    return Obx(() {
      final progress = ctrl.swapMealOptionsLoadingProgress.value;
      final message = ctrl.swapMealOptionsLoadingMessage.value;

      return Container(
        width: double.infinity,
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFF1E1E1E), Color(0xFF141414)],
          ),
          borderRadius: BorderRadius.circular(20.r),
          border: Border.all(
            color: AppColors.cb20000.withValues(alpha: 0.3),
            width: 1.5,
          ),
          boxShadow: [
            BoxShadow(
              color: AppColors.cb20000.withValues(alpha: 0.10),
              blurRadius: 32,
              spreadRadius: 4,
            ),
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.4),
              blurRadius: 16,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 28.h),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ///Section : Icon badge
            Container(
              width: 48.w,
              height: 48.w,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.cb20000.withValues(alpha: 0.12),
                border: Border.all(
                  color: AppColors.cb20000.withValues(alpha: 0.3),
                  width: 1,
                ),
              ),
              child: Icon(
                Icons.swap_horiz_rounded,
                color: AppColors.cb20000,
                size: 22.sp,
              ),
            ),
            SizedBox(height: 20.h),

            ///Section : Progress ring + percentage
            Stack(
              alignment: Alignment.center,
              children: [
                Container(
                  width: 110.w,
                  height: 110.w,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.cb20000.withValues(alpha: 0.15),
                        blurRadius: 24,
                        spreadRadius: 4,
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  width: 110.w,
                  height: 110.w,
                  child: CircularProgressIndicator(
                    value: progress / 100.0,
                    strokeWidth: 6,
                    backgroundColor: const Color(0xFF2A2A2A),
                    color: AppColors.cb20000,
                    strokeCap: StrokeCap.round,
                  ),
                ),
                RichText(
                  textAlign: TextAlign.center,
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text: '$progress',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 26.sp,
                          fontWeight: FontWeight.w700,
                          fontFamily: 'Poppins',
                          height: 1.0,
                        ),
                      ),
                      TextSpan(
                        text: '%',
                        style: TextStyle(
                          color: AppColors.cb20000,
                          fontSize: 13.sp,
                          fontWeight: FontWeight.w600,
                          fontFamily: 'Poppins',
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(height: 20.h),

            ///Section : Title
            Text(
              'Finding Meal Alternatives',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white,
                fontSize: 15.sp,
                fontWeight: FontWeight.w600,
                fontFamily: 'Poppins',
              ),
            ),
            SizedBox(height: 6.h),

            ///Section : Dynamic message
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 400),
              child: Text(
                message,
                key: ValueKey(message),
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: const Color(0xFF888888),
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w400,
                  fontFamily: 'Poppins',
                ),
              ),
            ),
            SizedBox(height: 20.h),

            ///Section : Thin progress bar
            ClipRRect(
              borderRadius: BorderRadius.circular(4.r),
              child: LinearProgressIndicator(
                value: progress / 100.0,
                backgroundColor: const Color(0xFF2A2A2A),
                color: AppColors.cb20000,
                minHeight: 4.h,
              ),
            ),
          ],
        ),
      );
    });
  }
}
