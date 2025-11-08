import 'package:bloodfit/constants/text_font_style.dart';
import 'package:bloodfit/gen/colors.gen.dart';
import 'package:bloodfit/helper/ui_helpers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class RulerScreen extends StatefulWidget {
  const RulerScreen({super.key});

  @override
  State<RulerScreen> createState() => _RulerScreenState();
}

class _RulerScreenState extends State<RulerScreen> {
  final ScrollController scrollController = ScrollController();
  int centerIndex = 0; // Start from first item

  final double itemWidth = 2.sp;
  final double itemSpacing = 10.w;
  final int minValue = 0;
  final int maxValue = 99;

  @override
  void initState() {
    super.initState();
    // Listen to scroll to update center index
    scrollController.addListener(_updateCenterIndex);

    // Update initial value after build
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _updateCenterIndex(); // Update initial value
    });
  }

  bool isIndexCentered(int index, double scrollOffset, double containerWidth) {
    final double centerX = containerWidth / 2;

    // Account for the initial center padding - items start from centerPadding position
    final double centerPadding = containerWidth / 2;
    final double itemCenter =
        centerPadding + index * (itemWidth + itemSpacing) + (itemWidth / 2);

    final double visibleItemCenter = itemCenter - scrollOffset;
    return (visibleItemCenter - centerX).abs() <= (itemWidth / 2);
  }

  int getCenteredIndex(double scrollOffset, double containerWidth) {
    for (int i = 0; i < 100; i++) {
      if (isIndexCentered(i, scrollOffset, containerWidth)) return i;
    }
    return 0;
  }

  void _updateCenterIndex() {
    final double scrollOffset = scrollController.offset;
    final double containerWidth = 1.sw - 20.sp;

    final int calculatedIndex = getCenteredIndex(scrollOffset, containerWidth);

    if (calculatedIndex != centerIndex) {
      setState(() {
        centerIndex = calculatedIndex;
      });
    }
  }

  @override
  void dispose() {
    scrollController.removeListener(_updateCenterIndex);
    scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final double containerWidth = 1.sw - 20.sp;
    final double centerPadding = containerWidth / 2;

    return Scaffold(
      backgroundColor: AppColors.scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: AppColors.scaffoldBackgroundColor,
        centerTitle: true,
        title: Text(
          "Ruler",
          style: TextFontStyle.headline20w500cfefefeStylePoppins,
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(UIHelper.kDefaulutPadding()),
        child: Column(
          children: [
            // Display current center value
            Container(
              padding: EdgeInsets.symmetric(vertical: 16.h),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "${centerIndex - 2}",
                    style: TextFontStyle.headline20w500cfefefeStylePoppins,
                  ),
                  Text(
                    "${centerIndex - 1}",
                    style: TextFontStyle.headline20w500cfefefeStylePoppins,
                  ),
                  Text(
                    "$centerIndex",
                    style: TextFontStyle.headline20w500cfefefeStylePoppins,
                  ),
                  Text(
                    "${centerIndex + 1}",
                    style: TextFontStyle.headline20w500cfefefeStylePoppins,
                  ),
                  Text(
                    "${centerIndex + 2}",
                    style: TextFontStyle.headline20w500cfefefeStylePoppins,
                  ),
                ],
              ),
            ),

            Stack(
              children: [
                Container(
                  width: 1.sw,
                  height: 70.h,
                  padding: EdgeInsets.all(10.sp),
                  decoration: BoxDecoration(color: AppColors.c363636),
                  child: ListView.builder(
                    controller: scrollController,
                    scrollDirection: Axis.horizontal,
                    itemCount: 100 + 1, // +1 for the starting padding
                    itemBuilder: (context, index) {
                      // First item is empty space to start from center
                      if (index == 0) {
                        return SizedBox(width: centerPadding);
                      }

                      // Actual divider items
                      final int itemIndex = index - 1;
                      bool isBigDivider = itemIndex % 5 == 0;
                      return Container(
                        margin: EdgeInsets.only(right: itemSpacing),
                        child: Align(
                          alignment: Alignment.center,
                          child: Container(
                            color: isBigDivider
                                ? AppColors.cb20000
                                : AppColors.c111111,
                            width: itemWidth,
                            height: isBigDivider ? 50.h : 24.h,
                          ),
                        ),
                      );
                    },
                  ),
                ),

                // Purple divider at the middle
                Positioned(
                  left: 1.sw / 2 - 1.sp,
                  top: 0,
                  bottom: 0,
                  child: Container(width: 2.sp, color: Colors.purple),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
