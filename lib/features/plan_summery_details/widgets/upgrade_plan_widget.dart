import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../constants/text_font_style.dart';
import '../../../helper/ui_helpers.dart';

class UpgradePlanWidget extends StatelessWidget {
  final String planTitle;
  final String planType;
  final double price;
  final String planDurationType;
  final double discountOnPreviousPlan;
  final double daysRemaining;
  final String subscriptionStartDate;
  const UpgradePlanWidget({
    super.key,
    required this.planTitle,
    required this.planType,
    required this.price,
    required this.planDurationType,
    required this.daysRemaining,
    required this.subscriptionStartDate,
    required this.discountOnPreviousPlan,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(planTitle, style: TextFontStyle.headline18w400cfefefeStylePoppins),
        UIHelper.verticalSpace(10.h),

        ///Section : ------------///Upgrade Plan Type///---------
        Text(
          "Plan: $planType",
          style: TextFontStyle.headline14w500cfefefeStylePoppins,
        ),
        UIHelper.verticalSpace(10.h),

        ///Section : ------------///CurrentPlan Price///---------
        Text(
          "Price: £$price//$planDurationType",
          style: TextFontStyle.headline14w500cfefefeStylePoppins,
        ),
        UIHelper.verticalSpace(10.h),

        ///Section : ------------///Discount for Previous Plan: -£3.495 Price///---------
        Text(
          "Discount For Previous Plan: -£$discountOnPreviousPlan",
          style: TextFontStyle.headline14w500cfefefeStylePoppins,
        ),
        UIHelper.verticalSpace(10.h),

        ///Section : ------------///Amount Charged Price///---------
        Text(
          "Days Remaining: $daysRemaining",
          style: TextFontStyle.headline14w500c999999StylePoppins,
        ),
        UIHelper.verticalSpace(10.h),

        ///Section : ------------///Amount Charged Price///---------
        Text(
          "Subscription Start: $subscriptionStartDate",
          style: TextFontStyle.headline14w500c999999StylePoppins,
        ),
      ],
    );
  }
}
