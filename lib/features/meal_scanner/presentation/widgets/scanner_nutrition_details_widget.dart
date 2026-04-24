import 'package:bloodfit/constants/text_font_style.dart';
import 'package:bloodfit/features/meal_scanner/presentation/widgets/bad_for_blood_type_widget.dart';
import 'package:bloodfit/features/meal_scanner/presentation/widgets/good_for_blood_type_widget.dart';
import 'package:bloodfit/gen/assets.gen.dart';
import 'package:bloodfit/gen/colors.gen.dart';
import 'package:bloodfit/helper/ui_helpers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

import '../../../../controllers/meal_scanner_screen_controller.dart';

class ScannerNutritionDetailsWidget extends StatelessWidget {
  final MealScannerScreenController controller =
      Get.find<MealScannerScreenController>();

  ScannerNutritionDetailsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return controller.nutritionData.isNotEmpty
          ? Positioned(
              top: 20.h,
              left: 20.w,
              right: 20.w,
              child: FadeTransition(
                opacity: controller.fadeAnimation,
                child: SlideTransition(
                  position: controller.slideAnimation,
                  child: Container(
                    height: 0.48.sh,
                    padding: EdgeInsets.all(22.sp),
                    decoration: BoxDecoration(
                      color: AppColors.c111111,
                      borderRadius: BorderRadius.circular(16.r),
                      border: Border.all(color: AppColors.cfefefe, width: 1.sp),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.3),
                          blurRadius: 20,
                          offset: Offset(0, 10),
                        ),
                      ],
                    ),
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Scanning Result',
                                style: TextFontStyle.headline16w500cfefefeStylePoppins,
                              ),
                              SizedBox.shrink(),
                              InkWell(
                                onTap: controller.clearNutritionData,
                                child: SvgPicture.asset(Assets.icons.cancelIcon),
                              ),
                            ],
                          ),
                          UIHelper.verticalSpace(8.h),
                          BadForBloodTypeWidget(),
                          UIHelper.verticalSpace(8.h),
                          GoodForBloodTypeWidget(),
                          UIHelper.verticalSpace(16.h),
                          Text(
                            "Avoid The Reds, Greens Are Good",
                            style: TextFontStyle.headline14w400cfefefeStylePoppins,
                          ),
                          UIHelper.verticalSpace(35.h),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            )
          : SizedBox.shrink();
    });
  }
}
