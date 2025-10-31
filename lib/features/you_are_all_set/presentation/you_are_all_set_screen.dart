import 'dart:developer';

import 'package:bloodfit/constants/text_font_style.dart';
import 'package:bloodfit/custom_widgets/custom_elevated_button.dart';
import 'package:bloodfit/custom_widgets/go_back_widget.dart';
import 'package:bloodfit/gen/colors.gen.dart';
import 'package:bloodfit/helper/ui_helpers.dart';
import 'package:bloodfit/routes/routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class YouAreAllSetScreen extends StatelessWidget {
  const YouAreAllSetScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldBackgroundColor,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(UIHelper.kDefaulutPadding()),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              ///Section : ------------///CustomBackButton///----------
              Align(alignment: Alignment.centerLeft, child: CustomBackButton()),
              UIHelper.verticalSpace(66.h),

              ///Section : ----------///Text-> you are all set///---------
              Text(
                "You Are All Set",
                style: TextFontStyle.headline22w500cfefefeStylePoppins,
              ),
              UIHelper.verticalSpace(22.h),

              ///Section : ----------///Text-> you are all set///---------
              Text(
                "Your Personalized Plans Are Ready",
                style: TextFontStyle.headline18w500cfefefeStylePoppins,
              ),
              UIHelper.verticalSpace(200.h),

              ///Section : ---------///Show Circle of All Set///---------
              Align(
                alignment: Alignment.center,
                child: Container(
                  width: 88.w,
                  height: 88.h,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppColors.cb20000,
                  ),
                  child: Icon(Icons.done, color: AppColors.c000000),
                ),
              ),
              Spacer(),

              CustomElevatedButton(
                onTap: () {
                  log("Button -> Continue Taped");
                  Get.toNamed(Routes.navigationScreen);
                },
                buttonTitle: "Continue",
              ),
              UIHelper.verticalSpace(UIHelper.kDefaulutPadding()),
            ],
          ),
        ),
      ),
    );
  }
}
