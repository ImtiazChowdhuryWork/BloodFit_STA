import 'dart:developer';

import 'package:bloodfit/constants/app_list.dart';
import 'package:bloodfit/features/information_gather_workout/presentation/widgets/current_body_shape/presentation/widgets/current_body_shape/widget/body_shape_widget.dart';
import 'package:bloodfit/helper/ui_helpers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../../../../../../constants/text_font_style.dart';
import '../../../../../../../../controllers/ig_current_body_type_controller.dart';

class CurrentBodyShapeWidget extends StatelessWidget {
  final IgCurrentBodyTypeController controller =
      Get.find<IgCurrentBodyTypeController>();

  CurrentBodyShapeWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ///Section : ------------------///Question///----------
        Text(
          "What's Your Current Body Shape?",
          style: TextFontStyle.headline22w500cfefefeStylePoppins,
        ),
        UIHelper.verticalSpace(16.h),

        ListView.separated(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: AppList.bodyTypeList.length,
          separatorBuilder: (context, index) => UIHelper.verticalSpace(10.h),
          itemBuilder: (context, index) {
            var data = AppList.bodyTypeList[index];
            return Obx(() {
              return BodyShapeWidget(
                onTap: () {
                  log("Tapped: On bodyType: ${data.bodyType}");
                  controller.selectBodyType(index);
                },
                boydType: data.bodyType,
                bodyImage: data.bodyImage,
                isSelected: controller.isSelected(index),
              );
            });
          },
        ),
      ],
    );
  }
}
