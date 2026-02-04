import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../constants/text_font_style.dart';
import '../../../../custom_widgets/custom_elevated_button.dart';
import '../../../../custom_widgets/go_back_widget.dart';
import '../../../../gen/colors.gen.dart';
import '../../../../helper/ui_helpers.dart';

class CurrentWeightUpdateSuccessAlertBox extends StatelessWidget {
  const CurrentWeightUpdateSuccessAlertBox({super.key});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: Container(
        width: 0.6.sw,
        height: 0.2.sh,
        decoration: BoxDecoration(
          color: AppColors.scaffoldBackgroundColor,
          borderRadius: BorderRadius.circular(12.r),
        ),
        alignment: Alignment.center,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            /// -------->>> Section : Alert Box Texts
            Text(
              'SUCCESS',
              textAlign: TextAlign.center,
              style: TextFontStyle.headline24w700cFFFFFFStylePoppins,
            ),
            UIHelper.verticalSpace(10.h),
            Text(
              "Congratulations! You have updated your weigght Successfully",
              textAlign: TextAlign.center,
              style: TextFontStyle.headline18w500cfefefeStylePoppins,
            ),
          ],
        ),
      ),
      actions: [
        ///------->>> Section : Close The Alert Box By Taping The Button!
        CustomElevatedButton(
          buttonTitle: 'Close',
          onTap: () {
            CustomBackButton();
          },
        ),
      ],
    );
  }
}
