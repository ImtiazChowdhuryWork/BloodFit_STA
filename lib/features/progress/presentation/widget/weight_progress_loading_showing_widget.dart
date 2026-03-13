import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../custom_widgets/custom_shimmer_effect.dart';
import '../../../../helper/ui_helpers.dart';

class WeightProgressLoadingShowingWidget extends StatelessWidget {
  const WeightProgressLoadingShowingWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomShimmerEffect(
      height: 170.h,
      width: 1.sw,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            CustomShimmerEffect(
              height: 100.h,
              width: 1.sw,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        CustomShimmerEffect(height: 10.h, width: 40.w),
                        CustomShimmerEffect(height: 10.h, width: 40.w),
                        CustomShimmerEffect(height: 10.h, width: 40.w),
                      ],
                    ),
                    UIHelper.verticalSpace(10.h),
                    CustomShimmerEffect(height: 50.h, width: 1.sw),
                  ],
                ),
              ),
            ),
            UIHelper.verticalSpace(20.h),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                CustomShimmerEffect(height: 20.h, width: 40.w),
                CustomShimmerEffect(height: 20.h, width: 40.w),
                CustomShimmerEffect(height: 20.h, width: 40.w),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
