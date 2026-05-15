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
    return Scaffold(
      backgroundColor: AppColors.scaffoldBackgroundColor,

      appBar: AppBar(
        backgroundColor: AppColors.scaffoldBackgroundColor,
        centerTitle: true,
        automaticallyImplyLeading: false,
        leading: const CustomBackButton(),
        title: Text(
          'settings'.tr,
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
              final data = AppList.settingsScreenList[index];

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  /// Section title header (e.g. "Preferences", "Account Management")
                  data.sectionTitle?.isNotEmpty == true
                      ? Text(
                          data.sectionTitle ?? "",
                          style:
                              TextFontStyle.headline14w500c999999StylePoppins,
                        )
                      : const SizedBox.shrink(),

                  data.sectionTitle?.isNotEmpty == true
                      ? UIHelper.verticalSpace(8.h)
                      : const SizedBox.shrink(),

                  /// Language tile — rendered as an inline toggle, not a nav tile.
                  if (data.titleEnum == SettingsOptionTitle.language)
                    _LanguageToggleTile()
                  else
                    CardTileOptionWidget(
                      onTap: () {
                        if (data.titleEnum !=
                            SettingsOptionTitle.deleteAccount) {
                          Get.toNamed(data.route);
                        } else {
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
                        }
                      },
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
                      imagePath: data.imagePath,
                      title: data.title,
                    ),

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

/// Inline language toggle tile shown in the Preferences section.
/// Switches app locale between English (EN) and Korean (KO).
class _LanguageToggleTile extends StatefulWidget {
  const _LanguageToggleTile();

  @override
  State<_LanguageToggleTile> createState() => _LanguageToggleTileState();
}

class _LanguageToggleTileState extends State<_LanguageToggleTile> {
  bool get _isKorean => Get.locale?.languageCode == 'ko';

  void _toggleLanguage() {
    final newLocale = _isKorean
        ? const Locale('en', 'US')
        : const Locale('ko', 'KR');

    Get.updateLocale(newLocale);

    // setState ensures the toggle visually updates immediately after locale change.
    setState(() {});

    Get.snackbar(
      'language'.tr,
      newLocale.languageCode == 'ko'
          ? 'korean_selected'.tr
          : 'english_selected'.tr,
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: AppColors.c2f772f,
      colorText: AppColors.cFFFFFF,
      duration: const Duration(seconds: 1),
      margin: EdgeInsets.all(10.w),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 1.sw,
      decoration: BoxDecoration(
        color: AppColors.c3c3c3c,
        borderRadius: BorderRadius.circular(8.r),
      ),
      padding: EdgeInsets.all(12.sp),
      child: Row(
        children: [
          Icon(Icons.language, color: AppColors.cFFFFFF, size: 22.sp),
          UIHelper.horizontalSpace(10.w),
          Text(
            'language'.tr,
            style: TextFontStyle.headline14w400cfefefeStylePoppins,
          ),
          Spacer(),
          GestureDetector(
            onTap: _toggleLanguage,
            child: Container(
              width: 80.w,
              height: 32.h,
              decoration: BoxDecoration(
                color: AppColors.c2f772f.withValues(alpha: 0.3),
                borderRadius: BorderRadius.circular(16.r),
                border: Border.all(
                  color: AppColors.cFFFFFF.withValues(alpha: 0.1),
                  width: 1,
                ),
              ),
              child: Stack(
                children: [
                  AnimatedAlign(
                    duration: const Duration(milliseconds: 250),
                    curve: Curves.easeInOut,
                    alignment: _isKorean
                        ? Alignment.centerRight
                        : Alignment.centerLeft,
                    child: Container(
                      width: 36.w,
                      height: 28.h,
                      margin: EdgeInsets.symmetric(horizontal: 2.w),
                      decoration: BoxDecoration(
                        color: AppColors.c2f772f,
                        borderRadius: BorderRadius.circular(14.r),
                        boxShadow: const [
                          BoxShadow(
                            color: Colors.black12,
                            blurRadius: 4,
                            offset: Offset(0, 2),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Center(
                          child: Text(
                            'EN',
                            style: TextStyle(
                              color: !_isKorean
                                  ? AppColors.cFFFFFF
                                  : AppColors.cFFFFFF.withValues(alpha: 0.6),
                              fontWeight: !_isKorean
                                  ? FontWeight.w700
                                  : FontWeight.w500,
                              fontSize: 11.sp,
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        child: Center(
                          child: Text(
                            'KO',
                            style: TextStyle(
                              color: _isKorean
                                  ? AppColors.cFFFFFF
                                  : AppColors.cFFFFFF.withValues(alpha: 0.6),
                              fontWeight: _isKorean
                                  ? FontWeight.w700
                                  : FontWeight.w500,
                              fontSize: 11.sp,
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
        ],
      ),
    );
  }
}
