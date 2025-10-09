import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../constants/text_font_style.dart';
import '../../../../gen/colors.gen.dart';

class FaqExpansionTile extends StatelessWidget {
  final String question;
  final String ans;
  final bool isAnsVisible;
  final VoidCallback? onTap;

  const FaqExpansionTile({
    super.key,
    required this.question,
    required this.ans,
    required this.isAnsVisible,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ///Section : -------------------///Question Section///---------------------
        InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(8.r),
          child: Container(
            width: 1.sw,
            padding: EdgeInsets.all(12.sp),
            decoration: BoxDecoration(
              color: AppColors.c3c3c3c,
              borderRadius: BorderRadius.circular(8.r),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    question,
                    style: TextFontStyle.headline14w400cc6c6c6StylePoppins,
                  ),
                ),
                AnimatedRotation(
                  duration: const Duration(milliseconds: 250),
                  turns: isAnsVisible ? 0.25 : 0,
                  child: Icon(
                    Icons.arrow_forward_ios_rounded,
                    size: 14.sp,
                    color: AppColors.c999999,
                  ),
                ),
              ],
            ),
          ),
        ),

        ///Section : ------------///Answer section///-------------
        AnimatedSwitcher(
          duration: const Duration(milliseconds: 250),
          transitionBuilder: (child, animation) =>
              SizeTransition(sizeFactor: animation, child: child),
          child: isAnsVisible
              ? Padding(
                  key: const ValueKey(true),
                  padding: EdgeInsets.only(top: 10.h),
                  child: Container(
                    width: 1.sw,
                    padding: EdgeInsets.all(12.sp),
                    decoration: BoxDecoration(
                      color: AppColors.c3c3c3c,
                      border: Border.all(color: AppColors.c999999),
                      borderRadius: BorderRadius.circular(8.r),
                    ),
                    child: Text(
                      ans,
                      style: TextFontStyle.headline14w400cc6c6c6StylePoppins,
                    ),
                  ),
                )
              : const SizedBox.shrink(key: ValueKey(false)),
        ),
      ],
    );
  }
}
