import 'package:bloodfit/custom_widgets/custom_shimmer_effect.dart';
import 'package:bloodfit/gen/colors.gen.dart';
import 'package:bloodfit/helper/ui_helpers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class OverAllProgressShimmerWidget extends StatelessWidget {
  const OverAllProgressShimmerWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(10.sp),
      decoration: BoxDecoration(
        color: AppColors.c262626,
        borderRadius: BorderRadius.circular(16.r),
      ),
      width: 1.sw,
      child: Column(
        children: [
          /// Row mirrors the top section: motivation text + circular indicator
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              /// Left: two shimmer text lines
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CustomShimmerEffect(height: 18.h, width: 120.w),
                  UIHelper.verticalSpace(6.h),
                  CustomShimmerEffect(height: 12.h, width: 180.w),
                ],
              ),

              /// Right: circular indicator placeholder
              CustomShimmerEffect(
                height: 127.h,
                width: 127.w,
                isShapUsed: true,
                shapType: BoxShape.circle,
              ),
            ],
          ),

          UIHelper.verticalSpace(10.h),
          Divider(color: AppColors.c727272, thickness: 1),
          UIHelper.verticalSpace(10.h),

          /// Bottom row mirrors two InfoTileWidgets
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _InfoTileShimmer(),
              _InfoTileShimmer(),
            ],
          ),
        ],
      ),
    );
  }
}

class _InfoTileShimmer extends StatelessWidget {
  const _InfoTileShimmer();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        /// Small circular progress placeholder
        CustomShimmerEffect(
          height: 40.h,
          width: 40.w,
          isShapUsed: true,
          shapType: BoxShape.circle,
        ),

        UIHelper.horizontalSpace(12.w),

        /// Vertical divider
        Container(
          height: 40.h,
          width: 1.sp,
          color: AppColors.c727272,
        ),

        UIHelper.horizontalSpace(8.w),

        /// Text lines
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CustomShimmerEffect(height: 12.h, width: 80.w),
            UIHelper.verticalSpace(6.h),
            CustomShimmerEffect(height: 12.h, width: 60.w),
          ],
        ),
      ],
    );
  }
}
