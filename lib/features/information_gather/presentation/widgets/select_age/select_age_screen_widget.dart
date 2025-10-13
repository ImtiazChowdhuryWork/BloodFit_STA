import 'package:bloodfit/features/information_gather/presentation/widgets/select_age/age_selector_widget.dart';
import 'package:bloodfit/gen/colors.gen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../constants/text_font_style.dart';
import '../../../../../helper/ui_helpers.dart';

class SelectAgeScreenWidgt extends StatelessWidget {
  const SelectAgeScreenWidgt({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "What’s Your Age?",
          style: TextFontStyle.headline22w500cfefefeStylePoppins,
        ),
        UIHelper.verticalSpace(0.3.sh),

        /// Age selector
        AgeSelectorWidget(
          minValue: 1,
          maxValue: 100,
          itemWidth: 60,

          height: 80,
          itemSpacing: 26,
          baseFontSize: 24,
          dividerGap: 30,
          textColor: AppColors.cFFFFFF,
        ),
      ],
    );
  }
}
