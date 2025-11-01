import 'package:bloodfit/constants/text_font_style.dart';
import 'package:bloodfit/features/onboarding/model/onboarding_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../helper/ui_helpers.dart';

class OnboardingWidget extends StatelessWidget {
  final String title;
  final String subTitle;
  final String imagePath;
  final List<OnboardingModel> myList;
  final int index;

  const OnboardingWidget({
    super.key,
    required this.title,
    required this.subTitle,
    required this.imagePath,
    required this.index,
    required this.myList,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          UIHelper.verticalSpace(104.h),

          /// Section: Title (for non-last pages)
          if (index != myList.length - 1) ...[
            Text(
              title,
              textAlign: TextAlign.center,
              style: TextFontStyle.headline24w700cFFFFFFStylePoppins,
            ),
            UIHelper.verticalSpace(64.h),
          ],

          /// Section: Image
          Image.asset(
            imagePath,
            height: index != myList.length - 1 ? 250.h : 0.4.sh,
            width: index != myList.length - 1 ? 250.w : 1.sw,
            fit: BoxFit.contain,
          ),

          /// Section: Title (for last page - after image)
          if (index == myList.length - 1) ...[
            UIHelper.verticalSpace(16.h),
            Text(
              title,
              textAlign: TextAlign.center,
              style: TextFontStyle.headline24w700cFFFFFFStylePoppins,
            ),
            UIHelper.verticalSpace(10.h),
          ],

          /// Section: SubTitle
          Text(
            subTitle,
            textAlign: TextAlign.center,
            style: TextFontStyle.headline16w500c999999StylePoppins,
          ),
          UIHelper.verticalSpace(index != myList.length - 1 ? 50.h : 60.h),
        ],
      ),
    );
  }
}
