import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../custom_widgets/custom_shimmer_effect.dart';
import '../../../../gen/colors.gen.dart';
import '../../../../helper/ui_helpers.dart';


class MealShowingWidgetShimmerEffect extends StatelessWidget {
  final void Function()? onTap;
  final Widget? child;
  const MealShowingWidgetShimmerEffect({super.key, this.onTap, this.child});

  @override
  Widget build(BuildContext context) {
    if (child != null) {
      return Container(
        width: 1.sw,
        height: 120.h,
        padding: EdgeInsets.all(10.sp),
        decoration: BoxDecoration(
          color: AppColors.c262626,
          borderRadius: BorderRadius.circular(12.r),
        ),
        child: child,
      );
    }

    return Container(
          width: 1.sw,
          height: 120.h,
          padding: EdgeInsets.all(10.sp),
          decoration: BoxDecoration(
            color: AppColors.c262626,
            borderRadius: BorderRadius.circular(12.r)
          ),
          child: Row(
            children: [
              CustomShimmerEffect(width: 0.3.sw, height: 1.sh),
              UIHelper.horizontalSpace(10.w),

              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CustomShimmerEffect(width: 0.5.sw, height: 15.h),
                  UIHelper.verticalSpace(10.h),

                  CustomShimmerEffect(width: 150.w, height: 15.h),
                  Spacer(),


                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                    CustomShimmerEffect(width: 80.w, height: 30.h),
                    UIHelper.horizontalSpace(20.w),
                    CustomShimmerEffect(width: 80.w, height: 30.h),
                  ],)
                ],
              )
            ],
          ),
        );
  }
}