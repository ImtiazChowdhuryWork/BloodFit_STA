import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../../constants/text_font_style.dart';
import '../../../../gen/colors.gen.dart';

class SelectableWrapBoxWidget extends StatelessWidget {
  final String title;
  final List<String> items;
  final RxSet<String> selectedItems;
  final Function(String) onTap;
  final int maxSelectable;

  const SelectableWrapBoxWidget({
    super.key,
    required this.title,
    required this.items,
    required this.selectedItems,
    required this.onTap,
    required this.maxSelectable,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 1.sw,
      color: AppColors.c111111,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          /// Background box
          Container(
            width: double.infinity,
            padding: EdgeInsets.all(20.sp),
            margin: EdgeInsets.only(top: 12.h),
            decoration: BoxDecoration(
              color: AppColors.c111111,
              border: Border.all(color: AppColors.cc6c6c6),
              borderRadius: BorderRadius.circular(12.r),
            ),
            child: Obx(
              () => Wrap(
                spacing: 10.w,
                runSpacing: 10.h,
                children: items.map((item) {
                  final isSelected = selectedItems.contains(item);

                  return GestureDetector(
                    onTap: () {
                      if (isSelected) {
                        selectedItems.remove(item);
                      } else {
                        if (selectedItems.length < maxSelectable) {
                          selectedItems.add(item);
                        }
                      }
                      onTap(item);
                    },
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      padding: EdgeInsets.symmetric(
                        horizontal: 14.w,
                        vertical: 10.h,
                      ),
                      decoration: BoxDecoration(
                        color: isSelected
                            ? AppColors.c3c3c3c
                            : AppColors.c111111,
                        border: Border.all(
                          color: isSelected
                              ? AppColors.cb20000
                              : AppColors.cc6c6c6,
                          width: isSelected ? 1.5 : 1,
                        ),
                        borderRadius: BorderRadius.circular(8.r),
                      ),
                      child: FittedBox(
                        fit: BoxFit.scaleDown,
                        child: Text(
                          item.substring(0, 3),
                          style: TextFontStyle.headline14w400cfefefeStylePoppins
                              .copyWith(
                                fontSize: 13.sp,
                                color: isSelected
                                    ? AppColors.cfefefe
                                    : AppColors.cfefefe.withOpacity(0.7),
                              ),
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
          ),

          /// Floating label
          Positioned(
            left: 16.w,
            top: 0,
            child: Container(
              color: AppColors.scaffoldBackgroundColor,
              padding: EdgeInsets.symmetric(horizontal: 6.w),
              child: FittedBox(
                fit: BoxFit.scaleDown,
                child: Text(
                  title,
                  style: TextFontStyle.headline14w400cfefefeStylePoppins
                      .copyWith(fontSize: 13.sp),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
