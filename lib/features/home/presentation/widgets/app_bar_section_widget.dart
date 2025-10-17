import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

import '../../../../custom_widgets/app_logo_widget.dart';
import '../../../../gen/assets.gen.dart';
import '../../../../gen/colors.gen.dart';
import '../../../../helper/ui_helpers.dart';
import '../../../../routes/routes.dart';

class AppBarSectionWidget extends StatelessWidget {
  const AppBarSectionWidget({super.key});

  @override
  Widget build(BuildContext context) {
    ///Section : ---------------------///AppLogo///-----------
    ///Section : ---------------------///Notification///-----------
    ///Section : ---------------------///Profile///-----------
    return Row(
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
    );
  }
}
