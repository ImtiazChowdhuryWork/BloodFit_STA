import 'package:bloodfit/constants/text_font_style.dart';
import 'package:bloodfit/features/profile_mealplan/presentation/widgets/custom_chip_with_delete_icon.dart';
import 'package:bloodfit/gen/assets.gen.dart';
import 'package:bloodfit/gen/colors.gen.dart';
import 'package:bloodfit/helper/ui_helpers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

class SearchAndSelectWidget extends StatelessWidget {
  final String title;
  final RxList<String> allItems;
  final RxList<String> selectedItems;
  final RxString searchQuery;
  final void Function(String) onItemToggle;
  final void Function(String) onItemRemove;

  const SearchAndSelectWidget({
    Key? key,
    required this.title,
    required this.allItems,
    required this.selectedItems,
    required this.searchQuery,
    required this.onItemToggle,
    required this.onItemRemove,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        /// Search box
        TextFormField(
          onChanged: (value) => searchQuery.value = value.trim(),
          style: TextStyle(color: AppColors.cFFFFFF),
          cursorColor: AppColors.cfefefe,
          decoration: InputDecoration(
            labelText: title,
            labelStyle: TextFontStyle.headline14w400cfefefeStylePoppins,
            hintText: "search",
            hintStyle: TextFontStyle.headline14w400c999999StylePoppins,

            suffixIcon: Padding(
              padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 16.h),
              child: SvgPicture.asset(Assets.icons.searchIcon),
            ),
            filled: true,
            fillColor: AppColors.c111111,
            border: OutlineInputBorder(
              borderSide: BorderSide(color: AppColors.cfefefe),
              borderRadius: BorderRadius.all(Radius.circular(4)),
            ),
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: AppColors.cfefefe),
              borderRadius: BorderRadius.all(Radius.circular(4)),
            ),
            disabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: AppColors.cfefefe),
              borderRadius: BorderRadius.all(Radius.circular(4)),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: AppColors.cfefefe),
              borderRadius: BorderRadius.all(Radius.circular(4)),
            ),
          ),
        ),
        UIHelper.verticalSpace(10.h),

        /// Suggested items — show only when searching
        Obx(() {
          final query = searchQuery.value.trim().toLowerCase();

          if (query.isEmpty) {
            return const SizedBox.shrink(); // Hide everything until search
          }

          final filtered = allItems
              .where((item) => item.toLowerCase().contains(query))
              .toList();

          if (filtered.isEmpty) {
            return const Text(
              "No matches found",
              style: TextStyle(color: Colors.grey),
            );
          }

          return Wrap(
            spacing: 16.sp,
            runSpacing: 16.sp,
            children: filtered.map((item) {
              return GestureDetector(
                onTap: () => onItemToggle(item),
                child: Chip(
                  label: Text(item),
                  side: BorderSide(
                    color: selectedItems.contains(item)
                        ? AppColors.cb20000
                        : AppColors.cFFFFFF,
                  ),
                  backgroundColor: selectedItems.contains(item)
                      ? AppColors.c3c3c3c
                      : AppColors.c111111,
                  labelStyle: TextStyle(
                    color: selectedItems.contains(item)
                        ? AppColors.cfefefe
                        : AppColors.c6a6a6a,
                  ),
                ),
              );
            }).toList(),
          );
        }),

        UIHelper.verticalSpace(20.h),

        /// Selected items with top-right delete icon
        Obx(() {
          if (selectedItems.isEmpty) return const SizedBox.shrink();

          return Wrap(
            spacing: 16.w,
            runSpacing: 16.h,
            children: selectedItems.map((item) {
              return TopRightDeleteChip(
                label: item,
                textStyle: TextFontStyle.headline14w400c999999StylePoppins,
                chipColor: AppColors.c3c3c3c,
                deleteIconColor: AppColors.c111111,
                deleteBackgroundColor: AppColors.cFFFFFF,
                onDelete: () => onItemRemove(item),
              );
            }).toList(),
          );
        }),

        Obx(() {
          return selectedItems.isEmpty
              ? SizedBox.shrink()
              : UIHelper.verticalSpace(24.h);
        }),
      ],
    );
  }
}
