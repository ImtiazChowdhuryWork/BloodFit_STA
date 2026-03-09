import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../custom_widgets/custom_shimmer_effect.dart';
import '../../../../helper/ui_helpers.dart';

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
