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
import '../../../services/iap_service.dart';
import '../widgets/current_plan_widget.dart';
import '../widgets/payment_info_row_widget.dart';

/// [PlanSummeryDetailsScreen] is the billing summary screen shown after
/// the user selects a subscription plan from [SubscriptionScreen].
///
/// --- DATA FLOW ---
/// Arguments received from [SubscriptionScreen] via [Get.toNamed]:
///   - planId    → used to call the backend billing summary API.
///   - planType  → 'monthly' or 'yearly', used in the billing API call.
///   - planName  → displayed as the plan label (currently unused in this screen).
///   - productId → the App Store / Play Store product ID for this plan.
///                 Used to trigger the IAP purchase when "Pay Now" is tapped.
///
/// --- RESPONSIBILITIES ---
/// 1. Fetches billing summary (plan name, price, date) from the backend.
/// 2. Shows promo code option (navigates to [addPromoCodeScreen]).
/// 3. "Pay Now" button triggers [IAPService.buyProduct] with the [productId],
///    which opens the native store payment sheet.
///    The purchase result is handled asynchronously by [IAPService._onPurchaseUpdate].
class PlanSummeryDetailsScreen extends StatefulWidget {
  const PlanSummeryDetailsScreen({super.key});

  @override
  State<PlanSummeryDetailsScreen> createState() =>
      _PlanSummeryDetailsScreenState();
}

class _PlanSummeryDetailsScreenState extends State<PlanSummeryDetailsScreen> {
  PlanSummeryDetailsScreenController planSummeryDetailsScreenController =
      Get.find<PlanSummeryDetailsScreenController>();

  /// Global IAP service used to trigger the purchase when "Pay Now" is tapped.
  /// Registered as a permanent singleton in [ControllerBindings].
  late final IAPService _iapService;

  /// Backend plan ID — used to call the billing summary API.
  String planId = '';

  /// Billing period — 'monthly' or 'yearly'. Sent to the billing summary API.
  String planType = '';

  /// Store product ID — passed from [SubscriptionScreen].
  /// Format: com.bloodfitltd.bloodfit.{slug}.{monthly|yearly}
  /// Used by [IAPService.buyProduct] to initiate the App Store / Play Store purchase.
  String productId = '';

  @override
  void initState() {
    final arguments = Get.arguments as Map<String, dynamic>?;

    planId = arguments?['planId'] ?? '';
    planType = arguments?['planType'] ?? '';
    productId = arguments?['productId'] ?? '';
    _iapService = Get.find<IAPService>();

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
            Text(
              "Billing Summary",
              style: TextFontStyle.headline22w500cfefefeStylePoppins,
            ),
            UIHelper.verticalSpace(24.h),

            /// Current plan details — fetched from the backend billing summary API.
            /// Shows shimmer placeholders while loading.
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
                subscriptionDate: planSummeryDetailsScreenController
                    .formattedSubscriptionDate,
              );
            }),

            UIHelper.verticalSpace(16.h),

            // UpgradePlanWidget — reserved for plan upgrade flow (not active yet).
            // UpgradePlanWidget(...),

            /// Promo code section — navigates to [addPromoCodeScreen]
            /// passing the [planId] so the promo can be applied to the correct plan.
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

            /// Price breakdown rows — all values come from the backend billing API.
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

            // Already Charged row — reserved for upgrade flow (not active yet).
            // PaymentInfoRowWidget(title: "Already Charged (Starter Plan):", price: 6.99),

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

            /// Pay Now button — the entry point for the IAP purchase.
            ///
            /// States:
            /// - Loading (billing API)  → shimmer placeholder.
            /// - Purchasing (IAP)       → CircularProgressIndicator.
            /// - Ready                  → "Pay Now" button.
            ///
            /// On tap: calls [IAPService.buyProduct] with [productId].
            /// The native store payment sheet appears.
            /// Purchase result (success / error / pending) is handled by
            /// [IAPService._onPurchaseUpdate] which shows snackbar feedback.
            Obx(() {
              if (planSummeryDetailsScreenController
                  .isSummeryDetailsLoading
                  .value) {
                return CustomShimmerEffect(height: 40.h, width: 0.6.sw);
              }

              if (_iapService.isPurchasing.value) {
                return const Center(
                  child: CircularProgressIndicator(color: AppColors.cb20000),
                );
              }

              return CustomElevatedButton(
                onTap: () {
                  log("Button Taped -> Pay Now | productId: $productId");
                  _iapService.buyProduct(productId);
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
