// 📁 faq_screen.dart
import 'package:bloodfit/constants/app_list.dart';
import 'package:bloodfit/custom_widgets/custom_shimmer_effect.dart';
import 'package:bloodfit/features/faq/presentation/widgets/faq_expansaion_tile.dart';
import 'package:bloodfit/helper/ui_helpers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../../constants/text_font_style.dart';
import '../../../../custom_widgets/go_back_widget.dart';
import '../../../../gen/colors.gen.dart';
import '../data/controller/faq_screen_controller.dart';

class FaqScreen extends StatelessWidget {
  const FaqScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final FaqScreenController controller = Get.find<FaqScreenController>();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.getFaqScreenApi();
    });
    return Scaffold(
      backgroundColor: AppColors.scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: AppColors.scaffoldBackgroundColor,
        centerTitle: true,
        automaticallyImplyLeading: false,
        leading: const CustomBackButton(),
        title: Text(
          "FAQ",
          style: TextFontStyle.headline24w700cFFFFFFStylePoppins,
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(UIHelper.kDefaulutPadding()),
          child: Obx(() {
            return controller.isLoading.value
                ? ListView.separated(
                    itemCount: 10,
                    separatorBuilder: (context, index) =>
                        UIHelper.verticalSpace(10.h),

                    itemBuilder: (context, index) {
                      return CustomShimmerEffect(height: 20.h, width: 1.sw);
                    },
                  )
                : ListView.separated(
                    // itemCount: AppList.faqList.length,
                    itemCount: controller.faqList.length,
                    separatorBuilder: (context, index) =>
                        UIHelper.verticalSpace(10.h),
                    itemBuilder: (context, index) {
                      final data = controller.faqList[index];

                      return Obx(() {
                        final isVisible =
                            controller.expandedIndex.value == index;

                        return FaqExpansionTile(
                          question: data.question ?? 'Question Not Found!',
                          ans: data.answer ?? 'Answer Not Found!',
                          isAnsVisible: isVisible,
                          onTap: () => controller.toggleExpand(index),
                        );
                      });
                    },
                  );
          }),
        ),
      ),
    );
  }
}
