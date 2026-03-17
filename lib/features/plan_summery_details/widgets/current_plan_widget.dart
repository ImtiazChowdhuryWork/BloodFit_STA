import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../constants/text_font_style.dart';
import '../../../helper/ui_helpers.dart';

class CurrentPlanWidget extends StatelessWidget {
  final String planTitle;
  final String planType;
  final double planPrice;
  final String planDuration;
  // final double daysRemaining;
  final String subscriptionDate;
  const CurrentPlanWidget({
    super.key,
    required this.planTitle,
    required this.planType,
    required this.planPrice,
    required this.planDuration,
    // required this.daysRemaining,
    required this.subscriptionDate,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(planTitle, style: TextFontStyle.headline18w400cfefefeStylePoppins),
        UIHelper.verticalSpace(10.h),

        ///Section : ------------///CurrentPlan Type///---------
        Text(
          "Plan: $planType",
          style: TextFontStyle.headline14w500cfefefeStylePoppins,
        ),
        UIHelper.verticalSpace(10.h),

        ///Section : ------------///CurrentPlan Price///---------
        Text(
          "Price: £$planPrice/$planDuration",
          style: TextFontStyle.headline14w500cfefefeStylePoppins,
        ),
        UIHelper.verticalSpace(10.h),

        ///Section : ------------///Amount Charged Price///---------
        // Text(
        //   "Days Remaining: $daysRemaining",
        //   style: TextFontStyle.headline14w500c999999StylePoppins,
        // ),
        // UIHelper.verticalSpace(10.h),

        ///Section : ------------///Subscription Date///---------
        Text(
          "Subscription Date: $subscriptionDate",
          style: TextFontStyle.headline14w500c999999StylePoppins,
        ),
      ],
    );
  }
}
