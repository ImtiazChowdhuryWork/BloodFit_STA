import 'dart:developer';

import 'package:bloodfit/features/information_gather/presentation/widgets/select_age/select_age_screen_widget.dart';
import 'package:bloodfit/features/information_gather/presentation/widgets/select_blood_group/select_blood_group_widget.dart';
import 'package:bloodfit/features/information_gather/presentation/widgets/select_gender/select_gender_widget.dart';
import 'package:bloodfit/features/information_gather/presentation/widgets/select_weight/presentation/select_weight_screen.dart';
import 'package:bloodfit/helper/ui_helpers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../custom_widgets/custom_elevated_button.dart';
import '../../../custom_widgets/go_back_widget.dart';
import '../../../gen/colors.gen.dart';
import '../../../routes/routes.dart';

class InformationGatherScreen extends StatelessWidget {
  const InformationGatherScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldBackgroundColor,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(UIHelper.kDefaulutPadding()),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ///Section : Custom Back Button
              CustomBackButton(),
              UIHelper.verticalSpace(26.h),

              ///Section : -----///Onboarding -> Blood Group Selection///----------------
              // SelectBloodGroupWidget(),

              ///Section : -----///Onboarding -> Gender Selection///----------
              // SelectGenderWidget(),

              ///Section : -----///Onboarding -> Age Selection///----------
              // SelectAgeScreenWidgt(),

              ///Section : -----///Onboarding -> Weight Selection///----------
              SelectWeightScreen(),
            ],
          ),
        ),
      ),
      // bottomNavigationBar: Container(
      //   padding: EdgeInsets.only(
      //     left: UIHelper.kDefaulutPadding(),
      //     right: UIHelper.kDefaulutPadding(),
      //     bottom: 40.h,
      //   ),
      //   child: CustomElevatedButton(
      //     onTap: () {
      //       log("Button Taped : On Select Your Age Screen");
      //       Get.toNamed(Routes.selectWeightScreen);
      //     },
      //     buttonTitle: "Continue",
      //   ),
      // ),
    );
  }
}
