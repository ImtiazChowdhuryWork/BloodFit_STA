import 'dart:developer';

import 'package:bloodfit/custom_widgets/custom_elevated_button.dart';
import 'package:bloodfit/gen/assets.gen.dart';
import 'package:bloodfit/helper/ui_helpers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

import '../../../constants/text_font_style.dart';
import '../../../custom_widgets/go_back_widget.dart';
import '../../../gen/colors.gen.dart';
import '../widgets/payment_info_row_widget.dart';
import '../widgets/upgrade_plan_widget.dart';

class CostDetailsForUpgradePlanScreen extends StatelessWidget {
  const CostDetailsForUpgradePlanScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldBackgroundColor,

      /// -------------------- App Bar Section --------------------
      appBar: AppBar(
        backgroundColor: AppColors.scaffoldBackgroundColor,
        centerTitle: true,
        automaticallyImplyLeading: false,
        leading: const CustomBackButton(),
        title: Text(
          "Payment",
          style: TextFontStyle.headline24w700cFFFFFFStylePoppins,
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(UIHelper.kDefaulutPadding()),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ///Section : -------///Text -> Biling Summery///-----------
            Text(
              "Billing Summary",
              style: TextFontStyle.headline22w500cfefefeStylePoppins,
            ),
            UIHelper.verticalSpace(24.h),

            ///Section : ------------///CurrentPlan Details///---------
            Text(
              "Current Plan",
              style: TextFontStyle.headline18w400cfefefeStylePoppins,
            ),
            UIHelper.verticalSpace(10.h),

            ///Section : ------------///CurrentPlan Type///---------
            Text(
              "Plan: Starter",
              style: TextFontStyle.headline14w500cfefefeStylePoppins,
            ),
            UIHelper.verticalSpace(10.h),

            ///Section : ------------///CurrentPlan Price///---------
            Text(
              "Price: £3.99/month",
              style: TextFontStyle.headline14w500cfefefeStylePoppins,
            ),
            UIHelper.verticalSpace(10.h),

            ///Section : ------------///Amount Charged Price///---------
            Text(
              "Days Remaining: 15",
              style: TextFontStyle.headline14w500cfefefeStylePoppins,
            ),
            UIHelper.verticalSpace(10.h),

            ///Section : ------------///Subscription Date///---------
            Text(
              "Subscription Date: 01/09/2024",
              style: TextFontStyle.headline14w500cfefefeStylePoppins,
            ),
            UIHelper.verticalSpace(16.h),

            ///-----------///Upgrade Plan///------------
            ///Section : ------------///CurrentPlan Details///---------
            UpgradePlanWidget(
              planTitle: "Upgraded Plan",
              planType: "Pro",
              price: 6.99,
              planDurationType: "Monthly",
              daysRemaining: 16,
              discountOnPreviousPlan: 3.495,
              subscriptionStartDate: "15/09/2025",
            ),
            UIHelper.verticalSpace(10.h),

            ///Section : ---------///PromoCode///---------
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                SvgPicture.asset(Assets.icons.promoCodeIcon),
                UIHelper.horizontalSpace(8.w),
                Text(
                  "Add Promo Code",
                  style: TextFontStyle.headline16w500ce7b0b0StylePoppins,
                ),
              ],
            ),
            UIHelper.verticalSpace(24.h),

            ///Section : -----------------------------------///Total Price for Current Plan///----------
            Text(
              "Total Price For Current Plan: ",
              style: TextFontStyle.headline16w500cfefefeStylePoppins,
            ),
            UIHelper.verticalSpace(16.h),

            ///Section:-------///Total Amount For This Month///----
            PaymentInfoRowWidget(
              title: "Total Amount For This Month:",
              price: 6.99,
            ),
            UIHelper.verticalSpace(10.h),

            ///Section:-------///Total Amount For This Month///----
            PaymentInfoRowWidget(
              title: "Already Charged (Starter Plan):",
              price: 6.99,
            ),
            UIHelper.verticalSpace(10.h),

            ///Section:-------///Pay for Upgrade: ///----
            PaymentInfoRowWidget(title: "Pay for Upgrade:", price: 6.99),
            UIHelper.verticalSpace(24.h),

            ///Section : -------///Button -> Pay Now///-----------
            CustomElevatedButton(
              onTap: () {
                log("Button Taped -> Pay Now");
              },
              buttonTitle: "Pay Now",
              borderRadius: 24.r,
            ),
          ],
        ),
      ),
    );
  }
}
