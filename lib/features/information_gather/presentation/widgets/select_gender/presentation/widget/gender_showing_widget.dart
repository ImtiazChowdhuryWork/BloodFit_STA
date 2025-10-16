import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

import '../../../../../../../constants/text_font_style.dart';
import '../../../../../../../gen/assets.gen.dart';
import '../../../../../../../gen/colors.gen.dart';
import '../../../../../../../helper/ui_helpers.dart';

class GenderShowingWidget extends StatelessWidget {
  final String title;
  final String imagePath;
  final void Function()? onTap;
  const GenderShowingWidget({
    super.key,
    required this.title,
    required this.imagePath,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return IntrinsicWidth(
      child: InkWell(
        onTap: onTap,
        child: Container(
          alignment: Alignment.center,
          constraints: const BoxConstraints(),
          padding: EdgeInsets.symmetric(vertical: 40.h, horizontal: 54.w),
          decoration: BoxDecoration(
            color: AppColors.c111111,
            shape: BoxShape.circle,
            border: Border.all(color: AppColors.cfefefe),
          ),

          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              ///Section : Image -> Blood Drop
              SvgPicture.asset(imagePath),
              UIHelper.verticalSpace(8.h),

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
