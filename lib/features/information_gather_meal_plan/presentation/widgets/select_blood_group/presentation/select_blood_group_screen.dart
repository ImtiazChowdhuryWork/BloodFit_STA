import 'dart:developer';

import 'package:bloodfit/constants/app_list.dart';
import 'package:bloodfit/constants/text_font_style.dart';
import 'package:bloodfit/features/information_gather_meal_plan/presentation/widgets/select_blood_group/presentation/widget/blood_group_widget.dart';
import 'package:bloodfit/helper/ui_helpers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../../../../controllers/ig_select_blood_grop_controller.dart';
import '../../../../../../gen/colors.gen.dart';

class SelectBloodGroupWidget extends StatelessWidget {
  final IgSelectBloodGropController selectBloodGropController =
      Get.find<IgSelectBloodGropController>();
  SelectBloodGroupWidget({super.key});

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
                child: Obx(() {
                  return BloodGroupWidget(
                    onTap: () {
                      log("Blood Group Index : $index");
                      log("Blood Group : $data");
                      selectBloodGropController.getSelectedIndex(
                        newValue: index,
                      );
                    },
                    title: data,
                    bgColor:
                        selectBloodGropController.selectedIndex.value == index
                        ? AppColors.c620000
                        : AppColors.c111111,
                    index: selectBloodGropController.selectedIndex.value,
                  );
                }),
              );
            }),
          ),
        ),
      ],
    );
  }
}
