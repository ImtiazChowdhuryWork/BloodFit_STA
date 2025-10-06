import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../constants/text_font_style.dart';
import '../../../../gen/colors.gen.dart';
import '../../../../helper/ui_helpers.dart';
import '../../model/personal_data_model.dart';

class ProfileDataShowingWidget extends StatelessWidget {
  final List<PersonalDataModel> myList;
  const ProfileDataShowingWidget({super.key, required this.myList});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: myList.map((data) {
          return Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
                decoration: BoxDecoration(
                  border: Border.all(color: AppColors.c3c3c3c),
                  borderRadius: BorderRadius.circular(16.r),
                ),
                child: Column(
                  children: [
                    ///Section : ---------------------///Data///-----------
                    Text(
                      data.data,
                      style: TextFontStyle.headline14w500cfefefeStylePoppins,
                    ),
                    UIHelper.verticalSpace(3.h),

                    ///Section : ---------------------///Field Title///-----------
                    Text(
                      data.field,
                      style: TextFontStyle.headline14w500c999999StylePoppins,
                    ),
                  ],
                ),
              ),
              UIHelper.horizontalSpace(10.w),
            ],
          );
        }).toList(),
      ),
    );
  }
}
