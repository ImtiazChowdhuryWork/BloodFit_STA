// import 'package:bloodfit/constants/text_font_style.dart';
// import 'package:bloodfit/gen/colors.gen.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:get/get.dart';

// import '../controllers/slider_button_controller.dart';

// class SliderButton extends StatelessWidget {
//   final List<String> items;
//   final Function(int index, String value)? onValueChanged;
//   final SliderButtonController controller;

//   const SliderButton({
//     super.key,
//     required this.items,
//     required this.controller,
//     this.onValueChanged,
//   }) : assert(items.length > 1, "SliderButton requires at least 2 items");

//   @override
//   Widget build(BuildContext context) {
//     // Fire the default callback once (safe because GetX initializes controllers early)
//     onValueChanged?.call(
//       controller.selectedIndex.value,
//       controller.selectedValue.value,
//     );

//     return Obx(() {
//       final selectedIndex = controller.selectedIndex.value;

//       return Container(
//         height: 50.h,
//         width: 0.5.sw,
//         decoration: BoxDecoration(
//           color: Colors.white,
//           borderRadius: BorderRadius.circular(8.r),
//         ),
//         child: Stack(
//           children: [
//             // Sliding indicator
//             AnimatedPositioned(
//               left: (0.5.sw / items.length) * selectedIndex,
//               duration: const Duration(milliseconds: 300),
//               curve: Curves.easeInOut,
//               child: Container(
//                 width: 0.5.sw / items.length,
//                 height: 50.h,
//                 decoration: BoxDecoration(
//                   color: AppColors.cb20000,
//                   borderRadius: BorderRadius.circular(8.r),
//                 ),
//               ),
//             ),

//             // Buttons
//             Row(
//               children: List.generate(items.length, (index) {
//                 final isSelected = selectedIndex == index;
//                 return Expanded(
//                   child: GestureDetector(
//                     onTap: () {
//                       controller.changeIndex(index, items);
//                       onValueChanged?.call(
//                         index,
//                         controller.selectedValue.value,
//                       );
//                     },
//                     child: Container(
//                       alignment: Alignment.center,
//                       height: 50.h,
//                       color: Colors.transparent,
//                       child: Text(
//                         items[index],
//                         style: isSelected
//                             ? TextFontStyle.headline22w500cfefefeStylePoppins
//                             : TextFontStyle.headline22w500cfefefeStylePoppins
//                                   .copyWith(color: AppColors.cb20000),
//                       ),
//                     ),
//                   ),
//                 );
//               }),
//             ),
//           ],
//         ),
//       );
//     });
//   }
// }

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
  final int initialIndex;

  const SliderButton({
    super.key,
    required this.items,
    required this.controller,
    this.onValueChanged,
    this.initialIndex = 0,
  }) : assert(items.length > 1, "SliderButton requires at least 2 items");

  @override
  Widget build(BuildContext context) {
    // Ensure controller initialized with current widget config
    controller.initialize(items, initialIndex: initialIndex);

    // Fire callback for first selected item
    onValueChanged?.call(
      controller.selectedIndex.value,
      controller.selectedValue.value,
    );

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
            Row(
              children: List.generate(items.length, (index) {
                final isSelected = selectedIndex == index;
                return Expanded(
                  child: GestureDetector(
                    onTap: () {
                      controller.changeIndex(index, items);
                      onValueChanged?.call(
                        index,
                        controller.selectedValue.value,
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
