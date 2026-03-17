import 'dart:developer';

import 'package:bloodfit/custom_widgets/custom_elevated_button.dart';
import 'package:bloodfit/helper/ui_helpers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../constants/text_font_style.dart';
import '../../../custom_widgets/go_back_widget.dart';
import '../../../gen/colors.gen.dart';
import '../data/controller/add_poromocode_screen_controller.dart';

class AddPromoCodeScreen extends StatefulWidget {
  const AddPromoCodeScreen({super.key});

  @override
  State<AddPromoCodeScreen> createState() => _AddPromoCodeScreenState();
}

class _AddPromoCodeScreenState extends State<AddPromoCodeScreen> {
  AddPoromocodeScreenController promoCodeScreenController =
      Get.find<AddPoromocodeScreenController>();
  String planId = '';

  @override
  void initState() {
    final arguments = Get.arguments as Map<String, dynamic>?;

    planId = arguments?['planId'] ?? '';

    WidgetsBinding.instance.addPostFrameCallback((_) {
      promoCodeScreenController.setPlanId(value: planId);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldBackgroundColor,

      /// -------------------- App Bar Section --------------------
      appBar: AppBar(
        backgroundColor: AppColors.scaffoldBackgroundColor,
        centerTitle: true,
        automaticallyImplyLeading: false,
        leading: const CustomBackButton(),
        title: Text(
          "Promo Code",
          style: TextFontStyle.headline24w700cFFFFFFStylePoppins,
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(UIHelper.kDefaulutPadding()),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /// Section : --------///Text -> Add Promo Code ///--------------
              Text(
                "Add Promo Code",
                style: TextFontStyle.headline20w500cfefefeStylePoppins,
              ),
              UIHelper.verticalSpace(16.h),

              ///Section : --------///TextFormField -> Promo Code///-------------
              Container(
                width: 1.sw,
                padding: EdgeInsets.symmetric(horizontal: 17.w, vertical: 12.h),
                decoration: BoxDecoration(
                  color: AppColors.c262626,
                  borderRadius: BorderRadius.circular(10.r),
                ),
                child: TextFormField(
                  controller: promoCodeScreenController.promocodeController,
                  style: TextFontStyle.headline12w500c999999StylePoppins,
                  decoration: InputDecoration(
                    hintText: "Enter Your Promo Code",
                    border: OutlineInputBorder(
                      borderSide: BorderSide(color: AppColors.cb20000),
                      borderRadius: BorderRadius.circular(8.r),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: AppColors.cb20000),
                      borderRadius: BorderRadius.circular(8.r),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: AppColors.cb20000),
                      borderRadius: BorderRadius.circular(8.r),
                    ),
                    disabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: AppColors.cb20000),
                      borderRadius: BorderRadius.circular(8.r),
                    ),
                  ),
                ),
              ),
              UIHelper.verticalSpace(32.h),

              Obx((){



                return CustomElevatedButton(
                onTap: () {
                  log("Button -> Validate Button Taped!");

                  promoCodeScreenController.postAddPromocodeApi();
                },
                buttonTitle: "Validate",
                isLoading: promoCodeScreenController.isPromocodeValueLoading.value,
              );
              }),
            ],
          ),
        ),
      ),
    );
  }
}
