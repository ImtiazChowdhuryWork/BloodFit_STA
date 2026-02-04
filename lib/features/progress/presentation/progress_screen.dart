import 'package:bloodfit/constants/text_font_style.dart';
import 'package:bloodfit/gen/colors.gen.dart';
import 'package:bloodfit/routes/routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../helper/ui_helpers.dart';
import '../../home/presentation/widgets/app_bar_section_widget.dart';

class ProgressScreen extends StatelessWidget {
  const ProgressScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldBackgroundColor,
      body: SingleChildScrollView(
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
            ],
          ),
        ),
      ),
    );
  }
}
