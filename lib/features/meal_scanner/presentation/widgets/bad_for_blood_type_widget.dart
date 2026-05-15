import 'package:bloodfit/constants/text_font_style.dart';
import 'package:bloodfit/features/meal_scanner/data/controller/meal_scanner_screen_controller.dart';
import 'package:bloodfit/features/meal_scanner/presentation/widgets/scanning_result_tile_widget.dart';
import 'package:bloodfit/gen/assets.gen.dart';
import 'package:bloodfit/gen/colors.gen.dart';
import 'package:bloodfit/helper/ui_helpers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class BadForBloodTypeWidget extends StatelessWidget {
  const BadForBloodTypeWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<MealScannerScreenController>();

    return Obx(() {
      final harmful = controller.scanResult.value?.harmfulIngredients ?? [];

      if (harmful.isEmpty) return const SizedBox.shrink();

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Bad For Your Blood Type",
            style: TextFontStyle.headline14w400cfefefeStylePoppins,
          ),
          UIHelper.verticalSpace(8.h),
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: harmful.length,
            separatorBuilder: (context, index) => UIHelper.verticalSpace(8.h),
            itemBuilder: (context, index) {
              final item = harmful[index];
              return ScanningResultTileWidget(
                itemName: item.name ?? '',
                sufficIcon: Assets.icons.cancelIcon,
                borderColor: AppColors.cb20000,
              );
            },
          ),
        ],
      );
    });
  }
}
