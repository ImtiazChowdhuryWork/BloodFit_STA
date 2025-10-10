import 'dart:developer';

import 'package:bloodfit/constants/appList.dart';
import 'package:bloodfit/gen/colors.gen.dart';
import 'package:bloodfit/routes/routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../constants/text_font_style.dart';
import '../../../custom_widgets/go_back_widget.dart';
import '../../../helper/ui_helpers.dart';
import '../model/subscription_package_model.dart';
import '../widgets/subscription_package_showing_widget.dart';

class SubscriptionScreen extends StatefulWidget {
  const SubscriptionScreen({super.key});

  @override
  State<SubscriptionScreen> createState() => _SubscriptionScreenState();
}

class _SubscriptionScreenState extends State<SubscriptionScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
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
                  /// subscriptionPackagesList
                  ListView.separated(
                    itemCount: AppList.subscriptionPackagesList.length,
                    separatorBuilder: (context, index) =>
                        UIHelper.verticalSpace(24.h),
                    itemBuilder: (context, index) {
                      var data = AppList.subscriptionPackagesList[index];
                      return SubscriptionPackageShowingWidget(
                        packagePrice: data.packagePrice,
                        packageOffersList: data.packageOffersList,
                        packageType: data.packageType,
                        isPackageActive: data.isActive,
                        isDiscountOfferAvailable: data.isDiscountOfferAvailable,
                        discountOffer: data.discountOffer,
                        onTap: () {
                          // handle selection
                          Get.toNamed(Routes.costDetailsForUpgradePlanScreen);
                          log("${data.packageType} selected");
                        },
                      );
                    },
                  ),

                  /// Yearly Tab
                  ListView.separated(
                    itemCount: AppList.subscriptionPackagesList.length,
                    separatorBuilder: (context, index) =>
                        UIHelper.verticalSpace(24.h),
                    itemBuilder: (context, index) {
                      var data = AppList.subscriptionPackagesList[index];
                      return SubscriptionPackageShowingWidget(
                        packagePrice: data.packagePrice,
                        packageOffersList: data.packageOffersList,
                        packageType: data.packageType,
                        isPackageActive: data.isActive,
                        isDiscountOfferAvailable: data.isDiscountOfferAvailable,
                        discountOffer: data.discountOffer,
                        onTap: () {
                          // handle selection
                          Get.toNamed(Routes.costDetailsForUpgradePlanScreen);
                          log("${data.packageType} selected");
                        },
                      );
                    },
                  ),
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
