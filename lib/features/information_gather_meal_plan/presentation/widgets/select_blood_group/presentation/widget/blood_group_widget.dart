import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

import '../../../../../../../constants/text_font_style.dart';
import '../../../../../../../gen/assets.gen.dart';
import '../../../../../../../gen/colors.gen.dart';
import '../../../../../../../helper/ui_helpers.dart';

class BloodGroupWidget extends StatelessWidget {
  final String title;

  final Color bgColor;
  final void Function()? onTap;

  const BloodGroupWidget({
    super.key,
    required this.title,
    this.onTap,

    required this.bgColor,
  });

  @override
  Widget build(BuildContext context) {
    return IntrinsicWidth(
      child: InkWell(
        borderRadius: BorderRadius.circular(16.r),
        onTap: onTap,
        child: Container(
          alignment: Alignment.center,
          constraints: const BoxConstraints(),
          padding: EdgeInsets.symmetric(vertical: 17.h, horizontal: 40.w),
          decoration: BoxDecoration(
            color: bgColor,
            border: Border.all(color: AppColors.cfefefe),
            borderRadius: BorderRadius.circular(16.r),
          ),

          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              ///Section : Image -> Blood Drop
              SvgPicture.asset(Assets.icons.bloodDrop),
              UIHelper.verticalSpace(10.h),

              ///Section : Blood Group
              Text(
                title,
                style: TextFontStyle.headline24w700cFFFFFFStylePoppins,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
