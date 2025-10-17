import 'package:bloodfit/constants/text_font_style.dart';
import 'package:bloodfit/features/onboarding/model/onboarding_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../custom_widgets/custom_elevated_button.dart';
import '../../../../helper/ui_helpers.dart';

class OnboardingWidget extends StatelessWidget {
  final String title;
  final String subTitle;
  final String imagePath;
  final List<OnboardingModel> myList;
  final int index;
  final void Function()? onTap;
  const OnboardingWidget({
    super.key,
    required this.title,
    required this.subTitle,
    required this.imagePath,
    this.onTap,
    required this.index,
    required this.myList,
  });

  @override
  Widget build(BuildContext context) {
    return index != myList.length - 1
        ? SingleChildScrollView(
            child: Column(
              children: [
                UIHelper.verticalSpace(104.h),

                ///Section : ---------------///Title///---------------
                Text(
                  title,
                  textAlign: TextAlign.center,
                  style: TextFontStyle.headline24w700cFFFFFFStylePoppins,
                ),
                UIHelper.verticalSpace(64.h),

                ///Section : ---------------///Image///---------------
                Image.asset(
                  imagePath,
                  height: 250.h,
                  width: 250.w,
                  fit: BoxFit.contain,
                ),
                UIHelper.verticalSpace(64.h),

                ///Section : ---------------///SubTitle///---------------
                Text(
                  subTitle,
                  textAlign: TextAlign.center,
                  style: TextFontStyle.headline16w500c999999StylePoppins,
                ),
                UIHelper.verticalSpace(50.h),

                ///Section : -------///PageIndicator///---------------------
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: myList.asMap().entries.map((data) {
                    var indicatorIndex = data.key;
                    return Container(
                      width: 10.w,
                      height: 10.h,
                      margin: EdgeInsets.only(right: 10.w),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: indicatorIndex == index
                            ? Colors.red
                            : Colors.white,
                      ),
                    );
                  }).toList(),
                ),
                UIHelper.verticalSpace(50.h),

                ///Section : ---------------///ElevatedButton///---------------
                CustomElevatedButton(
                  onTap: onTap,
                  buttonTitle: index <= myList.length - 2 ? "Next" : "Finish",
                ),
              ],
            ),
          )
        : SingleChildScrollView(
            child: Column(
              children: [
                UIHelper.verticalSpace(104.h),

                ///Section : ---------------///Image///---------------
                Image.asset(
                  imagePath,
                  height: 0.4.sh,
                  width: 1.sw,
                  fit: BoxFit.contain,
                ),
                // UIHelper.verticalSpace(16.h),

                ///Section : ---------------///Title///---------------
                Text(
                  title,
                  textAlign: TextAlign.center,
                  style: TextFontStyle.headline24w700cFFFFFFStylePoppins,
                ),
                UIHelper.verticalSpace(10.h),

                ///Section : ---------------///SubTitle///---------------
                Text(
                  subTitle,
                  textAlign: TextAlign.center,
                  style: TextFontStyle.headline16w500c999999StylePoppins,
                ),
                UIHelper.verticalSpace(60.h),

                ///Section : -------///PageIndicator///---------------------
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: myList.asMap().entries.map((data) {
                    var indicatorIndex = data.key;
                    return Container(
                      width: 10.w,
                      height: 10.h,
                      margin: EdgeInsets.only(right: 10.w),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: indicatorIndex == index
                            ? Colors.red
                            : Colors.white,
                      ),
                    );
                  }).toList(),
                ),
                UIHelper.verticalSpace(40.h),

                ///Section : ---------------///ElevatedButton///---------------
                CustomElevatedButton(
                  onTap: onTap,
                  buttonTitle: index <= myList.length - 2 ? "Next" : "Finish",
                ),
                UIHelper.verticalSpace(20.h),
              ],
            ),
          );
  }
}
