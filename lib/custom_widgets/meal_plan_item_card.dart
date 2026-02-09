import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

import '../constants/text_font_style.dart';
import 'custom_elevated_button.dart';
import '../gen/assets.gen.dart';
import '../gen/colors.gen.dart';
import '../helper/ui_helpers.dart';

class MealPlanItemCard extends StatelessWidget {
  final String mealImagePath;
  final String mealTitle;
  final String mealType;
  final int kcalValue;
  final bool showSectionTitle;
  final String leftButtonTitle;
  final Color? leftButtonColor;
  final void Function()? leftButtonOnTap;
  final String rightButtonTitle;
  final double? leftButtonBorderWidth;
  final void Function()? rightButtonOnTap;
  final Color? rightButtonBorderColor;
  final Color? leftButtonBorderColor;
  final bool isLeftButtonBorderUsed;
  const MealPlanItemCard({
    super.key,
    required this.mealImagePath,
    required this.mealTitle,
    required this.kcalValue,
    this.leftButtonOnTap,
    this.rightButtonOnTap,
    required this.mealType,
    this.showSectionTitle = true,
    required this.leftButtonTitle,
    required this.rightButtonTitle,
    this.rightButtonBorderColor,
    this.leftButtonBorderColor,
    this.isLeftButtonBorderUsed = false,
    this.leftButtonColor,
    this.leftButtonBorderWidth,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        showSectionTitle
            ? Text(
                mealType,
                style: TextFontStyle.headline18w500cfefefeStylePoppins,
              )
            : SizedBox.shrink(),
        showSectionTitle ? UIHelper.verticalSpace(12.h) : SizedBox.shrink(),

        /// Meal Container
        Align(
          alignment: Alignment.centerRight,
          child: Container(
            width: 0.8.sw,
            height: 130.h,
            padding: EdgeInsets.all(10.sp),
            decoration: BoxDecoration(
              color: AppColors.c262626,
              borderRadius: BorderRadius.circular(16.r),
            ),
            child: Row(
              children: [
                /// Food Image (half outside)
                /// Food Image (half outside)
                SizedBox(
                  width: 100.w, // increase width
                  height: 150.h, // increase height
                  child: Stack(
                    clipBehavior: Clip.none,
                    children: [
                      Positioned(
                        left: -50.w, // half of the image width
                        top: -16.h, // optional vertical adjustment
                        child: CachedNetworkImage(
                          imageUrl: mealImagePath,
                          width: 143.w, // increase image width
                          height: 140.h, // increase image height
                          fit: BoxFit.contain,
                        ),
                      ),
                    ],
                  ),
                ),

                UIHelper.horizontalSpace(14.w),

                /// Meal Info + Buttons
                Expanded(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      /// Meal Name
                      Text(
                        mealTitle,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: TextFontStyle.headline14w500cFFFFFFStylePoppins,
                      ),
                      UIHelper.verticalSpace(6.h),

                      /// Kcal Info
                      Row(
                        children: [
                          SvgPicture.asset(Assets.icons.fireRed),
                          UIHelper.horizontalSpace(8.w),
                          Text(
                            "$kcalValue Kcal",
                            style:
                                TextFontStyle.headline12w500cfefefeStylePoppins,
                          ),
                        ],
                      ),
                      UIHelper.verticalSpace(8.h),

                      /// Section : -----------///Left Button////------------
                      /// Section : ----------///Right Button///-------------
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Expanded(
                            child: CustomElevatedButton(
                              onTap: leftButtonOnTap,
                              // buttonWidth: 100.w,
                              buttonHeight: 34.h,
                              buttonColor: leftButtonColor,
                              isButtonBorderUsed: isLeftButtonBorderUsed,
                              buttonBorderColor: leftButtonBorderColor,
                              buttonBorderWidth: leftButtonBorderWidth,
                              buttonTitle: leftButtonTitle,
                              textStyle: TextFontStyle
                                  .headline12w500cfefefeStylePoppins,
                            ),
                          ),
                          UIHelper.horizontalSpace(8.w),
                          Expanded(
                            child: CustomElevatedButton(
                              onTap: rightButtonOnTap,
                              // buttonWidth: 100.w,
                              buttonHeight: 34.h,
                              buttonTitle: rightButtonTitle,
                              textStyle: TextFontStyle
                                  .headline12w500cfefefeStylePoppins,
                              isButtonBorderUsed: true,
                              buttonColor: AppColors.scaffoldBackgroundColor,
                              buttonBorderColor:
                                  rightButtonBorderColor ?? AppColors.cfefefe,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
