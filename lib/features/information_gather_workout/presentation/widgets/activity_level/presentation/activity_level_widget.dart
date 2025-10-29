import 'package:bloodfit/constants/text_font_style.dart';
import 'package:bloodfit/gen/assets.gen.dart';
import 'package:bloodfit/helper/ui_helpers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

// Example model
class ActivityLevelModel {
  final String imagePath;
  final String subTitle;
  ActivityLevelModel({required this.imagePath, required this.subTitle});
}

// Data
class ActivityLevelData {
  static List<ActivityLevelModel> activityLevelList = [
    ActivityLevelModel(
      imagePath: Assets.images.activityLevelSedentary.path,
      subTitle:
          "If You Spend Most Of Your Day Sitting And Rarely Engage In Physical Activity, This Level Is For You.",
    ),
    ActivityLevelModel(
      imagePath: Assets.images.activityLevelLightlyActive.path,
      subTitle:
          "If You Engage In Light Physical Activity Such As Walking Or Doing Household Chores, This Level Is For You.",
    ),
    ActivityLevelModel(
      imagePath: Assets.images.activityLevelActive.path,
      subTitle:
          "If You Regularly Exercise Or Have A Physically Demanding Job, This Level Is For You.",
    ),
    ActivityLevelModel(
      imagePath: Assets.images.activityLevelVeryActive.path,
      subTitle:
          "If You Perform Intense Physical Activity Or Sports Most Days, This Level Is For You.",
    ),
  ];
}

// Widget
class ActivityLevelWidget extends StatefulWidget {
  const ActivityLevelWidget({super.key});

  @override
  State<ActivityLevelWidget> createState() => _ActivityLevelWidgetState();
}

class _ActivityLevelWidgetState extends State<ActivityLevelWidget> {
  int selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    final list = ActivityLevelData.activityLevelList;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "What’s Your Activity Level?",
          style: TextFontStyle.headline22w500cfefefeStylePoppins,
        ),
        UIHelper.verticalSpace(20.h),

        // --- Image & Description ---
        Container(
          width: double.infinity,
          padding: EdgeInsets.all(16.w),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.05),
            borderRadius: BorderRadius.circular(16.r),
          ),
          child: Column(
            children: [
              Image.asset(list[selectedIndex].imagePath, height: 100.h),
              UIHelper.verticalSpace(10.h),
              Text(
                list[selectedIndex].subTitle,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 14.sp,
                  height: 1.4,
                ),
              ),
            ],
          ),
        ),

        UIHelper.verticalSpace(20.h),

        // --- Selector Bar ---
        Container(
          height: 14.h,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(50.r),
          ),
          padding: EdgeInsets.symmetric(horizontal: 12.w),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: List.generate(list.length, (index) {
              final isSelected = index == selectedIndex;
              return GestureDetector(
                onTap: () {
                  setState(() {
                    selectedIndex = index;
                  });
                },
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
        ),
        UIHelper.verticalSpace(10.h),
        // --- Labels ---
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 8.w),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Sedentary",
                style: TextStyle(
                  color: Colors.white.withOpacity(0.8),
                  fontSize: 12.sp,
                ),
              ),
              Text(
                "Very Active",
                style: TextStyle(
                  color: Colors.white.withOpacity(0.8),
                  fontSize: 12.sp,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
