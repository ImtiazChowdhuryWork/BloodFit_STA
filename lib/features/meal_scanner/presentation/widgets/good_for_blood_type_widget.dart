import 'package:bloodfit/constants/text_font_style.dart';
import 'package:bloodfit/features/meal_scanner/presentation/widgets/scanning_result_tile_widget.dart';
import 'package:bloodfit/gen/assets.gen.dart';
import 'package:bloodfit/gen/colors.gen.dart';
import 'package:bloodfit/helper/ui_helpers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class GoodForBloodTypeWidget extends StatelessWidget {
  const GoodForBloodTypeWidget({super.key});

  @override
  Widget build(BuildContext context) {
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
          itemCount: 3,
          separatorBuilder: (context, index) => UIHelper.verticalSpace(8.h),
          itemBuilder: (context, index) {
            return ScanningResultTileWidget(
              itemName: "Rich",
              sufficIcon: Assets.icons.doneIcon,
              borderColor: AppColors.c299105,
            );
          },
        ),
      ],
    );
  }
}
