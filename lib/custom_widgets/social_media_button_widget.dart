import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

import '../constants/text_font_style.dart';
import '../gen/assets.gen.dart';
import '../helper/ui_helpers.dart';

class SocialMediaButtonWidget extends StatelessWidget {
  final String title;
  final void Function()? faceBookOnTap;
  final void Function()? googleOnTap;
  const SocialMediaButtonWidget({
    super.key,
    required this.title,
    this.faceBookOnTap,
    this.googleOnTap,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ///Section : -----------------///Text -> or login with social media///----------------
        Row(
          children: [
            Expanded(child: Divider()),
            UIHelper.horizontalSpace(10.w),

            Text(title, style: TextFontStyle.headline14w400cd7d7d7StylePoppins),
            UIHelper.horizontalSpace(10.w),
            Expanded(child: Divider()),
          ],
        ),
        UIHelper.verticalSpace(16.h),

        ///Section : -----------------///Social Media Button -> Facebook//----------------
        ///Section : -----------------///Social Media Button -> Google//----------------
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            InkWell(
              onTap: faceBookOnTap,
              child: SvgPicture.asset(Assets.icons.facebookIcon),
            ),
            UIHelper.horizontalSpace(24.w),
            InkWell(
              onTap: googleOnTap,
              child: SvgPicture.asset(Assets.icons.googleIcon),
            ),
          ],
        ),
      ],
    );
  }
}
