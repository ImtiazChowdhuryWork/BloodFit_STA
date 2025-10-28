import 'package:bloodfit/constants/app_list.dart';
import 'package:bloodfit/features/information_gather_workout/presentation/widgets/current_body_shape/presentation/widgets/prefered_activity_level/presentation/widget/prefered_workout_level_showing_widget.dart';
import 'package:bloodfit/gen/assets.gen.dart';
import 'package:bloodfit/helper/ui_helpers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../../../../../../../constants/text_font_style.dart';
import '../../../../../../../../../controllers/ig_prefered_activity_level_controller.dart';

class PreferedActivityLevelWidget extends StatelessWidget {
  PreferedActivityLevelWidget({super.key});

  final IgPreferedActivityLevelController controller =
      Get.find<IgPreferedActivityLevelController>();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Choose Your Preferred Workout Level",
          style: TextFontStyle.headline22w500cfefefeStylePoppins,
        ),
        UIHelper.verticalSpace(16.h),

        ListView.separated(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: AppList.preferedActivityLevelList.length,
          separatorBuilder: (context, index) => UIHelper.verticalSpace(10.h),
          itemBuilder: (context, index) {
            var data = AppList.preferedActivityLevelList[index];
            return Obx(() {
              return PreferedWorkOutLevelShowingWidget(
                iconPath: data.iconPath,
                title: data.title,
                isSelected: controller.selectedIndex.value == index,
                onTap: () => controller.selectLevel(index),
              );
            });
          },
        ),
      ],
    );
  }
}
