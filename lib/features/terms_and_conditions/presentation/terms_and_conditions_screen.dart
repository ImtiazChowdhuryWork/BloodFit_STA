import 'package:bloodfit/features/terms_and_conditions/data/controller/terms_and_conditions_screen_controller.dart';
import 'package:bloodfit/custom_widgets/custom_loader.dart';
import 'package:bloodfit/gen/colors.gen.dart';
import 'package:bloodfit/helper/logger_util.dart';
import 'package:bloodfit/helper/ui_helpers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../constants/text_font_style.dart';
import '../../../custom_widgets/go_back_widget.dart';

class TermsAndConditionsScreen extends StatelessWidget {
  const TermsAndConditionsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final TermsAndConditionsScreenController controller =
        Get.find<TermsAndConditionsScreenController>();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.getTermsAndConditionsApi();
    });
    return Scaffold(
      backgroundColor: AppColors.scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: AppColors.scaffoldBackgroundColor,
        centerTitle: true,
        automaticallyImplyLeading: false,
        leading: CustomBackButton(),
        title: Text(
          "Terms & Conditions",
          style: TextFontStyle.headline24w700cFFFFFFStylePoppins,
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(UIHelper.kDefaulutPadding()),
            child: Column(
              children: [
                Obx(() {
                  LoggerUtils.debug(
                    "Terms And Conditions : ${controller.termsAndConditions}",
                  );
                  return controller.isLoading.value
                      ? CustomLoader()
                      : Text(
                          controller.termsAndConditions,
                          style:
                              TextFontStyle.headline14w400cc6c6c6StylePoppins,
                        );
                }),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
