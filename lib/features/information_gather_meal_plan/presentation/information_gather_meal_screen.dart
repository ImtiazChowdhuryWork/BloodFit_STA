import 'dart:developer';
import 'package:bloodfit/custom_widgets/custom_elevated_button.dart';
import 'package:bloodfit/custom_widgets/page_indicator.dart';
import 'package:bloodfit/features/information_gather_meal_plan/presentation/widgets/select_age/presentation/select_age_screen_widget.dart';
import 'package:bloodfit/features/information_gather_meal_plan/presentation/widgets/select_blood_group/presentation/select_blood_group_screen.dart';
import 'package:bloodfit/features/information_gather_meal_plan/presentation/widgets/select_country/presentation/select_country_widget.dart';
import 'package:bloodfit/features/information_gather_meal_plan/presentation/widgets/select_diet/presentation/select_diet_widget.dart';
import 'package:bloodfit/features/information_gather_meal_plan/presentation/widgets/select_dislike_foods/presentation/select_dislike_foods_widget.dart';
import 'package:bloodfit/features/information_gather_meal_plan/presentation/widgets/select_food_allergies/presentation/select_foood_allergies_widget.dart';
import 'package:bloodfit/features/information_gather_meal_plan/presentation/widgets/select_gender/presentation/select_gender_widget.dart';
import 'package:bloodfit/features/information_gather_meal_plan/presentation/widgets/select_height/presentation/select_height_screen_widget.dart';
import 'package:bloodfit/features/information_gather_meal_plan/presentation/widgets/select_weight/presentation/select_weight_screen.dart';
import 'package:bloodfit/helper/ui_helpers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../controllers/information_gather_screen_controller.dart';
import '../../../custom_widgets/go_back_widget.dart';
import '../../../gen/colors.gen.dart';
import '../../../routes/routes.dart';

class InformationGatherMealScreen extends StatelessWidget {
  const InformationGatherMealScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final InformationGatherMealPlanController controller = Get.put(
      InformationGatherMealPlanController(),
    );

    return Scaffold(
      backgroundColor: AppColors.scaffoldBackgroundColor,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(UIHelper.kDefaulutPadding()),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /// Top bar (Back button only)
              CustomBackButton(
                onTap: () {
                  if (controller.currentIndex.value > 0) {
                    controller.previousPage();
                  } else {
                    // Exit current flow (go back)
                    Get.back();
                  }
                },
              ),
              UIHelper.verticalSpace(26.h),

              /// Page Indicators
              PageIndicator(controller: controller),
              UIHelper.verticalSpace(16.h),

              /// PageView section
              Expanded(
                child: PageView(
                  controller: controller.pageController,
                  onPageChanged: controller.updateCurrentIndex,
                  physics: const NeverScrollableScrollPhysics(),
                  children: [
                    SelectBloodGroupWidget(),
                    SelectGenderWidget(),
                    SelectAgeScreenWidgt(),
                    SelectWeightScreen(),
                    SelectHeightScreenWidget(),
                    SelectCountryWidget(),
                    SelectDietWidget(),
                    SelectFooodAllergiesWidget(),
                    SelectDislikeFoodsWidget(),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),

      bottomNavigationBar: Container(
        width: 1.sw,
        height: 100.h,
        padding: EdgeInsets.only(
          left: UIHelper.kDefaulutPadding(),
          right: UIHelper.kDefaulutPadding(),
          bottom: 40.h,
        ),
        decoration: BoxDecoration(color: AppColors.scaffoldBackgroundColor),
        child: Obx(() {
          final isLastPage =
              controller.currentIndex.value == controller.totalPages - 1;
          return CustomElevatedButton(
            onTap: () {
              if (isLastPage) {
                // Finish onboarding or navigate to next screen
                log("Information Gathering Completed!");
                // Example navigation:
                Get.toNamed(Routes.dailyCaloriesIntakeScreen);
              } else {
                // Go to next page
                controller.nextPage();
              }
            },
            buttonTitle: isLastPage ? "Finish" : "Continue",
            buttonHeight: 60.h,
          );
        }),
      ),
    );
  }
}
