import 'package:bloodfit/constants/text_font_style.dart';
import 'package:bloodfit/custom_widgets/go_back_widget.dart';
import 'package:bloodfit/features/choose_from_our_suggested_meals/data/controller/choose_from_our_suggested_meal_controller.dart';
import 'package:bloodfit/features/choose_from_our_suggested_meals/sub_presentation/dinner/presentation/dinner_tab.dart';
import 'package:bloodfit/gen/colors.gen.dart';
import 'package:bloodfit/helper/ui_helpers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

import '../../../gen/assets.gen.dart';
import '../../../helper/logger_util.dart';
import '../../../routes/routes.dart';
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
  ChooseFromOurSuggestedMealController chooseFromOurSuggestedMealController = Get.find<ChooseFromOurSuggestedMealController>();

  // String receivedSelectedDate = '';
  String mealGenerationDate = '';

  @override
  void initState() {
    super.initState();

    ///-------------<>>>>> Section : NAVIGATION CONFIRMATION
    LoggerUtils.debug("╔═══════════════════════════════════════════════════════════");
    LoggerUtils.debug("🚀 [NAVIGATION] ChooseFromOurSuggestedMealsScreen - initState() CALLED");
    LoggerUtils.debug("🚀 [NAVIGATION] Received arguments: ${Get.arguments}");
    LoggerUtils.debug("╚═══════════════════════════════════════════════════════════");

    ///-------------<>>>>> Section : Receive Arguments
    final arguments = Get.arguments as Map<String,dynamic>?;
    // receivedSelectedDate = arguments?['selectedDate'] ?? '';
    mealGenerationDate = arguments?['mealGenerationDate'] ?? '';

    ///------------<>>>> Section : Send the selected date to controller
    WidgetsBinding.instance.addPostFrameCallback((_){
      LoggerUtils.debug("╔═══════════════════════════════════════════════════════════");
      LoggerUtils.debug("📱 [SCREEN] ChooseFromOurSuggestedMealsScreen loaded");
      LoggerUtils.debug("📱 [SCREEN] Setting selected date: $mealGenerationDate");
      LoggerUtils.debug("╚═══════════════════════════════════════════════════════════");
      chooseFromOurSuggestedMealController.setSelectedDate(date: mealGenerationDate);
    });

    _tabController = TabController(length: 3, vsync: this);


    ///------------->>> Section : Initial tab setup (Breakfast)
    chooseFromOurSuggestedMealController
        .setSelectedTabName(index: 0);

    ///------------->>> Section : Initialize AI Meals (MAIN DATA SOURCE)
    /// This loads the AI-generated meals for all tabs (Breakfast, Lunch, Dinner)
    WidgetsBinding.instance.addPostFrameCallback((_) {
      LoggerUtils.debug("╔═══════════════════════════════════════════════════════════");
      LoggerUtils.debug("📱 [SCREEN] Calling initializeAiMeals() to load meal data...");
      LoggerUtils.debug("╚═══════════════════════════════════════════════════════════");
      chooseFromOurSuggestedMealController.initializeAiMeals();
    });

    ///------------->>> Section : Initial API call for Previously Selected Meals
    chooseFromOurSuggestedMealController
        .getPreviouslySelectedMeals();

    _tabController.addListener(() {
      ///------------->>> Section : Fires when tab changes
      debugPrint('Current Tab Index: ${_tabController.index}');
      chooseFromOurSuggestedMealController.setSelectedTabName(index: _tabController.index);
      chooseFromOurSuggestedMealController.getPreviouslySelectedMeals();
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    LoggerUtils.debug("🏗️ [BUILD] ChooseFromOurSuggestedMealsScreen - build() called");
    
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
          // DEBUG BUTTON: Clear cached jobId and re-fetch
          InkWell(
            onTap: () {
              LoggerUtils.debug("🔧 [DEBUG] Clear cached jobId button tapped!");
              chooseFromOurSuggestedMealController.clearCachedJobIdAndReFetch();
            },
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
              margin: EdgeInsets.only(right: 8.w),
              decoration: BoxDecoration(
                color: Colors.red.shade800,
                borderRadius: BorderRadius.circular(8.r),
              ),
              child: Text(
                '🔄 Clear\nJobId',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 10.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          InkWell(
            onTap: () {
              Get.toNamed(Routes.notificationScreen);
            },
            child: SvgPicture.asset(Assets.icons.bellIcon),
          ),
          UIHelper.horizontalSpace(15.w),
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
                      Tab(
                        child: Container(
                          alignment: Alignment.center,
                          width: double.infinity,
                          child: Text('Breakfast'),
                        ),
                      ),
                      Tab(
                        child: Container(
                          alignment: Alignment.center,
                          width: double.infinity,
                          child: Text('Lunch'),
                        ),
                      ),
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
              Text(
                "Choose From Our Suggested Meals",
                style: TextFontStyle.headline20w500cfefefeStylePoppins,
              ),
              UIHelper.verticalSpace(6.h),
              Text(
                "Select Any One",
                style: TextFontStyle.headline14w500cc6c6c6StylePoppins,
              ),
              UIHelper.verticalSpace(32.h),
              Expanded(
                child: TabBarView(
                  controller: _tabController,
                  children: [
                    BreakfastTab(),
                    LunchTab(),
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
