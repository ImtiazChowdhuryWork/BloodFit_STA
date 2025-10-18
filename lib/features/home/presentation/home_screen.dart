import 'package:bloodfit/constants/text_font_style.dart';
import 'package:bloodfit/features/home/presentation/widgets/app_bar_section_widget.dart';
import 'package:bloodfit/features/home/presentation/widgets/number_section_widget.dart';
import 'package:bloodfit/features/home/presentation/widgets/test.dart';
import 'package:bloodfit/gen/assets.gen.dart';
import 'package:bloodfit/gen/colors.gen.dart';
import 'package:bloodfit/helper/ui_helpers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../custom_widgets/custom_calender_widget.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldBackgroundColor,
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(UIHelper.kDefaulutPadding()),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ///Section : ---------------------///AppLogo///-----------
              ///Section : ---------------------///Notification///-----------
              ///Section : ---------------------///Profile///-----------
              AppBarSectionWidget(),
              UIHelper.verticalSpace(20.h),

              ///Section : -------///Number Section///----------
              NumberSectionWidget(numberValue: 4),
              UIHelper.verticalSpace(14.h),

              ///Section : -----------///Calender Widget///--------------
              CustomCalenderWidget(),
              UIHelper.verticalSpace(20.h),

              // TestCircleProgress(),
              CircularProgressContainer(
                size: 44,
                progress: 0.6, // 60% progress
                progressColor: Colors.green,
                backgroundColor: Colors.grey.shade300,
                child: Text(
                  "60%",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
