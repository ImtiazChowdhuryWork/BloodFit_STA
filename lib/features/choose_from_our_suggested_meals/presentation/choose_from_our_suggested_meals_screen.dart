import 'dart:developer';

import 'package:bloodfit/constants/text_font_style.dart';
import 'package:bloodfit/custom_widgets/go_back_widget.dart';
import 'package:bloodfit/features/choose_from_our_suggested_meals/presentation/widgets/food_item_showing_widget.dart';
import 'package:bloodfit/features/choose_from_our_suggested_meals/sub_presentation/dinner/presentation/dinner_tab.dart';
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
import '../sub_presentation/breakfast/presentation/breakfast_tab.dart';
import '../sub_presentation/lunch/presentation/lunch_tab.dart';

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
            crossAxisAlignment: CrossAxisAlignment.start,
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
              UIHelper.verticalSpace(32.h),

              ///Section : -------------///Text -> Choose From Our Suggested Meals///------------
              Text(
                "Choose From Our Suggested Meals",
                style: TextFontStyle.headline20w500cfefefeStylePoppins,
              ),
              UIHelper.verticalSpace(6.h),

              ///Section : -------------///Text -> Select Any One///------------
              Text(
                "Select Any One",
                style: TextFontStyle.headline14w500cc6c6c6StylePoppins,
              ),
              UIHelper.verticalSpace(32.h),

              /// TabBarView
              Expanded(
                child: TabBarView(
                  controller: _tabController,
                  children: [
                    /// Monthly Tab
                    /// subscriptionPackagesList
                    BreakfastTab(),

                    /// subscriptionPackagesList
                    LunchTab(),

                    /// Yearly Tab
                    DinnerTab(),
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
