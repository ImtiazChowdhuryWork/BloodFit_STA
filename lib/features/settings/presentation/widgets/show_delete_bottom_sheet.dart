import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../../constants/text_font_style.dart';
import '../../../../custom_widgets/custom_elevated_button.dart';
import '../../../../gen/assets.gen.dart';
import '../../../../gen/colors.gen.dart';
import '../../../../helper/ui_helpers.dart';

void showDeleteBottomSheet({
  required VoidCallback onDelete,
  required VoidCallback onCancel,
  required RxBool isLoading,
}) {
  Get.bottomSheet(
    backgroundColor: AppColors.c111111,
    isDismissible: false,
    enableDrag: false,
    PopScope(
      canPop: true,
      child: Container(
        width: 1.sw,
        alignment: Alignment.center,
        padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 22.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            /// Top Divider
            Container(
              width: 76.w,
              height: 3.h,
              decoration: BoxDecoration(
                color: AppColors.c999999,
                borderRadius: BorderRadius.circular(10.r),
              ),
            ),
            UIHelper.verticalSpace(37.h),

            /// Delete Account Text
            Text(
              "Delete Account",
              style: TextFontStyle.headline18w500cfefefeStylePoppins,
            ),
            UIHelper.verticalSpace(16.h),

            /// Confirmation Text
            Text(
              "Are You Sure You Want To Delete Your Account?",
              style: TextFontStyle.headline12w400cfefefeStylePoppins,
            ),
            UIHelper.verticalSpace(80.h),

            /// Trash Box Image
            Container(
              height: 150.h,
              width: 150.w,
              padding: EdgeInsets.all(40.sp),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: AppColors.cb20000),
              ),
              child: Image.asset(
                height: 100.h,
                width: 100.w,
                fit: BoxFit.cover,
                Assets.images.trashCanImage.path,
              ),
            ),
            Spacer(),

            /// Buttons
            Row(
              children: [
                Expanded(
                  child: Obx(() {
                    return CustomElevatedButton(
                      onTap: onDelete,
                      isLoading: isLoading.value,
                      buttonTitle: "Delete",
                    );
                  }),
                ),
                UIHelper.horizontalSpace(8.w),
                Expanded(
                  child: CustomElevatedButton(
                    onTap: onCancel,
                    buttonTitle: "Cancel",
                    buttonColor: AppColors.c111111,
                    isButtonBorderUsed: true,
                    buttonBorderColor: AppColors.cc6c6c6,
                  ),
                ),
              ],
            ),
            UIHelper.verticalSpace(24.h),
          ],
        ),
      ),
    ),
  );
}
