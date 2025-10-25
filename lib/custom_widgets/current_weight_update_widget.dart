import 'package:bloodfit/controllers/home_screen_controller.dart';
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

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Update Your Current Weight",
          style: TextFontStyle.headline20w500cfefefeStylePoppins,
        ),
        UIHelper.verticalSpace(8.h),
        Container(
          padding: EdgeInsets.symmetric(vertical: 12.h, horizontal: 15.w),
          decoration: BoxDecoration(
            color: AppColors.c262626,
            borderRadius: BorderRadius.circular(16.r),
          ),
          child: TextFormField(
            controller: homeScreenController.weightController,
            style: TextFontStyle.headline14w700cfefefeStylePoppins,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              hintText: "Enter Your Weight",
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
                margin: EdgeInsets.symmetric(vertical: 12.h, horizontal: 15.w),
                padding: EdgeInsets.symmetric(vertical: 3.h, horizontal: 10.w),
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
                      value: homeScreenController
                          .selectedWeightUnit
                          .value, // default value
                      icon: Icon(
                        Icons.arrow_drop_down,
                        color: AppColors.cfefefe,
                      ),
                      items: ['Kg', 'lb'].map((unit) {
                        return DropdownMenuItem<String>(
                          value: unit,
                          child: Text(
                            unit,
                            style:
                                TextFontStyle.headline12w500cfefefeStylePoppins,
                          ),
                        );
                      }).toList(),
                      onChanged: (value) {
                        homeScreenController.setSelectedWeightUnit(
                          unit: value ?? "",
                        );
                      },
                    ),
                  );
                }),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
