import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../helper/ui_helpers.dart';
import '../../model/onboarding_model.dart';

class PageIndicatorWidget extends StatelessWidget {
  final int index;
  final List<OnboardingModel> myList;
  const PageIndicatorWidget({
    super.key,
    required this.myList,
    required this.index,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        /// Section: PageIndicator
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: myList.asMap().entries.map((data) {
            var indicatorIndex = data.key;
            return Container(
              width: indicatorIndex == index ? 14.w : 10.w,
              height: 10.h,
              margin: EdgeInsets.only(right: 10.w),
              decoration: BoxDecoration(
                borderRadius: indicatorIndex == index
                    ? BorderRadius.circular(6.r)
                    : null,
                shape: indicatorIndex == index
                    ? BoxShape.rectangle
                    : BoxShape.circle,
                color: indicatorIndex == index ? Colors.red : Colors.white,
              ),
            );
          }).toList(),
        ),
        UIHelper.verticalSpace(50.h),
      ],
    );
  }
}
