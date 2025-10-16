import 'dart:developer';

import 'package:bloodfit/features/information_gather/presentation/widgets/select_gender/presentation/widget/gender_showing_widget.dart';
import 'package:bloodfit/gen/colors.gen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../../constants/appList.dart';
import '../../../../../../constants/text_font_style.dart';
import '../../../../../../helper/ui_helpers.dart';

class SelectGenderWidget extends StatelessWidget {
  const SelectGenderWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Select Your Blood Group",
          style: TextFontStyle.headline22w500cfefefeStylePoppins,
        ),
        UIHelper.verticalSpace(120.h),

        /// Use Column for static list
        Align(
          alignment: Alignment.center,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(AppList.genderWithIconList.length, (index) {
              var data = AppList.genderWithIconList[index];
              return Padding(
                padding: EdgeInsets.only(bottom: 64.h),
                child: GenderShowingWidget(
                  onTap: () {
                    log("Gender List Index : $index");
                    log("Gender : ${data.title}");
                  },
                  title: data.title,
                  imagePath: data.iconPath,
                ),
              );
            }),
          ),
        ),
      ],
    );
  }
}
