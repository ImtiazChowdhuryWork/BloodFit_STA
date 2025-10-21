import 'dart:developer';

import 'package:bloodfit/constants/text_font_style.dart';
import 'package:bloodfit/custom_widgets/go_back_widget.dart';
import 'package:bloodfit/gen/colors.gen.dart';
import 'package:bloodfit/helper/ui_helpers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

import '../../../constants/app_list.dart';
import '../../../gen/assets.gen.dart';
import '../../../routes/routes.dart';
import '../../subscription/widgets/subscription_package_showing_widget.dart';

class ChooseFromOurSuggestedMealsScreen extends StatefulWidget {
  const ChooseFromOurSuggestedMealsScreen({super.key});

  @override
  State<ChooseFromOurSuggestedMealsScreen> createState() =>
      _ChooseFromOurSuggestedMealsScreenState();
}

class _ChooseFromOurSuggestedMealsScreenState
    extends State<ChooseFromOurSuggestedMealsScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
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
        automaticallyImplyLeading: false,
        leading: CustomBackButton(),
        centerTitle: true,
        title: Text(
          "Meal Plan",
          style: TextFontStyle.headline24w700cFFFFFFStylePoppins,
        ),
        actions: [
          ///Section : ---------------------///Notification///-----------
          InkWell(
            onTap: () {
              Get.toNamed(Routes.notificationScreen);
            },
            child: SvgPicture.asset(Assets.icons.bellIcon),
          ),
          UIHelper.horizontalSpace(15.w),

          ///Section : ---------------------///Profile///-----------
          InkWell(
            onTap: () {
              Get.toNamed(Routes.myProfileScreen);
            },
            child: Container(
              width: 48.w,
              height: 48.h,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: AppColors.cFFFFFF),
                image: DecorationImage(
                  fit: BoxFit.cover,
                  image: AssetImage(Assets.images.userImage.path),
                ),
              ),
            ),
          ),
          UIHelper.horizontalSpace(UIHelper.kDefaulutPadding()),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(UIHelper.kDefaulutPadding()),
          child: Column(
            children: [
              /// Custom TabBar (below AppBar)
              Align(
                alignment: Alignment.center,
                child: Container(
                  height: 50.h,
                  width: 1.sw,
                  decoration: BoxDecoration(
                    color: AppColors.c282828,
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
                    unselectedLabelColor: AppColors.cfefefe,
                    dividerColor: Colors.transparent,
                    labelStyle: TextFontStyle.headline18w500cfefefeStylePoppins,
                    unselectedLabelStyle:
                        TextFontStyle.headline18w500cfefefeStylePoppins,

                    tabs: [
                      /// Monthly Tab
                      Tab(
                        child: Container(
                          alignment: Alignment.center,
                          width: double.infinity,
                          child: Text('Breakfast'),
                        ),
                      ),

                      /// Monthly Tab
                      Tab(
                        child: Container(
                          alignment: Alignment.center,
                          width: double.infinity,
                          child: Text('Lunch'),
                        ),
                      ),

                      /// Yearly Tab
                      Tab(
                        child: Container(
                          alignment: Alignment.center,
                          width: double.infinity,
                          child: Text('Dinner'),
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
                          packageDuration: data.packageDuration,
                          isPackageActive: data.isActive,
                          isDiscountOfferAvailable:
                              data.isDiscountOfferAvailable,
                          discountOffer: data.discountOffer,
                          onTap: () {
                            // handle selection
                            Get.toNamed(Routes.costDetailsForUpgradePlanScreen);
                            log("${data.packageType} selected");
                          },
                        );
                      },
                    ),

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
                          packageDuration: data.packageDuration,
                          isPackageActive: data.isActive,
                          isDiscountOfferAvailable:
                              data.isDiscountOfferAvailable,
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
                          packageDuration: data.packageDuration,
                          isPackageActive: data.isActive,
                          isDiscountOfferAvailable:
                              data.isDiscountOfferAvailable,
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
      ),
    );
  }
}
