import 'package:bloodfit/constants/text_font_style.dart';
import 'package:bloodfit/gen/colors.gen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../controllers/slider_button_controller.dart';

class SliderButton extends StatelessWidget {
  final List<String> items;
  final Function(int index, String value)? onValueChanged;
  final SliderButtonController controller;

  const SliderButton({
    super.key,
    required this.items,
    required this.controller,
    this.onValueChanged,
  }) : assert(items.length > 1, "SliderButton requires at least 2 items");

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final selectedIndex = controller.selectedIndex.value;
      return Container(
        height: 50.h,
        width: 0.5.sw,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8.r),
        ),
        child: Stack(
          children: [
            // Sliding indicator
            AnimatedPositioned(
              left: (0.5.sw / items.length) * selectedIndex,
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeInOut,
              child: Container(
                width: 0.5.sw / items.length,
                height: 50.h,
                decoration: BoxDecoration(
                  color: AppColors.cb20000,
                  borderRadius: BorderRadius.circular(8.r),
                ),
              ),
            ),

            // Buttons
            Row(
              children: List.generate(items.length, (index) {
                final isSelected = selectedIndex == index;
                return Expanded(
                  child: GestureDetector(
                    onTap: () {
                      controller.changeIndex(index);
                      onValueChanged?.call(
                        index,
                        controller.selectedValue(items),
                      );
                    },
                    child: Container(
                      alignment: Alignment.center,
                      height: 50.h,
                      color: Colors.transparent,
                      child: Text(
                        items[index],
                        style: isSelected
                            ? TextFontStyle.headline22w500cfefefeStylePoppins
                            : TextFontStyle.headline22w500cfefefeStylePoppins
                                  .copyWith(color: AppColors.cb20000),
                      ),
                    ),
                  ),
                );
              }),
            ),
          ],
        ),
      );
    });
  }
}
