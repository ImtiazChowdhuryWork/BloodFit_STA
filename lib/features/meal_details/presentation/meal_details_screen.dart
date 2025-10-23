import 'package:bloodfit/constants/app_text.dart';
import 'package:bloodfit/constants/text_font_style.dart';
import 'package:bloodfit/gen/assets.gen.dart';
import 'package:bloodfit/gen/colors.gen.dart';
import 'package:bloodfit/helper/ui_helpers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

import '../../../custom_widgets/food_item_data_helper_widget.dart';
import '../widgets/item_image_and_title_widget.dart';

class MealDetailsScreen extends StatelessWidget {
  const MealDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldBackgroundColor,
      body: SingleChildScrollView(
        child: Column(
          children: [
            ///Section : ----------///Item Image///-------------
            ///Section : ----------///Item Title///-------------
            ItemImageAndTitleWidget(
              imagePath: Assets.images.eggOmletImage.path,
              title: "Avocado Toast & Poached Eggs",
            ),
            UIHelper.verticalSpace(8.h),

            ///Section : -----------///Meal Type -> Breakfast,Lunc,Dinner///------------
            Row(
              mainAxisSize: MainAxisSize.min, // ✅ Row doesn’t stretch
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                /// Food Total Kcal & Serving
                FoodItemDataHelperWidget(
                  iconPath: Assets.icons.mealIcon,
                  iconColor: AppColors.cfefefe,
                  title: "Breakfast",
                  value: 302,
                  isValueVisible: false,
                ),
                UIHelper.horizontalSpace(20.w),

                /// Divider
                Container(width: 2.sp, height: 20.h, color: AppColors.c282828),
                UIHelper.horizontalSpace(20.w),

                FoodItemDataHelperWidget(
                  title: "Kcal",
                  iconPath: Assets.icons.fireRed,
                  value: 302,
                ),
              ],
            ),
            UIHelper.verticalSpace(12.h),

            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: UIHelper.kDefaulutPadding(),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ///Section : ------///Text -> Mesal Details Text ///----------
                  Text(
                    foodDetailsText,
                    textAlign: TextAlign.center,
                    style: TextFontStyle.headline14w500c999999StylePoppins,
                  ),
                  UIHelper.verticalSpace(32.h),

                  ///Section : ---------///Text -> Calory Count For This Meal ///---------------
                  Text(
                    "Calory Count For This Meal",
                    style: TextFontStyle.headline20w500cfefefeStylePoppins,
                  ),
                  UIHelper.verticalSpace(16.h),

                  ///Section : -----///Carbs,Protein,Fat///-----------
                  Container(
                    padding: EdgeInsets.all(10.sp),
                    decoration: BoxDecoration(
                      border: Border.all(color: AppColors.cfefefe),
                      borderRadius: BorderRadius.circular(10.r),
                      gradient: const LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          Color(0xFF111111), // top-left tint
                          Color(0xFF2B1010), // main color
                        ],
                        stops: [0.0, 0.50], // small corner effect
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        SvgPicture.asset(Assets.icons.glutenIcon),
                        UIHelper.horizontalSpace(10.w),
                        Text(
                          "Test",
                          style:
                              TextFontStyle.headline14w400cfefefeStylePoppins,
                        ),
                      ],
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
