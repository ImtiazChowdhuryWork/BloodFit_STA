import 'package:bloodfit/constants/text_font_style.dart';
import 'package:bloodfit/features/progress/presentation/widget/infotile_widget.dart';
import 'package:bloodfit/features/progress/presentation/widget/overall_progress_showing_widget.dart';
import 'package:bloodfit/gen/colors.gen.dart';
import 'package:bloodfit/routes/routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../gen/assets.gen.dart';
import '../../../helper/ui_helpers.dart';
import '../../home/presentation/widgets/app_bar_section_widget.dart';

class ProgressScreen extends StatelessWidget {
  const ProgressScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldBackgroundColor,
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: UIHelper.kDefaulutPadding()),
        child: SafeArea(
          child: Column(
            children: [
              ///Section : ---------------------///AppLogo///-----------
              ///Section : ---------------------///Notification///-----------
              ///Section : ---------------------///Profile///-----------
              Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: UIHelper.kDefaulutPadding(),
                ),
                child: AppBarSectionWidget(),
              ),
              UIHelper.verticalSpace(20.h),

              OverAllProgressShowingWidget(
                overAllProgress: 0.7,
                inforTypeOne: 'Mealplan',
                infoTypeOneProgress: 0.7,
                infoTypeTwo: 'Workout',
                infoTypeTwoProgress: 0.4,
              ),

              InkWell(
                onTap: () {
                  Get.toNamed(Routes.weightHistoryScreen);
                },
                child: Container(
                  width: 1.sw,
                  height: 0.2.sh,
                  decoration: BoxDecoration(
                    color: AppColors.cb20000,
                    borderRadius: BorderRadius.circular(10.r),
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    "Weight History",
                    style: TextFontStyle.headline24w700cFFFFFFStylePoppins,
                  ),
                ),
              ),

              //               Card(
              //   child: Image.network('https://plus.unsplash.com/premium_photo-1689568126014-06fea9d5d341?q=80&w=1170&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
              //     height: 200,
              //     width: 200,
              //     fit: BoxFit.cover,
              //   ),
              // ),
            ],
          ),
        ),
      ),
    );
  }
}
