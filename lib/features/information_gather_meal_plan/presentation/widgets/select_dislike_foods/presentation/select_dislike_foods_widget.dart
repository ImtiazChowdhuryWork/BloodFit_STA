import 'dart:developer';
import 'package:bloodfit/controllers/ig_food_dislikes_screen_controller.dart';
import 'package:bloodfit/features/information_gather_meal_plan/presentation/widgets/select_dislike_foods/presentation/widgets/diagonial_line_painer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

import '../../../../../../constants/app_list.dart';
import '../../../../../../constants/text_font_style.dart';
import '../../../../../../custom_widgets/custom_elevated_button.dart';
import '../../../../../../custom_widgets/custom_text_form_field.dart';
import '../../../../../../gen/assets.gen.dart';
import '../../../../../../gen/colors.gen.dart';
import '../../../../../../helper/logger_util.dart';
import '../../../../../../helper/ui_helpers.dart';

class SelectDislikeFoodsWidget extends StatelessWidget {
  const SelectDislikeFoodsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    IgFoodDislikesScreenController controller =
        Get.find<IgFoodDislikesScreenController>();
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Any Food Dislikes?",
            style: TextFontStyle.headline22w500cfefefeStylePoppins,
          ),
          UIHelper.verticalSpace(24.h),

          /// Search Field
          Obx(() {
            return Row(
              children: [
                Expanded(
                  child: CustomFormField(
                    controller: controller.dislikeFoodController.value,
                    hintText: "Type your dislike foods!",
                    borderRadius: 16.r,
                  ),
                ),
                UIHelper.horizontalSpace(10.w),
                controller.isDisLikeFoodControllerNotEmpty.value
                    ? CustomElevatedButton(
                        onTap: () {
                          LoggerUtils.debug("Add Button Taped!");
                          controller.addDisLikeFoodToList();
                        },
                        buttonWidth: 0.2.sw,
                        buttonTitle: 'Add',
                      )
                    : SizedBox.shrink(),
              ],
            );
          }),
          UIHelper.verticalSpace(50.h),

          /// Selected Items
          Obx(() {
            return Wrap(
              spacing: 8.w,
              runSpacing: 8.h,
              children: controller.dislikedFoodList.map((item) {
                return InkWell(
                  onTap: () {
                    log("Remove Item By tapping on it");
                    controller.removeDislikeFoodFromList(food: item);
                  },
                  child: Stack(
                    children: [
                      Container(
                        width: 100.w,
                        padding: EdgeInsets.all(10.sp),
                        decoration: BoxDecoration(
                          color: AppColors.cb20000,
                          border: Border.all(color: AppColors.cFFFFFF),
                          borderRadius: BorderRadius.circular(8.r),
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(
                              Icons.food_bank_outlined,
                              color: Colors.white,
                            ),
                            UIHelper.verticalSpace(10.h),
                            Text(
                              item,
                              textAlign: TextAlign.center,
                              style: TextFontStyle
                                  .headline16w500cFFFFFFStylePoppins,
                            ),
                          ],
                        ),
                      ),

                      /// Diagonal Line Painter Overlay
                      Positioned.fill(
                        child: CustomPaint(
                          painter: DiagonalLinePainter(
                            color: Colors.white,
                            strokeWidth: 2,
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              }).toList(),
            );
          }),
        ],
      ),
    );
  }
}
