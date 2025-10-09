import 'dart:developer';

import 'package:bloodfit/custom_widgets/custom_elevated_button.dart';
import 'package:bloodfit/features/fitness/presentation/widgets/fitness_options_drop_down_widget.dart';
import 'package:bloodfit/gen/colors.gen.dart';
import 'package:bloodfit/helper/ui_helpers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../constants/appList.dart';
import '../../../constants/text_font_style.dart';
import '../../../controllers/fitness_screen_controller.dart';
import '../../../custom_widgets/custom_drop_down_field_widget.dart';
import '../../../custom_widgets/go_back_widget.dart';

class FitnessScreen extends StatelessWidget {
  FitnessScreen({super.key});

  FitnessScreenController controller = Get.find<FitnessScreenController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: AppColors.scaffoldBackgroundColor,
        centerTitle: true,
        automaticallyImplyLeading: false,
        leading: CustomBackButton(),
        title: Text(
          "Fitness",
          style: TextFontStyle.headline24w700cFFFFFFStylePoppins,
        ),
      ),

      body: SingleChildScrollView(
        padding: EdgeInsets.all(UIHelper.kDefaulutPadding()),
        child: Column(
          children: [
            ///Section : ----------------///Drop Down -> Body Shape///------------------
            FitnessOptionsDropDownWidget<String>(
              selectedValue: controller.selectedBodyShape,
              dropDownOptionsList: AppList.bodyShapesList,
              labelText: "What's Your Current Body Shape?",
              hintText: "Select your body shape",
            ),
            UIHelper.verticalSpace(24.h),

            ///Section : ----------------///Drop Down -> Daily Activiy Level///------------------
            FitnessOptionsDropDownWidget<String>(
              selectedValue: controller.selectedActivictyLevel,
              dropDownOptionsList: AppList.dailyActivityLevelsList,
              labelText: "What's Your Activity Level?",
              hintText: "Select your activity lebel",
            ),
            UIHelper.verticalSpace(24.h),

            ///Section : ----------------///Drop Down -> Workout Level///------------------
            FitnessOptionsDropDownWidget<String>(
              selectedValue: controller.selectedWorkOutLevel,
              dropDownOptionsList: AppList.workoutLevelsList,
              labelText: "What's Your Prefered Workout Level?",
              hintText: "Select your prefered workout level",
            ),
            UIHelper.verticalSpace(24.h),

            ///Section : ----------------///Drop Down -> Workout Goal///------------------
            FitnessOptionsDropDownWidget<String>(
              selectedValue: controller.selectedWorkOutGoal,
              dropDownOptionsList: AppList.workoutGoalsList,
              labelText: "What's Your Workout Goal?",
              hintText: "Select your workout goal",
            ),
            UIHelper.verticalSpace(24.h),

            ///Section : ----------------///Drop Down -> Desired Weight///------------------
            FitnessOptionsDropDownWidget<String>(
              selectedValue: controller.selectedDesiredWeight,
              dropDownOptionsList: AppList.humanWeightsList,
              labelText: "What's Your Desired Weight?",
              hintText: "Select your desired weight",
            ),
            UIHelper.verticalSpace(24.h),

            ///Section : ----------------///Drop Down -> Selected Focus Area///------------------
            FitnessOptionsDropDownWidget<String>(
              selectedValue: controller.selectedFocusArea,
              dropDownOptionsList: AppList.workoutFocusAreasList,
              labelText: "What's Your Focus Area?",
              hintText: "Select your focus area",
            ),
            UIHelper.verticalSpace(24.h),
          ],
        ),
      ),

      bottomNavigationBar: Container(
        width: 1.sw,

        padding: EdgeInsets.only(
          left: UIHelper.kDefaulutPadding(),
          right: UIHelper.kDefaulutPadding(),
          bottom: 70.h,
        ),

        child: CustomElevatedButton(
          buttonHeight: 52.h,
          borderRadius: 24.r,
          onTap: () {
            log("Button -> Save Changes Button Taped!");
          },
          buttonTitle: "Save Changes",
        ),
      ),
    );
  }
}
