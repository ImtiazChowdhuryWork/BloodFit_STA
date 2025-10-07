import 'package:bloodfit/constants/appList.dart';
import 'package:bloodfit/gen/colors.gen.dart';
import 'package:bloodfit/helper/ui_helpers.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../constants/text_font_style.dart';
import '../../../controllers/report_a_problem_screen_controller.dart';
import '../../../custom_widgets/go_back_widget.dart';

class ReportAProblemScreen extends StatelessWidget {
  ReportAProblemScreen({super.key});

  final ReportAProblemScreenController controller = Get.put(
    ReportAProblemScreenController(),
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: AppColors.scaffoldBackgroundColor,
        centerTitle: true,
        automaticallyImplyLeading: false,
        leading: CustomBackButton(),
        title: Text(
          "Report a Problem",
          style: TextFontStyle.headline24w700cFFFFFFStylePoppins,
        ),
      ),
      body: ListView(
        padding: EdgeInsets.all(UIHelper.kDefaulutPadding()),
        children: [
          Text(
            "Select Problem Type",
            style: TextFontStyle.headline14w400cc6c6c6StylePoppins,
          ),
          SizedBox(height: 8.h),
          Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
            decoration: BoxDecoration(
              color: AppColors.c3c3c3c,
              borderRadius: BorderRadius.circular(12.r),
            ),
            child: Obx(() {
              return DropdownButtonHideUnderline(
                child: DropdownButton2<String>(
                  isExpanded: true,
                  hint: Text(
                    "Select Problem Type",
                    style: TextFontStyle.headline14w400cc6c6c6StylePoppins,
                  ),
                  items: AppList.reportProblemTypeList.map((String item) {
                    final isLast = item == AppList.reportProblemTypeList.last;
                    return DropdownMenuItem<String>(
                      value: item,
                      child: Text(
                        item,
                        style: TextFontStyle.headline12w400c999999StylePoppins,
                      ),
                    );
                  }).toList(),
                  value: controller.selectedProblemType.value.isEmpty
                      ? null
                      : controller.selectedProblemType.value,
                  onChanged: (value) {
                    controller.selectedProblemType.value = value!;
                  },
                  iconStyleData: IconStyleData(
                    icon: const Icon(Icons.keyboard_arrow_down_rounded),
                    iconEnabledColor: Colors.yellow,
                    iconDisabledColor: Colors.grey,
                  ),
                  dropdownStyleData: DropdownStyleData(
                    elevation: 0,
                    maxHeight: 300.h,
                    offset: const Offset(
                      0,
                      -24,
                    ), // Gap between button and dropdown
                    decoration: BoxDecoration(
                      color: AppColors.c3c3c3c,
                      borderRadius: BorderRadius.circular(12.r),
                      border: Border.all(color: AppColors.c3c3c3c, width: 1.w),
                    ),
                    padding: EdgeInsets.symmetric(
                      vertical: 4.h,
                      horizontal: 8.w,
                    ),
                  ),
                ),
              );
            }),
          ),

          UIHelper.verticalSpace(24.h),

          // Add more widgets below if needed, they'll scroll automatically
          TextFormField(
            minLines: 8,
            maxLines: 8,
            decoration: InputDecoration(
              filled: true,
              fillColor: AppColors.c6a6a6a,

              hintText: "Describe What Issue You’re Facing",
              hintStyle: TextFontStyle.headline14w400c999999StylePoppins,
              border: OutlineInputBorder(borderSide: BorderSide.none),
            ),
          ),
        ],
      ),
    );
  }
}
