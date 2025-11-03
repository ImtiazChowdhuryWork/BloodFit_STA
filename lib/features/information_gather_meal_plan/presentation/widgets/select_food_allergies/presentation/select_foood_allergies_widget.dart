import 'dart:developer';

import 'package:bloodfit/constants/app_list.dart';
import 'package:bloodfit/gen/colors.gen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

import '../../../../../../constants/text_font_style.dart';
import '../../../../../../custom_widgets/custom_text_form_field.dart';
import '../../../../../../gen/assets.gen.dart';
import '../../../../../../helper/ui_helpers.dart';

class SelectFooodAllergiesWidget extends StatelessWidget {
  const SelectFooodAllergiesWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Any food allergies?",
            style: TextFontStyle.headline22w500cfefefeStylePoppins,
          ),
          UIHelper.verticalSpace(24.h),

          ///Section : ----------///TextFormFiled -> For Searching Country Names///-------------------
          CustomFormField(
            hintText: "Search",
            borderRadius: 16.r,
            suffixIcon: SvgPicture.asset(Assets.icons.searchIcon),
          ),
          UIHelper.verticalSpace(50.h),

          ///Section : ----------///Selected Items///-------------
          Wrap(
            spacing: 8.w, // Horizontal space between items
            runSpacing: 8.h, // Vertical space between lines
            children: AppList.dislikedFoodList.map((item) {
              return InkWell(
                onTap: () {
                  log("Remove Items By tapping on them");
                },
                child: Container(
                  padding: EdgeInsets.all(10.sp),
                  decoration: BoxDecoration(
                    color: AppColors.cb20000,
                    border: Border.all(color: AppColors.cFFFFFF),
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                  child: Column(
                    children: [
                      Icon(Icons.food_bank_outlined),
                      UIHelper.verticalSpace(10.h),

                      Text(
                        item,
                        style: TextFontStyle.headline16w500cFFFFFFStylePoppins,
                      ),
                    ],
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}
