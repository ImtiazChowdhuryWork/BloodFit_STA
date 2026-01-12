import 'package:bloodfit/custom_widgets/custom_loader.dart';
import 'package:bloodfit/features/privacy_policy/data/controller/privacy_policy_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../constants/text_font_style.dart';
import '../../../custom_widgets/go_back_widget.dart';
import '../../../gen/colors.gen.dart';
import '../../../helper/ui_helpers.dart';

class PrivacyPolicyScreen extends StatelessWidget {
  const PrivacyPolicyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    PrivacyPolicyController controller = Get.find<PrivacyPolicyController>();
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
          "Privacy Policy",
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
                  return controller.isLoading.value
                      ? CustomLoader()
                      : Text(
                          controller.privacyPolicyDescription,
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
