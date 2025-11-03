import 'package:bloodfit/constants/app_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SelectableBarWidget extends StatelessWidget {
  final int selectedIndex;
  final ValueChanged<int> onChanged; // <--- cleaner callback

  const SelectableBarWidget({
    super.key,
    required this.selectedIndex,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 30.h,
      padding: EdgeInsets.symmetric(horizontal: 12.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(50.r),
      ),

      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: List.generate(AppList.activityLevelList.length, (index) {
          final isSelected = index == selectedIndex;
          return GestureDetector(
            onTap: () => onChanged(index), // <--- pass the tapped index
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 250),
              width: 20.w,
              height: 20.w,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.black,
                border: isSelected
                    ? Border.all(color: Colors.red, width: 3.w)
                    : null,
              ),
            ),
          );
        }),
      ),
    );
  }
}
