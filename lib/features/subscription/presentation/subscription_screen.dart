import 'dart:developer';

import 'package:bloodfit/gen/colors.gen.dart';
import 'package:bloodfit/routes/routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../constants/text_font_style.dart';
import '../../../custom_widgets/go_back_widget.dart';
import '../../../helper/ui_helpers.dart';
import '../../../services/iap_service.dart';
import '../data/controller/subscription_plans_screen_controller.dart';
import '../data/model/subscription_plans_model.dart';
import '../widgets/subscription_package_showing_widget.dart';

/// [SubscriptionScreen] displays all available subscription plans
/// in a Monthly / Yearly tabbed layout.
///
/// --- DATA FLOW ---
/// This screen uses a hybrid data approach managed by [SubscriptionPlansScreenController]:
///
/// • PLAN STRUCTURE (features, name, active status)
///   → Fetched from the backend API on screen load via [getSubscriptionPlansApi].
///
/// • PLAN PRICES
///   → Read from [IAPService] which loads real prices from the App Store / Play Store.
///   → This ensures prices are always in the user's local currency and comply
///     with App Store / Play Store guidelines (you must display store prices).
///
/// --- IAP AVAILABILITY ---
/// [IAPService] is checked before rendering the plan cards:
///   - Still loading  → shows a loading spinner.
///   - Products empty → shows a "Coming Soon" message.
///     This happens when subscriptions have not yet been configured in the
///     App Store Connect or Google Play Console for the current platform.
///     Once products are added to the store with the matching product IDs,
///     the plan cards will appear automatically — no code change required.
///   - Products loaded → shows the Monthly / Yearly plan cards normally.
///
/// --- NAVIGATION ---
/// Tapping a plan navigates to [PlanSummeryDetailsScreen] and passes:
///   - planId    → used to fetch the billing summary from the backend.
///   - planType  → 'monthly' or 'yearly', used for the billing API call.
///   - planName  → displayed on the summary screen.
///   - productId → the store product ID used to trigger the IAP purchase
///                 when the user taps "Pay Now" on the summary screen.
class SubscriptionScreen extends StatefulWidget {
  const SubscriptionScreen({super.key});

  @override
  State<SubscriptionScreen> createState() => _SubscriptionScreenState();
}

class _SubscriptionScreenState extends State<SubscriptionScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  late SubscriptionPlansScreenController controller;
  late IAPService _iapService;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    controller = Get.find<SubscriptionPlansScreenController>();
    _iapService = Get.find<IAPService>();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.getSubscriptionPlansApi();
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
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
          "Subscription",
          style: TextFontStyle.headline24w700cFFFFFFStylePoppins,
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(UIHelper.kDefaulutPadding()),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// Tab bar with two options: Monthly and Yearly.
            Align(
              alignment: Alignment.center,
              child: Container(
                height: 50.h,
                width: 0.5.sw,
                decoration: BoxDecoration(
                  color: AppColors.cFFFFFF,
                  borderRadius: BorderRadius.circular(8.r),
                ),
                child: TabBar(
                  padding: EdgeInsets.zero,
                  labelPadding: EdgeInsets.symmetric(vertical: 10.h),
                  controller: _tabController,
                  indicator: BoxDecoration(
                    color: AppColors.cb20000,
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                  labelColor: AppColors.cfefefe,
                  unselectedLabelColor: AppColors.c6a6a6a,
                  dividerColor: Colors.transparent,
                  labelStyle: TextFontStyle.headline16w500cfefefeStylePoppins,
                  unselectedLabelStyle:
                      TextFontStyle.headline16w500cfefefeStylePoppins,
                  tabs: [
                    Tab(
                      child: Container(
                        alignment: Alignment.center,
                        width: double.infinity,
                        child: Text('Monthly'),
                      ),
                    ),
                    Tab(
                      child: Container(
                        alignment: Alignment.center,
                        width: double.infinity,
                        child: Text('Yearly'),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            UIHelper.verticalSpace(20.h),

            /// Renders plan cards once IAP products are confirmed available.
            /// Three states are handled reactively via [IAPService]:
            ///   1. Loading   → spinner while querying the store.
            ///   2. No products → "Coming Soon" (store not configured yet).
            ///   3. Ready     → Monthly / Yearly tabs with real plan cards.
            Expanded(
              child: Obx(() {
                // State 1: IAPService is still querying the store for products.
                if (_iapService.isLoading.value) {
                  return const Center(
                    child: CircularProgressIndicator(color: AppColors.cb20000),
                  );
                }

                // State 2: Store returned no products.
                // Subscriptions are not yet configured in App Store Connect
                // or Google Play Console for this platform.
                // Once added with matching product IDs, this resolves automatically.
                if (_iapService.products.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.hourglass_top_rounded,
                          size: 64,
                          color: AppColors.c999999,
                        ),
                        UIHelper.verticalSpace(16.h),
                        Text(
                          'Coming Soon',
                          style: TextFontStyle.headline22w500cfefefeStylePoppins,
                        ),
                        UIHelper.verticalSpace(8.h),
                        Text(
                          'Subscription plans will be available soon.',
                          style: TextFontStyle.headline14w500c999999StylePoppins,
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  );
                }

                // State 3: Products loaded — show the Monthly / Yearly plan tabs.
                return TabBarView(
                controller: _tabController,
                children: [
                  /// --- MONTHLY TAB ---
                  /// Shows plans where pricing.monthly is not null.
                  Obx(() {
                    if (controller.isSubscriptionBeingLoad.value) {
                      return const Center(
                        child: CircularProgressIndicator(
                          color: AppColors.cb20000,
                        ),
                      );
                    }
                    if (controller
                        .subscriptionsLoadingErrorMessage
                        .value
                        .isNotEmpty) {
                      return Center(
                        child: Text(
                          'Error: ${controller.subscriptionsLoadingErrorMessage.value}',
                        ),
                      );
                    }

                    final monthlyPlans = controller.subscriptionList.where((
                      plan,
                    ) {
                      return plan.pricing?.monthly != null;
                    }).toList();

                    if (monthlyPlans.isEmpty) {
                      return const Center(
                        child: Text('No monthly plans available'),
                      );
                    }

                    return ListView.separated(
                      itemCount: monthlyPlans.length,
                      separatorBuilder: (context, index) =>
                          UIHelper.verticalSpace(24.h),
                      itemBuilder: (context, index) {
                        var plan = monthlyPlans[index];
                        return SubscriptionPackageShowingWidget(
                          /// Price comes from the App Store / Play Store via IAPService.
                          /// plan.slug + 'monthly' → store product ID → rawPrice.
                          packagePrice: controller.getStorePriceForPlan(
                            plan.slug,
                            'monthly',
                          ),

                          /// Features (label text) come from the backend API response.
                          /// labelValues.reverse maps the Label enum back to its string.
                          packageOffersList: plan.features != null
                              ? plan.features!
                                    .map(
                                      (feature) =>
                                          labelValues.reverse[feature.label] ??
                                          '',
                                    )
                                    .toList()
                              : <String>[],

                          /// Included flags (true = active, false = greyed out)
                          /// also come from the backend API response.
                          isIncludedList:
                              plan.features
                                  ?.map(
                                    (isIncludedStatus) =>
                                        isIncludedStatus.included ?? false,
                                  )
                                  .toList() ??
                              [],
                          packageType: plan.name ?? 'Unknown',
                          packageDuration: 'Monthly',
                          isPackageActive: plan.isActive ?? false,

                          onTap: () {
                            /// Navigate to PlanSummeryDetailsScreen.
                            /// productId is passed so the Pay Now button
                            /// on that screen knows which product to purchase via IAP.
                            Get.toNamed(
                              Routes.costDetailsForUpgradePlanScreen,
                              arguments: {
                                'planId': plan.id ?? '',
                                'planType': 'monthly',
                                'planName': plan.name ?? 'Unknown',
                                'productId':
                                    'com.bloodfitltd.bloodfit.${plan.slug}.monthly',
                              },
                            );
                            log("${plan.name} selected");
                          },
                        );
                      },
                    );
                  }),

                  /// --- YEARLY TAB ---
                  /// Shows plans where pricing.yearly is not null.
                  Obx(() {
                    if (controller.isSubscriptionBeingLoad.value) {
                      return const Center(
                        child: CircularProgressIndicator(
                          color: AppColors.cb20000,
                        ),
                      );
                    }
                    if (controller
                        .subscriptionsLoadingErrorMessage
                        .value
                        .isNotEmpty) {
                      return Center(
                        child: Text(
                          'Error: ${controller.subscriptionsLoadingErrorMessage.value}',
                        ),
                      );
                    }

                    final yearlyPlans = controller.subscriptionList.where((
                      plan,
                    ) {
                      return plan.pricing?.yearly != null;
                    }).toList();

                    if (yearlyPlans.isEmpty) {
                      return const Center(
                        child: Text('No yearly plans available'),
                      );
                    }

                    return ListView.separated(
                      itemCount: yearlyPlans.length,
                      separatorBuilder: (context, index) =>
                          UIHelper.verticalSpace(24.h),
                      itemBuilder: (context, index) {
                        var plan = yearlyPlans[index];
                        return SubscriptionPackageShowingWidget(
                          /// Price comes from the App Store / Play Store via IAPService.
                          /// plan.slug + 'yearly' → store product ID → rawPrice.
                          packagePrice: controller.getStorePriceForPlan(
                            plan.slug,
                            'yearly',
                          ),

                          packageOffersList: plan.features != null
                              ? plan.features!
                                    .map(
                                      (feature) =>
                                          labelValues.reverse[feature.label] ??
                                          '',
                                    )
                                    .toList()
                              : <String>[],

                          isIncludedList:
                              plan.features
                                  ?.map(
                                    (isIncludedStatus) =>
                                        isIncludedStatus.included ?? false,
                                  )
                                  .toList() ??
                              [],
                          packageType: plan.name ?? 'Unknown',
                          packageDuration: 'Yearly',
                          isPackageActive: plan.isActive ?? false,

                          onTap: () {
                            /// productId follows the pattern:
                            /// com.bloodfitltd.bloodfit.{slug}.yearly
                            Get.toNamed(
                              Routes.costDetailsForUpgradePlanScreen,
                              arguments: {
                                'planId': plan.id ?? '',
                                'planType': 'yearly',
                                'planName': plan.name ?? 'Unknown',
                                'productId':
                                    'com.bloodfitltd.bloodfit.${plan.slug}.yearly',
                              },
                            );
                            log("${plan.name} selected");
                          },
                        );
                      },
                    );
                  }),
                ],
              );
            }),
            ),

            UIHelper.verticalSpace(24.h),
          ],
        ),
      ),
    );
  }
}
