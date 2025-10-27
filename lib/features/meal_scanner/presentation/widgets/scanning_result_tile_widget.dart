import 'package:bloodfit/constants/text_font_style.dart';
import 'package:bloodfit/gen/colors.gen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

class ScanningResultTileWidget extends StatelessWidget {
  final String itemName;
  final String sufficIcon;
  final Color? borderColor;
  const ScanningResultTileWidget({
    super.key,
    required this.itemName,
    required this.sufficIcon,
    this.borderColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 10.h, horizontal: 12.w),
      decoration: BoxDecoration(
        color: AppColors.c272727,
        border: Border.all(color: borderColor ?? Colors.transparent),
        borderRadius: BorderRadius.circular(8.r),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          ///Section : --------------///Item Name///-------------
          Text(
            itemName,
            style: TextFontStyle.headline14w400cfefefeStylePoppins,
          ),

          ///Section : ------------///Suffix Icon///--------------
          SvgPicture.asset(sufficIcon),
        ],
      ),
    );
  }
}
