import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../custom_widgets/custom_shimmer_effect.dart';
import '../../../../helper/ui_helpers.dart';

class SwapMealOptionsLoader extends StatelessWidget {
  const SwapMealOptionsLoader({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      itemCount: 10,
      separatorBuilder: (context,index) => UIHelper.verticalSpace(10.h),
      itemBuilder: (context, index) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            CustomShimmerEffect(height: 80.h, width: 0.2.sw),
            UIHelper.horizontalSpace(10.w),

            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomShimmerEffect(height: 10.h, width: 0.6.sw),
                UIHelper.verticalSpace(10.h),

                CustomShimmerEffect(height: 10.h, width: 0.5.sw),
                UIHelper.verticalSpace(10.h),

                CustomShimmerEffect(height: 10.h, width: 0.3.sw),
                UIHelper.verticalSpace(10.h),

                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    CustomShimmerEffect(height: 20.h, width: 70.w),
                    UIHelper.horizontalSpace(10.h),
                    CustomShimmerEffect(height: 20.h, width: 70.w),
                  ],
                ),
              ],
            ),
          ],
        );
      },
    );
  }
}
