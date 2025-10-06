import 'package:bloodfit/constants/appList.dart';
import 'package:bloodfit/custom_widgets/card_tile_option_widget.dart';
import 'package:bloodfit/gen/assets.gen.dart';
import 'package:bloodfit/gen/colors.gen.dart';
import 'package:bloodfit/helper/ui_helpers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../constants/app_enums.dart';
import '../../../constants/text_font_style.dart';
import '../../../custom_widgets/go_back_widget.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: AppColors.scaffoldBackgroundColor,
        centerTitle: true,
        automaticallyImplyLeading: false,
        leading: CustomBackButton(),
        title: Text(
          "Settings",
          style: TextFontStyle.headline24w700cFFFFFFStylePoppins,
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(UIHelper.kDefaulutPadding()),
          child: ListView.separated(
            itemCount: AppList.settingsScreenList.length,
            separatorBuilder: (context, index) => UIHelper.verticalSpace(16.h),
            itemBuilder: (context, index) {
              var data = AppList.settingsScreenList[index];
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  data.sectionTitle?.isNotEmpty == true
                      ? Text(
                          data.sectionTitle ?? "",
                          style:
                              TextFontStyle.headline14w500c363636StylePoppins,
                        )
                      : SizedBox.shrink(),

                  data.sectionTitle?.isNotEmpty == true
                      ? UIHelper.verticalSpace(8.h)
                      : SizedBox.shrink(),
                  CardTileOptionWidget(
                    onTap: () {
                      Get.toNamed(data.route);
                    },
                    cardColor:
                        data.titleEnum == SettingsOptionTitle.deleteAccount
                        ? AppColors.c000000
                        : null,
                    imagePath: data.imagePath,
                    title: data.title,
                  ),
                  index == 0 || index == 2 || index == 5
                      ? UIHelper.verticalSpace(8.h)
                      : SizedBox.shrink(),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
