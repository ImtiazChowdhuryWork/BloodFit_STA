import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../constants/text_font_style.dart';
import '../../../../gen/colors.gen.dart';
import '../../../../helper/ui_helpers.dart';

class BottomSheetScreenSelectableDaysShowingWidget extends StatefulWidget {
  final String title;
  final bool isSelected;
  final void Function()? onTap;
  const BottomSheetScreenSelectableDaysShowingWidget({
    super.key,
    required this.isSelected,
    required this.title,
    this.onTap,
  });

  @override
  State<BottomSheetScreenSelectableDaysShowingWidget> createState() =>
      _BottomSheetScreenSelectableDaysShowingWidgetState();
}

class _BottomSheetScreenSelectableDaysShowingWidgetState
    extends State<BottomSheetScreenSelectableDaysShowingWidget> {
  late bool _isSelected;

  @override
  void initState() {
    super.initState();
    _isSelected = widget.isSelected;
  }

  @override
  void didUpdateWidget(BottomSheetScreenSelectableDaysShowingWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.isSelected != widget.isSelected) {
      setState(() {
        _isSelected = widget.isSelected;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: widget.onTap,
      child: Container(
        // Remove fixed padding or add constraints that allow shrinking
        padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
        constraints: BoxConstraints(
          minWidth: 60.w, // Minimum width but can expand
        ),
        decoration: BoxDecoration(
          color: _isSelected ? AppColors.c3c3c3c : AppColors.c111111,
          border: Border.all(
            color: _isSelected ? AppColors.cb20000 : AppColors.c999999,
          ),
          borderRadius: BorderRadius.circular(8.r),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min, // This is correct
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: EdgeInsets.all(4.sp),
              decoration: BoxDecoration(
                color: _isSelected ? AppColors.cb20000 : AppColors.c111111,
                shape: BoxShape.circle,
                border: !_isSelected
                    ? Border.all(color: AppColors.cfefefe)
                    : null,
              ),
              child: Icon(
                Icons.done,
                size: 14.sp,
                color: _isSelected ? AppColors.c3c3c3c : AppColors.cfefefe,
              ),
            ),
            UIHelper.horizontalSpace(8.w), // Reduced space
            Flexible(
              // Add Flexible to prevent overflow
              child: Text(
                widget.title,
                style: TextFontStyle.headline16w500cfefefeStylePoppins,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
