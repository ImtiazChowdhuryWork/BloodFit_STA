import 'package:bloodfit/custom_widgets/food_item_data_helper_widget.dart';
import 'package:bloodfit/custom_widgets/meal_network_image_showing_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../constants/text_font_style.dart';
import '../../../../gen/assets.gen.dart';
import '../../../../gen/colors.gen.dart';
import '../../../../helper/ui_helpers.dart';

class FoodItemShowingWidget extends StatelessWidget {
  final bool isSelected;
  final String itemImagePath;
  final String itemTitle;
  final int kcalValue;
  final int personValue;
  final void Function(bool?)? onChanged;
  const FoodItemShowingWidget({
    super.key,
    required this.isSelected,
    required this.itemImagePath,
    required this.itemTitle,
    required this.kcalValue,
    required this.personValue,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 210.w,
      padding: EdgeInsets.all(10.sp),
      decoration: BoxDecoration(
        color: AppColors.c262626,
        borderRadius: BorderRadius.circular(16.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min, // ✅ makes the column shrink-wrap
        children: [
          ///Section : ------------///Item Image///-----------------
          ///Section : -----------///Check Box///--------------
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            mainAxisSize: MainAxisSize.min, // ✅ Row shrink-wraps horizontally
            children: [
              ///Section : ------------///Item Image///-----------------
              CustomNetworkImageWidget(
                imageUrl: itemImagePath,
                height: 130.h,
                width: 130.w,
                fit: BoxFit.contain,
              ),

              ///Section : -----------///Check Box///--------------
              Checkbox(
                activeColor: AppColors.cb20000,
                side: BorderSide(color: AppColors.cd7d7d7),
                value: isSelected,
                onChanged: onChanged,
              ),
            ],
          ),
          UIHelper.verticalSpace(21.h),

          /// Section: Item Name
          Text(
            itemTitle,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: TextFontStyle.headline16w500cFFFFFFStylePoppins,
          ),
          UIHelper.verticalSpace(8.h),

          SizedBox(
            width: 1.sw,

            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                mainAxisSize: MainAxisSize.min, // ✅ Row doesn’t stretch
                children: [
                  /// Food Total Kcal & Serving
                  FoodItemDataHelperWidget(
                    iconPath: Assets.icons.fireRed,
                    title: "Kcal",
                    value: kcalValue,
                  ),
                  UIHelper.horizontalSpace(6.w),

                  /// Divider
                  Container(
                    width: 2.sp,
                    height: 20.h,
                    color: AppColors.cFFFFFF,
                  ),
                  UIHelper.horizontalSpace(6.w),

                  FoodItemDataHelperWidget(
                    title: "Person",
                    iconPath: Assets.icons.personIcon,
                    value: personValue,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
