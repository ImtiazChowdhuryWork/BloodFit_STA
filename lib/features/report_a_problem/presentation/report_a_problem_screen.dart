import 'package:bloodfit/constants/app_constant_text.dart';
import 'package:bloodfit/constants/app_list.dart';
import 'package:bloodfit/custom_widgets/custom_elevated_button.dart';
import 'package:bloodfit/features/report_a_problem/data/controller/report_a_problem_screen_controller.dart';
import 'package:bloodfit/gen/colors.gen.dart';
import 'package:bloodfit/helper/di.dart';
import 'package:bloodfit/helper/ui_helpers.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../constants/text_font_style.dart';
import '../../../custom_widgets/error_message.dart';
import '../../../custom_widgets/go_back_widget.dart';

class ReportAProblemScreen extends StatelessWidget {
  ReportAProblemScreen({super.key});

  // final ReportAProblemScreenController controller = Get.put(
  //   ReportAProblemScreenController(),
  // );

  @override
  Widget build(BuildContext context) {
    ReportAProblemScreenController controller =
        Get.find<ReportAProblemScreenController>();

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
                    controller.setSelectedProblemType(problemType: value!);
                    // controller.selectedProblemType.value = value!;
                  },
                  iconStyleData: IconStyleData(
                    icon: const Icon(Icons.keyboard_arrow_down_rounded),
                    iconEnabledColor: AppColors.cc6c6c6,
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
            controller: controller.describedProblemController,
            style: TextFontStyle.headline14w500cFFFFFFStylePoppins,
            decoration: InputDecoration(
              filled: true,
              fillColor: AppColors.c3c3c3c,
              hintText: "Describe What Issue You’re Facing",
              hintStyle: TextFontStyle.headline14w400c999999StylePoppins,
              border: OutlineInputBorder(borderSide: BorderSide.none),
            ),
          ),

          UIHelper.verticalSpace(20.h),

          ///Section : Show error message if there is any
          ErrorMessageWidget(
            errorMessage: controller.errorMessage,
            onClear: controller.clearErrorMessage,
          ),
        ],
      ),

      bottomNavigationBar: Obx(() {
        return Container(
          width: 1.sw,
          padding: EdgeInsets.only(
            bottom: 70.h,
            left: UIHelper.kDefaulutPadding(),
            right: UIHelper.kDefaulutPadding(),
          ),
          color: Colors.transparent,
          child: CustomElevatedButton(
            onTap: controller.isLoading.value
                ? null
                : () async {
                    await controller.postReportAProblemApi();
                  },
            isLoading: controller.isLoading.value,
            buttonTitle: controller.isLoading.value
                ? 'Submitting...'
                : 'Submit',
            buttonColor: controller.isLoading.value
                ? Colors.grey
                : AppColors.cb20000,
          ),
        );
      }),
    );
  }
}
