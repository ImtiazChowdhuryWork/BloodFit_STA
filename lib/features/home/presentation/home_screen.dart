import 'package:bloodfit/constants/text_font_style.dart';
import 'package:bloodfit/features/home/presentation/widgets/app_bar_section_widget.dart';
import 'package:bloodfit/gen/colors.gen.dart';
import 'package:bloodfit/helper/ui_helpers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

import '../../../custom_widgets/app_logo_widget.dart';
import '../../../gen/assets.gen.dart';
import '../../../routes/routes.dart';

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
            children: [
              ///Section : ---------------------///AppLogo///-----------
              ///Section : ---------------------///Notification///-----------
              ///Section : ---------------------///Profile///-----------
              AppBarSectionWidget(),
              UIHelper.verticalSpace(20.h),
            ],
          ),
        ),
      ),
    );
  }
}
