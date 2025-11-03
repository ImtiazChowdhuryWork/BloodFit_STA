import 'dart:developer';

import 'package:bloodfit/constants/text_font_style.dart';
import 'package:bloodfit/custom_widgets/custom_text_form_field.dart';
import 'package:bloodfit/gen/assets.gen.dart';
import 'package:bloodfit/gen/colors.gen.dart';
import 'package:bloodfit/helper/ui_helpers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

class SelectCountryWidget extends StatelessWidget {
  const SelectCountryWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ///Section : ------------///Title///--------------
        Text(
          "Select Your Country",
          style: TextFontStyle.headline22w500cfefefeStylePoppins,
        ),
        UIHelper.verticalSpace(24.h),

        ///Section : ----------///TextFormFiled -> For Searching Country Names///-------------------
        CustomFormField(
          hintText: "Search",
          borderRadius: 16.r,
          suffixIcon: SvgPicture.asset(Assets.icons.searchIcon),
        ),
        UIHelper.verticalSpace(24.h),

        ///Section : ---------///Selected Country///------------
        Container(
          width: 1.sw,
          padding: EdgeInsets.all(10.sp),
          decoration: BoxDecoration(
            color: AppColors.c3c3c3c,
            borderRadius: BorderRadius.circular(8.r),
          ),
          child: Row(
            children: [
              Icon(Icons.flag, color: AppColors.cb20000),
              UIHelper.horizontalSpace(10.w),

              Text(
                "Bangladesh",
                style: TextFontStyle.headline16w500cfefefeStylePoppins,
              ),
              Spacer(),

              ///Section : --------///Remove Selected Item///--------------
              InkWell(
                onTap: () {
                  log("Delete Icon Taped!");
                },
                child: SvgPicture.asset(
                  Assets.icons.trashIcon,
                  colorFilter: ColorFilter.mode(
                    AppColors.cFFFFFF,
                    BlendMode.srcIn,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
