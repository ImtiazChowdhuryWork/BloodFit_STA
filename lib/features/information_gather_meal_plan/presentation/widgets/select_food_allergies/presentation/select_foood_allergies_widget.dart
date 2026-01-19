import 'package:bloodfit/controllers/ig_food_allergies_screen_controller.dart';
import 'package:bloodfit/custom_widgets/custom_elevated_button.dart';
import 'package:bloodfit/gen/colors.gen.dart';
import 'package:bloodfit/helper/logger_util.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../../../../constants/text_font_style.dart';
import '../../../../../../custom_widgets/custom_text_form_field.dart';
import '../../../../../../helper/ui_helpers.dart';

class SelectFooodAllergiesWidget extends StatelessWidget {
  const SelectFooodAllergiesWidget({super.key});

  @override
  Widget build(BuildContext context) {
    IgFoodAllergiesScreenController controller =
        Get.find<IgFoodAllergiesScreenController>();
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Any food allergies?",
            style: TextFontStyle.headline22w500cfefefeStylePoppins,
          ),

          // Optional: Show count of selected allergies
          Obx(
            () => Text(
              'Selected ${controller.alleriesFoodList.length} item(s)',
              style: TextFontStyle.headline10w500cfefefeStylePoppins,
            ),
          ),

          UIHelper.verticalSpace(24.h),

          ///Section : ----------///TextFormFiled -> For Searching Country Names///-------------------
          Obx(() {
            return Row(
              children: [
                Expanded(
                  child: CustomFormField(
                    controller: controller.allergiesFoodController.value,
                    hintText: "Type your food allergies!",
                    borderRadius: 16.r,
                  ),
                ),
                UIHelper.horizontalSpace(10.w),
                controller.isAllegiesTextFieldNotEmpty.value
                    ? CustomElevatedButton(
                        onTap: () {
                          LoggerUtils.debug("Add Button Taped!");
                          controller.addAllergiesFoodToList();
                        },
                        buttonWidth: 0.2.sw,
                        buttonTitle: 'Add',
                      )
                    : SizedBox.shrink(),
              ],
            );
          }),

          // Optional: Clear all button
          Obx(() {
            return controller.alleriesFoodList.isNotEmpty
                ? Column(
                    children: [
                      UIHelper.verticalSpace(10.h),
                      Align(
                        alignment: Alignment.centerRight,
                        child: TextButton(
                          onPressed: () {
                            controller.clearAllFoodAllergies();
                          },
                          child: Text(
                            'Clear All',
                            style:
                                TextFontStyle.headline12w400cfefefeStylePoppins,
                          ),
                        ),
                      ),
                    ],
                  )
                : SizedBox.shrink();
          }),

          Obx(() {
            return controller.alleriesFoodList.isEmpty
                ? UIHelper.verticalSpace(40.h)
                : UIHelper.verticalSpace(20.h);
          }),

          ///Section : ----------///Selected Items///-------------
          // Obx(() {
          //   return controller.alleriesFoodList.isNotEmpty
          //       ? Wrap(
          //           spacing: 8.w, // Horizontal space between items
          //           runSpacing: 8.h, // Vertical space between lines
          //           children: controller.alleriesFoodList.map((item) {
          //             return Container(
          //               padding: EdgeInsets.all(10.sp),
          //               decoration: BoxDecoration(
          //                 color: AppColors.cb20000,
          //                 border: Border.all(color: AppColors.cFFFFFF),
          //                 borderRadius: BorderRadius.circular(8.r),
          //               ),
          //               child: Row(
          //                 mainAxisSize: MainAxisSize.min,
          //                 children: [
          //                   Icon(
          //                     Icons.food_bank_outlined,
          //                     size: 20.sp,
          //                     color: AppColors.cFFFFFF,
          //                   ),
          //                   UIHelper.horizontalSpace(8.w),
          //                   Text(
          //                     item,
          //                     style: TextFontStyle
          //                         .headline16w500cFFFFFFStylePoppins
          //                         .copyWith(fontSize: 20.sp),
          //                   ),
          //                   UIHelper.horizontalSpace(8.w),
          //                   Stack(
          //                     children: [
          //                       Positioned(
          //                         child: InkWell(
          //                           onTap: () {
          //                             LoggerUtils.debug(
          //                               "Remove Items By tapping on them",
          //                             );
          //                             controller.removeFoodAllergy(food: item);
          //                           },
          //                           child: Icon(
          //                             Icons.close,
          //                             size: 20.sp,
          //                             color: AppColors.cFFFFFF,
          //                           ),
          //                         ),
          //                       ),
          //                     ],
          //                   ),
          //                 ],
          //               ),
          //             );
          //           }).toList(),
          //         )
          //       : Text(
          //           'No food allergies selected',
          //           style: TextFontStyle.headline14w500cfefefeStylePoppins,
          //         );
          // }),
          Obx(() {
            return controller.alleriesFoodList.isNotEmpty
                ? Wrap(
                    spacing: 12.w,
                    runSpacing: 12.h,
                    children: controller.alleriesFoodList.map((item) {
                      return Material(
                        color: Colors.transparent,
                        child: Stack(
                          clipBehavior: Clip.none,
                          children: [
                            // IgnorePointer on the main container
                            IgnorePointer(
                              child: Container(
                                padding: EdgeInsets.only(
                                  left: 10.sp,
                                  right: 25.sp,
                                  top: 8.sp,
                                  bottom: 8.sp,
                                ),
                                decoration: BoxDecoration(
                                  color: AppColors.cb20000,
                                  border: Border.all(color: AppColors.cFFFFFF),
                                  borderRadius: BorderRadius.circular(8.r),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(
                                      Icons.food_bank_outlined,
                                      size: 20.sp,
                                      color: AppColors.cFFFFFF,
                                    ),
                                    UIHelper.horizontalSpace(8.w),
                                    Text(
                                      item,
                                      style: TextFontStyle
                                          .headline16w500cFFFFFFStylePoppins
                                          .copyWith(fontSize: 20.sp),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            // Positioned close icon at top-right corner
                            Positioned(
                              top: -12.sp,
                              right: -8.sp,
                              child: GestureDetector(
                                onTap: () {
                                  LoggerUtils.debug(
                                    "Remove Items By tapping on them",
                                  );
                                  controller.removeFoodAllergy(food: item);
                                },
                                child: Container(
                                  width: 30
                                      .sp, // Make it larger for better touch area
                                  height: 30.sp,
                                  color: Colors
                                      .transparent, // Make entire area tappable
                                  child: Center(
                                    child: Container(
                                      width: 20.sp,
                                      height: 20.sp,
                                      decoration: BoxDecoration(
                                        color: AppColors.cFFFFFF,
                                        shape: BoxShape.circle,
                                        border: Border(
                                          top: BorderSide(
                                            color: AppColors.cb20000,
                                            width: 5.sp,
                                          ),
                                        ),
                                      ),
                                      child: Icon(
                                        Icons.close,
                                        size: 14.sp,
                                        color: AppColors.cb20000,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    }).toList(),
                  )
                : Text(
                    'No food allergies selected',
                    style: TextFontStyle.headline14w500cfefefeStylePoppins,
                  );
          }),
        ],
      ),
    );
  }
}
