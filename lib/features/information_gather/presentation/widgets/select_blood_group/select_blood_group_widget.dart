import 'dart:developer';

import 'package:bloodfit/constants/appList.dart';
import 'package:bloodfit/constants/text_font_style.dart';
import 'package:bloodfit/features/information_gather/presentation/widgets/select_blood_group/blood_group_widget.dart';
import 'package:bloodfit/helper/ui_helpers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SelectBloodGroupWidget extends StatelessWidget {
  const SelectBloodGroupWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Select Your Blood Group",
          style: TextFontStyle.headline22w500cfefefeStylePoppins,
        ),
        UIHelper.verticalSpace(52.h),

        /// Use Column for static list
        Align(
          alignment: Alignment.center,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(AppList.bloodGroups.length, (index) {
              var data = AppList.bloodGroups[index];
              return Padding(
                padding: EdgeInsets.only(bottom: 16.h),
                child: BloodGroupWidget(
                  title: data,
                  onTap: () {
                    log("Blood Group Index : $index");
                    log("Blood Group : $data");
                  },
                ),
              );
            }),
          ),
        ),
      ],
    );
  }
}
