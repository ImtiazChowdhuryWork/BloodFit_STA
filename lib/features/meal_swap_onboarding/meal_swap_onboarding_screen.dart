import 'dart:developer';

import 'package:bloodfit/constants/app_text.dart';
import 'package:bloodfit/constants/text_font_style.dart';
import 'package:bloodfit/custom_widgets/food_item_data_helper_widget.dart';
import 'package:bloodfit/gen/assets.gen.dart';
import 'package:bloodfit/gen/colors.gen.dart';
import 'package:bloodfit/helper/ui_helpers.dart';
import 'package:bloodfit/routes/routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../custom_widgets/custom_elevated_button.dart';

class MealSwapOnboardingScreen extends StatelessWidget {
  const MealSwapOnboardingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldBackgroundColor,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(UIHelper.kDefaulutPadding()),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              UIHelper.verticalSpace(0.1.sh),

              ///Section : --------------///Text -> Meal Swap Onboarding!///---------
              Text(
                "Meal Swap Onboarding!",
                style: TextFontStyle.headline22w500cfefefeStylePoppins,
              ),
              UIHelper.verticalSpace(34.h),

              ///Section : -------------///Image -> Food Item///---------------
              Image.asset(
                height: 250.h,
                width: 250.w,
                fit: BoxFit.contain,
                Assets.images.foodLudusImage.path,
              ),
              UIHelper.verticalSpace(30.h),

              ///Section : -------------///Food Item Name///--------------
              Text(
                "Avocado Toast & Poached Eggs",
                style: TextFontStyle.headline18w500cfefefeStylePoppins,
              ),
              UIHelper.verticalSpace(8.h),

              ///Section : -----------///Meal Type -> Breakfast,Lunc,Dinner///------------
              Row(
                mainAxisSize: MainAxisSize.min, // ✅ Row doesn’t stretch
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  /// Food Total Kcal & Serving
                  FoodItemDataHelperWidget(
                    iconPath: Assets.icons.mealIcon,
                    iconColor: AppColors.cfefefe,
                    title: "Breakfast",
                    value: 302,
                    isValueVisible: false,
                  ),
                  UIHelper.horizontalSpace(20.w),

                  /// Divider
                  Container(
                    width: 2.sp,
                    height: 20.h,
                    color: AppColors.c282828,
                  ),
                  UIHelper.horizontalSpace(20.w),

                  FoodItemDataHelperWidget(
                    title: "Kcal",
                    iconPath: Assets.icons.fireRed,
                    value: 302,
                  ),
                ],
              ),
              UIHelper.verticalSpace(8.h),

              ///Section : ----------///Text -> Food Details///---------------
              Text(
                foodDetailsText,
                textAlign: TextAlign.center,
                style: TextFontStyle.headline14w500c999999StylePoppins,
              ),
              UIHelper.verticalSpace(24.w),

              ///Section : -------------///Button -> Continue///-------------
              CustomElevatedButton(
                onTap: () {
                  log("Button Taped -> Confirm Mealplan");
                  Get.toNamed(Routes.navigationScreen);
                },
                buttonWidth: 1.sw,
                buttonHeight: 52.h,
                borderRadius: 24.r,
                buttonTitle: "Confirm Mealplan",
              ),
              UIHelper.verticalSpace(32.h),
            ],
          ),
        ),
      ),
    );
  }
}
