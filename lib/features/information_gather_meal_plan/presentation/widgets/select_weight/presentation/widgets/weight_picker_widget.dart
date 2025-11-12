import 'package:bloodfit/constants/text_font_style.dart';
import 'package:bloodfit/features/information_gather_meal_plan/presentation/widgets/select_weight/presentation/widgets/number_indicator_widget.dart';
import 'package:bloodfit/features/information_gather_meal_plan/presentation/widgets/select_weight/presentation/widgets/ruler_divider_widget.dart';
import 'package:bloodfit/gen/assets.gen.dart';
import 'package:bloodfit/gen/colors.gen.dart';
import 'package:bloodfit/helper/ui_helpers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import '../../../../../../../controllers/weight_picker_widget_controller.dart';

class CustomWeightRuler extends StatelessWidget {
  final String title;
  final String unit;
  final int minValue;
  final int maxValue;
  final Color centerIndicatorColor;

  const CustomWeightRuler({
    super.key,
    this.title = "Measurement Ruler",
    this.unit = "Kg",
    this.minValue = 0,
    this.maxValue = 99,
    this.centerIndicatorColor = Colors.purple,
  });

  @override
  Widget build(BuildContext context) {
    final WeightController controller = Get.put(WeightController());
    final double containerWidth = 1.sw - 20.sp;
    final double centerPadding = (containerWidth / 2) - 12.w;

    return SingleChildScrollView(
      padding: EdgeInsets.all(UIHelper.kDefaulutPadding()),
      child: Column(
        children: [
          // Number indicators
          Container(
            width: 1.sw,
            padding: EdgeInsets.symmetric(vertical: 16.h),
            child: Obx(
              () => Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  NumberIndicator(
                    value: controller.centerIndex.value - 2,
                    isCenter: false,
                  ),
                  NumberIndicator(
                    value: controller.centerIndex.value - 1,
                    isCenter: false,
                  ),
                  NumberIndicator(
                    value: controller.centerIndex.value,
                    isCenter: true,
                  ),
                  NumberIndicator(
                    value: controller.centerIndex.value + 1,
                    isCenter: false,
                  ),
                  NumberIndicator(
                    value: controller.centerIndex.value + 2,
                    isCenter: false,
                  ),
                ],
              ),
            ),
          ),

          // Ruler
          Container(
            width: 1.sw,
            height: 90.h,
            margin: EdgeInsets.symmetric(vertical: 16.h),
            decoration: BoxDecoration(
              color: AppColors.c363636,
              borderRadius: BorderRadius.circular(12.r),
            ),
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                // Ruler content
                Padding(
                  padding: EdgeInsets.all(10.sp),
                  child: ListView.builder(
                    controller: controller.scrollController,
                    scrollDirection: Axis.horizontal,
                    itemCount: WeightController.totalItems + 1,
                    physics: const BouncingScrollPhysics(),
                    itemBuilder: (context, index) {
                      if (index == 0) {
                        return SizedBox(width: centerPadding);
                      }
                      final int itemIndex = index - 1;
                      return RulerDivider(
                        itemIndex: itemIndex,
                        controller: controller,
                      );
                    },
                  ),
                ),

                // Center indicator with glow effect
                Positioned(
                  left: (1.sw / 2) - 12.sp,
                  top: 0,
                  bottom: 0,
                  child: Container(
                    width: 3.sp,
                    decoration: BoxDecoration(
                      color: centerIndicatorColor,
                      borderRadius: BorderRadius.circular(2.r),
                    ),
                  ),
                ),

                ///Section : Arrow Up
                Positioned(
                  left: (1.sw / 2) - 30.sp,
                  bottom: -40.h,
                  child: SvgPicture.asset(Assets.icons.upperArrowIcon),
                ),

                ///Section : Selected Value
                Obx(
                  () => Positioned(
                    left: (1.sw / 2) - 50.sp,
                    bottom: -100.h,
                    child: RichText(
                      text: TextSpan(
                        children: [
                          TextSpan(
                            text: controller.centerIndex.value.toString(),
                            style: TextFontStyle
                                .headline36w500cFFFFFFStylePoppins
                                .copyWith(fontWeight: FontWeight.w700),
                          ),
                          TextSpan(
                            text: " $unit",
                            style:
                                TextFontStyle.headline22w500cfefefeStylePoppins,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
