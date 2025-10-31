import 'package:bloodfit/constants/app_list.dart';
import 'package:bloodfit/constants/text_font_style.dart';
import 'package:bloodfit/gen/colors.gen.dart';
import 'package:bloodfit/helper/ui_helpers.dart';
import 'package:bloodfit/controllers/select_diet_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class SelectDietWidget extends StatelessWidget {
  final Function(int selectedIndex)? onSelected;

  const SelectDietWidget({super.key, this.onSelected});

  @override
  Widget build(BuildContext context) {
    final SelectDietController controller = Get.put(SelectDietController());

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Pick Your Diet",
            style: TextFontStyle.headline22w500cfefefeStylePoppins,
          ),
          UIHelper.verticalSpace(6.h),
          Text(
            "Select Any One",
            style: TextFontStyle.headline14w500cFFFFFFStylePoppins,
          ),
          UIHelper.verticalSpace(24.h),

          /// Diet List
          ListView.separated(
            itemCount: AppList.pickYourDietList.length,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            separatorBuilder: (context, index) => UIHelper.verticalSpace(16.h),
            itemBuilder: (context, index) {
              var data = AppList.pickYourDietList[index];

              return Obx(() {
                bool isSelected = controller.selectedIndex.value == index;

                return InkWell(
                  borderRadius: BorderRadius.circular(8.r),
                  onTap: () {
                    controller.selectDiet(index);
                    onSelected?.call(index);
                  },
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    width: 1.sw,
                    padding: EdgeInsets.all(12.sp),
                    decoration: BoxDecoration(
                      color: isSelected ? AppColors.cb20000 : AppColors.c3c3c3c,
                      borderRadius: BorderRadius.circular(8.r),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        /// Diet Name
                        Text(
                          data.dietName,
                          style:
                              TextFontStyle.headline16w500cfefefeStylePoppins,
                        ),

                        /// Diet Type
                        Text(
                          data.dietType,
                          style:
                              TextFontStyle.headline14w400cfefefeStylePoppins,
                        ),
                      ],
                    ),
                  ),
                );
              });
            },
          ),
        ],
      ),
    );
  }
}
