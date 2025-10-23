import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../constants/text_font_style.dart';
import '../../../custom_widgets/go_back_widget.dart';
import '../../../gen/colors.gen.dart';
import '../../../helper/ui_helpers.dart';

class ItemImageAndTitleWidget extends StatelessWidget {
  final String imagePath;
  final String title;
  const ItemImageAndTitleWidget({
    super.key,
    required this.imagePath,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        // Background image
        Image.asset(imagePath, width: 1.sw, height: 0.4.sh, fit: BoxFit.cover),

        // Deep gradient fade for smooth blend
        Positioned(
          bottom: 0,
          left: 0,
          right: 0,
          child: Container(
            height: 120.h, // increase depth of fade
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.transparent,
                  AppColors.scaffoldBackgroundColor.withValues(alpha: 0.3),
                  AppColors.scaffoldBackgroundColor.withValues(alpha: 0.6),
                  AppColors.scaffoldBackgroundColor.withValues(alpha: 0.9),
                  AppColors.scaffoldBackgroundColor,
                ],
                stops: const [0.0, 0.25, 0.5, 0.75, 1.0],
              ),
            ),
          ),
        ),

        // AppBar overlay
        Positioned(
          top: 80.h,
          left: 0.w,
          right: 0.w,
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: UIHelper.kDefaulutPadding(),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                CustomBackButton(),
                Text(
                  "Meal Details",
                  style: TextFontStyle.headline24w700cfefefeStylePoppins,
                ),
                const SizedBox.shrink(),
              ],
            ),
          ),
        ),

        Positioned(
          bottom: 0.h,
          left: 0.w,
          right: 0.w,
          child: Align(
            alignment: Alignment.center,
            child: Text(
              title,
              style: TextFontStyle.headline22w500cfefefeStylePoppins,
            ),
          ),
        ),
      ],
    );
  }
}
