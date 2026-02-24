// import 'dart:convert';

// import 'package:bloodfit/custom_widgets/food_item_data_helper_widget.dart';
// import 'package:bloodfit/custom_widgets/meal_network_image_showing_widget.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';

// import '../../../../constants/text_font_style.dart';
// import '../../../../gen/assets.gen.dart';
// import '../../../../gen/colors.gen.dart';
// import '../../../../helper/ui_helpers.dart';

// class FoodItemShowingWidget extends StatelessWidget {
//   final bool isSelected;
//   final String itemImagePath;
//   final String itemTitle;
//   final int kcalValue;
//   final int servingValue;
//   final void Function(bool?)? onChanged;
//   final void Function()? onTap;
//   final bool isImageLinkBase64;

//   const FoodItemShowingWidget({
//     super.key,
//     required this.isSelected,
//     required this.itemImagePath,
//     required this.itemTitle,
//     required this.kcalValue,
//     required this.servingValue,
//     this.onChanged,
//     this.onTap,
//     this.isImageLinkBase64 = false,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return GestureDetector(
//       onTap: onTap,
//       child: Stack(
//         children: [
//           Container(
//         width: 210.w,
//         padding: EdgeInsets.all(10.sp),
//         decoration: BoxDecoration(
//           color: AppColors.c262626,
//           borderRadius: BorderRadius.circular(16.r),
//         ),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           mainAxisSize: MainAxisSize.min, // ✅ makes the column shrink-wrap
//           children: [
//             ///Section : ------------///Item Image///-----------------
//             ///Section : -----------///Check Box///--------------
//             Row(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               mainAxisAlignment: MainAxisAlignment.start,
//               mainAxisSize: MainAxisSize.min, // ✅ Row shrink-wraps horizontally
//               children: [
//                 ///Section : ------------///Item Image///-----------------
//                 isImageLinkBase64
//                     ? Image.memory(
//                         base64Decode(
//                           itemImagePath.contains(',')
//                               ? itemImagePath
//                                     .split(',')
//                                     .last // remove prefix if exists
//                               : itemImagePath,
//                         ), // decode directly if no prefix
//                         width: 130.w,
//                         height: 130.h,
//                         fit: BoxFit.cover,
//                       )
                //     : CustomNetworkImageWidget(
                //         imageUrl: itemImagePath,
                //         height: 130.h,
                //         width: 130.w,
                //         fit: BoxFit.cover,
                //       ),

                // ///Section : -----------///Check Box///--------------
                // Checkbox(
                //   activeColor: AppColors.cb20000,
                //   side: BorderSide(color: AppColors.cd7d7d7),
                //   value: isSelected,
                //   onChanged: onChanged,
                // ),
//               ],
//             ),
//             UIHelper.verticalSpace(21.h),

//             /// Section: Item Name
//             Text(
//               itemTitle,
//               maxLines: 2,
//               overflow: TextOverflow.ellipsis,
//               style: TextFontStyle.headline16w500cFFFFFFStylePoppins,
//             ),
//             UIHelper.verticalSpace(8.h),

//             SizedBox(
//               width: 1.sw,

//               child: SingleChildScrollView(
//                 scrollDirection: Axis.horizontal,
//                 child: Row(
//                   mainAxisSize: MainAxisSize.min, // ✅ Row doesn’t stretch
//                   children: [
//                     /// Food Total Kcal & Serving
//                     FoodItemDataHelperWidget(
//                       iconPath: Assets.icons.fireRed,
//                       title: "Kcal",
//                       value: kcalValue,
//                     ),
//                     UIHelper.horizontalSpace(6.w),

//                     /// Divider
//                     Container(
//                       width: 2.sp,
//                       height: 20.h,
//                       color: AppColors.cFFFFFF,
//                     ),
//                     UIHelper.horizontalSpace(6.w),

//                     FoodItemDataHelperWidget(
//                       title: "Person",
//                       iconPath: Assets.icons.personIcon,
//                       value: servingValue,
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//         ],
//       ),
//     );
//   }
// }




import 'dart:convert';

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
  final int servingValue;
  final void Function(bool?)? onChanged;
  final void Function()? onTap;
  final bool isImageLinkBase64;

  const FoodItemShowingWidget({
    super.key,
    required this.isSelected,
    required this.itemImagePath,
    required this.itemTitle,
    required this.kcalValue,
    required this.servingValue,
    this.onChanged,
    this.onTap,
    this.isImageLinkBase64 = false,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 210.w,
        padding: EdgeInsets.all(10.sp),
        decoration: BoxDecoration(
          color: AppColors.c262626,
          borderRadius: BorderRadius.circular(16.r),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min, // shrink-wrap
          children: [
            /// Section: Image with checkbox overlay
           SizedBox(
  width: double.infinity,
  height: 130.h,
  child: Stack(
    children: [
      /// Image container decides size
      isImageLinkBase64
          ? ClipRRect(
            borderRadius: BorderRadius.circular(8.r),
            child: Image.memory(
                base64Decode(
                  itemImagePath.contains(',')
                      ? itemImagePath.split(',').last
                      : itemImagePath,
                ),
                fit: BoxFit.cover, // IMPORTANT
              ),
          )
          : CustomNetworkImageWidget(
              imageUrl: itemImagePath,
              height: 130.h,
              width: 130.w,
              fit: BoxFit.cover,
            ),

      /// Checkbox – fully independent
      Positioned(
        top: 0,
        right: 0,
        child: Padding(
          padding: EdgeInsets.all(4.sp),
          child: Checkbox(
            value: isSelected,
            onChanged: onChanged,
            activeColor: AppColors.cb20000,
            side: BorderSide(color: AppColors.cd7d7d7),
          ),
        ),
      ),
    ],
  ),
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

            /// Section: Kcal & Serving
            SizedBox(
              width: 1.sw,
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    FoodItemDataHelperWidget(
                      iconPath: Assets.icons.fireRed,
                      title: "Kcal",
                      value: kcalValue,
                    ),
                    UIHelper.horizontalSpace(6.w),

                    Container(
                      width: 2.sp,
                      height: 20.h,
                      color: AppColors.cFFFFFF,
                    ),
                    UIHelper.horizontalSpace(6.w),

                    FoodItemDataHelperWidget(
                      title: "Person",
                      iconPath: Assets.icons.personIcon,
                      value: servingValue,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}