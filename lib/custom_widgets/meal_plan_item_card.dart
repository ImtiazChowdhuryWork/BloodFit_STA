import 'dart:convert';

import 'package:bloodfit/custom_widgets/meal_network_image_showing_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

import '../constants/text_font_style.dart';
import '../gen/assets.gen.dart';
import '../gen/colors.gen.dart';
import '../helper/ui_helpers.dart';
import 'custom_elevated_button.dart';

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
  final bool isMealEaten;
  final void Function()? onTap;
  final bool isImageLinkBase64;

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
    required this.isMealEaten,
    this.onTap,
    this.isImageLinkBase64 = false,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
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
                          child: isImageLinkBase64
                              ? ClipRRect(
                                  borderRadius: BorderRadius.circular(100.r),
                                  child: Image.memory(
                                    base64Decode(
                                      mealImagePath.contains(',')
                                          ? mealImagePath.split(',').last
                                          : mealImagePath,
                                    ),
                                    width: 140.w,
                                    height: 140.h,
                                    fit: BoxFit.cover,
                                  ),
                                )
                              : CustomNetworkImageWidget(
                                  imageUrl: mealImagePath,
                                  mealType: mealType,
                                  width: 140.w,
                                  height: 140.h,
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
                        SizedBox(
                          height: 40.h,
                          child: Text(
                            mealTitle,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style:
                                TextFontStyle.headline14w500cFFFFFFStylePoppins,
                          ),
                        ),
                        UIHelper.verticalSpace(6.h),

                        /// Kcal Info
                        Row(
                          children: [
                            SvgPicture.asset(Assets.icons.fireRed),
                            UIHelper.horizontalSpace(8.w),
                            Text(
                              "$kcalValue Kcal",
                              style: TextFontStyle
                                  .headline12w500cfefefeStylePoppins,
                            ),
                          ],
                        ),
                        UIHelper.verticalSpace(8.h),

                        /// Section : -----------///Left Button////------------
                        /// Section : ----------///Right Button///-------------
                        isMealEaten
                            ? CustomElevatedButton(
                                onTap: null,
                                // buttonWidth: 100.w,
                                isDisabled: true,
                                buttonHeight: 30.h,
                                buttonColor: AppColors.cc6c6c6,
                                buttonTitle: 'Meal Consumed',
                                textStyle: TextFontStyle
                                    .headline12w500c000000StylePoppins,
                              )
                            : Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Expanded(
                                    child: CustomElevatedButton(
                                      onTap: leftButtonOnTap,
                                      buttonHeight: 34.h,
                                      buttonColor: leftButtonColor,
                                      isButtonBorderUsed:
                                          isLeftButtonBorderUsed,
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
                                      buttonColor:
                                          AppColors.scaffoldBackgroundColor,
                                      buttonBorderColor:
                                          rightButtonBorderColor ??
                                          AppColors.cfefefe,
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
      ),
    );
  }
}
