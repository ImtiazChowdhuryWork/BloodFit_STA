import 'dart:developer';

import 'package:bloodfit/constants/app_list.dart';
import 'package:bloodfit/custom_widgets/card_tile_option_widget.dart';
import 'package:bloodfit/features/settings/data/controller/delete_account_controller.dart';
import 'package:bloodfit/gen/colors.gen.dart';
import 'package:bloodfit/helper/ui_helpers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../constants/app_enums.dart';
import '../../../constants/text_font_style.dart';
import '../../../custom_widgets/go_back_widget.dart';
import 'widgets/show_delete_bottom_sheet.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    DeleteAccountController controller = Get.find<DeleteAccountController>();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.postDeleteAccountApi();
    });
    return Scaffold(
      backgroundColor: AppColors.scaffoldBackgroundColor,

      /// -------------------- App Bar Section --------------------
      appBar: AppBar(
        backgroundColor: AppColors.scaffoldBackgroundColor,
        centerTitle: true,
        automaticallyImplyLeading: false,
        leading: const CustomBackButton(),
        title: Text(
          "Settings",
          style: TextFontStyle.headline24w700cFFFFFFStylePoppins,
        ),
      ),

      /// -------------------- Body Section --------------------
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(UIHelper.kDefaulutPadding()),

          /// -------------------- Settings List Section --------------------
          child: ListView.separated(
            itemCount: AppList.settingsScreenList.length,
            separatorBuilder: (context, index) => UIHelper.verticalSpace(16.h),
            itemBuilder: (context, index) {
              final data = AppList.settingsScreenList[index];

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  /// ----------- Section Title (if available) -----------
                  data.sectionTitle?.isNotEmpty == true
                      ? Text(
                          data.sectionTitle ?? "",
                          style:
                              TextFontStyle.headline14w500c999999StylePoppins,
                        )
                      : const SizedBox.shrink(),

                  /// ----------- Spacing below section title -----------
                  data.sectionTitle?.isNotEmpty == true
                      ? UIHelper.verticalSpace(8.h)
                      : const SizedBox.shrink(),

                  /// ----------- Settings Option Card -----------
                  CardTileOptionWidget(
                    onTap: () {
                      if (data.titleEnum != SettingsOptionTitle.deleteAccount) {
                        Get.toNamed(data.route);
                      } else if (data.titleEnum ==
                          SettingsOptionTitle.deleteAccount) {
                        showDeleteBottomSheet(
                          isLoading: controller.isLoading,
                          onDelete: () async {
                            log("Button -> Delete Button Taped!");
                            await controller.postDeleteAccountApi();
                          },
                          onCancel: () {
                            log("Button -> Cancel Button Taped!");
                            Get.back();
                          },
                        );
                      } else {
                        return;
                      }
                    },

                    /// Apply a red bordered card style only for "Delete Account"
                    cardColor:
                        data.titleEnum == SettingsOptionTitle.deleteAccount
                        ? AppColors.c000000
                        : null,
                    isBorderUsed:
                        data.titleEnum == SettingsOptionTitle.deleteAccount
                        ? true
                        : false,
                    borderColor:
                        data.titleEnum == SettingsOptionTitle.deleteAccount
                        ? AppColors.cb20000
                        : null,

                    /// Card Content
                    imagePath: data.imagePath,
                    title: data.title,
                  ),

                  /// ----------- Conditional spacing for specific indices -----------
                  (index == 0 || index == 2 || index == 4)
                      ? UIHelper.verticalSpace(8.h)
                      : const SizedBox.shrink(),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
