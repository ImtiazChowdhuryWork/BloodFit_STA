import 'package:bloodfit/constants/text_font_style.dart';
import 'package:bloodfit/controllers/select_your_country_screen_controller.dart';
import 'package:bloodfit/custom_widgets/custom_text_form_field.dart';
import 'package:bloodfit/gen/assets.gen.dart';
import 'package:bloodfit/gen/colors.gen.dart';
import 'package:bloodfit/helper/logger_util.dart';
import 'package:bloodfit/helper/ui_helpers.dart';
import 'package:country_picker/country_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

class SelectCountryWidget extends StatelessWidget {
  const SelectCountryWidget({super.key});

  @override
  Widget build(BuildContext context) {
    IgSelectYourCountryScreenController controller =
        Get.find<IgSelectYourCountryScreenController>();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ///Section : ------------///Title///--------------
        Text(
          "Select Your Country",
          style: TextFontStyle.headline22w500cfefefeStylePoppins,
        ),
        UIHelper.verticalSpace(24.h),

        ///Section : ----------///TextFormFiled -> For Searching Country Names///-------------------
        GestureDetector(
          onTap: () {
            showCountryPicker(
              context: context,
              onSelect: (Country value) {
                controller.setCountryNameAndFlag(
                  name: value.name,
                  flag: value.flagEmoji,
                );
              },
            );
          },
          child: CustomFormField(
            hintText: "Search",
            borderRadius: 16.r,
            isEnabled: false,
            suffixIcon: SvgPicture.asset(Assets.icons.searchIcon),
          ),
        ),
        UIHelper.verticalSpace(24.h),

        ///Section : ---------///Selected Country///------------
        Obx(() {
          return controller.countryFlag.value.isNotEmpty &&
                  controller.countryName.value.isNotEmpty
              ? Text(
                  'Selected Country',
                  style: TextFontStyle.headline14w500cc6c6c6StylePoppins,
                )
              : SizedBox.shrink();
        }),

        Obx(() {
          return controller.countryFlag.value.isNotEmpty &&
                  controller.countryName.value.isNotEmpty
              ? UIHelper.verticalSpace(10.h)
              : SizedBox.shrink();
        }),
        Obx(() {
          return controller.countryFlag.value.isNotEmpty &&
                  controller.countryName.value.isNotEmpty
              ? Container(
                  width: 1.sw,
                  padding: EdgeInsets.all(10.sp),
                  decoration: BoxDecoration(
                    color: AppColors.c3c3c3c,
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                  child: Row(
                    children: [
                      /// ---->> Country Flag
                      Text(controller.countryFlag.value),
                      UIHelper.horizontalSpace(10.w),

                      ///------->> Country Name
                      Text(
                        controller.countryName.value,
                        style: TextFontStyle.headline16w500cfefefeStylePoppins,
                      ),
                      Spacer(),

                      ///Section : --------///Remove Selected Item///--------------
                      InkWell(
                        onTap: () {
                          LoggerUtils.debug("Delete Icon Taped!");
                          controller.removeCountryNameAndFlag();
                        },
                        child: SvgPicture.asset(
                          Assets.icons.trashIcon,
                          colorFilter: ColorFilter.mode(
                            AppColors.cFFFFFF,
                            BlendMode.srcIn,
                          ),
                        ),
                      ),
                    ],
                  ),
                )
              : SizedBox.shrink();
        }),

        /// Optional: Show saved country info for debugging
        Obx(() {
          return controller.countryName.value.isEmpty
              ? Column(
                  children: [
                    UIHelper.verticalSpace(20.h),
                    Text(
                      'No country selected',
                      style: TextFontStyle.headline10w500cfefefeStylePoppins,
                    ),
                  ],
                )
              : SizedBox.shrink();
        }),
      ],
    );
  }
}
