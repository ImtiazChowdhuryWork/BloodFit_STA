// 📁 faq_screen.dart
import 'package:bloodfit/constants/app_list.dart';
import 'package:bloodfit/features/faq/presentation/widgets/faq_expansaion_tile.dart';
import 'package:bloodfit/helper/ui_helpers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../../constants/text_font_style.dart';
import '../../../../custom_widgets/go_back_widget.dart';
import '../../../../gen/colors.gen.dart';
import '../../../controllers/faq_screen_controller.dart';

class FaqScreen extends StatelessWidget {
  const FaqScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final FaqScreenController controller = Get.put(FaqScreenController());

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
          child: ListView.separated(
            itemCount: AppList.faqList.length,
            separatorBuilder: (context, index) => UIHelper.verticalSpace(10.h),
            itemBuilder: (context, index) {
              final data = AppList.faqList[index];

              return Obx(() {
                final isVisible = controller.expandedIndex.value == index;

                return FaqExpansionTile(
                  question: data.question,
                  ans: data.ans,
                  isAnsVisible: isVisible,
                  onTap: () => controller.toggleExpand(index),
                );
              });
            },
          ),
        ),
      ),
    );
  }
}
