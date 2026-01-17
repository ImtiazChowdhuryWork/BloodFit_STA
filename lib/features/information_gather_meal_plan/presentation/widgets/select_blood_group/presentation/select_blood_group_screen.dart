import 'package:bloodfit/features/information_gather_meal_plan/presentation/widgets/select_blood_group/presentation/widget/blood_group_widget.dart';
import 'package:bloodfit/helper/ui_helpers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../../../../constants/app_constant_text.dart';
import '../../../../../../constants/text_font_style.dart';
import '../../../../../../controllers/ig_select_blood_grop_controller.dart';
import '../../../../../../gen/colors.gen.dart';
import '../../../../../../helper/di.dart';
import '../../../../../../helper/logger_util.dart';

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

        Align(
          alignment: Alignment.center,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(
              selectBloodGropController.bloodGroups.length,
              (index) {
                var data = selectBloodGropController.bloodGroups[index];
                return Padding(
                  padding: EdgeInsets.only(bottom: 16.h),
                  child: Obx(() {
                    return BloodGroupWidget(
                      onTap: () {
                        final newIndex = index;
                        final newBloodGroup =
                            selectBloodGropController.bloodGroups[newIndex];

                        LoggerUtils.debug("Tapped blood group: $newBloodGroup");

                        // Check if this is already selected
                        if (selectBloodGropController.selectedIndex.value ==
                            newIndex) {
                          LoggerUtils.debug(
                            "Same blood group selected, no change needed",
                          );
                          return;
                        }

                        // Save to storage
                        appData.write(kKeyBloodGroup, newBloodGroup);

                        // Update controller state
                        selectBloodGropController.getSelectedIndex(
                          newValue: newIndex,
                        );

                        LoggerUtils.debug("Saved blood group: $newBloodGroup");
                      },
                      title: data,
                      bgColor:
                          selectBloodGropController.selectedIndex.value == index
                          ? AppColors.c620000
                          : AppColors.c111111,
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
