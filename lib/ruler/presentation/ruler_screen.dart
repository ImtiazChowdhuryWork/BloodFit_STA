import 'package:bloodfit/constants/text_font_style.dart';
import 'package:bloodfit/gen/assets.gen.dart';
import 'package:bloodfit/gen/colors.gen.dart';
import 'package:bloodfit/helper/ui_helpers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

class RulerScreen extends StatefulWidget {
  const RulerScreen({super.key});

  @override
  State<RulerScreen> createState() => _RulerScreenState();
}

class _RulerScreenState extends State<RulerScreen> {
  final ScrollController scrollController = ScrollController();
  int centerIndex = 0;

  // Constants
  static const double _itemWidth = 2;
  static const double _itemSpacing = 10;
  static const int _minValue = 0;
  static const int _maxValue = 99;
  static const int _totalItems = 100;
  static const int _bigDividerInterval = 5;

  // Computed values
  double get itemWidth => _itemWidth.sp;
  double get itemSpacing => _itemSpacing.w;

  @override
  void initState() {
    super.initState();
    scrollController.addListener(_updateCenterIndex);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _updateCenterIndex();
    });
  }

  bool isIndexCentered(int index, double scrollOffset, double containerWidth) {
    final double centerX = containerWidth / 2;
    final double centerPadding = containerWidth / 2;
    final double itemCenter =
        centerPadding + index * (itemWidth + itemSpacing) + (itemWidth / 2);
    final double visibleItemCenter = itemCenter - scrollOffset;
    return (visibleItemCenter - centerX).abs() <= (itemWidth / 2);
  }

  int getCenteredIndex(double scrollOffset, double containerWidth) {
    for (int i = 0; i < _totalItems; i++) {
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

  Widget _buildNumberIndicator(int value, bool isCenter) {
    // Extract animation values from the provided code
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
          fontWeight:
              FontWeight.w500, // Using w500 to match your original styles
          color: isCenter ? AppColors.cFFFFFF : AppColors.cd7d7d7,
        ),
        child: value < 0
            ? SizedBox.shrink()
            : Text(value.toString(), textAlign: TextAlign.center),
      ),
    );
  }

  Widget _buildDivider(int itemIndex) {
    final bool isBigDivider = itemIndex % _bigDividerInterval == 0;
    return Container(
      margin: EdgeInsets.only(right: itemSpacing),
      child: Align(
        alignment: Alignment.center,
        child: Container(
          color: AppColors.c111111,
          width: itemWidth,
          height: isBigDivider ? 50.h : 24.h,
        ),
      ),
    );
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
    final double centerPadding = (containerWidth / 2) - 12.w;

    return Scaffold(
      backgroundColor: AppColors.scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: AppColors.scaffoldBackgroundColor,
        centerTitle: true,
        title: Text(
          "Measurement Ruler",
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
              padding: EdgeInsets.symmetric(vertical: 16.h),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildNumberIndicator(centerIndex - 2, false),
                  _buildNumberIndicator(centerIndex - 1, false),
                  _buildNumberIndicator(centerIndex, true),
                  _buildNumberIndicator(centerIndex + 1, false),
                  _buildNumberIndicator(centerIndex + 2, false),
                ],
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
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.3),
                    blurRadius: 8.r,
                    offset: Offset(0, 4.h),
                  ),
                ],
              ),
              child: Stack(
                clipBehavior: Clip.none,
                children: [
                  // Ruler background with subtle pattern
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12.r),
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          AppColors.c363636,
                          AppColors.c363636.withOpacity(0.9),
                        ],
                      ),
                    ),
                  ),

                  // Ruler content
                  Padding(
                    padding: EdgeInsets.all(10.sp),
                    child: ListView.builder(
                      controller: scrollController,
                      scrollDirection: Axis.horizontal,
                      itemCount: _totalItems + 1,
                      physics: const BouncingScrollPhysics(),
                      itemBuilder: (context, index) {
                        if (index == 0) {
                          return SizedBox(width: centerPadding);
                        }
                        final int itemIndex = index - 1;
                        return _buildDivider(itemIndex);
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
                        color: Colors.purple,
                        borderRadius: BorderRadius.circular(2.r),
                      ),
                    ),
                  ),

                  // Top and bottom borders for better visual definition
                  Positioned(
                    top: 0,
                    left: 0,
                    right: 0,
                    child: Container(
                      height: 1.h,
                      color: AppColors.cfefefe.withOpacity(0.1),
                    ),
                  ),
                  Positioned(
                    bottom: 0,
                    left: 0,
                    right: 0,
                    child: Container(
                      height: 1.h,
                      color: AppColors.cfefefe.withOpacity(0.1),
                    ),
                  ),

                  ///Section : Arrow Up
                  Positioned(
                    left: (1.sw / 2) - 30.sp,
                    // right: 0.w,
                    bottom: -40.h,
                    child: SvgPicture.asset(Assets.icons.upperArrowIcon),
                  ),

                  ///Section : Selected Value
                  Positioned(
                    left: (1.sw / 2) - 30.sp,
                    bottom: -100.h,
                    child: RichText(
                      text: TextSpan(
                        children: [
                          TextSpan(
                            text: centerIndex.toString(),
                            style: TextFontStyle
                                .headline36w500cFFFFFFStylePoppins
                                .copyWith(fontWeight: FontWeight.w700),
                          ),
                          TextSpan(
                            text: " Kg",
                            style:
                                TextFontStyle.headline22w500cfefefeStylePoppins,
                          ),
                        ],
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
}
