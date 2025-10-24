import 'package:bloodfit/constants/app_list.dart';
import 'package:bloodfit/constants/text_font_style.dart';
import 'package:bloodfit/features/home/presentation/widgets/selectable_days_showing_widget.dart';
import 'package:bloodfit/gen/colors.gen.dart';
import 'package:bloodfit/helper/ui_helpers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SelectYourDaysForMealPlanWidget extends StatelessWidget {
  final bool isSelected;
  const SelectYourDaysForMealPlanWidget({super.key, required this.isSelected});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Meal Plan Calendar",
          style: TextFontStyle.headline20w500cfefefeStylePoppins,
        ),
        UIHelper.verticalSpace(4.h),
        Text(
          "Customize Your Three Days",
          style: TextFontStyle.headline14w400cfefefeStylePoppins,
        ),
        UIHelper.verticalSpace(12.h),

        ///Section : ------///Seclect Day's///----------------
        Container(
          width: 1.sw,
          height: 120.h,
          padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 18.h),
          decoration: BoxDecoration(
            color: AppColors.c262626,
            borderRadius: BorderRadius.circular(8.r),
          ),
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: AppList.dayList.length,
            separatorBuilder: (context, indext) =>
                UIHelper.horizontalSpace(10.w),

            itemBuilder: (context, index) {
              var day = AppList.dayList[index];
              return SelectableDaysShowingWidget(isSelected: false, title: day);
            },
          ),
        ),
      ],
    );
  }
}
