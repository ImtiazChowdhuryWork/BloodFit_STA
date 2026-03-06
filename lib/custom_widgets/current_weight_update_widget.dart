
import 'package:bloodfit/features/home/data/controller/home_screen_controller.dart';
import 'package:bloodfit/custom_widgets/custom_elevated_button.dart';
import 'package:bloodfit/features/weight_history/data/controller/weight_history_screen_controller.dart';
import 'package:bloodfit/features/weight_history/presentation/widgets/current_weight_update_success_alertbox.dart';
import 'package:bloodfit/helper/logger_util.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../constants/text_font_style.dart';
import '../gen/colors.gen.dart';
import '../helper/ui_helpers.dart';

class CurrentWeightUpdateWidget extends StatelessWidget {
  CurrentWeightUpdateWidget({super.key});

  final HomeScreenController homeScreenController =
  Get.find<HomeScreenController>();
  final WeightHistoryScreenController weightHistoryScreenController =
  Get.find<WeightHistoryScreenController>();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'update_current_weight'.tr,
          style: TextFontStyle.headline20w500cfefefeStylePoppins,
        ),
        UIHelper.verticalSpace(8.h),
        Container(
          padding: EdgeInsets.symmetric(vertical: 12.h, horizontal: 15.w),
          decoration: BoxDecoration(
            color: AppColors.c262626,
            borderRadius: BorderRadius.circular(16.r),
          ),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                ///Section : -----------///Text Form Field -> Current Weight Update Widget///--------------
                TextFormField(
                  controller: weightHistoryScreenController.weightController,
                  style: TextFontStyle.headline14w700cfefefeStylePoppins,
                  keyboardType: TextInputType.number,
                  validator: weightHistoryScreenController
                      .updateCurrentWeightValidator,
                  onChanged: (value) {
                    // Update the reactive variable when text changes
                    weightHistoryScreenController.setIsWeightAvailableValue(
                      newValue: value.trim().isNotEmpty,
                    );
                  },
                  decoration: InputDecoration(
                    hintText: 'enter_your_weight'.tr,
                    hintStyle: TextFontStyle.headline12w500c999999StylePoppins,

                    border: OutlineInputBorder(
                      borderSide: BorderSide(color: AppColors.cb20000),
                      borderRadius: BorderRadius.circular(8.r),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: AppColors.cb20000),
                      borderRadius: BorderRadius.circular(8.r),
                    ),

                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: AppColors.cb20000),
                      borderRadius: BorderRadius.circular(8.r),
                    ),

                    disabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: AppColors.cb20000),
                      borderRadius: BorderRadius.circular(8.r),
                    ),
                    suffixIcon: Container(
                      margin: EdgeInsets.symmetric(
                        vertical: 12.h,
                        horizontal: 15.w,
                      ),
                      padding: EdgeInsets.symmetric(
                        vertical: 3.h,
                        horizontal: 10.w,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.c363636,
                        borderRadius: BorderRadius.circular(8.r),
                      ),

                      child: Obx(() {
                        return DropdownButtonHideUnderline(
                          child: DropdownButton<String>(
                            padding: EdgeInsets.zero,

                            isDense: true,
                            dropdownColor: AppColors.c262626,
                            value: weightHistoryScreenController
                                .selectedWeightUnit
                                .value, // default value
                            icon: Icon(
                              Icons.arrow_drop_down,
                              color: AppColors.cfefefe,
                            ),
                            items: weightHistoryScreenController.weightUnits
                                .map((unit) {
                              return DropdownMenuItem<String>(
                                value: unit,
                                child: Text(
                                  unit,
                                  style: TextFontStyle
                                      .headline12w500cfefefeStylePoppins,
                                ),
                              );
                            })
                                .toList(),
                            onChanged: (value) {
                              weightHistoryScreenController
                                  .setSelectedWeightUnit(unit: value ?? "");
                            },
                          ),
                        );
                      }),
                    ),
                  ),
                ),

                /// Only show the button and spacing when weight is available
                Obx(() {
                  return weightHistoryScreenController.isWeightAvailable.value
                      ? Column(
                    children: [
                      UIHelper.verticalSpace(14.h),
                      CustomElevatedButton(
                        onTap:
                        weightHistoryScreenController
                            .isUpdateCurrentWeightLoading
                            .value
                            ? null
                            : () async {
                          LoggerUtils.debug(
                            "Button Taped : Submit Button!",
                          );
                          if (_formKey.currentState!.validate()) {
                            LoggerUtils.debug(
                              "Button Taped : Submit Button!",
                            );

                            final success =
                            await weightHistoryScreenController
                                .postUpdateCurrentWeightApi();

                            if (success) {
                              _formKey.currentState!.reset();
                              showDialog(
                                barrierDismissible: false,
                                context: context,
                                builder: (context) {
                                  return CurrentWeightUpdateSuccessAlertBox();
                                },
                              );
                            }
                          }
                        },
                        buttonHeight: 32.h,
                        buttonColor: AppColors.c111111,
                        isButtonBorderUsed: true,
                        buttonBorderColor: AppColors.cb20000,
                        buttonTitle: 'submit'.tr,
                      ),
                    ],
                  )
                      : SizedBox.shrink();
                }),
              ],
            ),
          ),
        ),
      ],
    );
  }
}