import 'dart:developer';

import 'package:bloodfit/features/information_gather_meal_plan/presentation/widgets/select_gender/presentation/widget/gender_showing_widget.dart';
import 'package:bloodfit/gen/colors.gen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../../../../constants/app_list.dart';
import '../../../../../../constants/text_font_style.dart';
import '../../../../../../controllers/ig_select_gender_screen_controller.dart';
import '../../../../../../helper/ui_helpers.dart';

class SelectGenderWidget extends StatelessWidget {
  final IgSelectGenderScreenController selectGenderScreenController =
      Get.find<IgSelectGenderScreenController>();
  SelectGenderWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Select Your Gender",
          style: TextFontStyle.headline22w500cfefefeStylePoppins,
        ),

        // Optional: Show selected gender
        Obx(
          () => Text(
            'Selected Gender: ${selectGenderScreenController.selectedGender.value.isNotEmpty ? selectGenderScreenController.selectedGender.value : "Not selected"}',
            style: TextFontStyle.headline10w500cfefefeStylePoppins,
          ),
        ),

        UIHelper.verticalSpace(50.h), // Reduced space
        /// Use Column for static list
        Align(
          alignment: Alignment.center,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(
              selectGenderScreenController
                  .genderWithIconList
                  .length, // Use controller list
              (index) {
                var data =
                    selectGenderScreenController.genderWithIconList[index];
                return Padding(
                  padding: EdgeInsets.only(bottom: 64.h),
                  child: Obx(() {
                    return GenderShowingWidget(
                      onTap: () {
                        log("Gender List Index : $index");
                        log("Gender : ${data.title}");

                        // Check if already selected
                        if (selectGenderScreenController
                                .selectedGenderIndex
                                .value ==
                            index) {
                          log("Same gender selected, no change needed");
                          return;
                        }

                        // Update UI state
                        selectGenderScreenController.setSelectedGenderIndex(
                          newValue: index,
                        );

                        // Save to storage
                        selectGenderScreenController.saveGender();
                      },
                      title: data.title,
                      bgColor:
                          selectGenderScreenController
                                  .selectedGenderIndex
                                  .value ==
                              index
                          ? AppColors.c620000
                          : AppColors.c111111,
                      imagePath: data.iconPath,
                    );
                  }),
                );
              },
            ),
          ),
        ),
      ],
    );
  }
}
