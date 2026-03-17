import 'dart:developer';

import 'package:bloodfit/custom_widgets/custom_elevated_button.dart';
import 'package:bloodfit/custom_widgets/custom_shimmer_effect.dart';
import 'package:bloodfit/features/plan_summery_details/data/controller/plan_summery_details_screen_controller.dart';
import 'package:bloodfit/gen/assets.gen.dart';
import 'package:bloodfit/helper/ui_helpers.dart';
import 'package:bloodfit/routes/routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

import '../../../constants/text_font_style.dart';
import '../../../custom_widgets/go_back_widget.dart';
import '../../../gen/colors.gen.dart';
import '../widgets/current_plan_widget.dart';
import '../widgets/payment_info_row_widget.dart';
import '../widgets/upgrade_plan_widget.dart';

class PlanSummeryDetailsScreen extends StatefulWidget {
  const PlanSummeryDetailsScreen({super.key});

  @override
  State<PlanSummeryDetailsScreen> createState() =>
      _PlanSummeryDetailsScreenState();
}

class _PlanSummeryDetailsScreenState extends State<PlanSummeryDetailsScreen> {
  PlanSummeryDetailsScreenController planSummeryDetailsScreenController =
      Get.find<PlanSummeryDetailsScreenController>();

  String planId = '';
  String planType = '';

  @override
  void initState() {
    final arguments = Get.arguments as Map<String, dynamic>?;

    planId = arguments?['planId'] ?? '';
    planType = arguments?['planType'] ?? '';

    WidgetsBinding.instance.addPostFrameCallback((_) {
      planSummeryDetailsScreenController.setPlanId(value: planId);
      planSummeryDetailsScreenController.setBillingType(value: planType);
      planSummeryDetailsScreenController.getPlanSummeryDetailsApi();
    });
    super.initState();
  }

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
            Obx(() {
              if (planSummeryDetailsScreenController
                  .isSummeryDetailsLoading
                  .value) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CustomShimmerEffect(height: 10.h, width: 0.7.sw),
                    UIHelper.verticalSpace(10.h),

                    CustomShimmerEffect(height: 10.h, width: 0.3.sw),
                    UIHelper.verticalSpace(10.h),

                    CustomShimmerEffect(height: 10.h, width: 0.5.sw),
                    UIHelper.verticalSpace(10.h),
                  ],
                );
              }

              if (planSummeryDetailsScreenController.planSummeryModel.value ==
                  null) {
                return Center(
                  child: Text(
                    "No data available",
                    style: TextFontStyle.headline14w500c999999StylePoppins,
                  ),
                );
              }

              return CurrentPlanWidget(
                planTitle: "Current Plan",
                planType: planSummeryDetailsScreenController.planName,
                planPrice: planSummeryDetailsScreenController.planPrice,
                planDuration:
                    planSummeryDetailsScreenController.planDurationType,
                // daysRemaining: 15,
                subscriptionDate: planSummeryDetailsScreenController
                    .formattedSubscriptionDate,
              );
            }),

            UIHelper.verticalSpace(16.h),

            ///-----------///Upgrade Plan///------------
            // UpgradePlanWidget(
            //   planTitle: "Upgraded Plan",
            //   planType: "Pro",
            //   price: 6.99,
            //   planDurationType: "Monthly",
            //   daysRemaining: 15,
            //   discountOnPreviousPlan: 3.495,
            //   subscriptionStartDate: "15/09/2025",
            // ),
            // UIHelper.verticalSpace(24.h),

            ///Section : ---------///PromoCode///---------
            Obx(() {
              if (planSummeryDetailsScreenController
                  .isSummeryDetailsLoading
                  .value) {
                return Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    CustomShimmerEffect(height: 10.h, width: 0.2.sw),
                    UIHelper.horizontalSpace(10.w),
                    CustomShimmerEffect(height: 10.h, width: 0.6.sw),
                  ],
                );
              }

              return Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  SvgPicture.asset(Assets.icons.promoCodeIcon),
                  UIHelper.horizontalSpace(8.w),
                  InkWell(
                    onTap: () {
                      log("Text Button -> Add Promocode Text Button Taped!");
                      Get.toNamed(
                        Routes.addPromoCodeScreen,
                        arguments: {'planId': planId},
                      );
                    },
                    child: Text(
                      "Add Promo Code",
                      style: TextFontStyle.headline16w500ce7b0b0StylePoppins,
                    ),
                  ),
                ],
              );
            }),
            UIHelper.verticalSpace(24.h),

            ///Section : ---------------///Total Price for Current Plan///----------
            Obx(() {
              if (planSummeryDetailsScreenController
                  .isSummeryDetailsLoading
                  .value) {
                return Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    CustomShimmerEffect(height: 10.h, width: 0.6.sw),
                    UIHelper.horizontalSpace(10.w),
                    CustomShimmerEffect(height: 10.h, width: 30.w),
                  ],
                );
              }

              return Text(
                "Total Price For Current Plan: ",
                style: TextFontStyle.headline16w500cfefefeStylePoppins,
              );
            }),
            UIHelper.verticalSpace(16.h),

            ///Section:-------///Total Amount For This Month///----
            Obx(() {
              if (planSummeryDetailsScreenController
                  .isSummeryDetailsLoading
                  .value) {
                return Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    CustomShimmerEffect(height: 10.h, width: 0.6.sw),
                    UIHelper.horizontalSpace(10.w),
                    CustomShimmerEffect(height: 10.h, width: 30.w),
                  ],
                );
              }

              return PaymentInfoRowWidget(
                title: "Total Amount For This Month:",
                price: planSummeryDetailsScreenController.planPrice,
              );
            }),
            UIHelper.verticalSpace(10.h),

            ///Section:-------///Total Amount For This Month///----
            // PaymentInfoRowWidget(
            //   title: "Already Charged (Starter Plan):",
            //   price: 6.99,
            // ),
            // UIHelper.verticalSpace(10.h),

            ///Section:-------///Pay for Upgrade: ///----
            Obx(() {
              if (planSummeryDetailsScreenController
                  .isSummeryDetailsLoading
                  .value) {
                return Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    CustomShimmerEffect(height: 10.h, width: 0.6.sw),
                    UIHelper.horizontalSpace(10.w),
                    CustomShimmerEffect(height: 10.h, width: 30.w),
                  ],
                );
              }

              return PaymentInfoRowWidget(
                title: "Pay for Subscription:",
                price: planSummeryDetailsScreenController.totalAmount,
                textStyle: TextFontStyle.headline16w500cFFFFFFStylePoppins,
              );
            }),
            UIHelper.verticalSpace(24.h),

            ///Section : -------///Button -> Pay Now///-----------
            Obx(() {
              if (planSummeryDetailsScreenController
                  .isSummeryDetailsLoading
                  .value) {
                return CustomShimmerEffect(height: 40.h, width: 0.6.sw);
              }

              return CustomElevatedButton(
                onTap: () {
                  log("Button Taped -> Pay Now");
                },
                buttonTitle: "Pay Now",
                borderRadius: 24.r,
              );
            }),
          ],
        ),
      ),
    );
  }
}
