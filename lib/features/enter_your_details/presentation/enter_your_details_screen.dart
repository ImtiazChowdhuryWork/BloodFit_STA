import 'package:bloodfit/custom_widgets/app_logo_widget.dart';
import 'package:bloodfit/gen/assets.gen.dart';
import 'package:bloodfit/gen/colors.gen.dart';
import 'package:bloodfit/helper/ui_helpers.dart';
import 'package:bloodfit/routes/routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

class EnterYourDetailsScreen extends StatelessWidget {
  const EnterYourDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldBackgroundColor,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: UIHelper.kDefaulutPadding(),
          ),
          child: Column(
            children: [
              ///Section : ---------------------///AppLogo///-----------
              ///Section : ---------------------///Notification///-----------
              ///Section : ---------------------///Profile///-----------
              Row(
                children: [
                  ///Section : ---------------------///AppLogo///-----------
                  AppLogoWidget(),
                  Spacer(),

                  ///Section : ---------------------///Notification///-----------
                  InkWell(
                    onTap: () {
                      Get.toNamed(Routes.notificationScreen);
                    },
                    child: SvgPicture.asset(Assets.icons.bellIcon),
                  ),
                  UIHelper.horizontalSpace(15.w),

                  ///Section : ---------------------///Profile///-----------
                  InkWell(
                    onTap: () {
                      Get.toNamed(Routes.myProfileScreen);
                    },
                    child: Container(
                      width: 48.w,
                      height: 48.h,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(color: AppColors.cFFFFFF),
                        image: DecorationImage(
                          fit: BoxFit.cover,
                          image: AssetImage(Assets.images.userImage.path),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
