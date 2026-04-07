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
  late Worker _tabNavigationWorker;
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

    ///------------->>> Section : Listen for tab navigation requests from Review screen
    _tabNavigationWorker = ever(
      chooseFromOurSuggestedMealController.pendingNavigateToTab,
      (int index) {
        if (index >= 0 && index <= 2) {
          _tabController.animateTo(index);
          chooseFromOurSuggestedMealController.setSelectedTabName(index: index);
          chooseFromOurSuggestedMealController.pendingNavigateToTab.value = -1;
        }
      },
    );

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
    _tabNavigationWorker.dispose();
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
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              "Meal Plan",
              style: TextFontStyle.headline24w700cFFFFFFStylePoppins,
            ),
            UIHelper.horizontalSpace(12.w),
            // Clear Saved Data Button
            InkWell(
              onTap: () {
                _showClearDataConfirmationDialog();
              },
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
                decoration: BoxDecoration(
                  color: AppColors.c7e0101.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(8.r),
                  border: Border.all(color: AppColors.c7e0101, width: 1),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.delete_outline,
                      color: AppColors.c7e0101,
                      size: 18.sp,
                    ),
                    UIHelper.horizontalSpace(4.w),
                    Text(
                      "Clear",
                      style: TextStyle(
                        color: AppColors.c7e0101,
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w600,
                        fontFamily: 'Poppins',
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
        actions: [

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

  /// Show confirmation dialog before clearing saved meal data
  void _showClearDataConfirmationDialog() {
    Get.dialog(
      AlertDialog(
        backgroundColor: AppColors.scaffoldBackgroundColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.r),
          side: BorderSide(color: AppColors.c7e0101, width: 1),
        ),
        title: Row(
          children: [
            Icon(Icons.warning_amber_rounded, color: AppColors.c7e0101, size: 28.sp),
            UIHelper.horizontalSpace(8.w),
            Expanded(
              child: Text(
                "Clear Saved Meals?",
                style: TextFontStyle.headline16w500cFFFFFFStylePoppins,
              ),
            ),
          ],
        ),
        content: Text(
          "This will remove all saved meal selections for Breakfast, Lunch, and Dinner. This action cannot be undone.",
          style: TextFontStyle.headline14w400c999999StylePoppins,
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: Text(
              "Cancel",
              style: TextFontStyle.headline14w500cFFFFFFStylePoppins,
            ),
          ),
          ElevatedButton(
            onPressed: () async {
              Get.back();
              // Clear all selections
              chooseFromOurSuggestedMealController.clearAllSelections();
              // Clear recent meals lists
              chooseFromOurSuggestedMealController.breakfastRecentChosenMeals.clear();
              chooseFromOurSuggestedMealController.lunchRecentChosenMeals.clear();
              chooseFromOurSuggestedMealController.dinnerRecentChosenMeals.clear();
              
              // Clear jobId from local storage and re-fetch (also calls initializeAiMeals internally)
              await chooseFromOurSuggestedMealController.clearCachedJobIdAndReFetch();

              // Show success message
              Get.snackbar(
                "Success",
                "All saved meal data has been cleared",
                backgroundColor: AppColors.c4e000b,
                colorText: Colors.white,
                snackPosition: SnackPosition.TOP,
                margin: EdgeInsets.all(16),
                borderRadius: 12,
                duration: const Duration(seconds: 3),
                icon: const Icon(Icons.check_circle, color: Colors.white),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.c7e0101,
              padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 12.h),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.r),
              ),
            ),
            child: Text(
              "Clear All",
              style: TextFontStyle.headline14w500cFFFFFFStylePoppins,
            ),
          ),
        ],
      ),
    );
  }
}
