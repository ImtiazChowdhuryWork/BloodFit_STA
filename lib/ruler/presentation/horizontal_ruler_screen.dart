// import 'package:bloodfit/constants/text_font_style.dart';
// import 'package:bloodfit/gen/assets.gen.dart';
// import 'package:bloodfit/gen/colors.gen.dart';
// import 'package:bloodfit/helper/ui_helpers.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:flutter_svg/flutter_svg.dart';

// class RulerScreen extends StatefulWidget {
//   const RulerScreen({super.key});

//   @override
//   State<RulerScreen> createState() => _RulerScreenState();
// }

// class _RulerScreenState extends State<RulerScreen> {
//   final ScrollController scrollController = ScrollController();
//   int centerIndex = 0;
//   int lastValidCenterIndex = 0; // Add this to track last valid value

//   // Constants
//   static const double _itemWidth = 2;
//   static const double _itemSpacing = 10;
//   static const int _minValue = 0;
//   static const int _maxValue = 99;
//   static const int _totalItems = 100;
//   static const int _bigDividerInterval = 5;

//   // Computed values
//   double get itemWidth => _itemWidth.sp;
//   double get itemSpacing => _itemSpacing.w;

//   @override
//   void initState() {
//     super.initState();
//     scrollController.addListener(_updateCenterIndex);
//     WidgetsBinding.instance.addPostFrameCallback((_) {
//       _updateCenterIndex();
//     });
//   }

//   bool isIndexCentered(int index, double scrollOffset, double containerWidth) {
//     final double centerX = containerWidth / 2;
//     final double centerPadding = containerWidth / 2;
//     final double itemCenter =
//         centerPadding + index * (itemWidth + itemSpacing) + (itemWidth / 2);
//     final double visibleItemCenter = itemCenter - scrollOffset;
//     return (visibleItemCenter - centerX).abs() <= (itemWidth / 2);
//   }

//   int getCenteredIndex(double scrollOffset, double containerWidth) {
//     for (int i = 0; i < _totalItems; i++) {
//       if (isIndexCentered(i, scrollOffset, containerWidth)) return i;
//     }
//     return -1; // Return -1 when no item is centered
//   }

//   void _updateCenterIndex() {
//     final double scrollOffset = scrollController.offset;
//     final double containerWidth = 1.sw - 20.sp;
//     final int calculatedIndex = getCenteredIndex(scrollOffset, containerWidth);

//     if (calculatedIndex != centerIndex) {
//       setState(() {
//         // Only update centerIndex if we found a valid centered item
//         // Otherwise keep the last valid value
//         if (calculatedIndex >= 0) {
//           centerIndex = calculatedIndex;
//           lastValidCenterIndex = calculatedIndex; // Update last valid value
//         } else {
//           // When between items, use the last valid centered index
//           centerIndex = lastValidCenterIndex;
//         }
//       });
//     }
//   }

//   Widget _buildNumberIndicator(int value, bool isCenter) {
//     final targetScale = isCenter ? 1.4 : 1.0;
//     final targetOpacity = isCenter ? 1.0 : 0.45;
//     final baseFontSize = isCenter ? 36.0 : 34.0;
//     return AnimatedOpacity(
//       duration: const Duration(milliseconds: 120),
//       opacity: targetOpacity,
//       curve: Curves.easeOut,
//       child: AnimatedDefaultTextStyle(
//         duration: const Duration(milliseconds: 120),
//         style: TextStyle(
//           fontSize: (baseFontSize * targetScale).sp,
//           fontWeight:
//               FontWeight.w500, // Using w500 to match your original styles
//           color: isCenter ? AppColors.cFFFFFF : AppColors.cd7d7d7,
//         ),
//         child: value < 0
//             ? SizedBox.shrink()
//             : Text(value.toString(), textAlign: TextAlign.center),
//       ),
//     );
//   }

//   Widget _buildDivider(int itemIndex) {
//     final bool isBigDivider = itemIndex % _bigDividerInterval == 0;
//     return Container(
//       margin: EdgeInsets.only(right: itemSpacing),
//       child: Align(
//         alignment: Alignment.center,
//         child: Container(
//           color: AppColors.c111111,
//           width: itemWidth,
//           height: isBigDivider ? 50.h : 24.h,
//         ),
//       ),
//     );
//   }

//   @override
//   void dispose() {
//     scrollController.removeListener(_updateCenterIndex);
//     scrollController.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     final double containerWidth = 1.sw - 20.sp;
//     final double centerPadding = (containerWidth / 2) - 12.w;

//     return Scaffold(
//       backgroundColor: AppColors.scaffoldBackgroundColor,
//       appBar: AppBar(
//         backgroundColor: AppColors.scaffoldBackgroundColor,
//         centerTitle: true,
//         title: Text(
//           "Measurement Ruler",
//           style: TextFontStyle.headline20w500cfefefeStylePoppins,
//         ),
//       ),
//       body: SingleChildScrollView(
//         padding: EdgeInsets.all(UIHelper.kDefaulutPadding()),
//         child: Column(
//           children: [
//             // Number indicators
//             Container(
//               width: 1.sw,
//               padding: EdgeInsets.symmetric(vertical: 16.h),
//               child: Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceAround,
//                 children: [
//                   _buildNumberIndicator(centerIndex - 2, false),
//                   _buildNumberIndicator(centerIndex - 1, false),
//                   _buildNumberIndicator(centerIndex, true),
//                   _buildNumberIndicator(centerIndex + 1, false),
//                   _buildNumberIndicator(centerIndex + 2, false),
//                 ],
//               ),
//             ),

//             // Ruler
//             Container(
//               width: 1.sw,
//               height: 90.h,
//               margin: EdgeInsets.symmetric(vertical: 16.h),
//               decoration: BoxDecoration(
//                 color: AppColors.c363636,
//                 borderRadius: BorderRadius.circular(12.r),
//               ),
//               child: Stack(
//                 clipBehavior: Clip.none,
//                 children: [
//                   // Ruler content
//                   Padding(
//                     padding: EdgeInsets.all(10.sp),
//                     child: ListView.builder(
//                       controller: scrollController,
//                       scrollDirection: Axis.horizontal,
//                       itemCount: _totalItems + 1,
//                       physics: const BouncingScrollPhysics(),
//                       itemBuilder: (context, index) {
//                         if (index == 0) {
//                           return SizedBox(width: centerPadding);
//                         }
//                         final int itemIndex = index - 1;
//                         return _buildDivider(itemIndex);
//                       },
//                     ),
//                   ),

//                   // Center indicator with glow effect
//                   Positioned(
//                     left: (1.sw / 2) - 12.sp,
//                     top: 0,
//                     bottom: 0,
//                     child: Container(
//                       width: 3.sp,
//                       decoration: BoxDecoration(
//                         color: Colors.purple,
//                         borderRadius: BorderRadius.circular(2.r),
//                       ),
//                     ),
//                   ),

//                   ///Section : Arrow Up
//                   Positioned(
//                     left: (1.sw / 2) - 30.sp,
//                     // right: 0.w,
//                     bottom: -40.h,
//                     child: SvgPicture.asset(Assets.icons.upperArrowIcon),
//                   ),

//                   ///Section : Selected Value
//                   Positioned(
//                     left: (1.sw / 2) - 50.sp,
//                     bottom: -100.h,
//                     child: RichText(
//                       text: TextSpan(
//                         children: [
//                           TextSpan(
//                             text: centerIndex.toString(),
//                             style: TextFontStyle
//                                 .headline36w500cFFFFFFStylePoppins
//                                 .copyWith(fontWeight: FontWeight.w700),
//                           ),
//                           TextSpan(
//                             text: " Kg",
//                             style:
//                                 TextFontStyle.headline22w500cfefefeStylePoppins,
//                           ),
//                         ],
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

import 'package:bloodfit/constants/text_font_style.dart';
import 'package:bloodfit/gen/assets.gen.dart';
import 'package:bloodfit/gen/colors.gen.dart';
import 'package:bloodfit/helper/ui_helpers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

import '../../controllers/weight_picker_widget_controller.dart';
import '../../features/information_gather_meal_plan/presentation/widgets/select_weight/presentation/widgets/number_indicator_widget.dart';

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
    final WeightController weightController = Get.put(WeightController());
    final double containerWidth = 1.sw - 20.sp;
    final double centerPadding = (containerWidth / 2) - 12.w;

    return Scaffold(
      backgroundColor: AppColors.scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: AppColors.scaffoldBackgroundColor,
        centerTitle: true,
        title: Text(
          title,
          style: TextFontStyle.headline20w500cfefefeStylePoppins,
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(UIHelper.kDefaulutPadding()),
        child: Column(
          children: [
            // Number indicators
            Container(
              width: 1.sw,
              padding: EdgeInsets.symmetric(vertical: 12.h),
              child: Obx(() {
                double currentValue = weightController.centerValue.value;
                return Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    NumberIndicator(
                      value: currentValue - 0.4, // Pass double directly
                      isCenter: false,
                    ),
                    NumberIndicator(
                      value: currentValue - 0.2, // Pass double directly
                      isCenter: false,
                    ),
                    NumberIndicator(
                      value: currentValue, // Pass double directly
                      isCenter: true,
                    ),
                    NumberIndicator(
                      value: currentValue + 0.2, // Pass double directly
                      isCenter: false,
                    ),
                    NumberIndicator(
                      value: currentValue + 0.4, // Pass double directly
                      isCenter: false,
                    ),
                  ],
                );
              }),
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
                      controller: weightController.scrollController,
                      scrollDirection: Axis.horizontal,
                      itemCount: weightController.totalItems + 1,
                      physics: const BouncingScrollPhysics(),
                      itemBuilder: (context, index) {
                        if (index == 0) {
                          return SizedBox(width: centerPadding);
                        }
                        final int itemIndex = index - 1;
                        return _buildDivider(itemIndex, weightController);
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
                              text: weightController.centerValue.value
                                  .toString(),
                              style: TextFontStyle
                                  .headline36w500cFFFFFFStylePoppins
                                  .copyWith(fontWeight: FontWeight.w700),
                            ),
                            TextSpan(
                              text: " $unit",
                              style: TextFontStyle
                                  .headline22w500cfefefeStylePoppins,
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
      ),
    );
  }

  Widget _buildNumberIndicator(int value, bool isCenter) {
    final targetScale = isCenter ? 1.4 : 1.0;
    final targetOpacity = isCenter ? 1.0 : 0.45;
    final baseFontSize = isCenter ? 36.0 : 34.0;
    return AnimatedOpacity(
      duration: const Duration(milliseconds: 120),
      opacity: targetOpacity,
      curve: Curves.easeOut,
      child: AnimatedDefaultTextStyle(
        duration: const Duration(milliseconds: 120),
        style: TextStyle(
          fontSize: (baseFontSize * targetScale).sp,
          fontWeight: FontWeight.w500,
          color: isCenter ? AppColors.cFFFFFF : AppColors.cd7d7d7,
        ),
        child: value < 0
            ? const SizedBox.shrink()
            : Text(value.toString(), textAlign: TextAlign.center),
      ),
    );
  }

  Widget _buildDivider(int itemIndex, WeightController controller) {
    final bool isBigDivider = itemIndex % controller.bigDividerInterval == 0;
    return Container(
      margin: EdgeInsets.only(right: controller.computedItemSpacing),
      child: Align(
        alignment: Alignment.center,
        child: Container(
          color: AppColors.c111111,
          width: controller.computedItemWidth,
          height: isBigDivider ? 50.h : 24.h,
        ),
      ),
    );
  }
}
