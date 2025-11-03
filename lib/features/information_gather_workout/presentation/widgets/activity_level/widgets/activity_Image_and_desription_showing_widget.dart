import 'package:bloodfit/constants/text_font_style.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../../helper/ui_helpers.dart';

class ActivityImageAndDescriptionShowingWidget extends StatelessWidget {
  const ActivityImageAndDescriptionShowingWidget({
    super.key,
    // required this.list,
    required this.selectedIndex,
    required this.imagePath,
    required this.subTitle,
  });

  // final List<ActivityLevelModel> list;
  final String imagePath;
  final int selectedIndex;
  final String subTitle;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Image.asset(
          imagePath,
          fit: BoxFit.contain,
          height: 0.2.sh,
          width: 0.7.sw,
        ),
        UIHelper.verticalSpace(32.h),
        Text(
          subTitle,
          textAlign: TextAlign.center,
          style: TextFontStyle.headline14w400cc6c6c6StylePoppins,
        ),
      ],
    );
  }
}
