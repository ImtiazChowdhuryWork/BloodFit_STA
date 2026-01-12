import 'package:bloodfit/gen/assets.gen.dart';
import 'package:bloodfit/gen/colors.gen.dart';
import 'package:bloodfit/helper/ui_helpers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../custom_widgets/current_weight_update_widget.dart';
import '../../home/presentation/widgets/app_bar_section_widget.dart';

class WeightHistoryScreen extends StatelessWidget {
  const WeightHistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldBackgroundColor,
      body: SingleChildScrollView(
        padding: EdgeInsets.all(UIHelper.kDefaulutPadding()),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ///Section : ---------------------///AppLogo///-----------
            ///Section : ---------------------///Notification///-----------
            ///Section : ---------------------///Profile///-----------
            AppBarSectionWidget(),
            UIHelper.verticalSpace(20.h),

            ///Section : ----------------///Text -> update your current weight///------------
            ///Section : --------------///Weight Drop Down///----------
            CurrentWeightUpdateWidget(),
            UIHelper.verticalSpace(24.h),

            Image.asset(Assets.images.timelineImage.path),
            UIHelper.spacerFromBottomNav,
          ],
        ),
      ),
    );
  }
}
