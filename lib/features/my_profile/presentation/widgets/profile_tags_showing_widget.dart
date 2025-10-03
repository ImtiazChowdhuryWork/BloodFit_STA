import 'package:bloodfit/features/my_profile/presentation/widgets/profile_tag_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../gen/colors.gen.dart';
import '../../../../helper/ui_helpers.dart';

class ProfileTagShowingWidget extends StatelessWidget {
  final String dietType;
  final String weightGainOrLooseTarget;
  const ProfileTagShowingWidget({
    super.key,
    required this.dietType,
    required this.weightGainOrLooseTarget,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        ///Section : Diet Type
        ProfileTagWidget(title: dietType),
        UIHelper.horizontalSpace(8.w),

        ///Section : Divider
        Container(width: 1.w, height: 17.h, color: AppColors.c999999),
        UIHelper.horizontalSpace(8.w),

        ///Section : Weight Gain/Loose
        ProfileTagWidget(title: weightGainOrLooseTarget),
      ],
    );
  }
}
