import 'dart:developer';

import 'package:bloodfit/constants/text_font_style.dart';
import 'package:bloodfit/custom_widgets/custom_elevated_button.dart';
import 'package:bloodfit/features/subscription/widgets/active_package_header.dart';
import 'package:bloodfit/features/subscription/widgets/in_active_package_header.dart';
import 'package:bloodfit/gen/assets.gen.dart';
import 'package:bloodfit/gen/colors.gen.dart';
import 'package:bloodfit/helper/ui_helpers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

class SubscriptionPackageShowingWidget extends StatelessWidget {
  final double packagePrice;
  final List<String> packageOffersList;
  final String packageType;
  final bool isPackageActive;
  final String? discountOffer;
  final String? packageDuration;
  final void Function()? onTap;
  final bool isDiscountOfferAvailable;
  const SubscriptionPackageShowingWidget({
    super.key,
    required this.packagePrice,
    required this.packageOffersList,
    required this.packageType,
    required this.isPackageActive,
    this.onTap,
    this.discountOffer,
    this.isDiscountOfferAvailable = true,
    this.packageDuration,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        width: 1.sw,
        padding: EdgeInsets.all(20.sp),
        decoration: BoxDecoration(
          color: AppColors.c111111,
          border: Border.all(color: AppColors.c999999),
          borderRadius: BorderRadius.circular(8.r),
        ),

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            ///Section : --------------///Package Title///----------
            ///Section : ------------///Package Price///-----------
            isPackageActive == true
                ? ActivePackageHeader(
                    packagePrice: packagePrice,
                    packageType: packageType,
                    packageDuration: packageDuration,
                  )
                : InActivePackageHeader(
                    packagePrice: packagePrice,
                    packageType: packageType,
                  ),
            UIHelper.verticalSpace(24.h),

            ///Section : ------------///Package Offers///-----------
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: packageOffersList.length,
              separatorBuilder: (context, index) =>
                  UIHelper.verticalSpace(16.h),
              itemBuilder: (context, index) {
                var data = packageOffersList[index];
                return Row(
                  children: [
                    Icon(Icons.done, color: AppColors.cfefefe),
                    UIHelper.horizontalSpace(8.w),
                    Expanded(
                      child: Text(
                        data,
                        style: TextFontStyle.headline16w400cc6c6c6StylePoppins,
                      ),
                    ),
                  ],
                );
              },
            ),
            UIHelper.verticalSpace(24.h),

            ///Section : ------------///Discount Offers///-----------
            isDiscountOfferAvailable
                ? Row(
                    children: [
                      SvgPicture.asset(Assets.icons.fireIcon),

                      UIHelper.horizontalSpace(6.w),
                      Text(
                        discountOffer ?? "",
                        style: TextFontStyle.headline16w500cfefefeStylePoppins,
                      ),
                    ],
                  )
                : SizedBox.shrink(),

            isDiscountOfferAvailable
                ? UIHelper.verticalSpace(24.h)
                : SizedBox.shrink(),

            isPackageActive
                ? CustomElevatedButton(
                    onTap: () {
                      log("Button -> Button Taped -> Cancel This Package!");
                    },
                    buttonTitle: "Cancel This Plan",
                    buttonColor: AppColors.c111111,
                    isButtonBorderUsed: true,
                    borderRadius: 24.r,
                  )
                : SizedBox.shrink(),
          ],
        ),
      ),
    );
  }
}
