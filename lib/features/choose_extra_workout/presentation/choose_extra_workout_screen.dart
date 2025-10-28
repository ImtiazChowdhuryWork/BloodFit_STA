import 'dart:developer';

import 'package:bloodfit/constants/text_font_style.dart';
import 'package:bloodfit/features/choose_extra_workout/presentation/widgets/extra_workout_done_bottom_sheet.dart';
import 'package:bloodfit/gen/colors.gen.dart';
import 'package:bloodfit/helper/ui_helpers.dart';
import 'package:bloodfit/routes/routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../constants/app_list.dart';
import '../../home/presentation/widgets/app_bar_section_widget.dart';
import '../../../custom_widgets/workout_video_showing_widget.dart';

class ChooseExtraWorkoutScreen extends StatelessWidget {
  const ChooseExtraWorkoutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldBackgroundColor,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(UIHelper.kDefaulutPadding()),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ///Section : ---------------------///AppLogo///-----------
              ///Section : ---------------------///Notification///-----------
              ///Section : ---------------------///Profile///-----------
              AppBarSectionWidget(),
              UIHelper.verticalSpace(20.h),

              ///Section : --------///Choose Extra Workouts///----------
              Text(
                "Choose Extra Workouts",
                style: TextFontStyle.headline20w500cfefefeStylePoppins,
              ),
              UIHelper.verticalSpace(20.h),

              ///Seection :
              Text(
                "Warmup",
                style: TextFontStyle.headline18w500cfefefeStylePoppins,
              ),
              UIHelper.verticalSpace(16.h),

              ///Section :
              ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: AppList.videoDetailsList.length,
                separatorBuilder: (context, index) =>
                    UIHelper.verticalSpace(20.h),
                itemBuilder: (context, index) {
                  var data = AppList.videoDetailsList[index];
                  return WorkoutVideoShowingWidget(
                    onPlayVideoPressed: () {
                      log("Button Taped : Play Video!");
                      showExtraWorkoutDoneBottomSheet();
                    },
                    onChanged: (value) {},
                    isChecked: index % 2 == 0 ? true : false,
                    imagePath: data.imagePath,
                    videoTitle: data.videoTitle,
                    duration: "03",
                    totalSets: 3,
                    totalCal: 500,
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
