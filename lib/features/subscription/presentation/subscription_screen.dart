import 'dart:developer';

import 'package:bloodfit/gen/colors.gen.dart';
import 'package:bloodfit/routes/routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../constants/text_font_style.dart';
import '../../../custom_widgets/go_back_widget.dart';
import '../../../helper/ui_helpers.dart';
import '../data/controller/subscription_plans_screen_controller.dart';
import '../data/model/subscription_plans_model.dart';
import '../widgets/subscription_package_showing_widget.dart';

class SubscriptionScreen extends StatefulWidget {
  const SubscriptionScreen({super.key});

  @override
  State<SubscriptionScreen> createState() => _SubscriptionScreenState();
}

class _SubscriptionScreenState extends State<SubscriptionScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  late SubscriptionPlansScreenController controller;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    controller = Get.find<SubscriptionPlansScreenController>();

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
            /// Custom TabBar (below AppBar)
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
                    /// Monthly Tab
                    Tab(
                      child: Container(
                        alignment: Alignment.center,
                        width: double.infinity,
                        child: Text('Monthly'),
                      ),
                    ),

                    /// Yearly Tab
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

            /// TabBarView
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  /// Monthly Tab
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

                    // Filter monthly plans
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
                          packagePrice: plan.pricing?.monthly?.price ?? 0.0,
                          packageOffersList: plan.features != null
                              ? plan.features!.map((feature) => labelValues.reverse[feature.label] ?? '').toList()
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
                          packageDuration: 'Monthly',
                          isPackageActive: plan.isActive ?? false,
                          onTap: () {
                            // handle selection
                            Get.toNamed(Routes.costDetailsForUpgradePlanScreen, arguments: {
                              'planId' : plan.id ?? '',
                              'planType': 'monthly',
                              'planName': plan.name ?? 'Unknown'
                            });
                            log("${plan.name} selected");
                          },
                        );
                      },
                    );
                  }),

                  /// Yearly Tab
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

                    // Filter yearly plans
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
                          packagePrice: plan.pricing?.yearly?.price ?? 0.0,
                          packageOffersList: plan.features != null
                              ? plan.features!.map((feature) => labelValues.reverse[feature.label] ?? '').toList()
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
                            // handle selection
                            Get.toNamed(Routes.costDetailsForUpgradePlanScreen, arguments: {
                              'planId' : plan.id ?? '',
                              'planType': 'yearly',
                              'planName': plan.name ?? 'Unknown'
                            });
                            log("${plan.name} selected");
                          },
                        );
                      },
                    );
                  }),
                ],
              ),
            ),

            UIHelper.verticalSpace(24.h),
          ],
        ),
      ),
    );
  }
}
