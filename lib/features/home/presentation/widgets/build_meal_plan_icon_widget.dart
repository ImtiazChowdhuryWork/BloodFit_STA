import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

import '../../../../constants/text_font_style.dart';
import '../../../../custom_widgets/custom_elevated_button.dart';
import '../../../../gen/colors.gen.dart';
import '../../../../helper/ui_helpers.dart';

class BuildMealPlanWidget extends StatelessWidget {
  final void Function()? onTap;
  final String title;
  final String subTitle;
  final double? borderWidth;
  final String imageIconPath;
  final Color? buttonColor;
  final bool isBorderUsed;
  final Color? borderColor;
  final double positionTop;
  final double positionRight;
  final String buttonTitle;
  final bool showSectionTitle;
  final String? sectionTitle;
  final bool isShowButton;
  const BuildMealPlanWidget({
    super.key,
    this.onTap,
    required this.title,
    required this.subTitle,
    required this.imageIconPath,
    this.buttonColor,
    this.isBorderUsed = false,

    this.borderColor,
    required this.positionTop,
    required this.positionRight,
    required this.buttonTitle,
    this.borderWidth,
    this.showSectionTitle = false,
    this.isShowButton = true,
    this.sectionTitle,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ///Section : -------------///Text -> Choose From Our Suggested Meals///---------------
        showSectionTitle
            ? Text(
                sectionTitle ?? "No Section Title Is Available",
                style: TextFontStyle.headline20w500cfefefeStylePoppins,
              )
            : SizedBox.shrink(),

        showSectionTitle ? UIHelper.verticalSpace(16.h) : SizedBox.shrink(),

        Container(
          width: 1.sw,
          padding: EdgeInsets.all(22.sp),
          decoration: BoxDecoration(
            color: AppColors.c262626,
            borderRadius: BorderRadius.circular(8.r),
          ),
          child: Stack(
            clipBehavior: Clip.none, // allows the icon to overflow
            children: [
              /// Inner bordered container
              Container(
                width: 1.sw,
                padding: EdgeInsets.all(10.sp),
                decoration: BoxDecoration(
                  color: AppColors.c111111,
                  border: Border.all(color: AppColors.cfefefe),
                  borderRadius: BorderRadius.circular(8.r),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextFontStyle.headline16w500cfefefeStylePoppins,
                    ),
                    UIHelper.verticalSpace(8.h),
                    Text(
                      subTitle,
                      style: TextFontStyle.headline14w400c999999StylePoppins,
                    ),
                    UIHelper.verticalSpace(32.h),

                    /// Section: Button -> Get Started
                    
                    isShowButton?
                    CustomElevatedButton(
                      onTap: onTap,
                      buttonHeight: 40.h,
                      borderRadius: 24.r,
                      buttonBorderWidth: borderWidth,
                      isButtonBorderUsed: isBorderUsed,
                      buttonBorderColor: borderColor,
                      buttonColor: buttonColor,
                      buttonTitle: buttonTitle,
                    ) : SizedBox.shrink(),
                    UIHelper.verticalSpace(6.h),
                  ],
                ),
              ),

              /// Floating gift icon
              Positioned(
                // top: -36, // moves above the border
                // right: -20,
                top: positionTop,
                right: positionRight,
                child: SvgPicture.asset(imageIconPath),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
